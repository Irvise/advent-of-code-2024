pragma Ada_2022;
pragma Check_Policy (Debug => On);

with Ada.Text_IO; use Ada.Text_IO; -- Used to read the input
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Text_IO.Unbounded_IO;
with GNAT.Spitbol;
with GNAT.Spitbol.Patterns;
with Ada.Strings.Maps.Constants;

procedure Main is
   -- Input data
   Input : File_Type;
   Input_Name : constant String := "input";
   
   use Ada.Text_IO.Unbounded_IO;
   use GNAT.Spitbol;
   use GNAT.Spitbol.Patterns;
   use Ada.Strings.Maps.Constants;

   Input_Line : Unbounded_String;
            
   A_VStr, B_Vstr : VString;
   Digs : constant Pattern := Span("0123456789");
   Multiplicator_Pattern : constant Pattern := "mul(" & Digs ** A_VStr & ',' & Digs ** B_VStr & ')';
   -- Please, read the documentation about GNAT.Spitbol.Patterns as found in g-spipat.ads
   
   -- Do_Or_Dont : Pattern := "don't()" & NSpan(Graphic_Set) & "do()" or Any(Control_Set);
   Eliminated_Content : VString;
   Do_Termination : Pattern := Arbno(Any(Graphic_Set)) ** Eliminated_Content & "do()";
   Do_Or_Dont : Pattern := "don't()" & Do_Termination; --  Any(Graphic_Set) ** Eliminated_Content ;
 
   Accumulator : Natural := 0;
   A, B : Integer := 0;
 
begin
   -- Open the file
   Open (Input, In_File, Input_Name);
   
   while not End_Of_File (Input) loop
      Input_Line := Get_Line(Input);
      -- Clean Input Line from don't()s and the data between it and do()s
      while Match(Input_Line, Do_Or_Dont, "") loop
         -- pragma Debug(Put_Line("Eliminated content: " & Eliminated_Content'Image));
         null;
      end loop;
      
      -- We may have a don't() which is not terminated by a do(), the line just ends, we need to clean those too
      while Match(Input_Line, "don't()" & Rest ** Eliminated_Content, "") loop
         pragma Debug(Put_Line("Eliminated content final: " & Eliminated_Content'Image));
         null;
      end loop;
      
      pragma Debug (New_Line);
      pragma Debug (Put_Line("Cleaned Line is: " & Input_Line'Image));
      pragma Debug (New_Line);
      
      while Match (Input_Line, Multiplicator_Pattern, "") loop
         -- pragma Debug(Put_Line("Matched Values: A = " & A_VStr & " B = " & B_VStr));
         A := Integer'Value(To_String(A_VStr));
         B := Integer'Value(To_String(B_VStr));
         Accumulator := Accumulator + A * B;
      end loop;
   end loop;
   Put_Line("Result of accumulated multiplications: " & Accumulator'Image);
  
end Main;
