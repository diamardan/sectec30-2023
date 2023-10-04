import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final visibleButtonProvider = StateProvider.autoDispose<bool>((ref) {
  return true;
});
