import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:imgrep/utils/debug_logger.dart';

class ImGrep_NavBar extends StatefulWidget {
  const ImGrep_NavBar({super.key});

  @override
  _ImGrep_NavBarState createState() => _ImGrep_NavBarState();
}

class _ImGrep_NavBarState extends State<ImGrep_NavBar> {
  int _currentIndex = 0;

  void _onClick(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.black,
      iconSize: 28,
      type: BottomNavigationBarType.fixed,

      // Only showing the selected labels
      showSelectedLabels: true,
      showUnselectedLabels: false,
      selectedItemColor: Colors.white,

      currentIndex: _currentIndex,
      onTap: _onClick,

      items: [
        BottomNavigationBarItem(
          icon: SvgPicture.asset('assets/icons/ImageIcon.svg'),
          label: '•',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset('assets/icons/EyeGlass.svg'),
          label: '•',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset('assets/icons/LibraryIcon.svg'),
          label: '•',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset('assets/icons/CloudIcon.svg'),
          label: '•',
        ),
      ],
    );
  }
}
