import "package:flixur/routes/startup/login.dart";
import "package:flixur/routes/startup/server_url.dart";
import "package:flixur/routes/startup/setup.dart";
import "package:flixur/storage.dart";
import "package:flixur/ui/main_nav/common.dart";
import "package:flutter/material.dart";
import "package:go_router/go_router.dart";

// extracts `extra` from state and casts it to the proper type
T? extractExtra<T>(GoRouterState state) {
  final extra = state.extra;
  return extra is T ? extra : null;
}

final router = GoRouter(
  initialLocation: "/",
  redirect: (context, state) {
    final loggedIn = Storage.sessionToken.value != null;
    final path = state.matchedLocation;

    final isStartupRoute =
        path == "/" || path == "/startup" || path.startsWith("/startup/");

    // if logged in then bypass startup routes
    if (loggedIn) return isStartupRoute ? "/home" : null;
    // otherwise, logged out, redirect everything back to startup
    return !isStartupRoute ? "/" : null;
  },
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
    // nav shell for the main navigation bars
    StatefulShellRoute.indexedStack(
      builder: (_, _, navigationShell) =>
          MainNavWrapper(navShell: navigationShell),
      branches: [for (final section in mainNavSections) section.toBranch()],
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
