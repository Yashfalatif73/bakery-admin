import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  Future<List<Map<String, dynamic>>> fetchOrders() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return [];

    final ordersSnapshot = await FirebaseFirestore.instance
        .collection('orders')
        .where('adminId', isEqualTo: currentUser.uid)
        .orderBy('orderDate', descending: true)
        .get();

    List<Map<String, dynamic>> orders = [];

    for (var doc in ordersSnapshot.docs) {
      final data = doc.data();
      final customerId = data['customerId'];

      final userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(customerId)
          .get();

      final customerName = userSnapshot.data()?['name'] ?? 'Unknown';

      orders.add({
        'bakeryName': data['bakeryName'],
        'orderDate': data['orderDate'],
        'totalAmount': data['totalAmount'],
        'items': data['items'],
        'customerName': customerName,
      });
    }

    return orders;
  }

  String formatDate(DateTime dateTime) {
    final DateFormat dateFormat = DateFormat('yyyy-MM-dd – hh:mm a');
    return dateFormat.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffEEEEE6),
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Notifications'),
        backgroundColor: const Color(0xffEEEEE6),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            const Row(
              children: [
                Text('Today',
                    style: TextStyle(color: Colors.black, fontSize: 18)),
                Spacer(),
                Text('Mark all as read', style: TextStyle(color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: fetchOrders(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Error loading orders'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No orders found'));
                  }

                  final orders = snapshot.data!;

                  return ListView.builder(
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];
                      return Card(
                        elevation: 5,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                order['bakeryName'],
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepOrange,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Customer: ${order['customerName']}",
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Order Date: ${formatDate(order['orderDate'].toDate())}",
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Total Amount: \Rs ${order['totalAmount']}",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                "Items:",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 6),
                              ...List<Widget>.from(
                                  order['items'].map<Widget>((item) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 4.0),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.fastfood,
                                        color: Colors.orange,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        "${item['itemName']} (Qty: ${item['quantity']})",
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                );
                              })),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
