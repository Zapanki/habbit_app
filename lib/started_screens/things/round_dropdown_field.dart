import 'package:flutter/material.dart';
import 'package:habbit_app/started_screens/things/colo_extension.dart';

class RoundDropdown<T> extends StatelessWidget {
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final String hintText;
  final IconData? icon;

  const RoundDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.hintText,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: TColor.lightGray,
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          if (icon != null)
            Icon(
              icon,
              size: 20,
              color: TColor.gray,
            ),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<T>(
                value: value,
                items: items,
                onChanged: onChanged,
                hint: Text(
                  hintText,
                  style: TextStyle(color: TColor.gray, fontSize: 12),
                ),
                isExpanded: true,
                style: TextStyle(color: TColor.black, fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
