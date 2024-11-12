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

         Put_Line("In task sense");

         Object.SetFront(sensor_front.Read);
         Put_Line(" ");
         Put_Line("Front: " & Distance_cm'Image(Object.GetFront));
         distance_right       := sensor_right.Read;
         Put_Line(" ");
         Put_Line("Right: " & Distance_cm'Image(distance_right));
         distance_left        := sensor_left.Read;
         Put_Line(" ");
         Put_Line("Left: " & Distance_cm'Image(distance_left));
         distance_back        := sensor_back.Read;
         Put_Line(" ");
         Put_Line("Back: " & Distance_cm'Image(distance_back));

         ---delay (0.05); --normally the sensor should have 50ms execution time, may not be needed

         delay until myClock + period;
      end loop;
   end sense;

   --think task, (2 tasks)

   task body objectDetection is
      clockStart : Time;
      period : Time_Span := periodThink; --the peiod for think tasks
      flag : Boolean := False; --; skriv en protected obj som skal kommunisere mellom  think  og task
      counter : Integer := 0;
      front : Distance_cm;
   begin
      loop
         clockStart := Clock;

         Put_Line("In think task");

         -- get sensor input
         front := Object.GetFront;

         -- make a decision based on sensor input
         decision := DetectThread(front);

         -- make a drive direction based on detected thread
         Object.SetDriveDirection := Navigation(decision);


         --Object.SetDecision(front);

         --Navigation(flag, counter);

         --delay (0.05); --simulate 50 ms execution time, replace with your code

         delay until clockStart + period;

      end loop;

   end objectDetection;


   task body act is
      myClock : Time;
      period   : Time_Span := periodAct;
   begin

      loop
         myClock := Clock;

         Put_Line("In act task");

         -- Object.rotationOrder;

         delay until myClock + period;

      end loop;

   end act;


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

protected body Object is

  procedure SetFront (value : Distance_cm) is
  begin
   front := value;
  end SetFront;


  function GetFront return Distance_cm is
  begin
   return front;
  end GetFront;

      --see where the threat is
   function detectThreat(sensorSide : Sensor_type; distMax : Distance_cm) return Boolean is

      distNow : Distance_cm; -- what is the distance now
      begin

          Put_Line("In detectThreat");
         distNow := (case sensorSide is
                     when F => distance_front,
                     when R => distance_right,
                     when L => distance_left,
                     when B => distance_back);
      return distNow <= distMax;
   end detectThreat;

   --function for what the car should do if it detects a threat

   procedure Navigation(flag : in out Boolean; counter : in out Integer) is -- c is for clockwise

      begin

         Put_Line("In navigation");
         -- if there is a threat on the front
         if (detectThreat(F, 15) and not detectThreat(R, 15) and not detectThreat(L, 15) and not detectThreat(B, 15)) then
            rotateFirst       := True;
            setAngle          := 90;
            setBool           := True; -- -- we rotate the car clockise, +90 degrees
            setDirection      := goForward;
            setSpeed          := FullSpeed;

            -- use counter as delay for 0.5 ms
            if counter >= 50 then
               counter        := 0; -- if 0.5 sec have gone by, reset the counter
               flag           := True;

            else
               counter        := counter + 1;
            end if;

         elsif (detectThreat(F, 10) and not detectThreat(R, 10) and not detectThreat(L, 10) and not detectThreat(B, 10)) then
            noRotate          := True;
            setDirection      := stopping;
            setSpeed          := StopSpeed;

            -- counter delay 0.2 for waiting 0.2 seconds
            if counter < 20 then
               counter        := counter + 1;

            elsif counter < 70 then -- drive backwards for 0.7 seconds
               setDirection   := goBackward;
               setSpeed       := SlowSpeed;
               counter        := counter + 1;

            else
               counter        := 0;
               flag           := True;
            end if;

         -- if there is a threat on the right
         elsif(detectThreat(R, 15) and not detectThreat(F, 15) and not detectThreat(L, 15) and not detectThreat(B, 15)) then
            rotateFirst       := False;
            setDirection      := lateralLeft;
            setSpeed          := MediumSpeed;

            if counter >= 50 then
               setAngle       := 45;
               setBool        := False;
               counter        := 0;
               flag           := True;

            else
               counter        := counter + 1;
            end  if;

         elsif(detectThreat(R, 10) and not detectThreat(F, 10) and not  detectThreat(L, 10) and not detectThreat(B, 10)) then
            noRotate          := True;
            setDirection      := stopping;
            setSpeed          := StopSpeed;

            if counter < 20 then
               counter        := counter + 1;

            elsif counter < 70 then
               setDirection   := goBackward;
               setSpeed       := MediumSpeed;
               flag           := True;
            end if;

         -- if there is a threat on the left
         elsif(detectThreat(L, 15) and not detectThreat(F, 10) and not  detectThreat(L, 10) and not detectThreat(B, 10)) then
            rotateFirst       := False;
            setDirection      := lateralRight;
            setSpeed          := MediumSpeed;

            if counter >= 50 then
               setAngle       := 45;
               setBool        := True;
               counter        := 0;
               flag           := True;

            else
               counter        := 0;
            end if;

         elsif(detectThreat(L, 10) and not detectThreat(F, 10) and not  detectThreat(R, 10) and not detectThreat(B, 10)) then
            noRotate          := True;
            setDirection      := stopping;
            setSpeed          := StopSpeed;

            if counter < 20 then
               counter        := counter + 1;

            elsif counter < 70 then
               setDirection   := goBackward;
               setSpeed       := MediumSpeed;
               counter        := counter + 1;

            else
               counter        := 0;
               flag           := True;
            end if;

         -- if there is a threat in the back
         elsif(detectThreat(B, 15) and not detectThreat(F, 10) and not  detectThreat(R, 10) and not detectThreat(L, 10)) then
            noRotate          := True;
            setDirection      := goForward;
            setSpeed          := MediumSpeed;
            -- Set_Direction(goForward, FullSpeed);
            if counter < 20 then
               counter        := counter + 1;

            else
               counter        := 0;
               flag           := True;
            end if;

         -- if there is no threat near :)
         elsif(not detectThreat(F, 15) and not detectThreat(R, 10) and not  detectThreat(L, 10) and not detectThreat(B, 10)) then
            noRotate          := True;
            setDirection      := goForward;
            setSpeed          := FullSpeed;
            -- Set_Direction(goForward, FullSpeed);
            flag              := True;

         end if;
      end Navigation;


   procedure rotateCar(chosen_angle : Angle; clockwise : Boolean := True) is
      angleChangeDuration : constant Integer := 5; -- 1 degree of rotation takes 5 ms
      calcultedAngleDuration : Integer := chosen_angle * angleChangeDuration;
      angleDurationTotal : Time_Span := Microseconds (calcultedAngleDuration); --calculates how long a rotation will take
      startOfRotation : Time; -- when does the rotation start
      begin

         Put_Line("In rotatecar");
         if clockwise then
            Change_Direction(turnRight, MediumSpeed); -- lotateright
         else
            Change_Direction(turnLeft, MediumSpeed);
         end if;
         startOfRotation := Clock;
         delay until startOfRotation + angleDurationTotal;

   end rotateCar;

   function Change_Speed (s : Speed_type) return Speeds is
   speed : Speeds;
   begin

      Put_Line("In Change Speed");

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

   procedure Change_Direction (dir : Direction_type; s : Speed_type) is
      begin

         Put_Line("In change direction");
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

   procedure rotationOrder is
   begin
      if rotateFirst then
         Object.rotateCar(setAngle, setBool);
         Object.Change_Direction(setDirection, SetSpeed);
      elsif not rotateFirst then
         Object.Change_Direction(setDirection, setSpeed);
         Object.rotateCar(setAngle, setBool);
      elsif noRotate then
         Object.Change_Direction(setDirection, setSpeed);
      end if;
   end rotationOrder;


end Object;


end MyController_empty;

