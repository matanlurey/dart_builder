part of dart_builder.src.elements.definition;

/// A field-level definition, either top-level or within a class or body.
class FieldRef
    extends Definition
    implements ClassLevelElement, TopLevelElement {
  /// Optional: An expression assigned to the field.
  final Source assignment;

  /// Optional: The type of the field.
  final TypeRef typeRef;

  /// Whether the field should be considered `const`.
  final bool isConst;

  /// Whether the field should be considered `final`.
  final bool isFinal;

  /// Whether the field should be considered `isStatic`.
  final bool isStatic;

  /// Create a new field definition
  FieldRef(
      String name, {
      this.assignment,
      this.typeRef: TypeRef.DYNAMIC,
      this.isConst: false,
      this.isFinal: false,
      this.isStatic: false})
          : super(name) {
    if (isFinal && isConst) {
      throw new ArgumentError('Only "isFinal" or "isConst" can be true.');
    }
  }

  @override
  String toSource({bool inClass: false}) {
    var buffer = new StringBuffer();
    write(buffer, inClass: inClass);
    return buffer.toString();
  }

  @override
  void write(StringSink out, {bool inClass: false}) {
    if (!inClass && isStatic) {
      throw new StateError('Cannot output a static field outside of a class.');
    }
    if (isStatic) {
      out.write($STATIC);
      out.write(' ');
    }
    if (isFinal) {
      out.write($FINAL);
      out.write(' ');
    } else if (isConst) {
      out.write($CONST);
      out.write(' ');
    }
    if (!typeRef.isTyped && !isFinal && !isConst) {
      out.write($VAR);
      out.write(' ');
    } else if (typeRef.isTyped) {
      typeRef.write(out);
      out.write(' ');
    }
    out.write(name);
    if (assignment != null) {
      out.write(' = ');
      assignment.write(out);
    }
    out.write(';');
  }
}
