import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String selectedAvatar = 'assets/ava1.svg';
  String userName = ''; // Kosong di awal

  final TextEditingController _nameController = TextEditingController();

  final List<String> avatars =
      List.generate(12, (i) => 'assets/ava${i + 1}.svg');

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('userName') ?? '';
      selectedAvatar = prefs.getString('userAvatar') ?? selectedAvatar;
    });
  }

  Future<void> _saveProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', userName);
    await prefs.setString('userAvatar', selectedAvatar);
  }

  void _editName() {
    _nameController.text = userName;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit Name'),
        content: TextField(
          controller: _nameController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Masukkan nama Anda',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_nameController.text.trim().isNotEmpty) {
                setState(() {
                  userName = _nameController.text.trim();
                });
              }
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _saveAndBack() async {
    await _saveProfile();
    Navigator.pop(context, {
      'name': userName,
      'avatar': selectedAvatar,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1E40AF), Color(0xFF2563EB)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // HEADER
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: _saveAndBack,
                    ),

                    // JUDUL BENAR-BENAR TENGAH
                    const Expanded(
                      child: Center(
                        child: Text(
                          'Profile',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    // DUMMY SPACE biar balance dengan IconButton kiri
                    const SizedBox(width: 48),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // AVATAR
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.transparent,
                child: ClipOval(
                  child: SvgPicture.asset(
                    selectedAvatar,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // NAME - dengan opacity jika belum diisi
              GestureDetector(
                onTap: _editName,
                child: Text(
                  userName.isEmpty ? 'Tap to set name' : userName,
                  style: TextStyle(
                    color: userName.isEmpty 
                        ? Colors.white.withOpacity(0.4) // Transparan jika kosong
                        : Colors.white, // Solid jika sudah diisi
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'Choose your avatar',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),

              const SizedBox(height: 20),

              // GRID
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: GridView.builder(
                    itemCount: avatars.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                    ),
                    itemBuilder: (_, index) {
                      final avatar = avatars[index];
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedAvatar = avatar;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: avatar == selectedAvatar
                                  ? Colors.white
                                  : Colors.transparent,
                              width: 3,
                            ),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: SvgPicture.asset(
                            avatar,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}