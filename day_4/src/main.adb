pragma Ada_2022;
pragma Check_Policy (Debug => On);

with Ada.Text_IO; use Ada.Text_IO; -- Used to read the input

procedure Main is
   -- Input data
   Input : File_Type;
   Input_Name : constant String := "input";
   
   type Directions is record
      X, Y : Integer;
   end record;
   type Search_Direction is (Up_Left, Up, Up_Right, Left, Right, Down_Left, Down, Down_Right);
   Lookup_XMAS : array (Search_Direction) of Directions := [
     Up_Left => (X => -1, Y => 1),
     Up => (X => 0, Y => 1),
     Up_Right => (X => 1, Y => 1),
     Left => (X => -1, Y => 0),
     Right => (X => 1, Y => 0),
     Down_Left => (X => -1, Y => -1),
     Down => (X => 0, Y => -1),
     Down_Right => (X => 1, Y => -1)];
   
   type Character_Matrix is array (Natural range <>, Natural range <>) of Character;
   XMAS : constant String := "XMAS";
   
   function Create_Character_Matrix(Parse_Input : in out File_Type) return Character_Matrix is
      Lines : Natural := 0;
      Columns : Natural := 0;
      Skip : String := "a";
   begin
      -- Find number of colums, find number of lines and then read the entire file into the output
      while not End_Of_Line (Parse_Input) loop
         Columns := Columns + 1;
         Get(Parse_Input, Skip);
      end loop;
      while not End_Of_File (Parse_Input) loop
         Lines := Lines + 1;
         Skip_Line(Parse_Input);
      end loop;
      pragma Debug (Put_Line("The file has " & Columns'Image & " columns"));
      pragma Debug (Put_Line("The file has " & Lines'Image & " lines"));
      Reset(Parse_Input);
      -- Dump file contents into a character array
      declare
         Input_Contents : Character_Matrix(0 .. Columns - 1, 0 .. Lines - 1);
      begin
         for I in Input_Contents'Range(1) loop
            for J in Input_Contents'Range(2) loop
               Get(Parse_Input, Input_Contents(I, J));
            end loop;
         end loop;
         return Input_Contents;
      end;
   end;
   
   function Valid_Number_XMAS(Input : Character_Matrix) return Natural is
      Valid_Count : Natural := 0;
      Counter : Natural := 0;
   begin
      -- Loop over all characters
      for I in Input'Range(1) loop
         for J in Input'Range(2) loop
            -- Loop over all directions (some will be invalid at the limits, so catch exceptions)
            for K of Lookup_XMAS loop
               -- Loop in each direction
               Counter := 0;
               for V in XMAS'First - 1 .. XMAS'Last - 1
               when
                 (I + V * K.X) in Input'Range(1) and then
                 (J + V * K.Y) in Input'Range(2)
               loop
                  exit when XMAS(V + 1) /= Input(I + V * K.X, J + V * K.Y);
                  pragma Debug (Put_Line("V = " & V'Image));
                  pragma Debug (Put_Line ("Checking position (" & I'Image & J'Image & "), direction " & K'Image & ": XMAS(V) = " & XMAS(V + 1) & " Input = " & Input(I + V * K.X, J + V * K.Y)));
                  Counter := Counter + 1;
                  if Counter = XMAS'Length then
                     Valid_Count := Valid_Count + 1;
                     pragma Debug (Put_Line ("Match found!"));
                  end if;
               end loop;
            end loop;
         end loop;
      end loop;
      return Valid_Count;
   end;
   
   Accumulator : Natural := 0;
 
begin
   -- Open the file
   Open (Input, In_File, Input_Name);
   declare
      Christmas_Input : Character_Matrix := Create_Character_Matrix(Input);
   begin
      pragma Debug (Put_Line ("File read: "));
      pragma Debug (Put_Line (Christmas_Input'Image));
      Accumulator := Valid_Number_XMAS(Christmas_Input);
   end;
   
   Put_Line ("Valid number of Christmas: " & Accumulator'Image);   
end Main;
