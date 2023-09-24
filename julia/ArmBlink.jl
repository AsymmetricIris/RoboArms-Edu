using Blink

window = Blink.AtomShell.Window()
body!(window, "<h1>Banana</h1>")

body!(window, "Hello Julia! Don't Blink!")

# f = open("test.html") do file
#     read(file,String)
# end

# body!(window, f)