import 'package:dartfri/features/screens/account/account_page.dart';
import 'package:dartfri/features/screens/home/home_new_page.dart';
import 'package:dartfri/features/screens/notifications/pages/notification_page.dart';
import 'package:dartfri/features/screens/wallet/pages/wallet_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';

import '../account/pages/profile_page.dart';
import '../bookings/bookings_page.dart';

class DashboardPage extends StatefulWidget {

   DashboardPage({Key? key, }) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      body:  IndexedStack(
          children: [
            HomeNewPage(),
            BookingsPage(),
            WalletPage(),
            NotificationPage(),
            ProfilePage()
          ],
          index: _currentIndex,
        ),

      bottomNavigationBar: BottomNavigationBar(

        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
        items:  [
          BottomNavigationBarItem(
              icon: FaIcon(
                CupertinoIcons.home,
                color: Colors.black,
              ),
              label:  "Home"),
          BottomNavigationBarItem(
              icon: FaIcon(
                CupertinoIcons.book,
                // FontAwesomeIcons.book,
                color: Colors.black,
              ),
              label: "Bookings"),

          BottomNavigationBarItem(
              icon: FaIcon(
                Icons.account_balance_wallet_outlined,
                color: Colors.black,
              ),
              label: "Wallet"),
          BottomNavigationBarItem(
              icon: FaIcon(
                Icons.notifications_none,
                color: Colors.black,
              ),
              label: "Notification",),
          BottomNavigationBarItem(
              icon: FaIcon(
                CupertinoIcons.person_circle,
                // FontAwesomeIcons.,
                color: Colors.black,
              ),
              label: "Profile"),

        ],
      ),
    ));
  }
}
