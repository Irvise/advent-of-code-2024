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

begin
   -- Open the file
   Open (Input, In_File, Input_Name);

   while not End_Of_File (Input) loop
      null;
   end loop;

end Main;
