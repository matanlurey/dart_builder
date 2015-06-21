library dart_builder.test.elements.invoke.map_test;

import 'package:dart_builder/src/elements/invoke/map.dart';
import 'package:dart_builder/src/elements/source.dart';
import 'package:dart_builder/src/elements/type.dart';
import 'package:test/test.dart';

void main() {
  group('MapRef', () {
    test('can create a simple untyped empty map', () {
      expect(new MapRef().toSource(), '{}');
    });

    test('can create a simple untyped empty const map', () {
      expect(new MapRef(isConst: true).toSource(), 'const {}');
    });

    test('can define the type of the map', () {
      expect(
          new MapRef(
              keyTypeRef: TypeRef.STRING,
              valueTypeRef: TypeRef.STRING).toSource(),
          '<String, String> {}');
    });

    test('emits `dynamic` as the type if only one is typed', () {
      expect(
          new MapRef(
              keyTypeRef: TypeRef.DYNAMIC,
              valueTypeRef: TypeRef.STRING).toSource(),
          '<dynamic, String> {}');
    });

    test('can have values in the map', () {
      var map = new MapRef(values: {
        new Source.fromDart('1'): new Source.fromDart("'a'"),
        new Source.fromDart('2'): new Source.fromDart("'b'"),
        new Source.fromDart('3'): new Source.fromDart("'c'")
      });
      expect(map.toSource(), "{1: 'a', 2: 'b', 3: 'c'}");
    });
  });
}
