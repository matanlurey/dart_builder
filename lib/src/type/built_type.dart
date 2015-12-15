library dart_builder.src.type.built_type;

import 'package:collection/equality.dart';
import 'package:quiver/core.dart';

/// Immutable type definition, useful for code generation.
///
/// **Note**: There are two special pre-defined types, [BuiltType.coreDynamic]
/// and [BuiltType.coreVoid], which are unique, and are not equivalent to a
/// [BuiltType] with a name of `void` or `dynamic`.
///
/// See [TypeBuilder] for a mutable builder.
class BuiltType {
  static final Expando<int> _hashCodes = new Expando<int>('hashCodes');
  static const ListEquality _listEquals = const ListEquality();

  /// An alias for `BuiltType('bool')`.
  static const BuiltType coreBool = const BuiltType('bool');

  /// A pre-defined core type representing the `dynamic` keyword.
  ///
  /// **Note**: This is _not_ equivalent to `BuiltType('dynamic')`.
  static const BuiltType coreDynamic = const _DynamicBuiltType();

  /// An alias for `BuiltType('int')`.
  static const BuiltType coreInt = const BuiltType('int');

  /// An alias for `BuiltType('Object')`.
  static const BuiltType coreObject = const BuiltType('Object');

  /// An alias for `BuiltType('String')`.
  static const BuiltType coreString = const BuiltType('String');

  /// A pre-defined core type representing the `void` keyword.
  ///
  /// **Note**: This is _not_ equivalent to `BuiltType('void')`.
  static const BuiltType coreVoid = const _VoidBuiltType();

  /// Generic parameters.
  final List<BuiltType> generics;

  /// The name of the type.
  final String name;

  /// The import prefix, if any; otherwise `null`.
  final String prefix;

  const BuiltType(this.name, {this.generics: const [], this.prefix});

  const BuiltType.coreIterable([this.generics = const []])
      : this.name = 'Iterable',
        this.prefix = null;

  const BuiltType.coreList([this.generics = const []])
      : this.name = 'List',
        this.prefix = null;

  const BuiltType.coreMap([this.generics = const []])
      : this.name = 'Map',
        this.prefix = null;

  const BuiltType.coreSet([this.generics = const []])
      : this.name = 'Set',
        this.prefix = null;

  @override
  int get hashCode {
    int hashCode = _hashCodes[this];
    if (hashCode == null) {
      hashCode = hash3(name, prefix, hashObjects(generics));
      _hashCodes[this] = hashCode;
    }
    return hashCode;
  }

  @override
  bool operator ==(Object o) {
    if (o is BuiltType) {
      if (o is _DynamicBuiltType || o is _VoidBuiltType) return false;
      return o.name == name &&
          o.prefix == prefix &&
          _listEquals.equals(o.generics, generics);
    }
    return false;
  }

  @override
  String toString() => 'BuiltType' +
      {'name': name, 'prefix': prefix, 'generics': generics}.toString();
}

class _DynamicBuiltType implements BuiltType {
  @override
  final List<BuiltType> generics = const [];

  @override
  final String name = 'dynamic';

  @override
  final String prefix = null;

  const _DynamicBuiltType();

  String toString() => 'BuiltType {dynamic}';
}

class _VoidBuiltType implements BuiltType {
  @override
  final List<BuiltType> generics = const [];

  @override
  final String name = 'void';

  @override
  final String prefix = null;

  const _VoidBuiltType();

  @override
  String toString() => 'BuiltType {void}';
}
