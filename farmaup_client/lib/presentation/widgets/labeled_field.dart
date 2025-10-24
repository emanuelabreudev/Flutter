import 'package:flutter/material.dart';

class LabeledField extends StatelessWidget {
  final String label;
  final Widget child;
  const LabeledField({Key? key, required this.label, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      const SizedBox(height: 8),
      child
    ]);
  }
}
