pragma Ada_2022;
pragma Check_Policy (Debug => On);

with Ada.Text_IO; use Ada.Text_IO; -- Used to read the input
with Ada.Containers.Vectors;

procedure Main is
   -- Input data
   Input : File_Type;
   Input_Name : constant String := "input";
   
   -- Number array
   package Report_Vector is new
     Ada.Containers.Vectors
     (Index_Type => Natural,
     Element_Type => Natural);
   package Report_Sorter is new Report_Vector.Generic_Sorting;
   
   type Rate_Of_Change is (Increasing, Decreasing);
   subtype Valid_Difference is Integer range 1 .. 3;

   function Valid_Report (Input : Report_Vector.Vector) return Boolean is
      Change : constant Rate_Of_Change := (if Input.First_Element - Input(Input.First_Index + 1) >= 0 then Increasing else Decreasing);
      Difference : Integer := 0;
   begin
      for Level in (Input.First_Index + 1) .. Input.Last_Index loop
         -- Minimum difference
         Difference := Input(Level - 1) - Input(Level);
         if not (abs(Difference) in Valid_Difference) then
            return False;
         end if;
         -- Always increasing or decreasing
         if Difference >= 0 and then Change = Decreasing then
            return False;
         elsif Difference < 0 and then Change = Increasing then
           return False;
         end if;
      end loop;
      return True;
   end Valid_Report;

   function Modified_Valid_Report (Input : Report_Vector.Vector) return Boolean is 
      -- Bruteforce algorithm
      Dampened_Input : Report_Vector.Vector;
   begin
      for I in Input.First_Index .. Input.Last_Index loop
         Dampened_Input := Input;
         Dampened_Input.Delete(I);
         if Valid_Report (Dampened_Input) then
            return True;
         end if;
      end loop;
      return False;
   end Modified_Valid_Report;

   procedure Read_Report (Parse_Input : File_Type; A : out Report_Vector.Vector) is
      package Int_IO is new Ada.Text_IO.Integer_IO(Natural); use Int_IO;
      Value : Integer := 0;
   begin
      while not End_Of_Line (Parse_Input) loop
         Get(File => Parse_Input, Item => Value);
         A.Append(Value);
      end loop;
      pragma Debug(Put_Line("Value of report read: " & A'Image));
   end;
   
   Accumulator : Natural := 0;
 
begin
   -- Open the file
   Open (Input, In_File, Input_Name);
   
   while not End_Of_File (Input) loop
      declare
         Report_Line_Readout : Report_Vector.Vector;
      begin
         Read_Report(Input, Report_Line_Readout);
         if Valid_Report (Report_Line_Readout) then
            Accumulator := Accumulator + 1;
         -- Delete this next if statement in order to get the first part solution
         elsif Modified_Valid_Report(Report_Line_Readout) then
            Accumulator := Accumulator + 1;
         end if;
         Skip_Line(Input);
      end;
   end loop;
   Put_Line ("Valid number of reports: " & Accumulator'Image);   
end Main;
