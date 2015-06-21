library dart_builder.test.elements.definition.field_test;

import 'package:dart_builder/src/elements/definition.dart';
import 'package:dart_builder/src/elements/source.dart';
import 'package:dart_builder/src/elements/type.dart';
import 'package:test/test.dart';

void main() {
  group('FieldRef', () {
    test('can create a simple untyped field', () {
      var field = new FieldRef('bar');
      expect(field.toSource(), 'var bar;');
    });

    test('can create a static field in a class', () {
      var field = new FieldRef('bar', isStatic: true);
      expect(field.toSource(inClass: true), 'static var bar;');
    });

    test('throws when trying to create a static field outside a class', () {
      var field = new FieldRef('bar', isStatic: true);
      expect(() => field.toSource(), throwsStateError);
    });

    test('can create a const field', () {
      var field = new FieldRef('bar', isConst: true);
      expect(field.toSource(), 'const bar;');
    });

    test('can create a final field', () {
      var field = new FieldRef('bar', isFinal: true);
      expect(field.toSource(), 'final bar;');
    });

    test('throws if const and final are both true', () {
      expect(
          () => new FieldRef('', isConst: true, isFinal: true),
          throwsArgumentError);
    });

    test('can be typed', () {
      var field = new FieldRef('bar', typeRef: TypeRef.STRING);
      expect(field.toSource(), 'String bar;');
    });

    test('can have an assignment expression', () {
      var field = new FieldRef('bar', assignment: new Source.fromDart('5'));
      expect(field.toSource(), 'var bar = 5;');
    });
  });
}
