// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library universe;

import 'dart:collection';

import '../common.dart';
import '../compiler.dart' show Compiler;
import '../dart_types.dart';
import '../elements/elements.dart';
import '../util/util.dart';
import '../world.dart' show ClassWorld, World;
import 'selector.dart' show Selector;
import 'use.dart' show DynamicUse, DynamicUseKind, StaticUse, StaticUseKind;

/// The known constraint on receiver for a dynamic call site.
///
/// This can for instance be used to constrain this dynamic call to `foo` to
/// 'receivers of the exact instance `Bar`':
///
///     class Bar {
///        void foo() {}
///     }
///     main() => new Bar().foo();
///
abstract class ReceiverConstraint {
  /// Returns whether [element] is a potential target when being
  /// invoked on a receiver with this constraint. [selector] is used to ensure
  /// library privacy is taken into account.
  bool canHit(Element element, Selector selector, ClassWorld classWorld);

  /// Returns whether this [TypeMask] applied to [selector] can hit a
  /// [noSuchMethod].
  bool needsNoSuchMethodHandling(Selector selector, ClassWorld classWorld);
}

/// The combined constraints on receivers all the dynamic call sites of the same
/// selector.
///
/// For instance for these calls
///
///     class A {
///        foo(a, b) {}
///     }
///     class B {
///        foo(a, b) {}
///     }
///     class C {
///        foo(a, b) {}
///     }
///     new A().foo(a, b);
///     new B().foo(0, 42);
///
/// the selector constraints for dynamic calls to 'foo' with two positional
/// arguments could be 'receiver of exact instance `A` or `B`'.
abstract class SelectorConstraints {
  /// Returns `true` if [selector] applies to [element] under these constraints
  /// given the closed [world].
  ///
  /// Consider for instance in this world:
  ///
  ///     class A {
  ///        foo(a, b) {}
  ///     }
  ///     class B {
  ///        foo(a, b) {}
  ///     }
  ///     new A().foo(a, b);
  ///
  /// Ideally the selector constraints for calls `foo` with two positional
  /// arguments apply to `A.foo` but `B.foo`.
  bool applies(Element element, Selector selector, ClassWorld world);

  /// Returns `true` if at least one of the receivers matching these constraints
  /// in the closed [world] have no implementation matching [selector].
  ///
  /// For instance for this code snippet
  ///
  ///     class A {}
  ///     class B { foo() {} }
  ///     m(b) => (b ? new A() : new B()).foo();
  ///
  /// the potential receiver `new A()` has no implementation of `foo` and thus
  /// needs to handle the call through its `noSuchMethod` handler.
  bool needsNoSuchMethodHandling(Selector selector, ClassWorld world);
}

/// A mutable [SelectorConstraints] used in [Universe].
abstract class UniverseSelectorConstraints extends SelectorConstraints {
  /// Adds [constraint] to these selector constraints. Return `true` if the set
  /// of potential receivers expanded due to the new constraint.
  bool addReceiverConstraint(ReceiverConstraint constraint);
}

/// Strategy for computing the constraints on potential receivers of dynamic
/// call sites.
abstract class SelectorConstraintsStrategy {
  /// Create a [UniverseSelectorConstraints] to represent the global receiver
  /// constraints for dynamic call sites with [selector].
  UniverseSelectorConstraints createSelectorConstraints(Selector selector);
}

class Universe {
  /// The set of all directly instantiated classes, that is, classes with a
  /// generative constructor that has been called directly and not only through
  /// a super-call.
  ///
  /// Invariant: Elements are declaration elements.
  // TODO(johnniwinther): [_directlyInstantiatedClasses] and
  // [_instantiatedTypes] sets should be merged.
  final Set<ClassElement> _directlyInstantiatedClasses =
      new Set<ClassElement>();

  /// The set of all directly instantiated types, that is, the types of the
  /// directly instantiated classes.
  ///
  /// See [_directlyInstantiatedClasses].
  final Set<DartType> _instantiatedTypes = new Set<DartType>();

  /// Classes implemented by directly instantiated classes.
  final Set<ClassElement> _implementedClasses = new Set<ClassElement>();

  /// The set of all referenced static fields.
  ///
  /// Invariant: Elements are declaration elements.
  final Set<FieldElement> allReferencedStaticFields = new Set<FieldElement>();

