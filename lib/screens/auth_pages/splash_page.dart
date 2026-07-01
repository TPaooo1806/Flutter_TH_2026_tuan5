import 'dart:async';
import 'package:flutter/material.dart';
import 'login_page.dart';
import '../main_pages/main_page.dart';
import '../../services/auth_service.dart';

class SlashPage extends StatefulWidget {
  const SlashPage({super.key});

  @override
  State<SlashPage> createState() => _SlashPageState();
}

class _SlashPageState extends State<SlashPage> {
  double progress = 0;
  Timer? timer;
  bool isNavigated = false;

  @override
  void initState() {
    super.initState();
    startLoading();
  }

  void startLoading() {
    // 5 seconds total

    timer = Timer.periodic(const Duration(milliseconds: 100), (t) {
      setState(() {
        progress += 0.02; // 50 lần = 5 giây
      });

      if (progress >= 1) {
        t.cancel();
        goToLogin();
      }
    });
  }

  void goToLogin() async {
    if (isNavigated) return;

    isNavigated = true;
    timer?.cancel();

    bool isLogin = await AuthService.isLogin();

    if (!mounted) return;

    if (isLogin) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainPage()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.purple],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.shopping_bag,
                    size: 100,
                    color: Colors.white,
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'ỨNG DỤNG BÁN HÀNG',
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    'Hệ thống bán hàng Online',
                    style: TextStyle(fontSize: 18, color: Colors.white70),
                  ),

                  const SizedBox(height: 50),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 12,
                      backgroundColor: Colors.white30,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Colors.orange,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "${(progress * 100).toInt()} %",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 40),

                  SizedBox(
                    width: 180,
                    height: 45,
                    child: ElevatedButton.icon(
                      onPressed: goToLogin,
                      icon: const Icon(Icons.arrow_forward),
                      label: const Text("Tiếp tục"),
                    ),
                  ),

                  const SizedBox(height: 15),

                  const Text(
                    "Hoặc chờ 5 giây để tự động chuyển...",
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
