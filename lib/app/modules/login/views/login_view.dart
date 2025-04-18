import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tmdb/app/modules/login/views/CustomPaintHome.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Obx(
        () => Stack(
          children: [
            SizedBox(height: size.height * 0.4, child: TopBar_home()),

            Align(
              alignment: Alignment.bottomCenter,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: theme.cardColor.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white.withOpacity(0.2)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                "Welcome",
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                              const SizedBox(height: 20),

                              TextField(
                                controller: controller.username,
                                style: theme.textTheme.bodyLarge,
                                decoration: InputDecoration(
                                  labelText: "Username",
                                  prefixIcon: const Icon(Icons.person),
                                  filled: true,
                                  fillColor: theme.cardColor.withOpacity(0.5),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),

                              TextField(
                                controller: controller.password,
                                obscureText: true,
                                style: theme.textTheme.bodyLarge,
                                decoration: InputDecoration(
                                  labelText: "Password",
                                  prefixIcon: const Icon(Icons.lock),
                                  filled: true,
                                  fillColor: theme.cardColor.withOpacity(0.5),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 20),

                              FilledButton.icon(
                                onPressed: controller.loginWithCredentials,
                                icon: const Icon(Icons.login),
                                label: const Text("Login"),
                                style: FilledButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  textStyle: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    FilledButton.icon(
                      onPressed: controller.loginWithTMDB,
                      icon: const Icon(Icons.movie_creation_outlined),
                      label: const Text("Login with TMDB"),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                        textStyle: theme.textTheme.labelLarge?.copyWith(fontSize: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),

                    const SizedBox(height: 16),

                    OutlinedButton.icon(
                      onPressed: controller.loginAsGuest,
                      icon: const Icon(Icons.person_outline),
                      label: const Text("Continue as Guest"),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: theme.colorScheme.primary,
                        backgroundColor: theme.colorScheme.surface.withOpacity(0.6),
                        side: BorderSide(
                          // color: theme.colorScheme.primary.withOpacity(0.4),
                          color: Colors.white,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            if (controller.isLoading.value) const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}
