library dart_builder.src.source_writer;

import 'package:dart_builder/src/base.dart';
import 'package:dart_builder/src/clazz/built_class.dart';
import 'package:dart_builder/src/file/built_directive.dart';
import 'package:dart_builder/src/file/built_file.dart';
import 'package:dart_builder/src/method/built_method.dart';
import 'package:dart_builder/src/method/built_method_body.dart';
import 'package:dart_builder/src/parameter_list/built_parameter_list.dart';
import 'package:dart_builder/src/type/built_type.dart';
import 'package:dart_builder/src/variable/built_variable.dart';

/// Writes [object] to [stringBuffer].
typedef void WriteObject<T>(StringBuffer stringBuffer, T object);

// TODO: Refactor to remove having to type stringBuffer over and over.
// Instead, StringSourceWriter?.
class SourceWriter {
  const SourceWriter();

  /// A helper for writing many items out in a formatted matter.
  ///
  /// If [objects] is not empty:
  /// - Precedes with [prefix].
  /// - Writes items, separating them with [separator].
  /// - Ends with [suffix].
  void writeAll(StringBuffer stringBuffer, Iterable objects,
      {WriteObject writeObject: _identityWriteObject,
      String prefix: '',
      String separator: '',
      String suffix: ''}) {
    if (objects.isEmpty) return;
    stringBuffer.write(prefix);
    var wroteFirstItem = false;
    for (final object in objects) {
      if (wroteFirstItem) {
        stringBuffer.write(separator);
      }
      writeObject(stringBuffer, object);
      wroteFirstItem = true;
    }
    stringBuffer.write(suffix);
  }

  /// Writes [builtClass] to [stringBuffer].
  void writeClass(StringBuffer stringBuffer, BuiltClass builtClass) {
    if (builtClass.isAbstract) {
      stringBuffer.write('abstract ');
    }
    if (builtClass.isExternal) {
      stringBuffer.write('external ');
    }
    stringBuffer..write('class ')..write(builtClass.name);
    writeAll(stringBuffer, builtClass.generics,
        writeObject: writeType, separator: ', ', prefix: '<', suffix: '>');
    stringBuffer.write(' ');
    BuiltType extend = builtClass.extend;
    if (extend == null && builtClass.mixin.isNotEmpty) {
      extend = BuiltType.coreObject;
    }
    if (extend != null) {
      stringBuffer.write('extends ');
      writeType(stringBuffer, extend);
      stringBuffer.write(' ');
    }
    writeAll(stringBuffer, builtClass.mixin,
        writeObject: writeType, prefix: 'with ', suffix: ' ', separator: ', ');
    writeAll(stringBuffer, builtClass.implement,
        writeObject: writeType,
        prefix: 'implements ',
        suffix: ' ',
        separator: ', ');
    stringBuffer.writeln('{');
    writeAll(stringBuffer, builtClass.fields,
        writeObject: (StringBuffer buffer, BuiltVariable variable) {
      writeVariable(buffer, variable);
      buffer.write(';\n');
    });
    writeAll(stringBuffer, builtClass.methods,
        writeObject: writeMethod, separator: '\n');
    stringBuffer.writeln('}');
  }

  /// Writes [builtDirective] to [stringBuffer].
  void writeDirective(
      StringBuffer stringBuffer, BuiltDirective builtDirective) {
    if (builtDirective.isImport) {
      stringBuffer.write('import ');
    }
    if (builtDirective.isExport) {
      stringBuffer.write('export ');
    }
    if (builtDirective.isPart) {
      stringBuffer.write('part ');
    }
    stringBuffer..write("'")..write(builtDirective.url)..write("'");
    writeAll(stringBuffer, builtDirective.show,
        writeObject: (StringBuffer stringBuffer, String token) {
      stringBuffer.write(token);
    }, prefix: ' show ', separator: ',');
    writeAll(stringBuffer, builtDirective.hide,
        writeObject: (StringBuffer stringBuffer, String token) {
      stringBuffer.write(token);
    }, prefix: ' hide ', separator: ',');
    if (builtDirective.namespace != null) {
      if (builtDirective.isDeferred) {
        stringBuffer.write(' deferred');
      }
      stringBuffer..write(' as ')..write(builtDirective.namespace);
    }
  }

