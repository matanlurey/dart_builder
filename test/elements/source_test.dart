library dart_builder.test.source_test;

import 'package:dart_builder/src/elements/source.dart';
import 'package:test/test.dart';

void main() {
  group('Source', () {
    test('fromDart', () {
      var source = new Source.fromDart('if (a == null) return false;');
      expect(source.toSource(), 'if (a == null) return false;');
    });

    test('fromTemplate', () {
      var source = new Source.fromTemplate(
          'if ({{var}} == null) return {{value}};',
          {'var': 'a', 'value': 'false'});
      expect(source.toSource(), 'if (a == null) return false;');
    });
  });
}
