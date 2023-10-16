#include <Servo.h>

uint8_t rd_pins[] = {A0, A1, A2, A3, A4, A5, A6};
uint8_t servo_ctrl_pins[] = {7, 3, 4, 5, 6, 8};         //TODO - make this progression linear
Servo servos[] = {  Servo(), Servo(), Servo(), 
                    Servo(), Servo(), Servo()   };
long joint_angles[] = {0, 0, 0, 0, 0, 0};               //will assign values to angles before we write ctrl signals
uint8_t servo_count = 1;                              //will use 6 in later versions using the RoboArm

void assign_pins(Servo joint_servos[], uint8_t ctrl_pins[], uint8_t pin_count, long angles[]);
void rd_angles(uint8_t read_pins[], uint8_t pin_count, long angles[]);
void wr_angles(Servo joint_servos[], uint8_t pin_count, long angles[]);
void print_angles(uint8_t pin_count, long angles[]);

// the setup routine runs once when you press reset:
void setup() {
  // initialize serial communication at 9600 bits per second:
  Serial.begin(9600);
  assign_pins(servos, servo_ctrl_pins, servo_count, joint_angles);
}

// the loop routine runs over and over again forever:
void loop() {
  // read the input on analog pin 0:
  int sensorValue = analogRead(A0);
  // Convert the analog reading (which goes from 0 - 1023) to a voltage (0 - 5V):
  float voltage = sensorValue * (5.0 / 1023.0);
  long angle = map(sensorValue, 0, 1023, 0, 360);
  // print out the value you read:
  Serial.print(voltage);
  Serial.print(" \t ");
  rd_angles(servo_ctrl_pins, servo_count, joint_angles);
  print_angles(servo_count, joint_angles);
  wr_angles(servos, servo_count, joint_angles);
}

void assign_pins(Servo joint_servos[], uint8_t ctrl_pins[], uint8_t pin_count, long angles[])
{
  //Assign pins & set servo angles to home position
  for (int8_t idx = 0; idx < pin_count; idx++)
  {
    // Set default servo angles
    joint_servos[idx].write(angles[idx]);
    // Assign servo ctrl pins
    joint_servos[idx].attach(ctrl_pins[idx]);
  }
}

void print_angles(uint8_t pin_count, long angles[])
{
  for (int8_t idx = 0; idx < pin_count; idx++)
  {
    Serial.print(angles[idx]);
    Serial.print(" \t ");
  }
  Serial.println();
}

void wr_angles(Servo joint_servos[], uint8_t pin_count, long angles[])
{
  //TODO - send ctrl signals to joint servos
  for (int8_t idx = 0; idx < pin_count; idx++)
  {
    joint_servos[idx].write(angles[idx]);
  }
}

void rd_angles(uint8_t read_pins[], uint8_t pin_count, long angles[])
{
  //collect readings from all sensors (in o.g. version, they're pots)
  //...and, convert readings to ctrl angles for joint ctrl
  for (int8_t idx = 0; idx < pin_count; idx++)
  {
    int sensorValue = analogRead(read_pins[idx]);
    joint_angles[idx] = map(sensorValue, 0, 1023, 0, 360);
  }
}
