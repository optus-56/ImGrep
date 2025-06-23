import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:imgrep/widgets/nav_bar.dart';
import 'package:imgrep/widgets/app_bar.dart';
import 'package:imgrep/utils/debug_logger.dart';

// Pages
import 'package:imgrep/pages/home.dart';
import 'package:imgrep/pages/search.dart';
import 'package:imgrep/pages/library.dart';
import 'package:imgrep/pages/cloud.dart';

class MainLayout extends StatefulWidget {
  @override
  _MainLayoutState createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  // Note(slok): PageControllers and Page Index are here temporarily
  // Maybe shift to some provider shit when needed
  // Dont you dare refactor this sadit.
  final PageController _pageController = PageController();
  int _currentPageIndex = 0;

  void _onNavBarClick(int index) {
    setState(() {
      _currentPageIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ImGrep_AppBar(),
      backgroundColor: Colors.black,
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
        children: [
          HomeScreen(),
          SearchScreen(),
          LibraryScreen(),
          CloudScreen(),
        ],
      ),
      bottomNavigationBar: ImGrep_NavBar(
        onClick: _onNavBarClick,
        pageIndex: _currentPageIndex
      ),
    );
  }
}
