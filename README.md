# Dart Builder

[![Build Status](https://drone.io/github.com/matanlurey/dart_builder/status.png)](https://drone.io/github.com/matanlurey/dart_builder/latest)

## Introduction

A fluent, immutable API for creating Dart code.

Each of the core classes is split into two: a mutable builder and an immutable
"built" class. Builders are for computation, "built" classes are for safely
sharing with no need to copy defensively.

## Design

All of the "built" files are:

- Immutable using the `const` constructor or a "builder" class
- Hashable
- Implement deep equality

## Concepts

Will need to be expanded on (docs, examples), but here are some of the common data structures provided:

- [BuiltClass](//github.com/matanlurey/dart_builder/blob/master/lib/src/clazz/built_class.dart)
- [BuiltMethod](//github.com/matanlurey/dart_builder/blob/master/lib/src/method/built_method.dart)
- [BuiltType](//github.com/matanlurey/dart_builder/blob/master/lib/src/type/built_type.dart)
- [BuiltVariable](//github.com/matanlurey/dart_builder/blob/master/lib/src/clazz/built_variable.dart)

You may also be interested in the [SourceWriter](//github.com/matanlurey/dart_builder/blob/master/lib/src/source_writer.dart), which produces raw Dart code (text) from these data structures. Eventually it will be integrated with `dartfmt` and be possible to integrate into a processing pipeline.
