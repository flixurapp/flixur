#include "my_application.h"

int main(int argc, char** argv) {
  // force the backend to x11 so the custom titlebar will work properly on wayland
  // add wayland as a fallback just in case
  gdk_set_allowed_backends("x11,wayland");

  g_autoptr(MyApplication) app = my_application_new();
  return g_application_run(G_APPLICATION(app), argc, argv);
}
