import 'package:flutter/material.dart';

import '../../models/menu_item.dart';
import '../../models/user_model.dart';
import '../../services/auth_service.dart';

class AppDrawer extends StatelessWidget {
  final List<MenuItemModel> menus;
  final Function(MenuItemModel) onSelect;

  const AppDrawer({super.key, required this.menus, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: FutureBuilder<UserModel?>(
        future: AuthService.currentUser(),
        builder: (context, snapshot) {
          UserModel? user = snapshot.data;

          return Column(
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(user?.fullName ?? "Guest"),
                accountEmail: Text(user?.email ?? ""),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: user != null && user.avatar.isNotEmpty
                      ? NetworkImage(user.avatar)
                      : null,
                  child: user == null || user.avatar.isEmpty
                      ? const Icon(Icons.person, size: 40)
                      : null,
                ),
              ),

              Expanded(
                child: ListView.builder(
                  itemCount: menus.length,
                  itemBuilder: (context, index) {
                    final menu = menus[index];

                    return ListTile(
                      leading: Icon(menu.icon),
                      title: Text(menu.title),
                      onTap: () {
                        Navigator.pop(context);
                        onSelect(menu);
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
