# module ArmVizBlink

using Blink

window = Blink.AtomShell.Window()

body!(window, "Hello Julia! Don't Blink!")

# f = open("test.html") do file
#     read(file,String)
# end

f = open("test.html") do file
    read(file,String)
end

body!(window, f)

# end # module ArmVizBlink
