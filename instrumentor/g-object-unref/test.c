#include <glib-object.h>
#include <gtk/gtkmain.h>
#include <gtk/gtkwindow.h>


int main(int argc, char *argv[])
{
  GtkWindowGroup *object;

  gtk_init(&argc, &argv);

  object = gtk_window_group_new();
  g_object_ref(object);

  g_object_unref(object);
  g_object_unref(object);
  g_object_unref(object);

  return 0;
}
