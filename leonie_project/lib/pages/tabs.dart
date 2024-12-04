import 'package:first_app/pages/account_page.dart';
import 'package:first_app/pages/search_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// This is the main screen, used to switch between the different pages (currently the account page and the search page).

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});

  @override
  ConsumerState<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  int _selectedPageIndex = 0;
  final List<int> _navigationStack = [0];

  final GlobalKey<SearchPageState> searchPageKey = GlobalKey<SearchPageState>();

  final List<Widget> _pages = [
    const AccountPage(),
    const SearchPage(),
  ];

  void _onTabTapped(int index) {
    if (index != _selectedPageIndex) {
      setState(() {
        _selectedPageIndex = index;
        _navigationStack.add(index);
      });
    }
  }

  Future<bool> _onWillPop() async {
    if (_navigationStack.length > 1) {
      setState(() {
        _navigationStack.removeLast();
        _selectedPageIndex = _navigationStack.last;
      });
      return false; // Prevents the application from closing.
    }
    return true; // Closes the application if you're already on the first page.
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: Stack(
          children: _pages.asMap().entries.map((entry) {
            int index = entry.key;
            Widget page = entry.value;

            return Offstage(
              offstage: _selectedPageIndex != index,
              child: page,
            );
          }).toList(),
        ),
        bottomNavigationBar: BottomNavigationBar(
          onTap: _onTabTapped,
          currentIndex: _selectedPageIndex,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Account',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
            ),
          ],
        ),
      ),
    );
  }
}
