library dart_builder.test.parameter_list.parameter_list_builder_test;

import 'package:dart_builder/src/parameter_list/built_parameter_list.dart';
import 'package:dart_builder/src/parameter_list/parameter_list_builder.dart';
import 'package:dart_builder/src/variable/built_variable.dart';
import 'package:test/test.dart';

void main() {
  group('ParameterListBuilder', () {
    test('can build a parameter list', () {
      var builder = new ParameterListBuilder();
      builder.addParameter('foo');
      expect(
          builder.build(),
          const BuiltParameterList(
              requiredArguments: const [const BuiltVariable('foo')]));
    });
  });
}
