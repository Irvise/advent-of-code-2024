pragma Ada_2022;
pragma Check_Policy (Debug => On);

with Ada.Text_IO; use Ada.Text_IO; -- Used to read the input
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Text_IO.Unbounded_IO;
with GNAT.Spitbol;
with GNAT.Spitbol.Patterns;

procedure Main is
   -- Input data
   Input : File_Type;
   Input_Name : constant String := "input";
   
   use Ada.Text_IO.Unbounded_IO;
   use GNAT.Spitbol;
   use GNAT.Spitbol.Patterns;

   Input_Line : Unbounded_String;
            
   A_VStr, B_Vstr : VString;
   Digs : constant Pattern := Span("0123456789");
   Multiplicator_Pattern : constant Pattern := "mul(" & Digs ** A_VStr & ',' & Digs ** B_VStr & ')'; -- Please, read the documentation about GNAT.Spitbol.Patterns as found in g-spipat.ads
   
   -- Carry_Out : VString := "do()"
   -- Do_Or_Dont : Pattern := "do()" or "don't()";

   Accumulator : Natural := 0;
   A, B : Integer := 0;
 
begin
   -- Open the file
   Open (Input, In_File, Input_Name);
   
   while not End_Of_File (Input) loop
      Input_Line := Get_Line(Input);
      while Match (Input_Line, Multiplicator_Pattern, "") loop
         pragma Debug(Put_Line("Matched Values: A = " & A_VStr & " B = " & B_VStr));
         A := Integer'Value(To_String(A_VStr));
         B := Integer'Value(To_String(B_VStr));
         Accumulator := Accumulator + A * B;
      end loop;
   end loop;
   Put_Line("Result of accumulated multiplications: " & Accumulator'Image);
  
end Main;
