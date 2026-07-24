import "package:flixur/routes/setup/login.dart";
import "package:flixur/routes/setup/server_url.dart";
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
            context.go("/setup/url");
          },
          child: const Text("login"),
        ),
      ),
    ),
    GoRoute(
      path: "/setup/url",
      builder: (context, state) => const ServerUrlView(),
    ),
    GoRoute(
      path: "/setup/login",
      // redirect back to URL setup if we navigate directly to the login page
      redirect: (context, state) =>
          extractExtra<ServerLoginPayload>(state) == null ? "/setup/url" : null,
      pageBuilder: (context, state) {
        final serverResponse = extractExtra<ServerLoginPayload>(state);
        // should realistically never happen as the page should be redirected
        if (serverResponse == null) {
          return const MaterialPage(child: Text("Error"));
        }

        return CustomTransitionPage(
          key: state.pageKey,
          child: LoginView(serverInfo: serverResponse),
          transitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (_, animation, _, child) {
            // start at bottom and work up
            final tween = Tween(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).chain(CurveTween(curve: Curves.easeInOut));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        );
      },
    ),
  ],
);