  /// Writes [builtFile] to [stringBuffer].
  void writeFile(
      StringBuffer stringBuffer, BuiltFile builtFile) {
    if (builtFile.isPartOf) {
      stringBuffer.write('part of ');
    } else {
      stringBuffer.write('library ');
    }
    stringBuffer
      ..write(builtFile.libraryName)
      ..writeln(';');
    writeAll(
        stringBuffer,
        builtFile.directives,
        writeObject: (StringBuffer stringBuffer, BuiltDirective builtDirective) {
          writeDirective(stringBuffer, builtDirective);
          stringBuffer.writeln(';');
        },
        suffix: '\n\n');
    writeAll(
        stringBuffer,
        builtFile.definitions,
        writeObject: (StringBuffer stringBuffer, BuiltNamedDefinition builtNamedDefinition) {
          if (builtNamedDefinition is BuiltClass) {
            writeClass(stringBuffer, builtNamedDefinition);
            stringBuffer.writeln();
          } else if (builtNamedDefinition is BuiltMethod) {
            writeMethod(stringBuffer, builtNamedDefinition);
            stringBuffer.writeln();
          } else if (builtNamedDefinition is BuiltVariable) {
            writeVariable(stringBuffer, builtNamedDefinition);
            stringBuffer.writeln(';');
          }
        });
  }

  /// Writes [builtMethod] to [stringBuffer].
  void writeMethod(StringBuffer stringBuffer, BuiltMethod builtMethod) {
    if (builtMethod.isExternal) {
      stringBuffer..write('external')..write(' ');
    }
    if (builtMethod.isStatic) {
      stringBuffer..write('static')..write(' ');
    }
    if (builtMethod.isAbstract) {
      stringBuffer..write('abstract')..write(' ');
    }
    writeType(stringBuffer, builtMethod.returnType);
    stringBuffer.write(' ');
    if (builtMethod.isGetter) {
      stringBuffer..write('get')..write(' ');
    }
    if (builtMethod.isSetter) {
      stringBuffer..write('set')..write(' ');
    }
    if (builtMethod.isOperator) {
      stringBuffer..write('operator')..write(' ');
    }
    if (builtMethod.name != null) {
      stringBuffer.write(builtMethod.name);
    }
    if (!builtMethod.isGetter) {
      stringBuffer.write('(');
    }
    writeParameterList(stringBuffer, builtMethod.parameters);
    if (!builtMethod.isGetter) {
      stringBuffer.write(')');
    }
    if (builtMethod.body != null) {
      writeMethodBody(stringBuffer, builtMethod.body);
    }
  }

  /// Writes [builtMethodBody] to [stringBuffer].
  void writeMethodBody(
      StringBuffer stringBuffer, BuiltMethodBody builtMethodBody) {
    if (builtMethodBody.isAsync) {
      stringBuffer.write('async');
    }
    if (builtMethodBody.isSync) {
      stringBuffer.write('sync');
    }
    if (builtMethodBody.isStar) {
      stringBuffer.write('*');
    }
    if (builtMethodBody.isExpression) {
      stringBuffer.write(' => ');
      assert(builtMethodBody.lines.length == 1);
      stringBuffer.write(builtMethodBody.lines.first);
    } else {
      if (builtMethodBody.lines.isEmpty) {
        stringBuffer.writeln(' {}');
      } else {
        stringBuffer.writeln(' {');
        builtMethodBody.lines.forEach(stringBuffer.writeln);
        stringBuffer.writeln('}');
      }
    }
  }

  /// Writes [builtParameterList] to [stringBuffer].
  void writeParameterList(
      StringBuffer stringBuffer, BuiltParameterList builtParameterList) {
    writeAll(stringBuffer, builtParameterList.requiredArguments,
        writeObject: writeVariable, separator: ', ');
    if (builtParameterList.optionalArguments.isNotEmpty) {
      if (builtParameterList.requiredArguments.isNotEmpty) {
        stringBuffer.write(', ');
      }
      stringBuffer
          .write(builtParameterList.useNamedOptionalArguments ? '{' : '[');
      writeAll(stringBuffer, builtParameterList.optionalArguments,
          writeObject: (StringBuffer buffer, BuiltVariable parameter) {
        writeVariable(buffer, parameter,
            keyValuePair: builtParameterList.useNamedOptionalArguments);
      }, separator: ', ');
      stringBuffer
          .write(builtParameterList.useNamedOptionalArguments ? '}' : ']');
    }
  }

  /// Writes [builtType] to [stringBuffer].
  void writeType(StringBuffer stringBuffer, BuiltType builtType) {
    if (builtType.prefix != null) {
      stringBuffer.write(builtType.prefix);
      stringBuffer.write('.');
    }
    stringBuffer.write(builtType.name);
    writeAll(stringBuffer, builtType.generics,
        writeObject: writeType, prefix: '<', separator: ', ', suffix: '>');
  }

  /// Writes [builtParameter] to [stringBuffer].
  void writeVariable(StringBuffer stringBuffer, BuiltVariable builtParameter,
      {bool keyValuePair: false}) {
    writeType(stringBuffer, builtParameter.type);
    stringBuffer..write(' ')..write(builtParameter.name);
    if (builtParameter.defaultValue != null) {
      stringBuffer.write(keyValuePair ? ': ' : ' = ');
      stringBuffer.write(builtParameter.defaultValue);
    }
  }

  static void _identityWriteObject(StringBuffer stringBuffer, Object object) {
    stringBuffer.write(object.toString());
  }
}
