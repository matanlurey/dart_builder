part of dart_builder.src.elements.definition;

/// A parameter of a [MethodDefinition].
class ParameterRef extends NamedSourceElement {
  /// The default value, if any.
  final Source defaultValue;

  /// The type of the parameter, if any.
  final TypeRef typeRef;

  const ParameterRef(
      String name, {
      this.defaultValue,
      this.typeRef: TypeRef.DYNAMIC})
          : super(name);

  @override
  String toSource({bool asPositional: true}) {
    var buffer = new StringBuffer();
    write(buffer, asPositional: asPositional);
    return buffer.toString();
  }

  @override
  void write(StringSink out, {bool asPositional: true}) {
    var assignmentSpan = asPositional ? ' = ' : ': ';
    if (typeRef.isTyped) {
      typeRef.write(out);
      out.write(' ');
    }
    out.write(name);
    if (defaultValue != null) {
      out.write(assignmentSpan);
      defaultValue.write(out);
    }
  }
}
