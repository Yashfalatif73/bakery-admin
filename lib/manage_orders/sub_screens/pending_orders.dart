import 'package:bakeryadminapp/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class PendingOrders extends StatelessWidget {
  const PendingOrders({super.key});

  Future<List<Map<String, dynamic>>> fetchPendingOrders() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return [];

    final ordersSnapshot = await FirebaseFirestore.instance
        .collection('orders')
        .where('adminId', isEqualTo: currentUser.uid)
        .where('status', isEqualTo: 'pending')
        .orderBy('orderDate', descending: true)
        .get();

    List<Map<String, dynamic>> orders = [];

    for (var doc in ordersSnapshot.docs) {
      final data = doc.data();
      final customerId = data['customerId'];

      // Fetch customer name
      final userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(customerId)
          .get();

      final customerName = userSnapshot.data()?['name'] ?? 'Unknown';

      orders.add({
        'orderId': doc.id,
        'bakeryName': data['bakeryName'],
        'orderDate': data['orderDate'],
        'totalAmount': data['totalAmount'],
        'items': data['items'],
        'customerName': customerName,
        'customerId': customerId,
      });
    }

    return orders;
  }

  String formatDate(Timestamp timestamp) {
    final DateTime dateTime = timestamp.toDate();
    final DateFormat formatter = DateFormat('yyyy-MM-dd – hh:mm a');
    return formatter.format(dateTime);
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    await FirebaseFirestore.instance
        .collection('orders')
        .doc(orderId)
        .update({'status': status});
  }

  Future<List<String>> getCustomerTokens(String customerId) async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(customerId)
          .get();
      
      if (userDoc.exists && userDoc.data()!.containsKey('tokens')) {
        final tokens = List<String>.from(userDoc.data()!['tokens'] ?? []);
        return tokens;
      }
      return [];
    } catch (e) {
      debugPrint('Error fetching customer tokens: $e');
      return [];
    }
  }

  Future<void> sendOrderStatusNotification({
    required String customerId,
    required String status,
    required String bakeryName,
  }) async {
    final customerTokens = await getCustomerTokens(customerId);
    
    if (customerTokens.isEmpty) {
      debugPrint('No tokens found for customer: $customerId');
      return;
    }
    
    String title = '';
    String body = '';
    
    if (status == 'active') {
      title = 'Order Accepted';
      body = 'Your order from $bakeryName has been accepted and is being prepared.';
    } else if (status == 'rejected') {
      title = 'Order Rejected';
      body = 'We\'re sorry, but your order from $bakeryName has been rejected.';
    }
    
    await MessagingService.sendNotification(
      tokens: customerTokens,
      title: title,
      body: body,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffEEEEE6),
      appBar: AppBar(
        title: const Text('Pending Orders'),
        backgroundColor: const Color(0xffEEEEE6),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchPendingOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading orders'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No pending orders found'));
          }

          final orders = snapshot.data!;

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return Card(
                elevation: 5,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
                        "Order Date: ${formatDate(order['orderDate'])}",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),

                      Text(
                        "Total Amount: Rs ${order['totalAmount']}",
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
                      ...List<Widget>.from(order['items'].map<Widget>((item) {
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

                      const SizedBox(height: 12),

                      // Accept and Reject Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () async {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                },
                              );
                              
                              try {
                                await updateOrderStatus(order['orderId'], 'active');
                                
                                await sendOrderStatusNotification(
                                  customerId: order['customerId'],
                                  status: 'active',
                                  bakeryName: order['bakeryName'],
                                );
                                
                                Navigator.pop(context);
                                
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Order Accepted and Customer Notified')),
                                );
                                
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (_) => const PendingOrders()),
                                );
                              } catch (e) {
                                Navigator.pop(context);
                                
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error: ${e.toString()}')),
                                );
                              }
                            },
                            icon: const Icon(Icons.check, color: Colors.white),
                            label: const Text("Accept", style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () async {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                },
                              );
                              
                              try {
                                await updateOrderStatus(order['orderId'], 'rejected');
                                await sendOrderStatusNotification(
                                  customerId: order['customerId'],
                                  status: 'rejected',
                                  bakeryName: order['bakeryName'],
                                );
                                
                                Navigator.pop(context);
                                
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Order Rejected and Customer Notified')),
                                );
                                
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (_) => const PendingOrders()),
                                );
                              } catch (e) {
                                Navigator.pop(context);
                                
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error: ${e.toString()}')),
                                );
                              }
                            },
                            icon: const Icon(Icons.close, color: Colors.white),
                            label: const Text("Reject", style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}