import 'package:flutter/material.dart';

import '../../services/auth_service.dart';
import '../../services/preference_service.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<String> history = [];

  @override
  void initState() {
    super.initState();
    loadHistory();
  }

  Future<void> loadHistory() async {
    final results = await Future.wait([
      AuthService.getHistory(),
      // Giả lập tải 1 dữ liệu khác song song (ví dụ delay)
      Future.delayed(const Duration(milliseconds: 500)),
    ]);

    history = results[0] as List<String>;
    if (mounted) setState(() {});
  }

  Future<void> clearHistory() async {
    await PreferenceService.clearHistory();

    loadHistory();

    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("History cleared")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login History"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(icon: const Icon(Icons.delete), onPressed: clearHistory),
        ],
      ),

      body: history.isEmpty
          ? const Center(
              child: Text("No Login History", style: TextStyle(fontSize: 18)),
            )
          : RefreshIndicator(
              onRefresh: loadHistory,
              child: ListView.builder(
                itemCount: history.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    child: ListTile(
                      leading: const CircleAvatar(child: Icon(Icons.history)),

                      title: Text(history[index]),

                      subtitle: Text("Login ${index + 1}"),

                      trailing: const Icon(Icons.arrow_forward_ios),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
