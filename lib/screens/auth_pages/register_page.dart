import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final avatarController = TextEditingController(
    text: "https://i.pravatar.cc/300",
  );

  String gender = "Male";
  String city = "Ho Chi Minh";

  bool agree = false;
  bool hidePassword = true;
  bool isLoading = false;

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    avatarController.dispose();
    super.dispose();
  }

  Future<void> register() async {
    if (!_formKey.currentState!.validate()) return;

    if (!agree) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please agree to the Terms")),
      );
      return;
    }

    bool exist = await AuthService.isExistEmail(emailController.text.trim());

    if (!mounted) return;

    if (exist) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Email already exists")));

      return;
    }

    setState(() {
      isLoading = true;
    });

    UserModel user = UserModel(
      fullName: fullNameController.text.trim(),
      email: emailController.text.trim(),
      phone: phoneController.text.trim(),
      password: passwordController.text.trim(),
      avatar: avatarController.text.trim(),
      gender: gender,
      city: city,
    );

    bool success = await AuthService.register(user);

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    if (success) {
      fullNameController.clear();
      emailController.clear();
      phoneController.clear();
      passwordController.clear();

      avatarController.text = "https://i.pravatar.cc/300";

      gender = "Male";
      city = "Ho Chi Minh";
      agree = false;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Register Success"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Register Failed"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
        backgroundColor: Colors.blue,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Form(
            key: _formKey,

            child: Column(
              children: [
                const Icon(
                  Icons.app_registration,
                  size: 100,
                  color: Colors.blue,
                ),

                const SizedBox(height: 20),

                TextFormField(
                  controller: fullNameController,
                  decoration: InputDecoration(
                    labelText: "Full Name",
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? "Enter Full Name" : null,
                ),

                const SizedBox(height: 15),

                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: "Email",
                    prefixIcon: const Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) return "Enter Email";
                    if (!value.contains("@")) return "Invalid Email";
                    return null;
                  },
                ),

                const SizedBox(height: 15),

                TextFormField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: "Phone",
                    prefixIcon: const Icon(Icons.phone),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  validator: (value) => value!.isEmpty ? "Enter Phone" : null,
                ),

                const SizedBox(height: 15),

                TextFormField(
                  controller: passwordController,
                  obscureText: hidePassword,
                  decoration: InputDecoration(
                    labelText: "Password",
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        hidePassword ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          hidePassword = !hidePassword;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  validator: (value) {
                    if (value!.length < 6) {
                      return "Password >= 6 characters";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 15),

                TextFormField(
                  controller: avatarController,
                  decoration: InputDecoration(
                    labelText: "Avatar URL",
                    prefixIcon: const Icon(Icons.image),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Row(
                  children: [
                    const Text(
                      "Gender:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),

                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: RadioListTile<String>(
                              value: "Male",
                              groupValue: gender,
                              onChanged: (String? value) {
                                setState(() {
                                  gender = value!;
                                });
                              },
                              title: const Text("Male"),
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<String>(
                              value: "Female",
                              groupValue: gender,
                              onChanged: (String? value) {
                                setState(() {
                                  gender = value!;
                                });
                              },
                              title: const Text("Female"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                DropdownButtonFormField<String>(
                  value: city,
                  decoration: InputDecoration(
                    labelText: "City",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: "Ho Chi Minh",
                      child: Text("Ho Chi Minh"),
                    ),
                    DropdownMenuItem(value: "Can Tho", child: Text("Can Tho")),
                    DropdownMenuItem(
                      value: "Dong Nai",
                      child: Text("Dong Nai"),
                    ),
                    DropdownMenuItem(
                      value: "Dong Thap",
                      child: Text("Dong Thap"),
                    ),
                    DropdownMenuItem(
                      value: "An Giang",
                      child: Text("An Giang"),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      city = value!;
                    });
                  },
                ),

                const SizedBox(height: 15),

                CheckboxListTile(
                  value: agree,
                  title: const Text("I agree to the Terms"),
                  controlAffinity: ListTileControlAffinity.leading,
                  onChanged: (value) {
                    setState(() {
                      agree = value!;
                    });
                  },
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "REGISTER",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                  ),
                ),

                const SizedBox(height: 10),

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("BACK TO LOGIN"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
