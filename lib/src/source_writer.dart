library dart_builder.src.source_writer;

import 'package:dart_builder/src/base.dart';
import 'package:dart_builder/src/clazz/built_class.dart';
import 'package:dart_builder/src/clazz/built_constructor.dart';
import 'package:dart_builder/src/file/built_directive.dart';
import 'package:dart_builder/src/file/built_file.dart';
import 'package:dart_builder/src/method/built_method.dart';
import 'package:dart_builder/src/method/built_method_body.dart';
import 'package:dart_builder/src/method/built_method_invocation.dart';
import 'package:dart_builder/src/parameter_list/built_parameter_list.dart';
import 'package:dart_builder/src/type/built_type.dart';
import 'package:dart_builder/src/variable/built_variable.dart';

/// An interface that can write "built" structures, often to disk or memory.
abstract class SourceWriter {
  void writeClass(BuiltClass builtClass);
  void writeConstructor(BuiltConstructor builtConstructor, String className);
  void writeDirective(BuiltDirective builtDirective);
  void writeFile(BuiltFile builtFile);
  void writeMethod(BuiltMethod builtMethod);
  void writeMethodBody(BuiltMethodBody builtMethodBody);
  void writeMethodInvocation(BuiltMethodInvocation builtMethodInvocation);
  void writeParameterList(BuiltParameterList builtParameterList);
  void writeType(BuiltType builtType);
  void writeVariable(BuiltVariable builtVariable);
}

/// A writer on top of [StringBuffer].
///
/// Use [toString] to get the resulting string.
class StringSourceWriter implements SourceWriter {
  final StringBuffer _stringBuffer = new StringBuffer();

  @override
  String toString() => _stringBuffer.toString();

  /// A helper for writing many items out in a formatted matter.
  ///
  /// If [objects] is not empty:
  /// - Precedes with [prefix].
  /// - Writes items, separating them with [separator].
  /// - Ends with [suffix].
  void writeAll(Iterable objects,
      {void writeObject(Object object),
      String prefix: '',
      String separator: '',
      String suffix: ''}) {
    if (objects.isEmpty) return;
    _stringBuffer.write(prefix);
    var wroteFirstItem = false;
    for (final object in objects) {
      if (wroteFirstItem) {
        _stringBuffer.write(separator);
      }
      if (writeObject == null) {
        writeObject = _stringBuffer.write;
      }
      writeObject(object);
      wroteFirstItem = true;
    }
    _stringBuffer.write(suffix);
  }

  @override
  void writeClass(BuiltClass builtClass) {
    if (builtClass.isAbstract) {
      _stringBuffer.write('abstract ');
    }
    if (builtClass.isExternal) {
      _stringBuffer.write('external ');
    }
    _stringBuffer..write('class ')..write(builtClass.name);
    writeAll(builtClass.generics,
        writeObject: writeType, separator: ', ', prefix: '<', suffix: '>');
    _stringBuffer.write(' ');
    BuiltType extend = builtClass.extend;
    if (extend == null && builtClass.mixin.isNotEmpty) {
      extend = BuiltType.coreObject;
    }
    if (extend != null) {
      _stringBuffer.write('extends ');
      writeType(extend);
      _stringBuffer.write(' ');
    }
    writeAll(builtClass.mixin,
        writeObject: writeType, prefix: 'with ', suffix: ' ', separator: ', ');
    writeAll(builtClass.implement,
        writeObject: writeType,
        prefix: 'implements ',
        suffix: ' ',
        separator: ', ');
    _stringBuffer.writeln('{');
    writeAll(builtClass.fields, writeObject: (BuiltVariable variable) {
      writeVariable(variable);
      _stringBuffer.write(';\n');
    });
    writeAll(builtClass.constructors,
        writeObject: (BuiltConstructor constructor) {
      writeConstructor(constructor, builtClass.name);
      _stringBuffer.write('\n');
    });
    writeAll(builtClass.methods, writeObject: writeMethod, separator: '\n');
    _stringBuffer.writeln('}');
  }

