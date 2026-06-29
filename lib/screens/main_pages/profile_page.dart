import 'package:flutter/material.dart';
import '../../services/preference_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, String> profile = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    profile = await PreferenceService.getProfile();
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (profile.isEmpty) {
      return const Center(child: Text("No Profile Data"));
    }

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: profile["avatar"] != null && profile["avatar"]!.isNotEmpty
              ? NetworkImage(profile["avatar"]!)
              : null,
          child: profile["avatar"] == null || profile["avatar"]!.isEmpty
              ? const Icon(Icons.person, size: 50)
              : null,
        ),
        const SizedBox(height: 20),
        ListTile(
          leading: const Icon(Icons.person),
          title: const Text("Tên"),
          subtitle: Text(profile["fullName"] ?? ""),
        ),
        ListTile(
          leading: const Icon(Icons.email),
          title: const Text("Email"),
          subtitle: Text(profile["email"] ?? ""),
        ),
        ListTile(
          leading: const Icon(Icons.phone),
          title: const Text("SĐT"),
          subtitle: Text(profile["phone"] ?? ""),
        ),
        ListTile(
          leading: const Icon(Icons.location_city),
          title: const Text("Thành phố"),
          subtitle: Text(profile["city"] ?? ""),
        ),
      ],
    );
  }
}
