import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/user_provider.dart';
import '../../widgets/custom_button.dart';
import '../../config/themes.dart';
import '../../models/user_model.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  UserRole _selectedRole = UserRole.citizen;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    final data = {
      'name': _nameController.text,
      'email': _emailController.text,
      'phoneNumber': _phoneController.text,
      'password': _passwordController.text,
      'role': _selectedRole.value,
    };

    final notifier = ref.read(currentUserProvider.notifier);
    await notifier.register(data);

    final userState = ref.read(currentUserProvider);
    if (userState.hasError) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(userState.error.toString())),
        );
      }
    } else if (userState.value != null) {
      if (mounted) context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(currentUserProvider);
    final isLoading = userState.isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
        backgroundColor: Colors.transparent,
        foregroundColor: AppTheme.textPrimary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.defaultPadding * 1.5),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Join ResQNow to get immediate help during emergencies.',
                style: TextStyle(color: AppTheme.textSecondary),
              ),
              const SizedBox(height: 32),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (v) => v != null && v.isNotEmpty ? null : 'Name is required',
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (v) => v != null && v.contains('@') ? null : 'Enter a valid email',
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon: Icon(Icons.phone_outlined),
                ),
                keyboardType: TextInputType.phone,
                validator: (v) => v != null && v.length >= 10 ? null : 'Invalid phone number',
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
                obscureText: true,
                validator: (v) => v != null && v.length >= 6 ? null : 'Password (min 6 chars)',
              ),
              const SizedBox(height: 24),
              const Text('Select Your Role:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              SegmentedButton<UserRole>(
                segments: const [
                  ButtonSegment(value: UserRole.citizen, label: Text('Citizen'), icon: Icon(Icons.person)),
                  ButtonSegment(value: UserRole.responder, label: Text('Responder'), icon: Icon(Icons.emergency)),
                ],
                selected: {_selectedRole},
                onSelectionChanged: (set) => setState(() => _selectedRole = set.first),
              ),
              const SizedBox(height: 32),
              CustomButton(
                text: 'CREATE ACCOUNT',
                onPressed: _handleRegister,
                isLoading: isLoading,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already have an account?', style: TextStyle(color: AppTheme.textSecondary)),
                  TextButton(
                    onPressed: () => context.go('/login'),
                    child: const Text('Login', style: TextStyle(color: AppTheme.primaryRed, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
