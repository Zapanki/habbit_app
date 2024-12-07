import 'package:flutter/material.dart';
import 'package:habbit_app/started_screens/things/colo_extension.dart';
import 'package:habbit_app/started_screens/things/common/notification_row.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({super.key});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  List notificationArr = [
    {
      "image": "assets/images/Workout1.png",
      "title": "Hey, it’s time for lunch",
      "time": "About 1 minutes ago"
    },
    {
      "image": "assets/images/Workout2.png",
      "title": "Don’t miss your lowerbody workout",
      "time": "About 3 hours ago"
    },
    {
      "image": "assets/images/Workout3.png",
      "title": "Hey, let’s add some meals for your b",
      "time": "About 3 hours ago"
    },
    {
      "image": "assets/images/Workout1.png",
      "title": "Congratulations, You have finished A..",
      "time": "29 May"
    },
    {
      "image": "assets/images/Workout2.png",
      "title": "Hey, it’s time for lunch",
      "time": "8 April"
    },
    {
      "image": "assets/images/Workout3.png",
      "title": "Ups, You have missed your Lowerbo...",
      "time": "8 April"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.white,
        centerTitle: true,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            margin: const EdgeInsets.all(8),
            height: 40,
            width: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: TColor.lightGray,
                borderRadius: BorderRadius.circular(10)),
            child: IconButton(
              onPressed: () => {Navigator.pop(context)},
              icon: const Icon(Icons.arrow_back_ios_new),
            ),
          ),
        ),
        title: Text(
          "Notification",
          style: TextStyle(
              color: TColor.black, fontSize: 16, fontWeight: FontWeight.w700),
        ),
        actions: [
          InkWell(
            onTap: () {},
            child: Container(
              margin: const EdgeInsets.all(8),
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: TColor.lightGray,
                  borderRadius: BorderRadius.circular(10)),
              child: IconButton(
                  onPressed: () {}, icon: const Icon(Icons.more_horiz)),
            ),
          )
        ],
      ),
      backgroundColor: TColor.white,
      body: ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
          itemBuilder: ((context, index) {
            var nObj = notificationArr[index] as Map? ?? {};
            return NotificationRow(nObj: nObj);
          }),
          separatorBuilder: (context, index) {
            return Divider(
              color: TColor.gray.withOpacity(0.5),
              height: 1,
            );
          },
          itemCount: notificationArr.length),
    );
  }
}
