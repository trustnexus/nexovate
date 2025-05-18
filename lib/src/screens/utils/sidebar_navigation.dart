// lib/src/utils/sidebar_navigation.dart

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:nexovate/src/screens/account/change_email_screen.dart';
import 'package:nexovate/src/screens/account/change_password_screen.dart';
import 'package:nexovate/src/screens/Project/saved_project.dart';

class SidebarNavigation extends StatefulWidget {
  const SidebarNavigation({super.key});

  @override
  State<SidebarNavigation> createState() => _SidebarNavigationState();
}

class _SidebarNavigationState extends State<SidebarNavigation> {
  String name = "Ahmed Suhaib";
  File? profileImage;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black,
      child: Column(
        children: [
          const SizedBox(height: 50),
          ListTile(
            leading: Container(
              child: Padding(
                padding: const EdgeInsets.all(3),
                child: CircleAvatar(
                  backgroundColor: Colors.black,
                  backgroundImage: profileImage != null
                      ? FileImage(profileImage!)
                      : const AssetImage('assets/images/av.png') as ImageProvider,
                ),
              ),
            ),
            title: Text(
              name,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            subtitle: ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [Color.fromARGB(255, 255, 161, 20), Color.fromARGB(255, 255, 9, 91)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds),
                  child: const Text(
                    "Edit profile",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      color: Colors.white, // still needed, but shader overrides it
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            onTap: () async {
              final updatedData = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfileScreen(
                    initialName: name,
                    initialProfileImage: profileImage,
                  ),
                ),
              );

              if (updatedData != null) {
                setState(() {
                  name = updatedData['name'] ?? name;
                  profileImage = updatedData['profileImage'] ?? profileImage;
                });
              }
            },
          ),
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
  final nameController = TextEditingController(text: "Ahmed Suhaib");
  final emailController = TextEditingController(text: "test@nexovate.com");
  final passwordController = TextEditingController(text: "123456");
  final locationController = TextEditingController(text: "16D, Block A, Milton Street, California");

  bool obscurePassword = true;
  bool isChanged = false;
  File? _profileImage;
  late AnimationController _controller;
  Animation<double>? _fadeIn;

 @override
void initState() {
  super.initState();
  nameController.text = widget.initialName;
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
  final uri = Uri.parse("https://your-backend.com/api/update-profile");

  final request = http.MultipartRequest('POST', uri)
    ..fields['name'] = nameController.text
    ..fields['email'] = emailController.text
    ..fields['password'] = passwordController.text
    ..fields['location'] = locationController.text;

  if (_profileImage != null) {
    request.files.add(await http.MultipartFile.fromPath(
      'profile_image',
      _profileImage!.path,
      filename: p.basename(_profileImage!.path),
    ));
  }

  try {
    final response = await request.send();
    if (!mounted) return; // 🛡 CHECK before using context

    if (response.statusCode == 200) {
      setState(() => isChanged = false);

      // Return updated data first
      Navigator.pop(context, {
        'name': nameController.text,
        'profileImage': _profileImage,
      });

      // Showing snackbar if still mounted (safe way)
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Profile updated successfully")),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ Failed: Status ${response.statusCode}")),
        );
      }
    }
  } catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("⚠️ Error: $e")),
      );
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.orange),
          onPressed: () => Navigator.pop(context),
        ),
        title: FadeTransition(
          opacity: _fadeIn ?? const AlwaysStoppedAnimation(1),
          child: const Text(
            "Edit Profile",
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ),
        actions: [
           Padding(
             padding: const EdgeInsets.symmetric(horizontal: 16.0),
             child: Image.asset(
               'assets/images/N_log.png',
               height: 28,
               width: 28,
               fit: BoxFit.contain,
             ),
           )
         ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: FadeTransition(
          opacity: _fadeIn ?? const AlwaysStoppedAnimation(1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: GestureDetector(
                  onTap: pickImage,
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                               width: 104,
                               height: 104,
                               decoration: BoxDecoration(
                                 shape: BoxShape.circle,
                                 gradient: const LinearGradient(
                                   begin: Alignment.topCenter,
                                   end: Alignment.bottomCenter,
                                   colors: [
                                     Colors.orange,
                                     Colors.pinkAccent,
                                   ],
                                 ),
                               ),
                               child: Padding(
                                 padding: const EdgeInsets.all(3),
                                 child: Container(
                                   decoration: const BoxDecoration(
                                     shape: BoxShape.circle,
                                     color: Colors.black, // background inside the border
                                   ),
                                   child: CircleAvatar(
                                     radius: 48,
                                     backgroundImage: _profileImage != null
                                         ? FileImage(_profileImage!)
                                         : const AssetImage('assets/images/av.png') as ImageProvider,
                                   ),
                                 ),
                               ),
                             ),
                      const CircleAvatar(
                        radius: 14,
                        backgroundColor: Colors.pink,
                        child: Icon(Icons.edit, size: 16, color: Colors.white),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              buildInput("Full Name", nameController, false),
              buildInput("Email", emailController, true),
              buildPassword("Password", passwordController),
              buildInput("Location", locationController, false),
              const SizedBox(height: 40),
              AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  width: double.infinity,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: isChanged
                        ? const LinearGradient(
                            colors: [Colors.orange, Colors.pinkAccent],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          )
                        : const LinearGradient(
                            colors: [Colors.black54, Colors.black87],
                          ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: isChanged ? updateProfile : null,
                      borderRadius: BorderRadius.circular(12),
                      splashColor: Colors.white24,
                      child: Center(
                        child: Text(
                          "Save",
                          style: TextStyle(
                            color: isChanged ? Colors.white : Colors.white38,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInput(String label, TextEditingController controller, bool showChange) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(
          color: Colors.grey.shade400,
          fontSize: 13,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w400,
        ),
      ),
      Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontFamily: 'Poppins',
              ),
              cursorColor: Colors.orange,
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.only(top: 4),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white30),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.orange),
                ),
              ),
            ),
          ),
          if (showChange)
            Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 6),
              child: GestureDetector(
                onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ChangeEmailScreen()),
                        );

                        if (result != null && result['email'] != null) {
                          emailController.text = result['email'];
                          setState(() => isChanged = true);
                        }
                      },
                child: const Text(
                  "Change",
                  style: TextStyle(
                    fontSize: 12.5,
                    color: Colors.pinkAccent,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
        ],
      ),
      const SizedBox(height: 24),
    ],
  );
}

  Widget buildPassword(String label, TextEditingController controller) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(
          color: Colors.grey.shade400,
          fontSize: 13,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w400,
        ),
      ),
      Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: obscurePassword,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontFamily: 'Poppins',
              ),
              cursorColor: Colors.orange,
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.only(top: 4),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white30),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.orange),
                ),
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 6),
              child: GestureDetector(
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ChangePasswordScreen()),
                        );

                        if (result != null && result['password'] != null) {
                          passwordController.text = result['password'];
                          setState(() => isChanged = true);
                        }
                      },
                child: const Text(
                  "Change",
                  style: TextStyle(
                    fontSize: 12.5,
                    color: Colors.pinkAccent,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
        ],
      ),
      const SizedBox(height: 24),
    ],
  );
}
}