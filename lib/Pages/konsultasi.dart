import 'package:flutter/material.dart';
import 'package:sirehat_cerdas/component/nav.dart';
import 'package:sirehat_cerdas/component/constant/dimens.dart' as example;
import 'package:sirehat_cerdas/service/logout.dart';

class Konsultasi extends StatefulWidget {
  @override
  _KonsultasiState createState() => _KonsultasiState();
}

class _KonsultasiState extends State<Konsultasi> {
  int _selectedIndex = 2;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/registration');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/konsultasi');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/riwayat');
        break;
      case 4:
        Navigator.pushReplacementNamed(context, '/registration-add');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              'assets/logo.png', // Path to your image asset
              height: 24, // Adjust the height as needed
            ),
            GestureDetector(
              onTap: () {
                Logout.performLogout(context);
                // Implement your logout functionality here
              },
              child: Icon(
                Icons.logout, // Use the logout icon
                size: 24.0, // Adjust the size of the icon
                color: Colors.blue, // Adjust the color of the icon
              ),
            ),
          ],
        ),
      ),
      body: Container(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: buildChatItem(
                context: context,
                senderName: 'John Doe',
                message: 'Hi there!',
                time: '10:30 AM',
                unreadCount: 2,
                avatarUrl:
                    'assets/avatar1.png', // Replace with actual avatar image URL or path
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: buildChatItem(
                context: context,
                senderName: 'Jane Smith',
                message: 'How are you?',
                time: '11:45 AM',
                unreadCount: 0,
                avatarUrl:
                    'assets/avatar2.png', // Replace with actual avatar image URL or path
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: buildChatItem(
                context: context,
                senderName: 'Alice Johnson',
                message: 'See you later!',
                time: 'Yesterday',
                unreadCount: 0,
                avatarUrl:
                    'assets/avatar3.png', // Replace with actual avatar image URL or path
              ),
            ),
            // Add more chat items as needed
          ],
        ),
      ),
      floatingActionButton: const SizedBox(
        height: example.Dimens.heightNormal,
        width: example.Dimens.widthNormal,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: MyBottomNavigator(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

Widget buildChatItem({
  required BuildContext context,
  required String senderName,
  required String message,
  required String time,
  required int unreadCount,
  required String avatarUrl,
}) {
  return ListTile(
    leading: CircleAvatar(
      backgroundImage: AssetImage(avatarUrl),
      radius: 25,
    ),
    title: Text(
      senderName,
      style: TextStyle(
        fontWeight: FontWeight.bold,
      ),
    ),
    subtitle: Row(
      children: [
        Expanded(
          child: Text(
            message,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Text(
          time,
          style: TextStyle(
            fontSize: 12.0,
            color: Colors.grey,
          ),
        ),
      ],
    ),
    trailing: unreadCount > 0
        ? Container(
            padding: EdgeInsets.all(6.0),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Text(
              unreadCount.toString(),
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        : null,
    onTap: () {
      Navigator.pushReplacementNamed(
        context,
        '/chat',
        arguments: {
          'senderName': senderName,
          'message': message,
          'time': time,
          'unreadCount': unreadCount,
          'avatarUrl': avatarUrl,
        },
      );
      print('Tapped on $senderName');
    },
  );
}
