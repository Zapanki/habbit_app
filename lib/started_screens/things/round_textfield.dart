import 'package:flutter/material.dart';
import 'package:habbit_app/started_screens/things/colo_extension.dart';

class RoundTextField extends StatelessWidget {
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final String hitText;
  final IconData? icon;
  final Widget? rigtIcon;
  final bool obscureText;
  final EdgeInsets? margin;
  final VoidCallback? onTap;
  final bool isInvalid;
  final String? errorMessage;
  final VoidCallback? toggleVisibility;

  const RoundTextField({
    super.key,
    required this.hitText,
    required this.icon,
    this.controller,
    this.margin,
    this.keyboardType,
    this.obscureText = false,
    this.rigtIcon,
    this.onTap,
    this.isInvalid = false,
    this.errorMessage,
    this.toggleVisibility,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: margin,
          decoration: BoxDecoration(
            color: TColor.lightGray,
            borderRadius: BorderRadius.circular(15),
            border: isInvalid
                ? Border.all(color: Colors.red, width: 1.5)
                : Border.all(color: Colors.transparent, width: 1),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            obscureText: obscureText,
            readOnly: onTap != null,
            onTap: onTap,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                vertical: 15,
                horizontal: 15,
              ),
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              hintText: hitText,
              suffixIcon: toggleVisibility != null
                  ? GestureDetector(
                      onTap: toggleVisibility,
                      child: Icon(
                        obscureText
                            ? Icons.visibility_off // Закрытый глаз
                            : Icons.visibility, // Открытый глаз
                        color: TColor.gray,
                      ),
                    )
                  : rigtIcon,
              prefixIcon: icon != null
                  ? Icon(icon, size: 20, color: TColor.gray)
                  : null,
              hintStyle: TextStyle(color: TColor.gray, fontSize: 12),
            ),
          ),
        ),
        if (isInvalid && errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 4.0),
            child: Text(
              errorMessage!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