  /**
   * Documentation wanted -- johnniwinther
   *
   * Invariant: Elements are declaration elements.
   */
  final Set<FunctionElement> staticFunctionsNeedingGetter =
      new Set<FunctionElement>();
  final Set<FunctionElement> methodsNeedingSuperGetter =
      new Set<FunctionElement>();
  final Map<String, Map<Selector, SelectorConstraints>> _invokedNames =
      <String, Map<Selector, SelectorConstraints>>{};
  final Map<String, Map<Selector, SelectorConstraints>> _invokedGetters =
      <String, Map<Selector, SelectorConstraints>>{};
  final Map<String, Map<Selector, SelectorConstraints>> _invokedSetters =
      <String, Map<Selector, SelectorConstraints>>{};

  /**
   * Fields accessed. Currently only the codegen knows this
   * information. The resolver is too conservative when seeing a
   * getter and only registers an invoked getter.
   */
  final Set<Element> fieldGetters = new Set<Element>();

  /**
   * Fields set. See comment in [fieldGetters].
   */
  final Set<Element> fieldSetters = new Set<Element>();
  final Set<DartType> isChecks = new Set<DartType>();

  /**
   * Set of (live) [:call:] methods whose signatures reference type variables.
   *
   * A live [:call:] method is one whose enclosing class has been instantiated.
   */
  final Set<Element> callMethodsWithFreeTypeVariables = new Set<Element>();

  /**
   * Set of (live) local functions (closures) whose signatures reference type
   * variables.
   *
   * A live function is one whose enclosing member function has been enqueued.
   */
  final Set<Element> closuresWithFreeTypeVariables = new Set<Element>();

  /**
   * Set of all closures in the program. Used by the mirror tracking system
   * to find all live closure instances.
   */
  final Set<LocalFunctionElement> allClosures = new Set<LocalFunctionElement>();

  /**
   * Set of methods in instantiated classes that are potentially
   * closurized.
   */
  final Set<Element> closurizedMembers = new Set<Element>();

  final SelectorConstraintsStrategy selectorConstraintsStrategy;

  Universe(this.selectorConstraintsStrategy);

  /// All directly instantiated classes, that is, classes with a generative
  /// constructor that has been called directly and not only through a
  /// super-call.
  // TODO(johnniwinther): Improve semantic precision.
  Iterable<ClassElement> get directlyInstantiatedClasses {
    return _directlyInstantiatedClasses;
  }

  /// All directly instantiated types, that is, the types of the directly
  /// instantiated classes.
  ///
  /// See [directlyInstantiatedClasses].
  // TODO(johnniwinther): Improve semantic precision.
  Iterable<DartType> get instantiatedTypes => _instantiatedTypes;

  /// Returns `true` if [cls] is considered to be implemented by an
  /// instantiated class, either directly, through subclasses or through
  /// subtypes. The latter case only contains spurious information from
  /// instantiations through factory constructors and mixins.
  // TODO(johnniwinther): Improve semantic precision.
  bool isImplemented(ClassElement cls) {
    return _implementedClasses.contains(cls.declaration);
  }

  /// Register [type] as (directly) instantiated.
  ///
  /// If [byMirrors] is `true`, the instantiation is through mirrors.
  // TODO(johnniwinther): Fully enforce the separation between exact, through
  // subclass and through subtype instantiated types/classes.
  // TODO(johnniwinther): Support unknown type arguments for generic types.
  void registerTypeInstantiation(InterfaceType type,
      {bool byMirrors: false,
      bool isNative: false,
      void onImplemented(ClassElement cls)}) {
    _instantiatedTypes.add(type);
    ClassElement cls = type.element;
    if (!cls.isAbstract
        // We can't use the closed-world assumption with native abstract
        // classes; a native abstract class may have non-abstract subclasses
        // not declared to the program.  Instances of these classes are
        // indistinguishable from the abstract class.
        ||
        isNative
        // Likewise, if this registration comes from the mirror system,
        // all bets are off.
        // TODO(herhut): Track classes required by mirrors seperately.
        ||
        byMirrors) {
      _directlyInstantiatedClasses.add(cls);
    }

    // TODO(johnniwinther): Replace this by separate more specific mappings that
    // include the type arguments.
    if (_implementedClasses.add(cls)) {
      onImplemented(cls);
      cls.allSupertypes.forEach((InterfaceType supertype) {
        if (_implementedClasses.add(supertype.element)) {
          onImplemented(supertype.element);
        }
      });
    }
  }

  bool _hasMatchingSelector(Map<Selector, SelectorConstraints> selectors,
      Element member, World world) {
    if (selectors == null) return false;
    for (Selector selector in selectors.keys) {
      if (selector.appliesUnnamed(member, world)) {
        SelectorConstraints masks = selectors[selector];
        if (masks.applies(member, selector, world)) {
          return true;
        }
      }
    }
    return false;
  }

  bool hasInvocation(Element member, World world) {
    return _hasMatchingSelector(_invokedNames[member.name], member, world);
  }

