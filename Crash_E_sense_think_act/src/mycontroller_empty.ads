with Ada.Real_Time; use Ada.Real_Time;
with MicroBit.Console; use MicroBit.Console;
with MicroBit.MotorDriver; use MicroBit.MotorDriver;
with MicroBit.Ultrasonic;
with MicroBit.Types; use MicroBit.Types;
with DFR0548;
use MicroBit;
with MicroBit.DisplayRT;

package MyController_empty is
   pragma Elaborate_Body; -- makes the code safer :)

   -- priorities
   task Sense with Priority => 1;

   task objectDetection  with Priority => 3; -- what happens for the set direction if think and sense have the same prio and period?
                                       -- what happens if think has a higher priority? Why is think' set direction overwritten by sense' set direction?
   -- task emotion with Priority => 2

   task Act with Priority => 2;

   -- Period T
   sensePeriod : Time_Span := Milliseconds(700);
   periodThink : Time_Span := Milliseconds(900); --endre på
   periodAct   : Time_Span := Milliseconds(800);



   package sensor_front is new Ultrasonic(Trigger_Pin => MB_P1, Echo_Pin => MB_P0);
   package sensor_right is new Ultrasonic(Trigger_Pin => MB_P15, Echo_Pin => MB_P2);
   package sensor_left  is new Ultrasonic(Trigger_Pin => MB_P13, Echo_Pin => MB_P12);
   package sensor_back  is new Ultrasonic(Trigger_Pin => MB_P14, Echo_Pin => MB_P16);





   -- variables for sense task, private?
   distance_front :  Distance_cm := 0;
   distance_right :  Distance_cm := 0;
   distance_left  :  Distance_cm := 0;
   distance_back  :  Distance_cm := 0;


   -- new types that are used for setting a direction and speed of the car

      type Direction_type is (goForward,
                       goBackward,
                       backLeft,
                       backRight,
                       lateralLeft,
                       lateralRight,
                       diagonalLeft,
                       diagonalRight,
                       turnLeft,
                       turnRight,
                       stopping
                       --rotateLeft,
                       --rotateRight,
                       );

      type Threat_State is (frontThreat,
                           closeFrontThreat,
                           rightThreat,
                           closeRightThreat,
                           leftThreat,
                           closeLeftThreat,
                           backThreat,
                           closeBackThreat,
                           noThreat);

      type Speed_type is (SlowSpeed,
                        MediumSpeed,
                        FullSpeed,
                        StopSpeed);

      type Emotion_type is (sad,    -- used when it crashes
                           happy,   -- always happy
                           ups,     -- used when an almost crash occurred
                           right,   -- used when the car rotates right
                           left);   -- used when the car rotates left

      type Sensor_type is (F, L, R, B); -- so that we can use it for functions that need sensor



      subtype Angle is Integer range 0 .. 360; -- used in the rotateCar function
      distance_sensor : array (Sensor_type) of Distance_cm := (others => 0); -- setting all values to 0 before populating the array

      -- speed : Speeds := (4095, 4095, 4095, 4095);
      --emotion  : DisplayRT; -- vet ikke hva denne skal være

      -- the array that we put the sensor readings into, maybe private?


protected Object is

      -- procedures
      procedure Change_Direction (dir : Direction_type; s : Speed_Type);
      procedure Navigation(flag : in out Boolean; counter : in out Integer);
      procedure rotateCar(chosen_angle : Angle; clockwise : Boolean := True);
      procedure rotationOrder;
      procedure SetFront (value : Distance_cm);

      -- functions
      function Change_Speed (s : Speed_type) return Speeds;
      function detectThreat(sensorSide : Sensor_type; distMax : Distance_cm) return Boolean;
      --function emotionState(i : Integer; sensorSide : Sensor_type; dist : Distance_cm) return Integer;
      --procedure setEmotion(e : Emotion_type);
      function GetFront return Distance_cm;

   private

      dir            : Direction_type;
      s              : Speed_Type; -- used s because speed is already used
      setAngle       : Angle;
      setBool        : Boolean;
      setDirection   : Direction_type;
      setSpeed       : Speed_type;
      rotateFirst    : Boolean;
      noRotate       : Boolean;
      front          : Distance_cm;

end Object;

end MyController_empty;