  @override
  void writeConstructor(BuiltConstructor builtConstructor, String className) {
    if (builtConstructor.isConst) {
      _stringBuffer.write('const ');
    }
    if (builtConstructor.isFactory) {
      _stringBuffer.write('factory ');
    }
    _stringBuffer.write(className);
    if (builtConstructor.name != null) {
      _stringBuffer..write('.')..write(builtConstructor.name);
    }
    _stringBuffer.write('(');
    writeParameterList(builtConstructor.parameters);
    _stringBuffer.write(')');
    if (builtConstructor.redirectTo != null) {
      _stringBuffer.write(' = ');
      writeType(builtConstructor.redirectTo);
      if (builtConstructor.redirectToName != null) {
        _stringBuffer..write('.')..write(builtConstructor.redirectToName);
      }
    }
    if (builtConstructor.initializers.isNotEmpty ||
        builtConstructor.superCall != null) {
      _stringBuffer.write(' : ');
    }
    if (builtConstructor.superCall != null) {
      _stringBuffer.write('super');
      if (builtConstructor.superConstructorName != null) {
        _stringBuffer..write('.')..write(builtConstructor.superConstructorName);
      }
      writeMethodInvocation(builtConstructor.superCall);
      if (builtConstructor.initializers.isNotEmpty) {
        _stringBuffer.write(', ');
      }
    }
    if (builtConstructor.initializers.isNotEmpty) {
      writeAll(builtConstructor.initializers.keys,
          writeObject: (String property) {
        _stringBuffer
          ..write('this.')
          ..write(property)
          ..write(' = ')
          ..write(builtConstructor.initializers[property]);
      }, separator: ', ');
    }
    if (builtConstructor.body == null) {
      _stringBuffer.write(';');
    } else {
      _stringBuffer..write(' { ')..write(builtConstructor.body)..write('}');
    }
  }

  @override
  void writeDirective(BuiltDirective builtDirective) {
    if (builtDirective.isImport) {
      _stringBuffer.write('import ');
    }
    if (builtDirective.isExport) {
      _stringBuffer.write('export ');
    }
    if (builtDirective.isPart) {
      _stringBuffer.write('part ');
    }
    _stringBuffer..write("'")..write(builtDirective.url)..write("'");
    writeAll(builtDirective.show, writeObject: (String token) {
      _stringBuffer.write(token);
    }, prefix: ' show ', separator: ',');
    writeAll(builtDirective.hide, writeObject: (String token) {
      _stringBuffer.write(token);
    }, prefix: ' hide ', separator: ',');
    if (builtDirective.namespace != null) {
      if (builtDirective.isDeferred) {
        _stringBuffer.write(' deferred');
      }
      _stringBuffer..write(' as ')..write(builtDirective.namespace);
    }
  }

  @override
  void writeFile(BuiltFile builtFile) {
    if (builtFile.isPartOf) {
      _stringBuffer.write('part of ');
    } else {
      _stringBuffer.write('library ');
    }
    _stringBuffer
      ..write(builtFile.libraryName)
      ..writeln(';');
    writeAll(builtFile.directives,
        writeObject: (BuiltDirective builtDirective) {
      writeDirective(builtDirective);
      _stringBuffer.writeln(';');
    }, suffix: '\n\n');
    writeAll(builtFile.definitions,
        writeObject: (BuiltNamedDefinition builtNamedDefinition) {
      if (builtNamedDefinition is BuiltClass) {
        writeClass(builtNamedDefinition);
        _stringBuffer.writeln();
      } else if (builtNamedDefinition is BuiltMethod) {
        writeMethod(builtNamedDefinition);
        _stringBuffer.writeln();
      } else if (builtNamedDefinition is BuiltVariable) {
        writeVariable(builtNamedDefinition);
        _stringBuffer.writeln(';');
      }
    });
  }

