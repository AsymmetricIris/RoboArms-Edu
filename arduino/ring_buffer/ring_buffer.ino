//TODO  - can test whether there's a difference between raw / mean / median read jitteriness by changing buffer size to 1 versus taking means and medians 

#include <Servo.h>      //TODO - this is useless get rid of it
#include <RingBuf.h>

const int BAUD = 1200;
const int MAX_SERVO_COUNT = 6;
const uint8_t BUFFER_SIZE = 9;

RingBuf<uint8_t, BUFFER_SIZE> rd_buffers[] = { RingBuf<uint8_t, BUFFER_SIZE>(), RingBuf<uint8_t, BUFFER_SIZE>() }; 

uint8_t servo_ctrl_pins[] = {3, 4, 6, 7, 8, 0};         //TODO - this is useless
Servo servos[] = {  Servo(), Servo(), Servo(), 
                    Servo(), Servo(), Servo()   };    //TODO - this is useless get rid of it

uint8_t rd_pins[] = {A0, A1};
long joint_angles[] = {0, 0};
uint8_t servo_count = 1;

void rd_angles(uint8_t read_pins[], uint8_t pin_count, long angles[]);
void print_angles(uint8_t pin_count, long angles[]);
void assign_pins(Servo joint_servos[], uint8_t ctrl_pins[], uint8_t pin_count, long angles[]);
void sort_data(long &data);
long mean(long &data);

void setup() {
  // initialize at BAUD (baud rate) bits per second:
  Serial.begin(BAUD);
  // assign_pins(servos, servo_ctrl_pins, servo_count, joint_angles);
  assign_pins(servos, servo_ctrl_pins, MAX_SERVO_COUNT, joint_angles);
}

void loop() {
  // put your main code here, to run repeatedly:
  rd_angles(rd_pins, servo_count, joint_angles);
  // print_angles(servo_count, joint_angles);
  // wr_angles(servos, servo_count, joint_angles);

  for (int8_t idx = 0; idx < servo_count; idx++)
  {
    Serial.print(joint_angles[idx]); Serial.print(" "); 
    Serial.print(rd_buffers[idx][0]); Serial.print(" "); Serial.print(rd_buffers[idx][1]); Serial.print(" "); Serial.print(rd_buffers[idx][2]);
    uint8_t data[9];
    rd_buffers[idx].peek(data[0], 9);
    //TODO - create a copy of the array and confirm that it's a COPY rather than a reference
    //

    Serial.print(" "); Serial.print(rd_buffers[idx].size());

    Serial.print(" \t ");
  }
  Serial.println();
}

void rd_angles(uint8_t read_pins[], uint8_t pin_count, long angles[])
{
  //collect readings from all sensors (in o.g. version, they're pots)
  //...and, convert readings to ctrl angles for joint ctrl
  for (int8_t idx = 0; idx < pin_count; idx++)
  {
    int sensorValue = analogRead(read_pins[idx]);
    long angle_value = map(sensorValue, 0, 1023, 0, 180);
    joint_angles[idx] = angle_value;
    rd_buffers[idx].pushOverwrite(angle_value);
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

void assign_pins(Servo joint_servos[], uint8_t ctrl_pins[], uint8_t pin_count, long angles[])
{
  //Assign pins & set servo angles to home position
  for (int8_t idx = 0; idx < pin_count; idx++)
  {
    //set read pins
    pinMode(rd_pins[idx], INPUT);

    // pinMode(ctrl_pins[idx], OUTPUT);
    // Set default servo angles
    // joint_servos[idx].write(angles[idx]);
    // Assign servo ctrl pins
    // joint_servos[idx].attach(servo_ctrl_pins[idx]);
  }
}

void sort_data(long &data)
{
  //TODO - implement
  //sort the array
}

long mean(long &data)
{
  //TODO - implement
  //calculate mean from the array

  return 0
}