pragma Ada_2022;
pragma Check_Policy (Debug => On);

with Ada.Text_IO; use Ada.Text_IO; -- Used to read the input
with Ada.Containers.Vectors;

procedure Main is
   -- Input data
   Input : File_Type;
   Input_Name : constant String := "input";
   
   -- Number array
   package Location_Vector is new
     Ada.Containers.Vectors
     (Index_Type => Natural,
     Element_Type => Natural);
   package Location_Sorter is new Location_Vector.Generic_Sorting;

   procedure Read_Two_Lists (Parse_Input : File_Type; A, B : out Location_Vector.Vector) is
      package Int_IO is new Ada.Text_IO.Integer_IO(Natural); use Int_IO;
      Value : Natural;
   begin
      while not End_Of_File (Parse_Input) loop
         Get(File => Parse_Input, Item => Value);
         pragma Debug(Put_Line ("Read 1st number: " & Value'Image));
         A.Append(Value);
         Get(File => Parse_Input, Item => Value);
         pragma Debug (Put_Line ("Read 2nd number: " & Value'Image));
         B.Append(Value);
      end loop;
   end;
   
   First_Location_Vector : Location_Vector.Vector;
   Second_Location_Vector : Location_Vector.Vector;
   Difference_Location_Vector : Location_Vector.Vector;
   Accumulator : Natural := 0;
   Occurrences : Natural := 0;
   Similarity : Natural := 0;
begin
   -- Open the file
   Open (Input, In_File, Input_Name);
   Read_Two_Lists(Input, First_Location_Vector, Second_Location_Vector);
   Location_Sorter.Sort (First_Location_Vector);
   Location_Sorter.Sort (Second_Location_Vector);
   pragma Debug (Put_Line ("First Vector"));
   pragma Debug (Put(First_Location_Vector'Image));
   pragma Debug (Put_Line ("Second Vector"));
   pragma Debug (Put(Second_Location_Vector'Image));
   
   -- Fisrt part of the puzzle, calculate distance
   for I in First_Location_Vector.First_Index .. First_Location_Vector.Last_Index loop
      Accumulator := Accumulator + abs (First_Location_Vector(I) - Second_Location_Vector(I));
      pragma Debug (Put_Line("Value of accumulator: " & Accumulator'Image));
   end loop;
   Put_Line("Accumulated distance: " & Accumulator'Image);
   
   -- Second part of the puzzle, calculate similarity
   -- we do not take advantage of the fact that the vectors are sorted...
   for Val_1 of First_Location_Vector loop
      Occurrences := 0;
      for Val_2 of Second_Location_Vector loop
         if Val_1 = Val_2 then
            Occurrences := Occurrences + 1;
         end if;
      end loop;
      Similarity := Similarity + Occurrences * Val_1;
   end loop;
   Put_Line("Similarity score: " & Similarity'Image);
      
end Main;
