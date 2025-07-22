import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
// import 'package:nexovate/src/screens/account/change_email_screen.dart';
// import 'package:nexovate/src/screens/account/change_password_screen.dart';


import 'package:provider/provider.dart';
import 'package:nexovate/src/providers/user.dart';
import 'package:nexovate/src/services/auth/change-credentials.dart';

import 'package:nexovate/src/screens/utils/toast.dart';

class SidebarNavigation extends StatefulWidget {
  const SidebarNavigation({super.key});

  @override
  State<SidebarNavigation> createState() => _SidebarNavigationState();
}

class _SidebarNavigationState extends State<SidebarNavigation> {
  File? profileImage;

  String getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length == 1) return parts[0].substring(0, 1).toUpperCase();
    return (parts[0].substring(0, 1) + parts[1].substring(0, 1)).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black,
      child: Column(
        children: [
          const SizedBox(height: 50),
          Consumer<UserProvider>(builder: (context, userProvider, child) {
            final user = userProvider.user;
            return ListTile(
              leading: profileImage != null
                  ? CircleAvatar(
                      radius: 28,
                      backgroundImage: FileImage(profileImage!),
                    )
                  : ClipOval(
                      child: Container(
                        width: 56,
                        height: 56,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFFFFA114),
                              Color(0xFFFF095B),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            getInitials(user?.fullName ?? 'NA'),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
              title: Text(
                user?.fullName ?? "No Name",
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              subtitle: ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [
                    Color.fromARGB(255, 255, 161, 20),
                    Color.fromARGB(255, 255, 9, 91)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds),
                child: const Text(
                  "Edit profile",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              onTap: () async {
                final updatedData = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfileScreen(
                      initialName: user?.fullName ?? "",
                      initialProfileImage: profileImage,
                    ),
                  ),
                );

                if (updatedData != null) {
                  setState(() {
                    profileImage = updatedData['profileImage'] ?? profileImage;
                  });
                  if (updatedData['name'] != null && user != null) {
                    userProvider.setUser(
                      UserResponse(
                        token: user.token,
                        userId: user.userId,
                        fullName: updatedData['name'],
                        email: user.email,
                      ),
                    );
                  }
                }
              },
            );
          }),
          const Divider(color: Colors.white24),
          buildDrawerItem(context, Icons.home, "Home", '/dashboard'),
          buildDrawerItem(context, Icons.folder, "My Projects", '/saved_proj'),
          buildDrawerItem(context, Icons.help_outline, "FAQs", '/faqs'),
          buildDrawerItem(context, Icons.exit_to_app, "Log out", '/login'),
        ],
      ),
    );
  }

  Widget buildDrawerItem(BuildContext context, IconData icon, String title, String route) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Poppins',
          color: Colors.white,
        ),
      ),
      onTap: () {
        Navigator.pushNamed(context, route);
      },
    );
  }
}


// ------------------------
// EditProfileScreen Widget
// ------------------------


class EditProfileScreen extends StatefulWidget {
  final String initialName;
  final File? initialProfileImage;

  const EditProfileScreen({
    super.key,
    required this.initialName,
    required this.initialProfileImage,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> with SingleTickerProviderStateMixin {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController locationController;

  String _getInitials(String name) {
  final parts = name.trim().split(" ");
  if (parts.isEmpty) return "";
  if (parts.length == 1) return parts[0][0].toUpperCase();
  return (parts[0][0] + parts[1][0]).toUpperCase();
}


  bool obscurePassword = true;
  bool isChanged = false;
  File? _profileImage;
  late AnimationController _controller;
  Animation<double>? _fadeIn;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.initialName);

    final user = Provider.of<UserProvider>(context, listen: false).user;
    emailController = TextEditingController(text: user?.email ?? "");
    passwordController = TextEditingController();
    locationController = TextEditingController();

    _profileImage = widget.initialProfileImage;

    _controller = AnimationController(duration: const Duration(milliseconds: 600), vsync: this);
    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();

    for (var c in [nameController, emailController, passwordController, locationController]) {
      c.addListener(() => setState(() => isChanged = true));
    }
  }

  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _profileImage = File(picked.path);
        isChanged = true;
      });
    }
  }

  Future<void> updateProfile() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = userProvider.user;
    if (user == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("⚠️ User not logged in.")),
        );
      }
      return;
    }

    final token = user.token;
    final authService = AuthService();

    // Only update password if field is not empty
    if (passwordController.text.isNotEmpty) {
      final passwordResult = await authService.changePassword(
        token: token,
        currentPassword: "123456",
        newPassword: passwordController.text,
        confirmPassword: passwordController.text,
      );
      
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(passwordResult['message'] ?? 'Unknown error')),
          );
        }
        return;
    }

    // Only update email if changed
    if (emailController.text.isNotEmpty && emailController.text != user.email) {
      final emailResult = await authService.changeEmail(
        token: token,
        newEmail: emailController.text,
        confirmEmail: emailController.text,
      );
      if (emailResult['success'] != true) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Email change failed: ${emailResult['message'] ?? 'Unknown error'}")),
          );
        }
        return;
      }
      // Update provider with new email
      userProvider.setUser(
        UserResponse(
          token: user.token,
          userId: user.userId,
          fullName: nameController.text,
          email: emailController.text,
        ),
      );
    }

    // Update user profile
    userProvider.setUser(
      UserResponse(
        token: user.token,
        userId: user.userId,
        fullName: nameController.text,
        email: emailController.text,
      ),
    );

    setState(() => isChanged = false);

    Navigator.pop(context, {
      'name': nameController.text,
      'profileImage': _profileImage,
    });

    if (mounted) {
      
        showToast(context, "Profile updated successfully!");
      
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: Colors.black,
      ),
      body: FadeTransition(
        opacity: _fadeIn!,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              GestureDetector(
                onTap: pickImage,
                child: ClipOval(
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFFFFA114),
                              Color(0xFFFF095B),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            _getInitials(nameController.text.isNotEmpty ? nameController.text : widget.initialName),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 48,
                            ),
                          ),
                        ),
                      ),
                    ),
              ),
              const SizedBox(height: 24),
              buildInput(
                controller: nameController,
                label: "Full Name",
                icon: Icons.person,
              ),
              const SizedBox(height: 16),
              buildInput(
                controller: emailController,
                label: "Email",
                icon: Icons.email,
                enabled: true,
              ),
              const SizedBox(height: 16),
              buildPassword(
                controller: passwordController,
                label: "New Password",
                icon: Icons.lock,
              ),
              const SizedBox(height: 16),
              buildInput(
                controller: locationController,
                label: "Location",
                icon: Icons.location_on,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: isChanged ? updateProfile : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text("Save Changes"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInput({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool enabled = true,
  }) {
    return TextField(
      controller: controller,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget buildPassword({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscurePassword,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(obscurePassword ? Icons.visibility : Icons.visibility_off),
          onPressed: () => setState(() => obscurePassword = !obscurePassword),
        ),
      ),
    );
  }
}
