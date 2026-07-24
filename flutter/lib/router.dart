import "package:flixur/routes/setup/server_url.dart";
import "package:flutter/material.dart";
import "package:go_router/go_router.dart";

final router = GoRouter(
  initialLocation: "/",
  routes: [
    GoRoute(
      path: "/",
      builder: (context, state) => Center(
        child: MaterialButton(
          onPressed: () {
            context.go("/setup/login");
          },
          child: const Text("login"),
        ),
      ),
    ),
    GoRoute(
      path: "/setup/login",
      builder: (context, state) => const ServerUrlView(),
    ),
  ],
);
