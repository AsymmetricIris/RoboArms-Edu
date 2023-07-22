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

joints = [
    RJoint(0, 0, 0, 0) 
    RJoint(0, 0, 4, 90)
    RJoint(0, 15, 0, 90) 
    RJoint(0, 0, 0, 0) 
    RJoint(0, 0, 0, 0)
    RJoint(0, 0, 0, 0)
]

default_angles = Observable([ 45, 140, 175, 90, 0, 45 ])

for idx = 1:size(joints)[1]
    joints[idx].angle = default_angles[][idx]
end

println("Ports: ")
println(list_ports())

# Modify these as needed
# portname = "/dev/ttyUSB0"
portname = "COM8"
baudrate = 115200

joint_count = size(joints)[1]
observe_joints = Observable(joint_count)

function printqml(number)
  println(number)
end
@qmlfunction printqml

function changeAngleQml(angle_idx, angle)
  joints[angle_idx].angle = trunc(Int32, angle)
end
@qmlfunction changeAngleQml

function showAnglesQml()
    ctrl_string = ""

    for idx = 1:joint_count
        ctrl_string *= string(joints[idx].angle)
        ctrl_string *= ","
    end

    ctrl_string = ctrl_string * "end"
    ctrl_string = replace(ctrl_string, ",end" => "\n")

    print(ctrl_string)

#   for idx = 1:joint_count
#     print(joints[idx].angle)
#     print(" ")
#   end

#   println("]")
end
@qmlfunction showAnglesQml

function truncQml(number)
  return trunc(Int32, number)
end
@qmlfunction truncQml

qml_file = joinpath(dirname(@__FILE__), "qml", "ctrl_v0.3.qml")
loadqml(qml_file, observables = JuliaPropertyMap("num_joints" => observe_joints, "default_angles" => default_angles))

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