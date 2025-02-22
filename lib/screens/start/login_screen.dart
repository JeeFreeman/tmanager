import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tmanager/core/routers/app_routers.dart';
import 'package:tmanager/screens/user_interface/widgets/splash_logo_text.dart';

class FirstLoginScreen extends StatelessWidget {
  const FirstLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Expanded(
            child: SplashLogoText(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final User? user = FirebaseAuth.instance.currentUser;

                    if (user != null) {
                      if (user.emailVerified) {
                        if (context.mounted) {
                          context.go(AppRoutes.home.path);
                        }
                      } else {
                        if (context.mounted) {
                          context.go(AppRoutes.verification.path);
                        }
                      }
                    } else {
                      if (context.mounted) {
                        context.go(AppRoutes.register.path);
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 50,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                  ),
                  child: const Text(
                    'Войти',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 100),
                const Text(
                  'Нажимая «Войти», вы соглашаетесь с Пользовательским соглашением, '
                  'Политикой конфиденциальности и условиями передачи информации',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
