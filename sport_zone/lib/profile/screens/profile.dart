import 'package:flutter/material.dart';
import 'package:sport_zone/profile/widgets/profile.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    if (request.loggedIn) {
      return Profile(shouldShowAdmin: true);
    } else {
      return Scaffold(
        appBar: AppBar(title: const Text('Profil')),
        body: const Center(
          child: Text('Silahkan login terlebih dahulu untuk melihat profil'),
        ),
      );
    }
  }
}
