#include <Servo.h>
#include <LinkedList.h>

//int32_t joint_angles[] = {45, 135, 180, 90, 45, 15};
int32_t joint_angles[] = {0,0,0,0,0,0};
Servo servos[] = {Servo(), Servo(), Servo(), Servo(), Servo(), Servo()};
int8_t servo_pins[] = {4, 5, 6, 7, 8, 9};
String input;

// Use this to introduce latency in the response
unsigned long responseDelay = 3000;

// Use these to generate additional traffic (timestamped ADC values).
bool write_adc = false;
unsigned long writeInterval = 50;  // ms

unsigned long timeMarker = millis();

void retrieve_angles(String a_input, int32_t a_joint_angles[]);

void setup()
{
  //Serial Port begin
  Serial.begin(115200);

  //Assign pins & set servo angles to home position
  for (int8_t idx = 0; idx < 6; idx++)
  {
    servos[idx].write(joint_angles[idx]);
    servos[idx].attach(servo_pins[idx]);
  }
  Serial.println("45,135,180,90,45,15\n");
}

void loop()
{
  if (Serial.available() > 0)
  {
    delay(responseDelay);

    String arg_input = Serial.readStringUntil('\n');
    retrieve_angles(arg_input, joint_angles);
    
//    Serial.flush();
    Serial.println(arg_input);
  }

  // TODO - make this actually receive angles  
  // write designated angles as servo control signals
  if (joint_angles[0] >= 0)
  {
    int32_t i = 0; Serial.flush();
    for (int8_t idx = 0; idx < 6; idx++)
    {
      if (joint_angles[idx] >= 0)
      {
        servos[idx].write(joint_angles[idx]);
      }
    }
  }
}

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
  }
}
