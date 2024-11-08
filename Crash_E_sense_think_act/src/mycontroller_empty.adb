with Ada.Real_Time; use Ada.Real_Time;
with MicroBit.Console; use MicroBit.Console;
with MicroBit.MotorDriver; use MicroBit.MotorDriver;
with MicroBit.Ultrasonic;
with MicroBit.Types; use MicroBit.Types;
with DFR0548;
use MicroBit;
with MicroBit.DisplayRT;


package body MyController_empty is

   task body sense is
      myClock  : Time;
      period   : Time_Span := sensePeriod;
   begin

      loop
         myClock := Clock;

         -- read the distance

         distance_front := sensor_front.Read;
         distance_right := sensor_right.Read;
         distance_left  := sensor_left.Read;
         distance_back  := sensor_back.Read;


         delay (0.05); --normally the sensor should have 50ms execution time

         delay until myClock + period;
      end loop;
   end sense;

   --think task, (2 tasks)

   task body objectDetection is
      clockStart : Time;
      period : Time_Span := periodThink; --the peiod for think tasks
      flag : Boolean;
   begin
      loop
         clockStart := Clock;

         if distance_front <= 20 then
            detectThreat(F, 20);
         end if;

         --detectThreat();
         Navigation(flag);

         delay (0.05); --simulate 50 ms execution time, replace with your code

         delay until clockStart + period;

      end loop;

   end objectDetection;


   task body act is
      myClock : Time;
      period   : Time_Span := periodAct;
   begin

      loop
         myClock := Clock;

         if rotateFirst then
            rotateCar(setAngle, setBool);
            Change_Direction(setDirection, setSpeed);
         elsif not rotateCar then
            Change_Direction(setDirection, setSpeed);
            rotateCar(setAngle, setBool);
         elsif noRotate then
            Change_Direction(setDirection, setSpeed);
         end if;

         delay until myClock + period;
      end loop;


   end act;





   -- procedures
    procedure Change_Direction (dir : Direction_type; s : Speed_type) is
      begin

         case dir is
            when goForward       => MotorDriver.Drive(Forward,          Change_Speed(s));
            when goBackward      => MotorDriver.Drive(Backward,         Change_Speed(s));
            when backLeft        => MotorDriver.Drive(Backward_Left,    Change_Speed(s));
            when backRight       => MotorDriver.Drive(Backward_Right,   Change_Speed(s));
            when lateralLeft     => MotorDriver.Drive(Lateral_Left,     Change_Speed(s));
            when lateralRight    => MotorDriver.Drive(Lateral_Right,    Change_Speed(s));
            when diagonalLeft    => MotorDriver.Drive(Forward_Left,     Change_Speed(s));
            when diagonalRight   => MotorDriver.Drive(Forward_Right,    Change_Speed(s));
            when turnLeft        => MotorDriver.Drive(Turning_Left,     Change_Speed(s));
            when turnRight       => MotorDriver.Drive(Turning_Right,    Change_Speed(s));
            when stopping        => MotorDriver.Drive(Stop,             Change_Speed(s)
            --when rotateLeft      => MotorDriver.Drive(Rotating_Left,    Set_Speed(s));
            --when rotateRight     => MotorDriver.Drive(Rotating_Right,   Set_Speed(s));
            );
         end case;

   end Change_Direction;

   --functions

   function Change_Speed (s : Speed_type) return Speeds is
      speed : Speeds;
      begin

         case s is
                  when SlowSpeed =>
                     speed := (1000, 1000, 1000, 1000); -- speed/5

                  when MediumSpeed =>
                     speed := (2048, 2048, 2048, 2048); -- speed/2 opprundet

                  when FullSpeed =>
                     speed := (4095, 4095, 4095, 4095);

                  when StopSpeed =>
                     speed := (0, 0, 0, 0);
         end case;

      return speed;
    end Change_Speed;

    --see where the threat is
    function detectThreat(sensorSide : Sensor_type; distMax : Distance_cm) return Boolean is
      distNow : Distance_cm; -- what is the distance now
      begin
         distNow := (case sensorSide is
                     when F => distance_front,
                     when R => distance_right,
                     when L => distance_left,
                     when B => distance_back);
      return distNow <= distMax;
   end detectThreat;

   --function for what the car should do if it detects a threat (act)

   procedure Navigation(counter : Integer; flag : in out Boolean) is -- c is for clockwise

      begin

         -- if there is a threat on the front
         if (detectThreat(F, 15) and not detectThreat(R, 15) and not detectThreat(L, 15) and not detectThreat(B, 15)) then
            rotateFirst    := True;
            setAngle       := 90;
            setBool        := True; -- -- we rotate the car clockise, +90 degrees
            setDirection   := goForward;
            setSpeed       := FullSpeed;
            --  rotateCar(90, True);
            --  Set_Direction(goForward, FullSpeed);
            delay 0.6;
            flag           := True;
         elsif (detectThreat(F, 10) and not detectThreat(R, 10) and not detectThreat(L, 10) and not detectThreat(B, 10)) then
            noRotate       := True;
            setDirection   := stopping;
            setSpeed       := StopSpeed;
            -- Set_Direction(stopping, StopSpeed);
            delay 0.2; -- stop for 0.2 seconds then go slowly backward
            setDirection   := goBackward;
            setSpeed       := SlowSpeed;
            -- Set_Direction(goBackward, SlowSpeed);
            delay 0.5;
            flag           := True;

         -- if there is a threat on the right
         elsif(detectThreat(R, 15) and not detectThreat(F, 15) and not detectThreat(L, 15) and not detectThreat(B, 15)) then
            rotateCar      := False;
            setDirection   := lateralLeft;
            setSpeed       := MediumSpeed;
            -- Set_Direction(lateralLeft, MediumSpeed);
            delay 0.5;
            setAngle       := 45;
            setBool        := False;
            -- rotateCar(45, False);
            flag           := True;

         elsif(detectThreat(R, 10) and not detectThreat(F, 10) and not  detectThreat(L, 10) and not detectThreat(B, 10)) then
            noRotate       := True;
            setDirection   := stopping;
            setSpeed       := StopSpeed;
            -- Set_Direction(Stopping, StopSpeed);
            delay 0.2;
            setDirection   := goBackward;
            setSpeed       := MediumSpeed;
            -- Set_Direction(goBackward, MediumSpeed);
            delay 0.5;
            flag           := True;

         -- if there is a threat on the left
         elsif(detectThreat(L, 15) and not detectThreat(F, 10) and not  detectThreat(L, 10) and not detectThreat(B, 10)) then
            rotateFirst    := False;
            setDirection   := lateralRight;
            setSpeed       := MediumSpeed;
            -- Set_Direction(lateralRight, MediumSpeed);
            delay 0.5;
            setAngle       := 45;
            setBool        := True;
            -- rotateCar(45, True);
            delay 0.5;
            flag           := True;

         elsif(detectThreat(L, 10) and not detectThreat(F, 10) and not  detectThreat(R, 10) and not detectThreat(B, 10)) then
            noRotate       := True;
            setDirection   := stopping;
            setSpeed       := StopSpeed;
            -- Set_Direction(Stopping, StopSpeed);
            delay 0.2;
            setDirection   := goBackward;
            setSpeed       := MediumSpeed;
            -- Set_Direction(goBackward, MediumSpeed);
            delay 0.5;
            flag           := True;

         -- if there is a threat in the back
         elsif(detectThreat(B, 15) and not detectThreat(F, 10) and not  detectThreat(R, 10) and not detectThreat(L, 10)) then
            noRotate       := True;
            setDirection   := goForward;
            setSpeed       := MediumSpeed;
            -- Set_Direction(goForward, FullSpeed);
            delay 0.2;
            flag := True;

         -- if there is no threat near :)
         elsif(not detectThreat(F, 15) and not detectThreat(R, 10) and not  detectThreat(L, 10) and not detectThreat(B, 10)) then
            noRotate       := True;
            setDirection   := goForward;
            setSpeed       := FullSpeed;
            -- Set_Direction(goForward, FullSpeed);
            flag           := True;

         end if;
      end Navigation;



   procedure rotateCar(chosen_angle : Angle; clockwise : Boolean := True) is
      angleChangeDuration : constant Integer := 5; -- 1 degree of rotation takes 5 ms
      calcultedAngleDuration : Integer := chosen_angle * angleChangeDuration;
      angleDurationTotal : Time_Span := Microseconds (calcultedAngleDuration); --calculates how long a rotation will take
      startOfRotation : Time; -- when does the rotation start
      begin
         if clockwise then
            Change_Direction(turnRight, MediumSpeed); -- lotateright
         else
            Change_Direction(turnLeft, MediumSpeed);
         end if;
         startOfRotation := Clock;
         delay until startOfRotation + angleDurationTotal;

   end rotateCar;



   --  procedure setEmotion(e : Emotion_type) is
   --     k : int;
   --     begin
   --        --  case emotion is =>
   --        --  when sad
   --        k := 1;
   --  end setEmotion;


   --  --function for emotional state of the car
   --  function emotionState(i : int; sensorSide : Sensor_type; dist : Distance_cm) return int is
   --     begin
   --        i := 1;
   --     return i;
   --  end emotionState;



end MyController_empty;

-----
function detectThreat(sensorSide : Sensor_type; distMax : Distance_cm) return Boolean is
   distNow : Distance_cm;
begin

   distNow := (case sensorSide is
                  when F => distance_front,
                  when R => distance_right,
                  when L => distance_left,
                  when B => distance_back);

   --hvis sensoren detekterer noe innen 20cm->starter Navig prosesssen:


   return distNow <= distMax;
end detectThreat;


---Nb. counter
