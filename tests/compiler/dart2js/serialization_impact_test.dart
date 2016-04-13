// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library dart2js.serialization_impact_test;

import 'dart:async';
import 'package:async_helper/async_helper.dart';
import 'package:compiler/src/commandline_options.dart';
import 'package:compiler/src/common/resolution.dart';
import 'package:compiler/src/compiler.dart';
import 'package:compiler/src/elements/elements.dart';
import 'package:compiler/src/filenames.dart';
import 'package:compiler/src/serialization/equivalence.dart';
import 'memory_compiler.dart';
import 'serialization_helper.dart';
import 'serialization_test_helper.dart';

main(List<String> arguments) {
  asyncTest(() async {
    String serializedData = await serializeDartCore();
    if (arguments.isNotEmpty) {
      Uri entryPoint = Uri.base.resolve(nativeToUriPath(arguments.last));
      await check(serializedData, entryPoint);
    } else {
      Uri entryPoint = Uri.parse('memory:main.dart');
      await check(serializedData, entryPoint, {'main.dart': 'main() {}'});
    }
  });
}

Future check(
  String serializedData,
  Uri entryPoint,
  [Map<String, String> sourceFiles = const <String, String>{}]) async {

  Compiler compilerNormal = compilerFor(
      memorySourceFiles: sourceFiles,
      options: [Flags.analyzeOnly]);
  compilerNormal.resolution.retainCachesForTesting = true;
  await compilerNormal.run(entryPoint);

  Compiler compilerDeserialized = compilerFor(
      memorySourceFiles: sourceFiles,
      options: [Flags.analyzeOnly]);
  compilerDeserialized.resolution.retainCachesForTesting = true;
  deserialize(compilerDeserialized, serializedData);
  await compilerDeserialized.run(entryPoint);

  checkAllImpacts(compilerNormal, compilerDeserialized, verbose: true);
}
