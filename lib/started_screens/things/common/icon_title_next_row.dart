import 'package:flutter/material.dart';
import 'package:habbit_app/started_screens/things/colo_extension.dart';

class IconTitleNextRow extends StatelessWidget {
  final IconData? icon;
  final String title;
  final String time;
  final VoidCallback onPressed;
  final Color color;
  const IconTitleNextRow(
      {super.key,
      required this.icon,
      required this.title,
      required this.time,
      required this.onPressed,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                width: 30,
                height: 30,
                alignment: Alignment.center,
                child: Icon(
                  icon,
                  size: 20,
                  color: TColor.white,
                )),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: TextStyle(color: TColor.gray, fontSize: 12),
              ),
            ),
            SizedBox(
              width: 120,
              child: Text(
                time,
                textAlign: TextAlign.right,
                style: TextStyle(color: TColor.gray, fontSize: 12),
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 25,
              height: 25,
              child: Container(
                  width: 25,
                  height: 25,
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 15,
                    color: TColor.gray,
                  )),
            )
          ],
        ),
      ),
    );
  }
}
