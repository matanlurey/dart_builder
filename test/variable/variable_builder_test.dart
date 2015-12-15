library dart_builder.test.type.type_builder;

import 'package:dart_builder/src/type/built_type.dart';
import 'package:dart_builder/src/type/type_builder.dart';
import 'package:dart_builder/src/variable/built_variable.dart';
import 'package:dart_builder/src/variable/variable_builder.dart';
import 'package:test/test.dart';

void main() {
  group('VariableBuilder', () {
    test('should be able to build a variable', () {
      VariableBuilder builder = new VariableBuilder('foo');
      expect(builder.build(), const BuiltVariable('foo'));

      builder.type = TypeBuilder.coreString;
      expect(builder.build(),
          const BuiltVariable('foo', type: BuiltType.coreString));
    });

    // TODO: Expand tests to be more comprehensive.
  });
}
