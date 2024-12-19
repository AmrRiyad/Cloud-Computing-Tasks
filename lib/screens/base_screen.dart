import 'package:cc_sa_1/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

import '../models/user.dart';
import 'all_channels_screen.dart';
import 'base.dart';
import 'my_channels_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends BaseScreen<MainScreen> {
  int currentPageIndex = 0;
  String screenTitle = 'All Channels';
  List<Widget> pages = [];

  @override
  Future<void> initializeScreenState() async {
    pages = [
      const AllChannelsScreen(),
      const SubscribedChannelsScreen(),
    ];

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? buildLoadingIndicator()
        : Scaffold(
            appBar: _buildAppBar(currentUser),
            body: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: _buildPageContent(),
            ),
            bottomNavigationBar: _buildBottomNavigationBar(),
          );
  }

  Widget _buildPageContent() {
    return IndexedStack(
      index: currentPageIndex,
      children: pages,
    );
  }

  AppBar _buildAppBar(UserModel? user) {
    String appBarTitle;
    appBarTitle = screenTitle;

    double titleSize = 0.4 * AppBar().preferredSize.height;
    return AppBar(
      leading: Image.asset("assets/cloud.png"),
      leadingWidth: titleSize * 3,
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () async {
            GoogleSignIn googleSignIn = GoogleSignIn();
            googleSignIn.disconnect();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          },
          icon: const Icon(Icons.exit_to_app),
        )
      ],
      title: Text(appBarTitle, style: TextStyle(fontSize: titleSize)),
    );
  }



  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      onTap: (index) {
        setState(() {
          currentPageIndex = index;
          screenTitle = ['All Channels', 'My Channels'][index];
        });
      },
      currentIndex: currentPageIndex,
      showUnselectedLabels: true,
      iconSize: 26,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home, size: 26),
          label: "All Channels",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.category, size: 26),
          label: "My Channels",
        ),
      ],
    );
  }
}
