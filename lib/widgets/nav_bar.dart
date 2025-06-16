import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:imgrep/utils/debug_logger.dart';

class ImGrep_NavBar extends StatelessWidget {
  final Function(int) onClick;
  final int pageIndex;

  const ImGrep_NavBar({
    super.key,
    required this.onClick,
    required this.pageIndex
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Theme(
        // Added theme to reduce that ripple effect, needs more work though
        data: Theme.of(context).copyWith(
          splashFactory: InkRipple.splashFactory,
          splashColor: Colors.white.withOpacity(0.05),
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.black,
          iconSize: 28,
          type: BottomNavigationBarType.fixed,

          // Only showing the selected labels
          showSelectedLabels: true,
          showUnselectedLabels: false,
          selectedItemColor: Colors.white,

          currentIndex: pageIndex,
          onTap: onClick,

          // All the items required in the nav bar
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
        ),
      ),
    );
  }
}
