library dart_builder.src.file.built_file;

import 'package:quiver/core.dart';

// TODO: Implement.
class BuiltFile {}

/// An `import` or `export` directive.
class BuiltDirective {
  static final Expando<int> _hashCodes = new Expando<int>('hashCodes');

  /// Whether the directive should be post-fixed with the `deferred` keyword.
  ///
  /// It is assumed [namespace] will also be supplied in this case.
  final bool isDeferred;

  /// Whether this is an export directive.
  final bool isExport;

  /// Whether this is an import directive.
  final bool isImport;

  /// The post-fixed keyword; "foo" becomes `as foo`.
  final String namespace;

  /// The URL being imported or exported.
  final String url;

  BuiltDirective.export(
      this.url, {
      this.isDeferred: false,
      this.namespace})
          : this.isExport = true,
            this.isImport = false;

  BuiltDirective.import(
      this.url, {
      this.isDeferred: false,
      this.namespace})
          : this.isExport = false,
            this.isImport = true;

  @override
  int get hashCode {
    int hashCode = _hashCodes[this];
    if (hashCode == null) {
      hashCode = hashObjects([
        isDeferred,
        isExport,
        isImport,
        namespace,
        url
      ]);
      _hashCodes[this] = hashCode;
    }
    return hashCode;
  }

  @override
  bool operator ==(Object o) {
    if (o is BuiltDirective) {
      // Avoid a more expensive comparison if the hash codes are different.
      if (o.hashCode != hashCode) return false;
      return o.isDeferred == isDeferred &&
             o.isExport == isExport &&
             o.isImport == isImport &&
             o.namespace == namespace &&
             o.url == url;
    }
    return false;
  }
}
