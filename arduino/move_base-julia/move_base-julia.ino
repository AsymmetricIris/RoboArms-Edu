#include <Servo.h>
#include <LinkedList.h>

Servo servos[] = {Servo(), Servo(), Servo(), Servo(), Servo(), Servo()};
int8_t servo_pins[] = {4, 5, 6, 7, 8, 9};
// initial joint angles (chosen to achieve a stable pose)
int32_t default_angles[] = {0, 135, 180, 90, 45, 15};
int32_t joint_angles[] = {0, 135, 180, 90, 45, 15};

// Use this to introduce latency in the response
unsigned long responseDelay = 1000; // ms

// declare support functions

// will retrieve servo angles 
// so they can be output to servo ctrl pins
void retrieve_angles(String a_input, int32_t a_joint_angles[]);
void write_angles();

void setup()
{
  //Serial Port begin
  Serial.begin(115200);

  //Assign pins & set servo angles to home position
  for (int8_t idx = 0; idx < 6; idx++)
  {
    // Set default servo angles
    servos[idx].write(joint_angles[idx]);
    // Assign servo ctrl pins
    servos[idx].attach(servo_pins[idx]);
  }
}

//TODO - are we just re-setting default angles when we don't receive a ctrl string?
void loop()
{
  if (Serial.available() > 0)
  {
    delay(responseDelay);

    String arg_input = Serial.readStringUntil('\n');
    retrieve_angles(arg_input, joint_angles);
    
    print_servo_angles();

    // TODO - bug - weird behaviour where arm moves to several random angles 
    //              whenever write is attmepted
    // TODO - bug - resolved random movement by moving write_angles() 
    //              into Serial.available condition
    //              Figure out why write_angles() does the wacky

    // write designated angles as servo control signals
    if (joint_angles[0] >= 0)
    {
      write_angles();
    }
  }
}

//assign target angle signals to joints' servo controllers
void write_angles()
{
  //int32_t i = 0; Serial.flush();
  for (int idx = 0; idx < 6; idx++)
  {
    if (joint_angles[idx] >= 0)
    {
      servos[idx].write(joint_angles[idx]);
      Serial.print(joint_angles[idx]);
      Serial.print(",");
    }
  }
  Serial.print(" : ");
}

// retrieve servo angles 
// so they can be output to servo ctrl pins
void retrieve_angles(String a_input, int32_t a_joint_angles[])
{
  int32_t prev_delim_idx = 0; // will tell us where to start collecting an arg string
  int32_t next_delim_idx = 0; // will tell us where to stop collecting an arg string
  int32_t joint_angle;        // angle from arg string

  // find the next delimiter
  // so we can collect the string between previous and next
  next_delim_idx = a_input.indexOf(",", prev_delim_idx + 1);
  String arg_string = a_input.substring(prev_delim_idx + 1, next_delim_idx); // grab the substring between delimiters


  // collect joint angles from the input string
  // and, assign them to the joint angles array
  for (int32_t idx = 0; idx < 6; idx++)
  {
    // get joint angle from the last arg_string collected
    joint_angle = arg_string.toInt();

    // place the joint angle at the corresponding index
    // in the joint angles array
    a_joint_angles[idx] = joint_angle;

    // index where we found delimiter
    // is now the start of our search
    prev_delim_idx = next_delim_idx;

    // search for next comma delimiter, starting from prev delimeter
    next_delim_idx = a_input.indexOf(",", prev_delim_idx + 1);

    // grab the substring between delimiters
    arg_string = a_input.substring(prev_delim_idx + 1, next_delim_idx);
    // Serial.print(" (" + arg_string + ") ");
  }
}

// print angles assigned to all servo ctrl pins
void print_servo_angles()
{
  Serial.print(joint_angles[0]); Serial.print(" ");
  Serial.print(joint_angles[1]); Serial.print(" ");
  Serial.print(joint_angles[2]); Serial.print(" ");
  Serial.print(joint_angles[3]); Serial.print(" ");
  Serial.print(joint_angles[4]); Serial.print(" ");
  Serial.print(joint_angles[5]); Serial.print(" ");
  Serial.println();
}
