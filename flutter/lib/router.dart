import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import './routes/setup/login.dart';

final router = GoRouter(
  initialLocation: "/",
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => Center(
        child: MaterialButton(
          onPressed: () {
            context.go("/setup/login");
          },
          child: Text("login"),
        ),
      ),
    ),
    GoRoute(
      path: "/setup/login",
      builder: (context, state) => const LoginScreen(),
    ),
  ],
);
