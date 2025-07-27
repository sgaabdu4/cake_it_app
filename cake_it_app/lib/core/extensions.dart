import 'package:flutter/material.dart';

// context extensions for cleaner route argument access
extension BuildContextExtensions on BuildContext {
  T? routeArguments<T>() {
    return ModalRoute.of(this)?.settings.arguments as T?;
  }
}
