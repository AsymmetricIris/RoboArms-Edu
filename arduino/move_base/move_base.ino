#include <Servo.h>
#include <LinkedList.h>

// TODO - implement tidy/readable way to store/mutate servos
// typename: robo_arm;
// struct {  
// } ;

int32_t joint_angles[] = {0, 135, 180, 90, 45, 15};
Servo servos[] = {Servo(), Servo(), Servo(), Servo(), Servo(), Servo()};
int8_t servo_pins[] = {4, 5, 6, 7, 8, 9};
String input;


void retrieve_angles(String a_input, int32_t a_joint_angles[]);

void setup() {
  //Serial Port begin
  Serial.begin (9600);

  for (int8_t idx = 0; idx < 6; idx++)
  {
    servos[idx].write(joint_angles[idx]);
    servos[idx].attach(servo_pins[idx]);
  }
}
 
void loop()
{    
  if (Serial.available())
  {
    String arg_input = Serial.readStringUntil('\n');
    retrieve_angles(arg_input, joint_angles);  
    Serial.flush();         
  }

  // TODO -  make thie runnable, currently expected to fail
  if (joint_angles[0] >= 0)
  {
    int32_t i = 0;
    for (int8_t idx = 0; idx < 6; idx++)
    {
      if (joint_angles[idx] >= 0)
      {
        Serial.print(joint_angles[idx]);
        Serial.print(" ");

        servos[idx].write(joint_angles[idx]);
      }
    }
    Serial.println();
  }

  delay(250);
}

void retrieve_angles(String a_input, int32_t a_joint_angles[])
{
  int32_t prev_delim_idx = 0;
  int32_t next_delim_idx = 0;
  int32_t joint_angle;

  next_delim_idx = a_input.indexOf(",", prev_delim_idx+1);
  String arg_str = a_input.substring(prev_delim_idx+1, next_delim_idx);  // grab the substring between delimiters

  int32_t idx = 0;
  for (idx = 0; idx < 6; idx++)
  {
    joint_angle = arg_str.toInt();
    a_joint_angles[idx] = joint_angle;                            // place the joint angle at the corresponding index in the joint angles array

    Serial.print("Arg: "); Serial.print(arg_str); Serial.print(" Idx:"); Serial.print(idx);
    Serial.println();
    //Serial.print("Prev: "); Serial.println(prev_delim_idx);

    prev_delim_idx = next_delim_idx;                            // the index where we found our delimiter is now the start of our search
    next_delim_idx = a_input.indexOf(",", prev_delim_idx+1);
    arg_str = a_input.substring(prev_delim_idx+1, next_delim_idx);  // grab the substring between delimiters
    // idx++;
  }
}
