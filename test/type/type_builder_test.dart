library dart_builder.test.type.type_builder;

import 'package:dart_builder/src/type/built_type.dart';
import 'package:dart_builder/src/type/type_builder.dart';
import 'package:test/test.dart';

void main() {
  group('TypeBuilder', () {
    group('presets return a set BuiltType', () {
      test('bool', () {
        expect(TypeBuilder.coreBool.build(), BuiltType.coreBool);
      });

      test('dynamic', () {
        expect(TypeBuilder.coreDynamic.build(), BuiltType.coreDynamic);
      });

      test('int', () {
        expect(TypeBuilder.coreInt.build(), BuiltType.coreInt);
      });

      test('Object', () {
        expect(TypeBuilder.coreObject.build(), BuiltType.coreObject);
      });

      test('String', () {
        expect(TypeBuilder.coreString.build(), BuiltType.coreString);
      });

      test('void', () {
        expect(TypeBuilder.coreVoid.build(), BuiltType.coreVoid);
      });
    });

    test('can build a type', () {
      var typeBuilder = new TypeBuilder('List');
      expect(typeBuilder.build(), const BuiltType.coreList());

      typeBuilder.addExistingGeneric(TypeBuilder.coreString);
      expect(typeBuilder.build(),
          const BuiltType.coreList(const [BuiltType.coreString]));
    });

    // TODO: Expand tests to be more comprehensive.
  });
}
