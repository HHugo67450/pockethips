import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RandomHips extends ConsumerStatefulWidget {
  const RandomHips({super.key});

  @override
  ConsumerState<RandomHips> createState() => _RandomHipsState();
}

class _RandomHipsState extends ConsumerState<RandomHips> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
    );
  }
}