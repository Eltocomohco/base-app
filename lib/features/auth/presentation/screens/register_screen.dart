import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pizzeria_pepe_app/features/auth/presentation/providers/auth_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrarse')),
      body: Padding(
        padding: EdgeInsets.all(24.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo_icon.png', height: 100.h),
            SizedBox(height: 32.h),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Nombre',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                prefixIcon: const Icon(Icons.person_outline),
              ),
            ),
            SizedBox(height: 16.h),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                prefixIcon: const Icon(Icons.email_outlined),
              ),
            ),
            SizedBox(height: 16.h),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Contraseña',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                prefixIcon: const Icon(Icons.lock_outline),
              ),
              obscureText: true,
            ),
            SizedBox(height: 32.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _register,
                style: ElevatedButton.styleFrom(minimumSize: Size(0, 50.h)),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('CREAR CUENTA'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _register() async {
    if (_emailController.text.isEmpty || 
        _passwordController.text.isEmpty ||
        _nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, rellena todos los campos')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await ref.read(authProvider.notifier).register(
        _emailController.text.trim(),
        _passwordController.text.trim(),
        _nameController.text.trim(),
      );
      if (mounted) {
        Navigator.of(context).pop(); // Volver al login
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cuenta creada exitosamente')),
        );
      }
    } catch (e) {
      if (mounted) {
        String errorMessage = 'Error al crear la cuenta';
        if (e is FirebaseAuthException) {
          switch (e.code) {
            case 'email-already-in-use':
              errorMessage = 'Este email ya está en uso';
              break;
            case 'invalid-email':
              errorMessage = 'Email inválido';
              break;
            case 'weak-password':
              errorMessage = 'La contraseña es muy débil';
              break;
            default:
              errorMessage = e.message ?? errorMessage;
          }
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
