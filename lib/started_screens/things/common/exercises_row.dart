import 'package:flutter/material.dart';
import 'package:habbit_app/started_screens/things/colo_extension.dart';

class ExercisesRow extends StatelessWidget {
  final Map eObj;
  final VoidCallback onPressed;
  const ExercisesRow({super.key, required this.eObj, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Image.asset(
              eObj["image"].toString(),
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                eObj["title"].toString(),
                style: TextStyle(
                    color: TColor.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
              Text(
                eObj["value"].toString(),
                style: TextStyle(
                  color: TColor.gray,
                  fontSize: 12,
                ),
              ),
            ],
          )),
          IconButton(
              onPressed: onPressed,
              icon: Icon(
                Icons.arrow_forward_ios,
                color: TColor.black,
              ))
        ],
      ),
    );
  }
}
