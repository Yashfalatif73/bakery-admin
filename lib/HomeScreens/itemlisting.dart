import 'package:bakeryadminapp/HomeScreens/controllers/edit_item_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

// Controller to manage item list state
class ItemListController extends GetxController {
  final RxList<DocumentSnapshot> items = <DocumentSnapshot>[].obs;
  final RxInt currentPage = 0.obs;
  final RxInt itemsPerPage = 5.obs;
  final RxInt totalPages = 0.obs;
  final RxString searchQuery = ''.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchItems();
  }

  // Fetch items from Firestore
  Future<void> fetchItems() async {
    isLoading.value = true;
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('items')
          .orderBy('createdAt', descending: true)
          .get();
      
      items.value = snapshot.docs;
      calculateTotalPages();
    } catch (e) {
      print('Error fetching items: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Calculate total pages based on item count
  void calculateTotalPages() {
    totalPages.value = (items.length / itemsPerPage.value).ceil();
    if (totalPages.value == 0) totalPages.value = 1;
  }

  // Get current page items
  List<DocumentSnapshot> get currentPageItems {
    int startIndex = currentPage.value * itemsPerPage.value;
    int endIndex = startIndex + itemsPerPage.value;
    
    if (startIndex >= items.length) return [];
    if (endIndex > items.length) endIndex = items.length;
    
    return items.sublist(startIndex, endIndex);
  }

  // Navigate to next page
  void nextPage() {
    if (currentPage.value < totalPages.value - 1) {
      currentPage.value++;
    }
  }

  // Navigate to previous page
  void prevPage() {
    if (currentPage.value > 0) {
      currentPage.value--;
    }
  }

  // Delete item from Firestore
  Future<void> deleteItem(String itemId) async {
    try {
      await FirebaseFirestore.instance.collection('items').doc(itemId).delete();
      await fetchItems(); // Refresh the list
    } catch (e) {
      print('Error deleting item: $e');
    }
  }

  // Toggle item visibility
  Future<void> toggleVisibility(String itemId, bool currentVisibility) async {
    try {
      await FirebaseFirestore.instance
          .collection('items')
          .doc(itemId)
          .update({'visibility': !currentVisibility});
      await fetchItems(); // Refresh the list
    } catch (e) {
      print('Error updating visibility: $e');
    }
  }

  // Filter items based on search query
  void filterItems(String query) {
    searchQuery.value = query;
    // Implement search functionality if needed
  }
}

class ItemListingScreen extends StatelessWidget {
  ItemListingScreen({Key? key}) : super(key: key);

  final ItemListController controller = Get.put(ItemListController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: ScreenUtil().screenHeight,
        width: ScreenUtil().screenWidth,
        color: const Color(0xffEEEEE6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 50.h),
            
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Screen Title
                  _buildScreenTitle(),
                  SizedBox(height: 20.h),
                  
                  // Items List Container
                  _buildItemsContainer(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Screen Title Widget
  Widget _buildScreenTitle() {
    return const Text(
      "Items Listing",
      style: TextStyle(
        fontSize: 18,
        color: Color(0xff20402A),
        fontWeight: FontWeight.w600,
      ),
    );
  }

  // Main Items Container
  Widget _buildItemsContainer() {
    return Container(
      height: 392.h,
      width: 330.w,
      decoration: const BoxDecoration(
        color: Color(0xffF2F2F2),
      ),
      child: Column(
        children: [
          // Search and Filter Bar
          _buildSearchFilterBar(),
          
          // Table Header
          _buildTableHeader(),
          
          // Table Separator
          _buildDivider(),
          
          // Items List
          _buildItemsList(),
          
          // Pagination Info
          _buildPaginationInfo(),
        ],
      ),
    );
  }

  // Search and Filter Bar
  Widget _buildSearchFilterBar() {
    return Container(
      height: 64.h,
      width: 330.w,
      color: const Color(0xffFAFAFA),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Search Field
          _buildSearchField(),
          
          // Filter Button
          _buildFilterButton(),
        ],
      ),
    );
  }

  // Search Field Widget
  Widget _buildSearchField() {
    return Container(
      width: 215.w,
      height: 32.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32.r),
        border: Border.all(
          color: const Color(0xffF2F2F2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          SizedBox(width: 10.w),
          Image(
            image: const AssetImage("images/icon.png"),
            height: 12.h,
          ),
          SizedBox(width: 5.w),
          Expanded(
            child: TextField(
              decoration: const InputDecoration(
                hintText: "Search",
                hintStyle: TextStyle(
                  fontSize: 12,
                  color: Color(0xff979797),
                  fontWeight: FontWeight.w400,
                ),
                border: InputBorder.none,
              ),
              onChanged: (value) => controller.filterItems(value),
            ),
          ),
        ],
      ),
    );
  }

  // Filter Button Widget
  Widget _buildFilterButton() {
    return Container(
      width: 67.w,
      height: 32.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: const Color(0xffF2F2F2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          SizedBox(width: 10.w),
          Image(
            image: const AssetImage("images/filter.png"),
            height: 12.h,
          ),
          SizedBox(width: 5.w),
          const Text(
            "Filter",
            style: TextStyle(
              fontSize: 12,
              color: Color(0xff807A7A),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  // Table Header Widget
  Widget _buildTableHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: SizedBox(
        height: 40.h,
        width: 330.w,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Item Name",
              style: TextStyle(
                fontSize: 12.sp,
                color: const Color(0xff404040),
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              "Description",
              style: TextStyle(
                fontSize: 12.sp,
                color: const Color(0xff404040),
                fontWeight: FontWeight.w500,
              ),
            ),
            Row(
              children: [
                _buildPaginationButton(
                  icon: Icons.arrow_back_ios_new_rounded,
                  onTap: () => controller.prevPage(),
                ),
                _buildPaginationButton(
                  icon: Icons.arrow_forward_ios_rounded,
                  onTap: () => controller.nextPage(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Pagination Button Widget
  Widget _buildPaginationButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 24.h,
        width: 24.w,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xffF5F7F9),
        ),
        child: Center(
          child: Icon(
            icon,
            size: 12.h,
          ),
        ),
      ),
    );
  }

  // Divider Widget
  Widget _buildDivider() {
    return Container(
      height: 1.h,
      width: 330.w,
      color: const Color(0xffF2F2F2),
    );
  }

  // Items List Widget
  Widget _buildItemsList() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Expanded(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }
      
      if (controller.items.isEmpty) {
        return const Expanded(
          child: Center(
            child: Text("No items found"),
          ),
        );
      }
      
      return Expanded(
        child: ListView.builder(
          itemCount: controller.currentPageItems.length,
          itemBuilder: (context, index) {
            final item = controller.currentPageItems[index];
            return _buildItemRow(item, context);
          },
        ),
      );
    });
  }

  // Item Row Widget
  Widget _buildItemRow(DocumentSnapshot item, BuildContext context) {
    final data = item.data() as Map<String, dynamic>;
    
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: SizedBox(
            height: 40.h,
            width: 330.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Item Name
                Text(
                  data['itemName'] ?? "Unknown",
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: const Color(0xff404040),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(width: 3.w),
                
                // Item Description (truncated)
                SizedBox(
                  width: 100.w,
                  child: Text(
                    data['itemDescription'] != null 
                        ? (data['itemDescription'] as String).length > 10
                            ? "${(data['itemDescription'] as String).substring(0, 10)}..."
                            : data['itemDescription']
                        : "No description",
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: const Color(0xff404040),
                      fontWeight: FontWeight.w400,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                
                // Action Buttons
                SizedBox(
                  width: 79.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Edit Button
                      _buildActionButton(
                        color: const Color(0xff0FCB02),
                        imagePath: "images/Group 2128.png",
                        imageHeight: 14.7.h,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditItemScreen(itemId: item.id),
                            ),
                          ).then((_) => controller.fetchItems());
                        },
                      ),
                      
                      // Delete Button
                      _buildActionButton(
                        color: const Color(0xffF55F44),
                        imagePath: "images/Vector (1).png",
                        imageHeight: 10.h,
                        onTap: () => _showDeleteConfirmationDialog(context, item.id),
                      ),
                      
                      // Visibility Toggle Button
                      _buildActionButton(
                        color: const Color(0xff495057),
                        imagePath: "images/Group 2415.png",
                        imageHeight: 8.h,
                        onTap: () => _showVisibilityConfirmationDialog(
                          context, 
                          item.id, 
                          data['visibility'] ?? true
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        _buildDivider(),
      ],
    );
  }

  // Action Button Widget
  Widget _buildActionButton({
    required Color color,
    required String imagePath,
    required double imageHeight,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 21.h,
        width: 21.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.r),
          color: color,
        ),
        child: Center(
          child: Image(
            image: AssetImage(imagePath),
            height: imageHeight,
          ),
        ),
      ),
    );
  }

  // Delete Confirmation Dialog
  Future<void> _showDeleteConfirmationDialog(BuildContext context, String itemId) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Item"),
        content: const Text("Are you sure you want to delete this item?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              controller.deleteItem(itemId);
              Navigator.pop(context);
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  // Visibility Confirmation Dialog
  Future<void> _showVisibilityConfirmationDialog(
    BuildContext context, 
    String itemId, 
    bool currentVisibility
  ) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Change Visibility"),
        content: Text(
          currentVisibility 
              ? "Do you want to turn off visibility of this item?" 
              : "Do you want to turn on visibility of this item?"
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              controller.toggleVisibility(itemId, currentVisibility);
              Navigator.pop(context);
            },
            child: const Text("Confirm"),
          ),
        ],
      ),
    );
  }

  // Pagination Info Widget
  Widget _buildPaginationInfo() {
    return Obx(() => Padding(
      padding: EdgeInsets.only(right: 16.w, bottom: 8.h),
      child: Align(
        alignment: Alignment.bottomRight,
        child: Text(
          "${controller.currentPage.value + 1}/${controller.totalPages.value}",
          style: TextStyle(
            fontSize: 12.sp,
            color: const Color(0xff404040),
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    ));
  }
}