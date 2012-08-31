// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Test to ensure that an abstract getter is not mistaken for a field.

class Foo {
  abstract get i;
}

class Bar {
}

noMethod(e) => e is NoSuchMethodException;

checkIt(f) {
  Expect.throws(() { f.i = 'hi'; }, noMethod);
  Expect.throws(() { print(f.i); }, noMethod);
  Expect.throws(() { print(f.i()); }, noMethod);
}

main() {
  checkIt(new Foo());  /// 01: runtime error
  checkIt(new Bar());
}
