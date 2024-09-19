import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScreenPage extends StatefulWidget {
  @override
  _ScreenPageState createState() => _ScreenPageState();
}
class _ScreenPageState extends State<ScreenPage> {
  int _selectedIndex = 0;
  int _selectedIndex1 = 0;
  final List<String> _tabs = ['Project', 'Saved', 'Shared', 'Achievement'];
  final double _tabHeight = 3.h; // Height for the divider line
  final List<Map<String, String>> _items = List.generate(
    40,
        (index) => {
      'image': 'assets/images/${index % 4 + 1}.png', // Cycling through 1.png to 4.png
      'badge': String.fromCharCode(65 + (index % 26)), // Generating badge letters A-Z
    },
  );
  List<Map<String, String>> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    // Initialized _filteredItems with the first 4 items
    _filteredItems = _items.take(4).toList();
  }

  void _filterItems(String query) {
    setState(() {
      _filteredItems = _items.where((item) {
        final badgeText = item['badge']?.toLowerCase() ?? '';
        final searchQuery = query.toLowerCase();
        return badgeText.contains(searchQuery);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          height: 21,
          width: 171,
          child: Text(
            'Portfolio',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Image.asset(
              'assets/Icons/shopping_bag.png',
              width: 24.w,
              height: 24.h,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Image.asset(
              'assets/Icons/notifications.png',
              width: 24.w,
              height: 24.h,
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(height: 5.h),
              // Tab bar
              Column(
                children: [
                  // Tab bar
                  Container(
                    child: Row(
                      children: _tabs.asMap().entries.map((entry) {
                        int index = entry.key;
                        String tab = entry.value;
                        final isSelected = index == _selectedIndex;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedIndex = index;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8), // Adjust vertical padding
                              child: Text(
                                tab,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis, // Prevent overflow
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: isSelected ? Colors.orange.shade900 : Colors.black,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  fontFamily: 'Roboto',
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  // Divider line
                  Container(
                    height: _tabHeight,
                    width: double.infinity,
                    child: Row(
                      children: _tabs.asMap().entries.map((entry) {
                        int index = entry.key;
                        return Expanded(
                          child: Container(
                            color: index == _selectedIndex ? Colors.orange : Colors.grey.shade300, // Change color based on selection
                            height: _tabHeight,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              // Search bar
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 22.h),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search by badge text',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade500,
                      fontFamily: 'Roboto',
                      fontSize: 18.0,
                    ),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(right: 10, top: 4, bottom: 4),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.deepOrange,
                          borderRadius: BorderRadius.circular(13.0),
                        ),
                        child: Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide(color: Colors.deepOrange, width: 2.0), // Border color on focus
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide(color: Colors.grey.shade300, width: 2), // Default border color
                    ),
                    fillColor: Colors.transparent,
                  ),
                  onChanged: (value) {
                    _filterItems(value);
                  },
                ),
              ),
              // Project cards
              Expanded(
                child: _selectedIndex == 0
                    ? ListView.builder(
                  itemCount: _filteredItems.length,
                  itemBuilder: (context, index) {
                    return PortfolioCard(
                      imagePath: _filteredItems[index]['image']!,
                      badgeText: _filteredItems[index]['badge']!,
                    );
                  },
                )
                    : Container(),
              ),
              SizedBox(height: 15),
            ],
          ),
          Positioned(
            bottom: 30,
            left: MediaQuery.of(context).size.width / 2 - 50,
            child: Container(
              height: 45,
              width: 120,
              decoration: BoxDecoration(
                color: Colors.deepOrange,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                    child: Image.asset("assets/Icons/filter.png")),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex1,
        onTap: (index) {
          setState(() {
            _selectedIndex1 = index;
          });
        },
        type: BottomNavigationBarType.fixed, // Ensures both icon and label are shown
        selectedItemColor: Colors.deepOrange,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(
            icon: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_selectedIndex1 == 0)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Container(
                      height: 2,
                      width: 24,
                      color: Colors.deepOrange,
                      alignment: Alignment.center,
                    ),
                  ),
                Image.asset(
                  "assets/Icons/Home.png",
                  width: 24,
                  height: 24,
                  color: _selectedIndex1 == 0 ? Colors.deepOrange : Colors.grey,
                ),
              ],
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_selectedIndex1 == 1)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Container(
                      height: 2,
                      width: 24,
                      color: Colors.deepOrange,
                      alignment: Alignment.center,
                    ),
                  ),
                Image.asset(
                  "assets/Icons/Portfolio.png",
                  width: 24,
                  height: 24,
                  color: _selectedIndex1 == 1 ? Colors.deepOrange : Colors.grey,
                ),
              ],
            ),
            label: 'Portfolio',
          ),
          BottomNavigationBarItem(
            icon: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_selectedIndex1 == 2)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Container(
                      height: 2,
                      width: 24,
                      color: Colors.deepOrange,
                      alignment: Alignment.center,
                    ),
                  ),
                Image.asset(
                  "assets/Icons/Input.png",
                  width: 24,
                  height: 24,
                  color: _selectedIndex1 == 2 ? Colors.deepOrange : Colors.grey,
                ),
              ],
            ),
            label: 'Input',
          ),
          BottomNavigationBarItem(
            icon: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_selectedIndex1 == 3)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Container(
                      height: 2,
                      width: 24,
                      color: Colors.deepOrange,
                      alignment: Alignment.center,
                    ),
                  ),
                Image.asset(
                  "assets/Icons/Profile.png",
                  width: 24,
                  height: 24,
                  color: _selectedIndex1 == 3 ? Colors.deepOrange : Colors.grey,
                ),
              ],
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}




class PortfolioCard extends StatelessWidget {
  final String imagePath;
  final String badgeText;

  PortfolioCard({required this.imagePath, required this.badgeText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 12.w), // Padding for card
      child: Card(
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.grey.shade300, width: 1),
          borderRadius: BorderRadius.circular(10.r),
        ),
        elevation: 0,
        child: Row(
          children: [
            Container(
              width: 110.w,
              height: 120.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.r),
                  bottomLeft: Radius.circular(10.r),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.r),
                  bottomLeft: Radius.circular(10.r),
                ),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(12.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Kemampuan Merangkum\nTulisan', // Card Title
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          children: [
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'BAHASA SUNDA\n',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Oleh Al-Baiq Samsam',
                                    style: TextStyle(
                                      fontSize: 10.sp,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 50),
                              child: Container(
                                width: 45.w,
                                height: 28.w,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.orange,
                                      Color(0xFFFFD700),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(6.r),
                                ),
                                child: Center(
                                  child: Text(
                                    badgeText, // Badge Text from the list
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
