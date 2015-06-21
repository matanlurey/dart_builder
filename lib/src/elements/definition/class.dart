part of dart_builder.src.elements.definition;

/// A class definition.
class ClassRef extends Definition implements TopLevelElement {
  /// Fields on the class.
  final List<FieldRef> fields;

  /// Methods on the class.
  final List<MethodRef> methods;

  /// Whether the class should be declared abstract.
  final bool isAbstract;

  ClassRef(
      String name, {
      this.fields: const [],
      this.methods: const [],
      this.isAbstract: false})
          : super(name);

  /// Whether either [fields] or [methods] are defined.
  bool get hasBody => fields.isNotEmpty || methods.isNotEmpty;

  @override
  void write(StringSink out) {
    if (isAbstract) {
      out.write($ABSTRACT);
      out.write(' ');
    }
    out.write($CLASS);
    out.write(' ');
    out.write(name);
    if (!hasBody) {
      out.write(' {}');
    } else {
      out.writeln(' {');
      for (final field in fields) {
        out.write('  ');
        field.write(out, inClass: true);
        out.writeln();
      }
      for (final method in methods) {
        out.write('  ');
        method.write(out);
        out.writeln();
      }
      out.writeln('}');
    }
  }
}
