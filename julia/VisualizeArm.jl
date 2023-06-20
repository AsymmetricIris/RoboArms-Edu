# based on code from https://github.com/JuliaIO/LibSerialPort.jl

using LibSerialPort

using CImGui
using CImGui.CSyntax
using CImGui.CSyntax.CStatic
using ImGuiGLFWBackend #CImGui.GLFWBackend
using ImGuiOpenGLBackend #CImGui.OpenGLBackend
using ImGuiGLFWBackend.LibGLFW # #CImGui.OpenGLBackend.GLFW
using ImGuiOpenGLBackend.ModernGL
using Printf

@static if Sys.isapple()
    # OpenGL 3.2 + GLSL 150
    const glsl_version = 150
    glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3)
    glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 2)
    glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE) # 3.2+ only
    glfwWindowHint(GLFW_OPENGL_FORWARD_COMPAT, GL_TRUE) # required on Mac
else
    # OpenGL 3.0 + GLSL 130
    const glsl_version = 130
    glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3)
    glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 0)
end

# setup GLFW error callback
#? error_callback(err::GLFW.GLFWError) = @error "GLFW ERROR: code $(err.code) msg: $(err.description)"
#? GLFW.SetErrorCallback(error_callback)

# create window
window = glfwCreateWindow(1280, 720, "Robo Arm", C_NULL, C_NULL)
@assert window != C_NULL
glfwMakeContextCurrent(window)
glfwSwapInterval(1)  # enable vsync

# setup Dear ImGui context
ctx = CImGui.CreateContext()

# setup Dear ImGui style
CImGui.StyleColorsDark()

# load Fonts
# - If no fonts are loaded, dear imgui will use the default font. You can also load multiple fonts and use `CImGui.PushFont/PopFont` to select them.
# - `CImGui.AddFontFromFileTTF` will return the `Ptr{ImFont}` so you can store it if you need to select the font among multiple.
# - If the file cannot be loaded, the function will return C_NULL. Please handle those errors in your application (e.g. use an assertion, or display an error and quit).
# - The fonts will be rasterized at a given size (w/ oversampling) and stored into a texture when calling `CImGui.Build()`/`GetTexDataAsXXXX()``, which `ImGui_ImplXXXX_NewFrame` below will call.
# - Read 'fonts/README.txt' for more instructions and details.
fonts_dir = joinpath(@__DIR__, "..", "fonts")
fonts = unsafe_load(CImGui.GetIO().Fonts)
# default_font = CImGui.AddFontDefault(fonts)
CImGui.AddFontFromFileTTF(fonts, joinpath(fonts_dir, "Roboto-Medium.ttf"), 16)
# @assert default_font != C_NULL

# setup Platform/Renderer bindings
glfw_ctx = ImGuiGLFWBackend.create_context(window, install_callbacks = true)
ImGuiGLFWBackend.init(glfw_ctx)
opengl_ctx = ImGuiOpenGLBackend.create_context(glsl_version)
ImGuiOpenGLBackend.init(opengl_ctx)

# var:float64 = [4, 4]
# var ./= 2
# println(var)

println("Ports: ")
println(list_ports())

# Modify these as needed
# portname = "/dev/ttyUSB0"
portname = "COM8"
baudrate = 115200

try
    # show a simple window that we create ourselves.
    # we use a Begin/End pair to created a named window.
    @cstatic f=Cfloat(0.0) b=Cfloat(0.0) c=Cfloat(0.0) counter=Cint(0) begin
        CImGui.Begin("Hello, world!")  # create a window called "Hello, world!" and append into it.
        CImGui.Text("This is some useful text.")  # display some text
        @c CImGui.Checkbox("Demo Window", &show_demo_window)  # edit bools storing our window open/close state
        @c CImGui.Checkbox("Another Window", &show_another_window)

        @c CImGui.SliderFloat("Joint 1", &f, 0, 180)  # edit 1 float using a slider from 0 to 1
        @c CImGui.SliderFloat("Joint 2", &b, 0, 180)  # edit 1 float using a slider from 0 to 1
        @c CImGui.SliderFloat("Joint 3", &c, 0, 180)  # edit 1 float using a slider from 0 to 1
        CImGui.ColorEdit3("clear color", clear_color)  # edit 3 floats representing a color
        CImGui.Button("Button") && (counter += 1)

        CImGui.SameLine()
        CImGui.Text("counter = $counter")
        CImGui.Text(@sprintf("Application average %.3f ms/frame (%.1f FPS)", 1000 / unsafe_load(CImGui.GetIO().Framerate), unsafe_load(CImGui.GetIO().Framerate)))

        println(b)

        CImGui.End()
    end
catch e
    @error "Error in renderloop!" exception=e
    Base.show_backtrace(stderr, catch_backtrace())
finally
    ImGuiOpenGLBackend.shutdown(opengl_ctx) #ImGui_ImplOpenGL3_Shutdown()
    ImGuiGLFWBackend.shutdown(glfw_ctx) #ImGui_ImplGlfw_Shutdown()
    CImGui.DestroyContext(ctx)
    glfwDestroyWindow(window)
end

# Snippet from examples/mwe.jl
LibSerialPort.open(portname, baudrate) do serial_port
	sleep(2)

	if bytesavailable(serial_port) > 0
    	println(String(read(serial_port)))
	end

    write(serial_port, " 45,140,175,90,0,45\n")
    sleep(1)
    println(readline(serial_port))
    sleep(1)
    write(serial_port, " 180,140,175,90,25,15\n")
    sleep(1)
    println(readline(serial_port))
    sleep(1)
    println("Done")
end