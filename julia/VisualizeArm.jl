# based on code from https://github.com/JuliaIO/LibSerialPort.jl

using LibSerialPort

# var:float64 = [4, 4]
# var ./= 2
# println(var)

println("Ports: ")
println(list_ports())

# Modify these as needed
# portname = "/dev/ttyUSB0"
portname = "COM6"
baudrate = 115200

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
    write(serial_port, " 180,140,175,90,90,15\n")
    sleep(1)
    println(readline(serial_port))
    sleep(1)
    println("Done")
end