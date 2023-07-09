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

qml_file = joinpath(dirname(@__FILE__), "qml", "observable.qml")

const input = Observable(90.0)
const output = Observable(0.0)
const num_joints = Observable(size(joints)[1])
const joint_selected_ui = Observable(2)
joint_selected::Int32 = 2

robot = Robot(2)

on(joint_selected_ui) do y
  # joint_selected = trunc(Int64, y)
  robot.joint_selected = trunc(Int64, y)
  println("Selected ", robot.joint_selected)
end

on(output) do x
  # joints[joint_selected].angle = trunc(Int64, x)
  joints[robot.joint_selected].angle = trunc(Int64, x)
  ctrl_string::String = " "           # leading space avoids weird bug w libserialport
  
  for joint in joints
    ctrl_string = ctrl_string * string(joint.angle) * ","
  end
  ctrl_string = ctrl_string * "end"
  ctrl_string = replace(ctrl_string, ",end" => "\n")
  
  print(ctrl_string)

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
end

loadqml(qml_file, observables = JuliaPropertyMap("input" => input, "output" => output, "num_joints" => num_joints, "joint_selected" => joint_selected_ui))

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

#   write(serial_port, " 45,140,175,90,0,45\n")
#   sleep(1)
#   println(readline(serial_port))
#   sleep(1)
#   write(serial_port, " 180,140,175,90,25,15\n")
#   sleep(1)
#   println(readline(serial_port))
#   sleep(1)
#   println("Done")
# end