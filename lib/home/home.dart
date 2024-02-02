import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taxi_chill/models/misc_methods.dart';
import 'package:taxi_chill/services/auth_service.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    logBuild(runtimeType);
    return Scaffold(
      body: Center(
        child: IconButton(
          onPressed: () async {
            await context.read<AuthService>().logout();
            if (mounted) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/auth',
                (Route<dynamic> route) => false,
              );
            }
          },
          icon: const Icon(Icons.logout_rounded),
        ),
      ),
    );
  }
}
