# Dart Builder

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
