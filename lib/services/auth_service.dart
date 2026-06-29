import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import 'preference_service.dart';

class AuthService {
  /// ============================
  /// REGISTER
  /// ============================
  static Future<bool> register(UserModel user) async {
    try {
      // Lưu User vào SharedPreferences
      await PreferenceService.saveUser(user);

      return true;
    } catch (e) {
      debugPrint("Register Error: $e");
      return false;
    }
  }

  /// ============================
  /// LOGIN
  /// ============================
  static Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      // Lấy User từ SharedPreferences
      UserModel? user = await PreferenceService.getUser();

      if (user == null) {
        return false;
      }

      // Kiểm tra Email và Password
      if (user.email == email && user.password == password) {
        // Lưu trạng thái đăng nhập
        await PreferenceService.setLogin(true);

        // Lưu lịch sử đăng nhập
        await PreferenceService.addHistory(email);

        return true;
      }

      return false;
    } catch (e) {
      debugPrint("Login Error: $e");
      return false;
    }
  }

  /// ============================
  /// USER HIỆN TẠI
  /// ============================
  static Future<UserModel?> currentUser() async {
    return await PreferenceService.getUser();
  }

  /// ============================
  /// KIỂM TRA ĐĂNG NHẬP
  /// ============================
  static Future<bool> isLogin() async {
    return await PreferenceService.isLogin();
  }

  /// ============================
  /// LOGOUT
  /// ============================
  static Future<void> logout() async {
    await PreferenceService.logout();
  }

  /// ============================
  /// LỊCH SỬ ĐĂNG NHẬP
  /// ============================
  static Future<List<String>> getHistory() async {
    return await PreferenceService.getHistory();
  }

  /// ============================
  /// KIỂM TRA EMAIL ĐÃ TỒN TẠI
  /// ============================
  static Future<bool> isExistEmail(String email) async {
    try {
      UserModel? user = await PreferenceService.getUser();

      if (user == null) {
        return false;
      }

      debugPrint("========== USER SAVED ==========");
      debugPrint("Name     : ${user.fullName}");
      debugPrint("Email    : ${user.email}");
      debugPrint("Password : ${user.password}");
      debugPrint("===============================");

      return user.email.trim().toLowerCase() == email.trim().toLowerCase();
    } catch (e) {
      debugPrint("Check Email Error: $e");
      return false;
    }
  }
}