  @override
  void writeMethod(BuiltMethod builtMethod) {
    if (builtMethod.isExternal) {
      _stringBuffer..write('external')..write(' ');
    }
    if (builtMethod.isStatic) {
      _stringBuffer..write('static')..write(' ');
    }
    if (builtMethod.isAbstract) {
      _stringBuffer..write('abstract')..write(' ');
    }
    writeType(builtMethod.returnType);
    _stringBuffer.write(' ');
    if (builtMethod.isGetter) {
      _stringBuffer..write('get')..write(' ');
    }
    if (builtMethod.isSetter) {
      _stringBuffer..write('set')..write(' ');
    }
    if (builtMethod.isOperator) {
      _stringBuffer..write('operator')..write(' ');
    }
    if (builtMethod.name != null) {
      _stringBuffer.write(builtMethod.name);
    }
    if (!builtMethod.isGetter) {
      _stringBuffer.write('(');
    }
    writeParameterList(builtMethod.parameters);
    if (!builtMethod.isGetter) {
      _stringBuffer.write(')');
    }
    if (builtMethod.body != null) {
      writeMethodBody(builtMethod.body);
    }
  }

  @override
  void writeMethodBody(BuiltMethodBody builtMethodBody) {
    if (builtMethodBody.isAsync) {
      _stringBuffer.write('async');
    }
    if (builtMethodBody.isSync) {
      _stringBuffer.write('sync');
    }
    if (builtMethodBody.isStar) {
      _stringBuffer.write('*');
    }
    if (builtMethodBody.isExpression) {
      _stringBuffer.write(' => ');
      _stringBuffer.write(builtMethodBody.body);
    } else {
      if (builtMethodBody.body.isEmpty) {
        _stringBuffer.writeln(' {}');
      } else {
        _stringBuffer..write(' {')..write(builtMethodBody.body)..write('}');
      }
    }
  }

  @override
  void writeMethodInvocation(BuiltMethodInvocation builtMethodInvocation) {
    _stringBuffer.write('(');
    writeAll(builtMethodInvocation.positionalArguments, separator: ', ');
    if (builtMethodInvocation.positionalArguments.isNotEmpty &&
        builtMethodInvocation.namedArguments.isNotEmpty) {
      _stringBuffer.write(', ');
    }
    writeAll(builtMethodInvocation.namedArguments.keys,
        writeObject: (String key) {
      _stringBuffer.write('$key: ${builtMethodInvocation.namedArguments[key]}');
    }, separator: ', ');
    _stringBuffer.write(')');
  }

  @override
  void writeParameterList(BuiltParameterList builtParameterList) {
    writeAll(builtParameterList.requiredArguments,
        writeObject: writeVariable, separator: ', ');
    if (builtParameterList.optionalArguments.isNotEmpty) {
      if (builtParameterList.requiredArguments.isNotEmpty) {
        _stringBuffer.write(', ');
      }
      _stringBuffer
          .write(builtParameterList.useNamedOptionalArguments ? '{' : '[');
      writeAll(builtParameterList.optionalArguments,
          writeObject: (BuiltVariable parameter) {
        writeVariable(parameter,
            keyValuePair: builtParameterList.useNamedOptionalArguments);
      }, separator: ', ');
      _stringBuffer
          .write(builtParameterList.useNamedOptionalArguments ? '}' : ']');
    }
  }

  @override
  void writeType(BuiltType builtType) {
    if (builtType.prefix != null) {
      _stringBuffer..write(builtType.prefix)..write('.');
    }
    _stringBuffer.write(builtType.name);
    writeAll(builtType.generics,
        writeObject: writeType, prefix: '<', separator: ', ', suffix: '>');
  }

  @override
  void writeVariable(BuiltVariable builtParameter, {bool keyValuePair: false}) {
    writeType(builtParameter.type);
    _stringBuffer..write(' ')..write(builtParameter.name);
    if (builtParameter.defaultValue != null) {
      _stringBuffer.write(keyValuePair ? ': ' : ' = ');
      _stringBuffer.write(builtParameter.defaultValue);
    }
  }
}
