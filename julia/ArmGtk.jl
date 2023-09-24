using Gtk

window = GtkWindow("Hello Gtk!")

box = GtkBox(:v)
push!(window, box)

label = GtkLabel("Hello, World!")
GAccessor.justify(label, Gtk.GConstants.GtkJustification.CENTER)
push!(box, label)

button = GtkButton("Click me")
push!(box, button)

showall(window)

set_gtk_property!(box, :expand, label, true)