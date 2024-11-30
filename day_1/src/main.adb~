with Ada.Text_IO; use Ada.Text_IO; -- Used to read the input
with Ada.Strings.Bounded; -- Accumulate the string
with Ada.Strings.Fixed; use Ada.Strings.Fixed;
with Ada.Characters.Handling; use Ada.Characters.Handling;

procedure Main is
   -- Input data
   Input : File_Type;
   Input_Name : constant String := "input";

   -- Type to parse onto
   subtype Number_Char is Character range '0' .. '9';
   type Number_Letter is (zero, one, two, three, four, five, six, seven, eight, nine);

   -- String acumulator
   package B_String is new
     Ada.Strings.Bounded.Generic_Bounded_Length
       (Max => 50);
   use B_String;

   Simple_Line : Bounded_String;

   Accumulator : Natural := 0;

   function Clean_String (S: String) return String
   is
      Numeric_String : Bounded_String;
   begin
      Put_Line("Line read is: " & S);
      for I in S'Range loop

         -- Check for actual numeric values
         if S(I) in Number_Char then
            Append(Numeric_String, S(I));
         end if;

         -- Check for spelled numbers
         for J in Number_Letter loop
            -- Check that we are not trying to access over the length of the string
            if S'Length + 1 - I >= J'Image'Length then
               -- Put_Line("Checking substring " & S(I .. I + J'Image'Length - 1));
               if S(I .. I + J'Image'Length - 1) = To_Lower(J'Image) then
                  Put_Line("Checking substring " & S(I .. I + J'Image'Length - 1));
                  Put_Line("Match found!");
                  Put_Line("Appending" & Number_Letter'Pos(J)'Image);
                  -- Careful!!! 'Image adds an estra whitespace!!!!!!
                  Append(Numeric_String,
                         Trim(Number_Letter'Pos(J)'Image, Ada.Strings.Left));
               end if;
            end if;
         end loop;
      end loop;
      Put_Line("Numeric String is: " & To_String(Numeric_String));
      return To_String(Numeric_String);
   end;

   function Parse_String (S : String) return Integer
   is
      Cleaned_String : String := Clean_String(S);
      Result_String : String := Cleaned_String(Cleaned_String'First) & Cleaned_String(Cleaned_String'Last);
   begin
      return Integer'Value(Result_String);
   end;


begin
   -- Open the file
   Open (Input, In_File, Input_Name);

   while not End_Of_File (Input) loop
      -- Read line by line and extract the information
      -- Read Line
      Simple_Line := To_Bounded_String(Get_Line(Input));
      -- Parse line and accumulate
      Accumulator := Accumulator + Parse_String(To_String(Simple_Line));
   end loop;
   Put_Line("Accumulated result is: " & Accumulator'Image);
end Main;
