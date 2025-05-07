// This file includes the ActiveOrders, DeliveredOrders, and RejectedOrders screens.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ActiveOrders extends StatelessWidget {
  const ActiveOrders({super.key});

  Future<void> updateOrderStatus(String orderId, String status) async {
    await FirebaseFirestore.instance.collection('orders').doc(orderId).update({
      'status': status,
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(title: const Text("Active Orders"),
      backgroundColor: const Color(0xffEEEEE6),),
      backgroundColor: const Color(0xffEEEEE6),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('adminId', isEqualTo: currentUserId)
            .where('status', isEqualTo: 'active')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final orders = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              final orderDate = DateFormat('dd MMM yyyy, hh:mm a')
                  .format((order['orderDate'] as Timestamp).toDate());

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(order['customerId'])
                    .get(),
                builder: (context, userSnapshot) {
                  if (!userSnapshot.hasData) {
                    return const SizedBox();
                  }
                  final user = userSnapshot.data!;
                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    margin: const EdgeInsets.only(bottom: 20),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Bakery: ${order['bakeryName']}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                          Text("Customer: ${user['name']}"),
                          Text("Order Date: $orderDate"),
                          Text("Total: Rs. ${order['totalAmount']}",
                              style: const TextStyle(fontWeight: FontWeight.w600)),
                          const SizedBox(height: 10),
                          const Text("Items:", style: TextStyle(fontWeight: FontWeight.bold)),
                          ...List.generate(order['items'].length, (i) {
                            final item = order['items'][i];
                            return Text("- ${item['itemName']} (x${item['quantity']})");
                          }),
                          const SizedBox(height: 10),
                          ElevatedButton.icon(
                            onPressed: () async {
                              await updateOrderStatus(order.id, 'completed');
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Order marked as delivered')));
                            },
                            icon: const Icon(Icons.check_circle,color: Colors.white,),
                            label: const Text("Mark as Delivered",style: TextStyle(color: Colors.white),),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

