import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:floating_bottom_bar/animated_bottom_navigation_bar.dart';
import 'package:sirehat_cerdas/component/constant/dimens.dart' as example;
import 'package:sirehat_cerdas/component/constant/strings.dart' as example;

class MyBottomNavigator extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const MyBottomNavigator({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  State<MyBottomNavigator> createState() => _MyBottomNavigatorState();
}

class _MyBottomNavigatorState extends State<MyBottomNavigator> {
  @override
  Widget build(BuildContext context) {
    return AnimatedBottomNavigationBar(
      barColor: Colors.white,
      controller:
          FloatingBottomBarController(initialIndex: widget.currentIndex),
      bottomBar: [
        BottomBarItem(
          icon: const Icon(Icons.home, size: example.Dimens.iconNormal),
          iconSelected: const Icon(Icons.home,
              color: Color(0xFF1580EB), size: example.Dimens.iconNormal),
          title: example.Strings.home,
          dotColor: Color(0xFF1580EB),
          onTap: (value) {
            widget.onTap(value);
            log('Home $value');
          },
        ),
        BottomBarItem(
          icon: const Icon(Icons.history_edu, size: example.Dimens.iconNormal),
          iconSelected: const Icon(Icons.history_edu,
              color: Color(0xFF1580EB), size: example.Dimens.iconNormal),
          title: example.Strings.search,
          dotColor: Color(0xFF1580EB),
          onTap: (value) {
            widget.onTap(value);
            log('Registrasi $value');
          },
        ),
        BottomBarItem(
          icon: const Icon(Icons.question_answer,
              size: example.Dimens.iconNormal),
          iconSelected: const Icon(Icons.question_answer,
              color: Color(0xFF1580EB), size: example.Dimens.iconNormal),
          title: example.Strings.person,
          dotColor: Color(0xFF1580EB),
          onTap: (value) {
            widget.onTap(value);
            log('Profile $value');
          },
        ),
        BottomBarItem(
          icon: const Icon(Icons.history, size: example.Dimens.iconNormal),
          iconSelected: const Icon(Icons.history,
              color: Color(0xFF1580EB), size: example.Dimens.iconNormal),
          title: example.Strings.settings,
          dotColor: Color(0xFF1580EB),
          onTap: (value) {
            widget.onTap(value);
            log('Settings $value');
          },
        ),
      ],
      bottomBarCenterModel: BottomBarCenterModel(
        centerBackgroundColor: Color(0xFF1580EB),
        centerIcon: const FloatingCenterButton(
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        centerIconChild: [
          FloatingCenterButtonChild(
            child: const Icon(
              Icons.add_box_outlined,
              color: Colors.white,
            ),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/registration-add');
            },
          ),
          FloatingCenterButtonChild(
            child: const Icon(
              Icons.app_registration_sharp,
              color: Colors.white,
            ),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/registration-add');
            },
          ),
        ],
      ),
    );
  }
}
