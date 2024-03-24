LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY ANDGate IS
   GENERIC ( BubblesMask : std_logic_vector );
   PORT ( input1 : IN  std_logic;
          input2 : IN  std_logic;
          result : OUT std_logic );
END ENTITY ANDGate;

ARCHITECTURE platformIndependent OF ANDGate IS 

   SIGNAL s_realInput1 : std_logic;
   SIGNAL s_realInput2 : std_logic;

BEGIN

   s_realInput1 <= input1 WHEN BubblesMask(0) = '0' ELSE NOT(input1);
   s_realInput2 <= input2 WHEN BubblesMask(1) = '0' ELSE NOT(input2);

   result <= s_realInput1 AND 
             s_realInput2;

END platformIndependent;