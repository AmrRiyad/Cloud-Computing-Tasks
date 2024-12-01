import 'package:flutter/material.dart';

import '../components/vertical_scroll.dart';

class AllChannelsScreen extends StatefulWidget {
  const AllChannelsScreen({super.key});

  @override
  State<AllChannelsScreen> createState() => _AllChannelsScreenState();
}

class _AllChannelsScreenState extends State<AllChannelsScreen> {
  @override
  Widget build(BuildContext context) {
    return ScrollableCardsPage();
  }
}
