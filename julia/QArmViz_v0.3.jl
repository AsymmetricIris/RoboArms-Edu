# based on code from https://github.com/JuliaIO/LibSerialPort.jl

using LibSerialPort
using QML
using Qt5QuickControls_jll
using Observables

mutable struct RJoint
    angle::Real         #theta : angle about prev z from x_old to x_new
    extension::Real     #'d' : offset along prev z to common normal
    length2Next::Real   #'r' or 'a' : length of common normal
    angle2Next::Real    #alpha : length of common normal
end

mutable struct Robot
  joint_selected::Int32
end

joints = [
    RJoint(0, 0, 0, 0) 
    RJoint(0, 0, 4, 90)
    RJoint(0, 15, 0, 90) 
    RJoint(0, 0, 0, 0) 
    RJoint(0, 0, 0, 0)
    RJoint(0, 0, 0, 0)
]

println("Ports: ")
println(list_ports())

# Modify these as needed
# portname = "/dev/ttyUSB0"
portname = "COM8"
baudrate = 115200

qml_file = joinpath(dirname(@__FILE__), "qml", "ctrl.qml")

joint_count = size(joints)[1]

robot = Robot(2)

function printqml(number)
  println(number)
end
@qmlfunction printqml

function changeAngleQml(angle_idx, angle)
  joints[angle_idx].angle = trunc(Int32, angle)
end
@qmlfunction changeAngleQml

function showAnglesQml()
  print("[ ")

  for idx = 1:joint_count
    print(joints[idx].angle)
    print(" ")
  end

  println("]")
end
@qmlfunction showAnglesQml

function truncQml(number)
  return trunc(Int32, number)
end
@qmlfunction truncQml

loadqml(qml_file)

if isinteractive()
  exec_async()
else
  exec()
end

# # Snippet from examples/mwe.jl
  # LibSerialPort.open(portname, baudrate) do serial_port
  # 	sleep(2)

  # 	if bytesavailable(serial_port) > 0
  #     	println(String(read(serial_port)))
  # 	end

  #   write(serial_port, ctrl_string)
  #   sleep(1)
  #   println(readline(serial_port))
  #   sleep(1)
  # end