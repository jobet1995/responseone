import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../providers/user_provider.dart';
import '../../services/auth_service.dart';
import '../../config/themes.dart';
import '../../widgets/custom_button.dart';
import 'package:go_router/go_router.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _skillsController;
  XFile? _image;
  Uint8List? _imageBytes;
  bool _isVolunteer = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final user = ref.read(currentUserProvider).value;
    _nameController = TextEditingController(text: user?.name ?? '');
    _phoneController = TextEditingController(text: user?.phoneNumber ?? '');
    _skillsController = TextEditingController(text: user?.skills ?? '');
    _isVolunteer = user?.isVolunteer ?? false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _skillsController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      
      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _image = pickedFile;
          _imageBytes = bytes;
        });
      }
    } catch (e) {
      if (mounted) {
        String message = 'Error picking image: $e';
        if (e.toString().contains('photo_access_denied')) {
          message = 'Permission denied. Please enable photo access in settings.';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    }
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    
    try {
      final userState = ref.read(currentUserProvider);
      final currentUser = userState.value;
      if (currentUser == null) return;

      String avatarUrl = currentUser.avatarUrl;
      if (_image != null) {
        avatarUrl = await AuthService.instance.uploadAvatar(_image!);
      }

      final updatedUser = currentUser.copyWith(
        name: _nameController.text,
        phoneNumber: _phoneController.text,
        avatarUrl: avatarUrl,
        isVolunteer: _isVolunteer,
        skills: _skillsController.text,
        updatedAt: DateTime.now(),
      );

      await ref.read(currentUserProvider.notifier).updateUser(updatedUser);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating profile: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.defaultPadding),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              Center(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: AppTheme.primaryRed.withOpacity(0.2), width: 2),
                            ),
                            child: CircleAvatar(
                              radius: 50,
                              backgroundColor: AppTheme.primaryRed.withOpacity(0.1),
                              backgroundImage: _imageBytes != null 
                                  ? MemoryImage(_imageBytes!)
                                  : (ref.watch(currentUserProvider).value?.avatarUrl.isNotEmpty ?? false)
                                      ? NetworkImage(ref.watch(currentUserProvider).value!.avatarUrl)
                                      : null,
                              child: (_image == null && (ref.watch(currentUserProvider).value?.avatarUrl.isEmpty ?? true))
                                  ? const Icon(Icons.person, size: 60, color: AppTheme.primaryRed)
                                  : null,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: AppTheme.primaryRed,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.camera_alt, size: 20, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton.icon(
                      onPressed: _pickImage,
                      icon: const Icon(Icons.photo_library_outlined, size: 20, color: AppTheme.primaryRed),
                      label: const Text(
                        'Change Photo',
                        style: TextStyle(
                          color: AppTheme.primaryRed,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (v) => v != null && v.isNotEmpty ? null : 'Name is required',
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon: Icon(Icons.phone_outlined),
                ),
                keyboardType: TextInputType.phone,
                validator: (v) => v != null && v.isNotEmpty ? null : 'Phone number is required',
              ),
              const SizedBox(height: 32),
              const Divider(),
              const SizedBox(height: 16),
              const Text(
                'Volunteer Program',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              SwitchListTile(
                title: const Text('Register as Volunteer'),
                subtitle: const Text('Get notified for nearby emergencies'),
                value: _isVolunteer,
                activeColor: AppTheme.primaryRed,
                onChanged: (bool value) {
                  setState(() => _isVolunteer = value);
                },
              ),
              if (_isVolunteer) ...[
                const SizedBox(height: 16),
                TextFormField(
                  controller: _skillsController,
                  decoration: const InputDecoration(
                    labelText: 'Skills (e.g., CPR, First Aid)',
                    prefixIcon: Icon(Icons.psychology_outlined),
                  ),
                ),
              ],
              const SizedBox(height: 48),
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else
                CustomButton(
                  text: 'SAVE CHANGES',
                  onPressed: _handleSave,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
