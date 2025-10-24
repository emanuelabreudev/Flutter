import 'package:flutter/material.dart';

class LabeledField extends StatelessWidget {
  final String label;
  final String? value; // agora opcional
  final Widget? child; // novo: permite passar um widget (ex.: TextFormField)
  final IconData? icon;
  final Color? iconColor;

  const LabeledField({
    Key? key,
    required this.label,
    this.value,
    this.child,
    this.icon,
    this.iconColor,
  }) : assert(
         value != null || child != null,
         'Either value or child must be provided',
       ),
       super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 20, color: iconColor ?? Colors.grey[600]),
          const SizedBox(width: 12),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              // Se child existir, usa-o; senão usa o value como texto simples
              child ??
                  Text(
                    value!,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
            ],
          ),
        ),
      ],
    );
  }
}
