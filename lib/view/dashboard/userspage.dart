import 'package:flutter/material.dart';
import 'package:admin_demo/utils/textstyles.dart';
import 'package:admin_demo/viewmodel/notifiers/thememode.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  // SVG asset paths
  static const String ellipseAsset = 'assets/images/ellipse_bg.svg';
  static const String lineAsset = 'assets/images/line_svg.svg';

  final List<Map<String, String>> _users = [
    //TODO: use providers from viewmodel, and models to fetch users
    {
      'id': '1',
      'name': 'John Doe',
      'email': 'john.doe@example.com',
      'role': 'User',
    },
    {
      'id': '2',
      'name': 'Jane Smith',
      'email': 'jane.smith@example.com',
      'role': 'User',
    },
    {
      'id': '3',
      'name': 'Peter Jones',
      'email': 'peter.jones@example.com',
      'role': 'Developer',
    },
    {
      'id': '4',
      'name': 'Alice Brown',
      'email': 'alice.brown@example.com',
      'role': 'User',
    },
    {
      'id': '5',
      'name': 'Bob White',
      'email': 'bob.white@example.com',
      'role': 'User',
    },
    {
      'id': '6',
      'name': 'Bob White',
      'email': 'bob.white@example.com',
      'role': 'User',
    },
    {
      'id': '7',
      'name': 'Bob White',
      'email': 'bob.white@example.com',
      'role': 'User',
    },
    {
      'id': '8',
      'name': 'Bob White',
      'email': 'bob.white@example.com',
      'role': 'User',
    },
    {
      'id': '8',
      'name': 'Bob White',
      'email': 'bob.white@example.com',
      'role': 'User',
    },
    {
      'id': '8',
      'name': 'Bob White',
      'email': 'bob.white@example.com',
      'role': 'User',
    },
  ];

  // Controllers for search fields
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();

  List<Map<String, String>> _filteredUsers = [];

  @override
  void initState() {
    super.initState();
    _filteredUsers = List.from(_users);
    _idController.addListener(_onSearchChanged);
    _emailController.addListener(_onSearchChanged);
    _nameController.addListener(_onSearchChanged);
    _roleController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _idController.dispose();
    _emailController.dispose();
    _nameController.dispose();
    _roleController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    String id = _idController.text.trim().toLowerCase();
    String email = _emailController.text.trim().toLowerCase();
    String name = _nameController.text.trim().toLowerCase();
    String role = _roleController.text.trim().toLowerCase();

    setState(() {
      _filteredUsers = _users.where((user) {
        final matchesId = id.isEmpty || (user['id']?.toLowerCase().contains(id) ?? false);
        final matchesEmail = email.isEmpty || (user['email']?.toLowerCase().contains(email) ?? false);
        final matchesName = name.isEmpty || (user['name']?.toLowerCase().contains(name) ?? false);
        final matchesRole = role.isEmpty || (user['role']?.toLowerCase().contains(role) ?? false);
        return matchesId && matchesEmail && matchesName && matchesRole;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeModeProvider>(
      builder: (context, provider, child) {
        final isDark = provider.isDarkMode;
        final borderColor = isDark ? Colors.white30 : Colors.black26;
        final headingColor = isDark ? Colors.white : Colors.black;
        final subTextColor = isDark ? Color(0xFFCDCDCD) : Color(0xFF695858);

        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              // Top left ellipse
              Positioned(
                top: -80,
                left: -120,
                child: SvgPicture.asset(ellipseAsset, height: 220, width: 220),
              ),
              // Bottom right ellipse
              Positioned(
                bottom: -100,
                right: -140,
                child: SvgPicture.asset(ellipseAsset, height: 300, width: 300),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30.0,
                  vertical: 20,
                ),
                child: Column(
                  children: [
                    // Line SVG as a separator
                    SvgPicture.asset(lineAsset, height: 5, width: 400),
                    const SizedBox(height: 24),
                    ZoomIn(
                      duration: Duration(milliseconds: 400),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            colors:
                                isDark
                                    ? [
                                      Colors.white.withAlpha(102),
                                      Colors.white.withAlpha(78),
                                      Colors.white.withAlpha(52),
                                      Colors.white.withAlpha(25),
                                    ]
                                    : [
                                      Colors.grey.shade400.withAlpha(102),
                                      Colors.grey.shade400.withAlpha(78),
                                      Colors.grey.shade400.withAlpha(52),
                                      Colors.grey.shade400.withAlpha(25),
                                    ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          border: Border.all(color: borderColor, width: 1),
                        ),
                        margin: EdgeInsets.only(bottom: 30.0),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 30,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Text(
                                  "SEARCH USERS",
                                  style: GoogleFonts.plusJakartaSans(
                                    color: headingColor,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 18),
                              Row(
                                children: [
                                  Flexible(
                                    child: _buildSearchField(
                                      controller: _idController,
                                      hint: "SEARCH BY ID",
                                      isDark: isDark,
                                      subTextColor: subTextColor,
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Flexible(
                                    child: _buildSearchField(
                                      controller: _emailController,
                                      hint: "SEARCH BY EMAIL",
                                      isDark: isDark,
                                      subTextColor: subTextColor,
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Flexible(
                                    child: _buildSearchField(
                                      controller: _nameController,
                                      hint: "SEARCH BY NAME",
                                      isDark: isDark,
                                      subTextColor: subTextColor,
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Flexible(
                                    child: _buildSearchField(
                                      controller: _roleController,
                                      hint: "SEARCH BY ROLE",
                                      isDark: isDark,
                                      subTextColor: subTextColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ZoomInDown(
                        duration: Duration(milliseconds: 400),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                              colors:
                                  isDark
                                      ? [
                                        Colors.white.withAlpha(102),
                                        Colors.white.withAlpha(78),
                                        Colors.white.withAlpha(52),
                                        Colors.white.withAlpha(25),
                                      ]
                                      : [
                                        Colors.grey.shade400.withAlpha(102),
                                        Colors.grey.shade400.withAlpha(78),
                                        Colors.grey.shade400.withAlpha(52),
                                        Colors.grey.shade400.withAlpha(25),
                                      ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            border: Border.all(color: borderColor, width: 1),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(28.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: Text(
                                    "USER LIST",
                                    style: GoogleFonts.plusJakartaSans(
                                      color: headingColor,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 1.1,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 18),
                                Expanded(
                                  child: DataTable2(
                                    columnSpacing: 12,
                                    horizontalMargin: 12,
                                    minWidth: 700,
                                    dataRowHeight: 60,
                                    headingRowHeight: 70,
                                    headingTextStyle:
                                        GoogleFonts.plusJakartaSans(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                    dataTextStyle: GoogleFonts.plusJakartaSans(
                                      color:
                                          isDark
                                              ? Colors.white70
                                              : Colors.black87,
                                      fontSize: 14,
                                    ),
                                    border: TableBorder.all(
                                      color: borderColor,
                                      width: 1,
                                    ),
                                    headingRowDecoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0xFFFFB608),
                                          Color(0xFFFF2553),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(10),
                                      ),
                                    ),
                                    columns: const [
                                      DataColumn2(
                                        label: Text('ID'),
                                        fixedWidth: 80,
                                      ),
                                      DataColumn2(label: Text('Name')),
                                      DataColumn2(label: Text('Email')),
                                      DataColumn2(label: Text('Role')),
                                      DataColumn2(
                                        label: Text('Actions'),
                                        fixedWidth: 150,
                                      ),
                                    ],
                                    rows:
                                        _filteredUsers.map((user) {
                                          return DataRow2(
                                            cells: [
                                              DataCell(Text(user['id']!)),
                                              DataCell(Text(user['name']!)),
                                              DataCell(Text(user['email']!)),
                                              DataCell(Text(user['role']!)),
                                              DataCell(
                                                Row(
                                                  children: [
                                                    IconButton(
                                                      icon: Icon(
                                                        Icons.edit,
                                                        color:
                                                            isDark
                                                                ? Colors.amber
                                                                : Colors.black,
                                                      ),
                                                      onPressed: () {
                                                        print(
                                                          'Edit user: ${user['name']}',
                                                        );
                                                      },
                                                    ),
                                                    IconButton(
                                                      icon: Icon(
                                                        Icons.delete,
                                                        color:
                                                            isDark
                                                                ? Colors
                                                                    .redAccent
                                                                : Colors.red,
                                                      ),
                                                      onPressed: () {
                                                        print(
                                                          'Delete user: ${user['name']}',
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          );
                                        }).toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSearchField({
    required TextEditingController controller,
    required String hint,
    required bool isDark,
    required Color subTextColor,
  }) {
    return TextField(
      controller: controller,
      style: GoogleFonts.plusJakartaSans(
        color: isDark ? Colors.white : Colors.black,
      ),
      cursorColor: Color(0xFFE20C75),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: isDark ? Color(0xFFCDCDCD) : Color(0xFF696969),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: isDark ? Color(0xFFCDCDCD) : Color(0xFF696969),
            width: 2,
          ),
        ),
        hintText: hint,
        hintStyle: GoogleFonts.plusJakartaSans(color: subTextColor),
      ),
    );
  }
}
