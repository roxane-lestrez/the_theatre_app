import 'package:first_app/screens/account_screen.dart';
import 'package:first_app/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});

  @override
  ConsumerState<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  int _selectedPageIndex = 0;
  final GlobalKey<SearchScreenState> searchScreenKey =
      GlobalKey<SearchScreenState>();

  // This will hold the history of selected tabs
  final List<int> _navigationHistory = [0];

  void _selectPage(int index) {
    setState(() {
      // If the new tab is different from the current tab, add it to the history
      if (_selectedPageIndex != index) {
        if (_selectedPageIndex == 1) {
          // Resets search when navigating between tabs
          searchScreenKey.currentState?.resetSearch();
        }
        _navigationHistory.add(index);
      }
      _selectedPageIndex = index;
    });
  }

  Future<bool> _onWillPop() async {
    // If there's more than one item in the history, pop the last one
    if (_navigationHistory.length > 1) {
      setState(() {
        _navigationHistory.removeLast();
        _selectedPageIndex = _navigationHistory.last;
      });
      return false; // Don't exit the app
    }
    return true; // Exit the app
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: IndexedStack(
          index: _selectedPageIndex,
          children: [
            const AccountScreen(),
            SearchScreen(key: searchScreenKey),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          onTap: _selectPage,
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
