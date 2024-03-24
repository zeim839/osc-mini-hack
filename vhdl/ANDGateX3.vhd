LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY ANDGateX3 IS
   GENERIC ( BubblesMask : std_logic_vector );
   PORT ( input1 : IN  std_logic;
          input2 : IN  std_logic;
          input3 : IN  std_logic;
          result : OUT std_logic );
END ENTITY ANDGateX3;

ARCHITECTURE arc OF ANDGateX3 IS 

   SIGNAL s_realInput1 : std_logic;
   SIGNAL s_realInput2 : std_logic;
   SIGNAL s_realInput3 : std_logic;

BEGIN

   s_realInput1 <= input1 WHEN BubblesMask(0) = '0' ELSE NOT(input1);
   s_realInput2 <= input2 WHEN BubblesMask(1) = '0' ELSE NOT(input2);
   s_realInput3 <= input3 WHEN BubblesMask(2) = '0' ELSE NOT(input3);

   result <= s_realInput1 AND 
             s_realInput2 AND 
             s_realInput3;

END arc;
