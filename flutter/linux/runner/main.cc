#include "my_application.h"

int main(int argc, char** argv) {
  // if this env var is set, then the backend will fall through
  // just in case a system is somehow wayland ONLY
  // the app will still have a titlebar
  if (g_getenv("FLIXUR_BYPASS_GDK_BACKEND") == NULL) {
    // force the backend to x11 so the custom titlebar will work on wayland
    g_setenv("GDK_BACKEND", "x11", TRUE);
  }
  gdk_set_allowed_backends("x11,wayland");

  g_autoptr(MyApplication) app = my_application_new();
  return g_application_run(G_APPLICATION(app), argc, argv);
}
