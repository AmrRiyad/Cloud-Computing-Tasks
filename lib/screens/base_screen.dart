import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';

import 'base.dart';
import '../models/user.dart';
import 'all_channels_screen.dart';
import 'notification_screen.dart';

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
      const NotificationScreen(),
      const NotificationScreen(),
    ];

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? buildLoadingIndicator()
        : Directionality(
            textDirection: currentLocale.languageCode == 'ar'
                ? TextDirection.rtl
                : TextDirection.ltr,
            child: Scaffold(
              appBar: _buildAppBar(currentUser),
              body: _buildPageContent(), // IndexedStack for the content
              bottomNavigationBar: _buildBottomNavigationBar(),
            ),
          );
  }

  Widget _buildPageContent() {
    return IndexedStack(
      index: currentPageIndex,
      children: pages,
    );
  }

  AppBar _buildAppBar(UserModel? user) {
    bool isDark = AdaptiveTheme.of(context).mode.isDark;

    // Fetch the localized string for the title
    String appBarTitle;
    switch (screenTitle) {
      case 'All Channels':
        appBarTitle = localization.get('allChannels');
        break;
      case 'My Channels':
        appBarTitle = localization.get('myChannels');
        break;
      case 'More':
        appBarTitle = localization.get('more');
        break;
      default:
        appBarTitle = localization.get('appTitle');
    }

    double titleSize = 0.4 * AppBar().preferredSize.height;
    return AppBar(
      leading: Image.asset("assets/cloud.png"),
      leadingWidth: titleSize * 3,
      centerTitle: true,
      title: Text(appBarTitle, style: TextStyle(fontSize: titleSize)),
      actions: [
        IconButton(
          iconSize: titleSize, // Adjust icon size
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const NotificationScreen(),
            ),
          ),
          icon: Icon(
            Icons.notifications_none_rounded,
            size: titleSize * 1.4,
          ),
        ),
      ],
    );
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      onTap: (index) {
        setState(() {
          currentPageIndex = index;
          screenTitle = ['All Channels', 'My Channels', 'More'][index];
        });
      },
      currentIndex: currentPageIndex,
      showUnselectedLabels: true,
      iconSize: 26,
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.home, size: 26),
          label: localization.get('allChannels'),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.category, size: 26),
          label: localization.get('myChannels'),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.more_horiz_outlined, size: 26),
          label: localization.get('more'),
        ),
      ],
    );
  }
}
