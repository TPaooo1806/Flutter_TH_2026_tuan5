import 'package:flutter/material.dart';

import '../../screens/widgets/nav_widget.dart';
import '../../screens/widgets/drawer_widget.dart';
import '../../screens/main_pages/history_page.dart';
import '../../screens/main_pages/home_page.dart';
import '../../screens/main_pages/profile_page.dart';
import '../../screens/main_pages/setting_page.dart';
import '../../screens/main_pages/product_categories_page.dart';
import '../../models/menu_item.dart';
import '../../services/auth_service.dart';
import '../auth_pages/login_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Future<void> logout() async {
    // Xóa trạng thái đăng nhập
    await AuthService.logout();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  //
  int currentIndex = 0;

  late Widget currentBody;
  String currentTitle = "Home";

  final List<MenuItemModel> drawerMenus = [
    MenuItemModel(
      title: "Product Categories",
      icon: Icons.category_rounded,
      route: "/productCategories",
    ),

    MenuItemModel(title: "Settings", icon: Icons.settings, route: "/settings"),
    MenuItemModel(title: "About", icon: Icons.info, route: "/about"),
    MenuItemModel(title: "Logout", icon: Icons.logout, route: "/logout"),
  ];

  @override
  void initState() {
    super.initState();
    currentBody = HomePage();
  }

  void changeTab(int index) {
    setState(() {
      currentIndex = index;

      switch (index) {
        case 0:
          currentBody = HomePage();
          currentTitle = "Home";
          break;

        case 1:
          currentBody = HistoryPage();
          currentTitle = "History";
          break;

        case 2:
          currentBody = ProfilePage();
          currentTitle = "Profile";
          break;

        case 3:
          currentBody = SettingPage();
          currentTitle = "Setting";
          break;
      }
    });
  }

  void onDrawerSelect(MenuItemModel menu) {
    switch (menu.route) {
      case "/productCategories":
        setState(() {
          currentIndex = 0; // focus Home
          currentBody = const ProductCategoriesPage();
          currentTitle = "Product Categories";
        });
        break;
      case "/settings":
        setState(() {
          currentIndex = 0; // focus Home
          currentBody = const SettingPage();
          currentTitle = "Settings";
        });
        break;

      case "/about":
        showAboutDialog(
          context: context,
          applicationName: "Shop App",
          applicationVersion: "1.0.0",
        );
        break;

      case "/logout":
        Future.delayed(Duration.zero, () {
          logout();
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(currentTitle)),

      drawer: AppDrawer(menus: drawerMenus, onSelect: onDrawerSelect),

      body: currentBody,

      bottomNavigationBar: AppBottomNav(
        currentIndex: currentIndex,
        onTap: changeTab,
      ),
    );
  }
}
