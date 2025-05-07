import 'package:bakeryadminapp/manage_orders/sub_screens/active_orders.dart';
import 'package:bakeryadminapp/manage_orders/sub_screens/delivered_orders.dart';
import 'package:bakeryadminapp/manage_orders/sub_screens/pending_orders.dart';
import 'package:bakeryadminapp/manage_orders/sub_screens/rejected_orders.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ManageOrdersScreen extends StatefulWidget {
  const ManageOrdersScreen({super.key});

  @override
  _ManageOrdersScreenState createState() => _ManageOrdersScreenState();
}

class _ManageOrdersScreenState extends State<ManageOrdersScreen> {
  int totalOrders = 0;
  int pendingOrders = 0;
  int activeOrders = 0;
  int deliveredOrders = 0;
  int rejectedOrders = 0;

  @override
  void initState() {
    super.initState();
    fetchOrderCounts();
  }

  Future<void> fetchOrderCounts() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    final ordersSnapshot = await FirebaseFirestore.instance
        .collection('orders')
        .where('adminId', isEqualTo: currentUser.uid)
        .get();

    setState(() {
      totalOrders = ordersSnapshot.docs.length;
      pendingOrders =
          ordersSnapshot.docs.where((doc) => doc['status'] == 'pending').length;
      activeOrders =
          ordersSnapshot.docs.where((doc) => doc['status'] == 'active').length;
      deliveredOrders = ordersSnapshot.docs
          .where((doc) => doc['status'] == 'completed')
          .length;
      rejectedOrders = ordersSnapshot.docs
          .where((doc) => doc['status'] == 'rejected')
          .length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffEEEEE6),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xffEEEEE6),
        title: const Text('Manage Orders'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Total Orders: $totalOrders',
                style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const PendingOrders()));
                    },
                    child: OrderStatusCard(
                      title: 'Pending Orders',
                      count: pendingOrders,
                      color: Colors.orange,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ActiveOrders()));
                    },
                    child: OrderStatusCard(
                      title: 'Active Orders',
                      count: activeOrders,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const DeliveredOrders()));
                    },
                    child: OrderStatusCard(
                      title: 'Delivered Orders',
                      count: deliveredOrders,
                      color: Colors.green,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RejectedOrders()));
                    },
                    child: OrderStatusCard(
                      title: 'Rejected Orders',
                      count: rejectedOrders,
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class OrderStatusCard extends StatelessWidget {
  final String title;
  final int count;
  final Color color;

  const OrderStatusCard({
    Key? key,
    required this.title,
    required this.count,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: color.withOpacity(0.1),
        border: Border.all(color: color),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: color, fontSize: 16)),
            Text('$count',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: color, fontSize: 24)),
          ],
        ),
      ),
    );
  }
}
