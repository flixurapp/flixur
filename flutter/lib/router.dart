import "package:flixur/routes/startup/login.dart";
import "package:flixur/routes/startup/server_url.dart";
import "package:flixur/routes/startup/setup.dart";
import "package:flutter/material.dart";
import "package:go_router/go_router.dart";

// extracts `extra` from state and casts it to the proper type
T? extractExtra<T>(GoRouterState state) {
  final extra = state.extra;
  return extra is T ? extra : null;
}

final router = GoRouter(
  initialLocation: "/",
  routes: [
    GoRoute(
      path: "/",
      builder: (context, state) => Center(
        child: MaterialButton(
          onPressed: () {
            context.goNamed("startup_home");
          },
          child: const Text("login"),
        ),
      ),
    ),
    GoRoute(
      name: "startup_home",
      path: "/startup",
      builder: (context, state) => const ServerUrlView(),
      routes: [
        _startupRoute(
          "login",
          (serverInfo) => LoginView(serverInfo: serverInfo),
        ),
        _startupRoute(
          "setup",
          (serverInfo) => SetupView(serverInfo: serverInfo),
        ),
      ],
    ),
  ],
);

GoRoute _startupRoute(
  String type,
  Widget Function(ServerLoginPayload) childBuilder,
) {
  return GoRoute(
    name: "startup_$type",
    path: type,
    // redirect back to URL setup if we navigate directly to the login page
    redirect: (context, state) =>
        extractExtra<ServerLoginPayload>(state) == null
        ? context.namedLocation("startup_home")
        : null,
    pageBuilder: (context, state) {
      final serverResponse = extractExtra<ServerLoginPayload>(state);
      // should realistically never happen as the page should be redirected
      if (serverResponse == null) {
        return const MaterialPage(child: Text("Error"));
      }

      return CustomTransitionPage(
        key: state.pageKey,
        child: childBuilder(serverResponse),
        transitionDuration: const Duration(seconds: 1),
        transitionsBuilder: (_, animation, _, child) {
          // start at bottom and work up
          final tween = Tween(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).chain(CurveTween(curve: Curves.linearToEaseOut));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      );
    },
  );
}
