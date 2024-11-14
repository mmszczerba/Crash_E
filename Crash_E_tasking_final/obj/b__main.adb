pragma Warnings (Off);
pragma Ada_95;
pragma Source_File_Name (ada_main, Spec_File_Name => "b__main.ads");
pragma Source_File_Name (ada_main, Body_File_Name => "b__main.adb");
pragma Suppress (Overflow_Check);

package body ada_main is

   E074 : Short_Integer; pragma Import (Ada, E074, "ada__tags_E");
   E005 : Short_Integer; pragma Import (Ada, E005, "ada__strings__text_buffers_E");
   E072 : Short_Integer; pragma Import (Ada, E072, "system__bb__timing_events_E");
   E012 : Short_Integer; pragma Import (Ada, E012, "ada__exceptions_E");
   E044 : Short_Integer; pragma Import (Ada, E044, "system__soft_links_E");
   E042 : Short_Integer; pragma Import (Ada, E042, "system__exception_table_E");
   E152 : Short_Integer; pragma Import (Ada, E152, "ada__streams_E");
   E159 : Short_Integer; pragma Import (Ada, E159, "system__finalization_root_E");
   E157 : Short_Integer; pragma Import (Ada, E157, "ada__finalization_E");
   E161 : Short_Integer; pragma Import (Ada, E161, "system__storage_pools_E");
   E156 : Short_Integer; pragma Import (Ada, E156, "system__finalization_masters_E");
   E133 : Short_Integer; pragma Import (Ada, E133, "ada__real_time_E");
   E163 : Short_Integer; pragma Import (Ada, E163, "system__pool_global_E");
   E234 : Short_Integer; pragma Import (Ada, E234, "system__tasking__protected_objects_E");
   E236 : Short_Integer; pragma Import (Ada, E236, "system__tasking__restricted__stages_E");
   E154 : Short_Integer; pragma Import (Ada, E154, "hal__gpio_E");
   E191 : Short_Integer; pragma Import (Ada, E191, "hal__i2c_E");
   E184 : Short_Integer; pragma Import (Ada, E184, "hal__spi_E");
   E195 : Short_Integer; pragma Import (Ada, E195, "hal__uart_E");
   E149 : Short_Integer; pragma Import (Ada, E149, "nrf__gpio_E");
   E179 : Short_Integer; pragma Import (Ada, E179, "nrf__rtc_E");
   E182 : Short_Integer; pragma Import (Ada, E182, "nrf__spi_master_E");
   E209 : Short_Integer; pragma Import (Ada, E209, "nrf__tasks_E");
   E207 : Short_Integer; pragma Import (Ada, E207, "nrf__clock_E");
   E186 : Short_Integer; pragma Import (Ada, E186, "nrf__timers_E");
   E189 : Short_Integer; pragma Import (Ada, E189, "nrf__twi_E");
   E193 : Short_Integer; pragma Import (Ada, E193, "nrf__uart_E");
   E139 : Short_Integer; pragma Import (Ada, E139, "nrf__device_E");
   E197 : Short_Integer; pragma Import (Ada, E197, "microbit__console_E");
   E201 : Short_Integer; pragma Import (Ada, E201, "dfr0548_E");
   E203 : Short_Integer; pragma Import (Ada, E203, "microbit__i2c_E");
   E199 : Short_Integer; pragma Import (Ada, E199, "microbit__motordriver_E");
   E205 : Short_Integer; pragma Import (Ada, E205, "microbit__timehighspeed_E");
   E222 : Short_Integer; pragma Import (Ada, E222, "microbit__ultrasonic_E");
   E131 : Short_Integer; pragma Import (Ada, E131, "mycontroller_empty_E");

   Sec_Default_Sized_Stacks : array (1 .. 4) of aliased System.Secondary_Stack.SS_Stack (System.Parameters.Runtime_Default_Sec_Stack_Size);

   Local_Priority_Specific_Dispatching : constant String := "";
   Local_Interrupt_States : constant String := "";

   Is_Elaborated : Boolean := False;

   procedure adafinal is
      procedure s_stalib_adafinal;
      pragma Import (Ada, s_stalib_adafinal, "system__standard_library__adafinal");

      procedure Runtime_Finalize;
      pragma Import (C, Runtime_Finalize, "__gnat_runtime_finalize");

   begin
      if not Is_Elaborated then
         return;
      end if;
      Is_Elaborated := False;
      Runtime_Finalize;
      s_stalib_adafinal;
   end adafinal;

   procedure adainit is
      Main_Priority : Integer;
      pragma Import (C, Main_Priority, "__gl_main_priority");
      Time_Slice_Value : Integer;
      pragma Import (C, Time_Slice_Value, "__gl_time_slice_val");
      WC_Encoding : Character;
      pragma Import (C, WC_Encoding, "__gl_wc_encoding");
      Locking_Policy : Character;
      pragma Import (C, Locking_Policy, "__gl_locking_policy");
      Queuing_Policy : Character;
      pragma Import (C, Queuing_Policy, "__gl_queuing_policy");
      Task_Dispatching_Policy : Character;
      pragma Import (C, Task_Dispatching_Policy, "__gl_task_dispatching_policy");
      Priority_Specific_Dispatching : System.Address;
      pragma Import (C, Priority_Specific_Dispatching, "__gl_priority_specific_dispatching");
      Num_Specific_Dispatching : Integer;
      pragma Import (C, Num_Specific_Dispatching, "__gl_num_specific_dispatching");
      Main_CPU : Integer;
      pragma Import (C, Main_CPU, "__gl_main_cpu");
      Interrupt_States : System.Address;
      pragma Import (C, Interrupt_States, "__gl_interrupt_states");
      Num_Interrupt_States : Integer;
      pragma Import (C, Num_Interrupt_States, "__gl_num_interrupt_states");
      Unreserve_All_Interrupts : Integer;
      pragma Import (C, Unreserve_All_Interrupts, "__gl_unreserve_all_interrupts");
      Detect_Blocking : Integer;
      pragma Import (C, Detect_Blocking, "__gl_detect_blocking");
      Default_Stack_Size : Integer;
      pragma Import (C, Default_Stack_Size, "__gl_default_stack_size");
      Default_Secondary_Stack_Size : System.Parameters.Size_Type;
      pragma Import (C, Default_Secondary_Stack_Size, "__gnat_default_ss_size");
      Bind_Env_Addr : System.Address;
      pragma Import (C, Bind_Env_Addr, "__gl_bind_env_addr");

      procedure Runtime_Initialize (Install_Handler : Integer);
      pragma Import (C, Runtime_Initialize, "__gnat_runtime_initialize");
      Binder_Sec_Stacks_Count : Natural;
      pragma Import (Ada, Binder_Sec_Stacks_Count, "__gnat_binder_ss_count");
      Default_Sized_SS_Pool : System.Address;
      pragma Import (Ada, Default_Sized_SS_Pool, "__gnat_default_ss_pool");

   begin
      if Is_Elaborated then
         return;
      end if;
      Is_Elaborated := True;
      Main_Priority := 0;
      Time_Slice_Value := 0;
      WC_Encoding := 'b';
      Locking_Policy := 'C';
      Queuing_Policy := ' ';
      Task_Dispatching_Policy := 'F';
      Priority_Specific_Dispatching :=
        Local_Priority_Specific_Dispatching'Address;
      Num_Specific_Dispatching := 0;
      Main_CPU := -1;
      Interrupt_States := Local_Interrupt_States'Address;
      Num_Interrupt_States := 0;
      Unreserve_All_Interrupts := 0;
      Detect_Blocking := 1;
      Default_Stack_Size := -1;

      ada_main'Elab_Body;
      Default_Secondary_Stack_Size := System.Parameters.Runtime_Default_Sec_Stack_Size;
      Binder_Sec_Stacks_Count := 4;
      Default_Sized_SS_Pool := Sec_Default_Sized_Stacks'Address;

      Runtime_Initialize (1);

      Ada.Strings.Text_Buffers'Elab_Spec;
      E005 := E005 + 1;
      System.Bb.Timing_Events'Elab_Spec;
      E072 := E072 + 1;
      Ada.Exceptions'Elab_Spec;
      System.Soft_Links'Elab_Spec;
      Ada.Tags'Elab_Body;
      E074 := E074 + 1;
      System.Exception_Table'Elab_Body;
      E042 := E042 + 1;
      E044 := E044 + 1;
      E012 := E012 + 1;
      Ada.Streams'Elab_Spec;
      E152 := E152 + 1;
      System.Finalization_Root'Elab_Spec;
      E159 := E159 + 1;
      Ada.Finalization'Elab_Spec;
      E157 := E157 + 1;
      System.Storage_Pools'Elab_Spec;
      E161 := E161 + 1;
      System.Finalization_Masters'Elab_Spec;
      System.Finalization_Masters'Elab_Body;
      E156 := E156 + 1;
      Ada.Real_Time'Elab_Body;
      E133 := E133 + 1;
      System.Pool_Global'Elab_Spec;
      E163 := E163 + 1;
      System.Tasking.Protected_Objects'Elab_Body;
      E234 := E234 + 1;
      System.Tasking.Restricted.Stages'Elab_Body;
      E236 := E236 + 1;
      HAL.GPIO'ELAB_SPEC;
      E154 := E154 + 1;
      HAL.I2C'ELAB_SPEC;
      E191 := E191 + 1;
      HAL.SPI'ELAB_SPEC;
      E184 := E184 + 1;
      HAL.UART'ELAB_SPEC;
      E195 := E195 + 1;
      Nrf.Gpio'Elab_Spec;
      Nrf.Gpio'Elab_Body;
      E149 := E149 + 1;
      E179 := E179 + 1;
      Nrf.Spi_Master'Elab_Spec;
      Nrf.Spi_Master'Elab_Body;
      E182 := E182 + 1;
      E209 := E209 + 1;
      E207 := E207 + 1;
      Nrf.Timers'Elab_Spec;
      Nrf.Timers'Elab_Body;
      E186 := E186 + 1;
      Nrf.Twi'Elab_Spec;
      Nrf.Twi'Elab_Body;
      E189 := E189 + 1;
      Nrf.Uart'Elab_Spec;
      Nrf.Uart'Elab_Body;
      E193 := E193 + 1;
      Nrf.Device'Elab_Spec;
      Nrf.Device'Elab_Body;
      E139 := E139 + 1;
      Microbit.Console'Elab_Body;
      E197 := E197 + 1;
      DFR0548'ELAB_SPEC;
      DFR0548'ELAB_BODY;
      E201 := E201 + 1;
      E203 := E203 + 1;
      Microbit.Motordriver'Elab_Body;
      E199 := E199 + 1;
      Microbit.Timehighspeed'Elab_Body;
      E205 := E205 + 1;
      E222 := E222 + 1;
      mycontroller_empty'elab_spec;
      Mycontroller_Empty'Elab_Body;
      E131 := E131 + 1;
   end adainit;

   procedure Ada_Main_Program;
   pragma Import (Ada, Ada_Main_Program, "_ada_main");

   procedure main is
      procedure Initialize (Addr : System.Address);
      pragma Import (C, Initialize, "__gnat_initialize");

      procedure Finalize;
      pragma Import (C, Finalize, "__gnat_finalize");
      SEH : aliased array (1 .. 2) of Integer;

      Ensure_Reference : aliased System.Address := Ada_Main_Program_Name'Address;
      pragma Volatile (Ensure_Reference);

   begin
      Initialize (SEH'Address);
      adainit;
      Ada_Main_Program;
      adafinal;
      Finalize;
   end;

--  BEGIN Object file/option list
   --   C:\usn\IntelligentRTSproject\Code\libs\Ada_Drivers_Library\examples\MicroBit_v2\ravenscar\Crash_E_tasking_final\obj\priorities.o
   --   C:\usn\IntelligentRTSproject\Code\libs\Ada_Drivers_Library\examples\MicroBit_v2\ravenscar\Crash_E_tasking_final\obj\mycontroller_empty.o
   --   C:\usn\IntelligentRTSproject\Code\libs\Ada_Drivers_Library\examples\MicroBit_v2\ravenscar\Crash_E_tasking_final\obj\main.o
   --   -LC:\usn\IntelligentRTSproject\Code\libs\Ada_Drivers_Library\examples\MicroBit_v2\ravenscar\Crash_E_tasking_final\obj\
   --   -LC:\usn\IntelligentRTSproject\Code\libs\Ada_Drivers_Library\examples\MicroBit_v2\ravenscar\Crash_E_tasking_final\obj\
   --   -LC:\usn\IntelligentRTSproject\Code\libs\Ada_Drivers_Library\boards\MicroBit_v2\obj\full_lib_Debug\
   --   -LC:\users\mgdsz\appdata\local\alire\cache\toolchains\gnat_arm_elf_14.1.3_184f9b28\arm-eabi\lib\gnat\embedded-nrf52833\adalib\
   --   -static
   --   -lgnarl
   --   -lgnat
--  END Object file/option list   

end ada_main;
