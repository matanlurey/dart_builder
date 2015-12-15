library dart_builder.test.file.built_directive_test;

import 'package:dart_builder/src/clazz/built_class.dart';
import 'package:dart_builder/src/file/built_directive.dart';
import 'package:dart_builder/src/file/built_file.dart';
import 'package:dart_builder/src/method/built_method.dart';
import 'package:dart_builder/src/method/built_method_body.dart';
import 'package:dart_builder/src/variable/built_variable.dart';
import 'package:dart_builder/src/source_writer.dart';
import 'package:test/test.dart';

void main() {
  group('BuiltFile with SourceWriter', () {
    StringBuffer stringBuffer;
    SourceWriter sourceWriter;

    setUp(() {
      stringBuffer = new StringBuffer();
      sourceWriter = const SourceWriter();
    });

    test('writes a library file', () {
      sourceWriter
          .writeFile(
              stringBuffer,
              const BuiltFile('foo',
                  definitions: const [
                    const BuiltVariable('someVar'),
                    const BuiltMethod(
                        name: 'someMethod',
                        body: BuiltMethodBody.empty),
                    const BuiltClass('SomeClass')
                  ],
                  directives: const [
                    const BuiltDirective.import('package:bar/bar.dart')
                  ]));
      expect(
          stringBuffer.toString(),
          'library foo;\n'
          'import \'package:bar/bar.dart\';\n'
          '\n'
          '\n'
          'dynamic someVar;\n'
          'void someMethod() {}\n\n'
          'class SomeClass {\n'
          '}\n'
          '\n'
          '');
    });

    test('writes a part file', () {
      sourceWriter
          .writeFile(
              stringBuffer,
              const BuiltFile('foo',
                  definitions: const [],
                  directives: const [],
                  isPartOf: true));
      expect(
        stringBuffer.toString(),
        'part of foo;\n');
    });
  });
}
