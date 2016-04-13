library dart_builder.test.parameter.built_parameter_list_test;

import 'package:dart_builder/src/parameter_list/built_parameter_list.dart';
import 'package:dart_builder/src/source_writer.dart';
import 'package:dart_builder/src/type/built_type.dart';
import 'package:dart_builder/src/variable/built_variable.dart';
import 'package:test/test.dart';

void main() {
  group('BuiltParameterList with StringSourceWriter', () {
    StringSourceWriter sourceWriter;

    setUp(() {
      sourceWriter = new StringSourceWriter();
    });

    test('writes a parameter list with a single required parameter', () {
      sourceWriter.writeParameterList(const BuiltParameterList(
          requiredArguments: const [
            const BuiltVariable('foo', type: BuiltType.coreString),
          ]));
      expect(sourceWriter.toString(), 'String foo');
    });

    test('writes a parameter list with multiple required parameter', () {
      sourceWriter.writeParameterList(
          const BuiltParameterList(requiredArguments: const [
        const BuiltVariable('foo', type: BuiltType.coreString),
        const BuiltVariable('bar', type: BuiltType.coreInt)
      ]));
      expect(sourceWriter.toString(), 'String foo, int bar');
    });

    test('writes a parameter list with a single optional parameter', () {
      sourceWriter.writeParameterList(const BuiltParameterList(
          optionalArguments: const [
            const BuiltVariable('foo', type: BuiltType.coreString),
          ]));
      expect(sourceWriter.toString(), '[String foo]');
    });

    test('writes a parameter list with a single named parameter', () {
      sourceWriter.writeParameterList(const BuiltParameterList(
          optionalArguments: const [
            const BuiltVariable('foo', type: BuiltType.coreString),
          ],
          useNamedOptionalArguments: true));
      expect(sourceWriter.toString(), '{String foo}');
    });

    test('writes a parameter list with required and optional parameters', () {
      sourceWriter.writeParameterList(const BuiltParameterList(
          requiredArguments: const [
            const BuiltVariable('foo', type: BuiltType.coreString)
          ],
          optionalArguments: const [
            const BuiltVariable('bar', type: BuiltType.coreInt)
          ]));
      expect(sourceWriter.toString(), 'String foo, [int bar]');
    });

    test('writes a parameter list with required and optional parameters', () {
      sourceWriter.writeParameterList(const BuiltParameterList(
          requiredArguments: const [
            const BuiltVariable('foo', type: BuiltType.coreString)
          ],
          optionalArguments: const [
            const BuiltVariable('bar', type: BuiltType.coreInt)
          ],
          useNamedOptionalArguments: true));
      expect(sourceWriter.toString(), 'String foo, {int bar}');
    });
  });
}
