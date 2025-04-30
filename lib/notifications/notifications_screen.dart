import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffEEEEE6),
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: const Color(0xffEEEEE6),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            const Row(
              children: [
                Text('Today',style: TextStyle(color: Colors.black),),
                Spacer(),
                Text('Mark all as read',style: TextStyle(color: Colors.grey))
              ],
            ),
            const SizedBox(height: 10,),
            Container(
              width: double.infinity,
              height: 55,
              color: Colors.blueGrey,
            )
          ],
        ),
      ),
    );
  }
}