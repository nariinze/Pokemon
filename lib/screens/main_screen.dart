import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../config.dart';
import '../controllers/entry_controller.dart';
import '../controllers/favorite_controller.dart';
import '../controllers/item_controller.dart';
import 'entry_screen.dart';
import 'favorite_screen.dart';
import 'home_screen.dart';

/// Bottom Navigation Bar: List | Favorites | Tab ke-3
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _index = 0;

  @override
  void initState() {
    super.initState();
    Get.put(ItemController());
    Get.put(EntryController());
  }

  @override
  Widget build(BuildContext context) {
    final fav = Get.find<FavoriteController>();
    return Scaffold(
      // IndexedStack: state tiap tab (scroll, search, filter) tidak hilang
      body: IndexedStack(
        index: _index,
        children: const [HomeScreen(), FavoriteScreen(), EntryScreen()],
      ),
      bottomNavigationBar: NavigationBar(
        height: 68,
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: [
          NavigationDestination(
            icon: Icon(appConfig.tabItemsIcon),
            label: appConfig.tabItems,
          ),
          NavigationDestination(
            icon: Obx(() => Badge(
                  isLabelVisible: fav.favorites.isNotEmpty,
                  label: Text('${fav.favorites.length}'),
                  child: const Icon(Icons.favorite_border_rounded),
                )),
            selectedIcon: Obx(() => Badge(
                  isLabelVisible: fav.favorites.isNotEmpty,
                  label: Text('${fav.favorites.length}'),
                  child: const Icon(Icons.favorite_rounded),
                )),
            label: 'Favorites',
          ),
          NavigationDestination(
            icon: Icon(appConfig.tabEntriesIcon),
            label: appConfig.tabEntries,
          ),
        ],
      ),
    );
  }
}