  bool hasInvokedGetter(Element member, World world) {
    return _hasMatchingSelector(_invokedGetters[member.name], member, world) ||
        member.isFunction && methodsNeedingSuperGetter.contains(member);
  }

  bool hasInvokedSetter(Element member, World world) {
    return _hasMatchingSelector(_invokedSetters[member.name], member, world);
  }

  bool registerDynamicUse(DynamicUse dynamicUse) {
    switch (dynamicUse.kind) {
      case DynamicUseKind.INVOKE:
        return _registerNewSelector(dynamicUse, _invokedNames);
      case DynamicUseKind.GET:
        return _registerNewSelector(dynamicUse, _invokedGetters);
      case DynamicUseKind.SET:
        return _registerNewSelector(dynamicUse, _invokedSetters);
    }
  }

  bool _registerNewSelector(DynamicUse dynamicUse,
      Map<String, Map<Selector, SelectorConstraints>> selectorMap) {
    Selector selector = dynamicUse.selector;
    String name = selector.name;
    ReceiverConstraint mask = dynamicUse.mask;
    Map<Selector, SelectorConstraints> selectors = selectorMap.putIfAbsent(
        name, () => new Maplet<Selector, SelectorConstraints>());
    UniverseSelectorConstraints constraints =
        selectors.putIfAbsent(selector, () {
      return selectorConstraintsStrategy.createSelectorConstraints(selector);
    });
    return constraints.addReceiverConstraint(mask);
  }

  Map<Selector, SelectorConstraints> _asUnmodifiable(
      Map<Selector, SelectorConstraints> map) {
    if (map == null) return null;
    return new UnmodifiableMapView(map);
  }

  Map<Selector, SelectorConstraints> invocationsByName(String name) {
    return _asUnmodifiable(_invokedNames[name]);
  }

  Map<Selector, SelectorConstraints> getterInvocationsByName(String name) {
    return _asUnmodifiable(_invokedGetters[name]);
  }

  Map<Selector, SelectorConstraints> setterInvocationsByName(String name) {
    return _asUnmodifiable(_invokedSetters[name]);
  }

  void forEachInvokedName(
      f(String name, Map<Selector, SelectorConstraints> selectors)) {
    _invokedNames.forEach(f);
  }

  void forEachInvokedGetter(
      f(String name, Map<Selector, SelectorConstraints> selectors)) {
    _invokedGetters.forEach(f);
  }

  void forEachInvokedSetter(
      f(String name, Map<Selector, SelectorConstraints> selectors)) {
    _invokedSetters.forEach(f);
  }

  DartType registerIsCheck(DartType type, Compiler compiler) {
    type.computeUnaliased(compiler.resolution);
    type = type.unaliased;
    // Even in checked mode, type annotations for return type and argument
    // types do not imply type checks, so there should never be a check
    // against the type variable of a typedef.
    isChecks.add(type);
    return type;
  }

  void registerStaticUse(StaticUse staticUse) {
    Element element = staticUse.element;
    if (Elements.isStaticOrTopLevel(element) && element.isField) {
      allReferencedStaticFields.add(element);
    }
    switch (staticUse.kind) {
      case StaticUseKind.STATIC_TEAR_OFF:
        staticFunctionsNeedingGetter.add(element);
        break;
      case StaticUseKind.FIELD_GET:
        fieldGetters.add(element);
        break;
      case StaticUseKind.SUPER_FIELD_SET:
      case StaticUseKind.FIELD_SET:
        fieldSetters.add(element);
        break;
      case StaticUseKind.SUPER_TEAR_OFF:
        methodsNeedingSuperGetter.add(element);
        break;
      case StaticUseKind.GENERAL:
        break;
      case StaticUseKind.CLOSURE:
        allClosures.add(element);
        break;
    }
  }

  void forgetElement(Element element, Compiler compiler) {
    allClosures.remove(element);
    slowDirectlyNestedClosures(element).forEach(compiler.forgetElement);
    closurizedMembers.remove(element);
    fieldSetters.remove(element);
    fieldGetters.remove(element);
    _directlyInstantiatedClasses.remove(element);
    if (element is ClassElement) {
      assert(invariant(element, element.thisType.isRaw,
          message: 'Generic classes not supported (${element.thisType}).'));
      _instantiatedTypes..remove(element.rawType)..remove(element.thisType);
    }
  }

  // TODO(ahe): Replace this method with something that is O(1), for example,
  // by using a map.
  List<LocalFunctionElement> slowDirectlyNestedClosures(Element element) {
    // Return new list to guard against concurrent modifications.
    return new List<LocalFunctionElement>.from(
        allClosures.where((LocalFunctionElement closure) {
      return closure.executableContext == element;
    }));
  }
}
