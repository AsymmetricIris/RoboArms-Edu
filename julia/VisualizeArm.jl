# based on code from https://github.com/JuliaIO/LibSerialPort.jl

using LibSerialPort

println(list_ports())

# Modify these as needed
portname = "COM5"
baudrate = 9600

# Snippet from examples/mwe.jl
LibSerialPort.open(portname, baudrate) do sp
	# sleep(2)

	# if bytesavailable(sp) > 0
    # 	println(String(read(sp)))
	# end

    write(sp, "0, 140, 175, 90, 0, 45\n")
    sleep(2)
    println(readline(sp))

    sleep(5)
    println("Done")
end