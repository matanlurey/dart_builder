library dart_builder.src.elements.source;

import 'package:mustache/mustache.dart' as mustache;

abstract class Source {
  /// When it's difficult or impossible to represent parts of the source code
  /// in objects and builders, it's possible to just use [rawDartSource].
  factory Source.fromDart(String rawDartSource) = _RawSource;

  /// Similar to the [fromDart] constructor, allows creation from mustache-type
  /// templates.
  factory Source.fromTemplate(String template, [context]) =  _TemplateSource;

  const Source();

  void write(StringSink out);

  String toSource() {
    final buffer = new StringBuffer();
    write(buffer);
    return buffer.toString();
  }

  @override
  String toString() => runtimeType.toString() + ' {' + toSource() + '}';
}

class _TemplateSource extends Source {
  final _context;
  final mustache.Template _mustacheTemplate;

  factory _TemplateSource(
      String mustacheTemplate, [
      context = const {}]) {
    return new _TemplateSource._(
        new mustache.Template(mustacheTemplate),
        context);
  }

  _TemplateSource._(this._mustacheTemplate, this._context);

  @override
  void write(StringSink out) {
    _mustacheTemplate.render(_context, out);
  }
}

class _RawSource extends Source {
  final String rawSource;

  _RawSource(this.rawSource);

  @override
  void write(StringSink out) {
    out.write(rawSource);
  }
}

typedef void CustomWriteFn(Source source, StringSink out);

void writeAll(
    Iterable<Source> elements,
    StringSink out, {
    String prefix: '',
    String postfix: '',
    String join: ', ',
    CustomWriteFn customWrite}) {
  if (elements.isNotEmpty) {
    out.write(prefix);
    final iterator = elements.iterator..moveNext();
    if (customWrite == null) {
      iterator.current.write(out);
    } else {
      customWrite(iterator.current, out);
    }
    while (iterator.moveNext()) {
      out.write(join);
      if (customWrite == null) {
        iterator.current.write(out);
      } else {
        customWrite(iterator.current, out);
      }
    }
    out.write(postfix);
  } else {
    out.write(prefix);
    out.write(postfix);
  }
}
