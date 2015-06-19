library dart_builder.src.elements.directive;

import 'package:dart_builder/src/keywords.dart';
import 'package:dart_builder/src/elements/source.dart';

abstract class Directive extends Source {}

abstract class UriDirective extends Directive {
  /// The URI this directive points to.
  final Uri uri;

  UriDirective(this.uri);
}

class LibraryDirective extends Directive {
  final String name;

  LibraryDirective(this.name);

  @override
  void write(StringSink out) {
    out.write($LIBRARY);
    out.write(' ');
    out.write(name);
    out.write(';');
  }
}

class PartDirective extends UriDirective {
  PartDirective(Uri uri) : super(uri);

  @override
  void write(StringSink out) {
    out.write($PART);
    out.write(" '");
    out.write(uri);
    out.write("';");
  }
}

class PartOfDirective extends Directive {
  final String name;

  PartOfDirective(this.name);

  @override
  void write(StringSink out) {
    out.write($PART);
    out.write(' ');
    out.write($OF);
    out.write(' ');
    out.write(name);
    out.write(';');
  }
}

class ImportDirective extends UriDirective {
  final String as;

  final List<String> show;
  final List<String> hide;

  ImportDirective(
      Uri uri, {
      this.as,
      Iterable<String> show: const [],
      Iterable<String> hide: const []}) :
          super(uri),
          this.show = show.toList(growable: false),
          this.hide = hide.toList(growable: false) {
    if (show.isNotEmpty && hide.isNotEmpty) {
      throw new ArgumentError('Cannot use both "show" and "hide".');
    }
  }

  @override
  void write(StringSink out) {
    out.write($IMPORT);
    out.write(" '");
    out.write(uri);
    out.write("'");
    if (as != null) {
      out.write(' ');
      out.write($AS);
      out.write(' ');
      out.write(as);
    }
    if (show.isNotEmpty) {
      out.write(' ');
      out.write($SHOW);
      out.write(' ');
      out.write(show.join(', '));
    }
    if (hide.isNotEmpty) {
      out.write(' ');
      out.write($HIDE);
      out.write(' ');
      out.write(hide.join(', '));
    }
    out.write(';');
  }
}
