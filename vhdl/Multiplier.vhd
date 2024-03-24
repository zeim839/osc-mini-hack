LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY Multiplier IS
   GENERIC ( calcBits           : INTEGER := 64;
             nrOfBits           : INTEGER := 32;
             unsignedMultiplier : INTEGER := 1);
   PORT ( carryIn  : IN  std_logic_vector( (nrOfBits - 1) DOWNTO 0 );
          inputA   : IN  std_logic_vector( (nrOfBits - 1) DOWNTO 0 );
          inputB   : IN  std_logic_vector( (nrOfBits - 1) DOWNTO 0 );
          multHigh : OUT std_logic_vector( (nrOfBits - 1) DOWNTO 0 );
          multLow  : OUT std_logic_vector( (nrOfBits - 1) DOWNTO 0 ) );
END ENTITY Multiplier;

ARCHITECTURE arc OF Multiplier IS 

   SIGNAL s_extendedcarryIn : std_logic_vector( (calcBits - 1) DOWNTO 0 );
   SIGNAL s_multResult      : std_logic_vector( (calcBits - 1) DOWNTO 0 );
   SIGNAL s_newResult       : std_logic_vector( (calcBits - 1) DOWNTO 0 );

BEGIN

   s_multResult <= std_logic_vector(unsigned(inputA)*unsigned(inputB))
                       WHEN unsignedMultiplier= 1 ELSE
                    std_logic_vector(signed(inputA)*signed(inputB));
   s_extendedcarryIn(calcBits-1 DOWNTO nrOfBits) <= (OTHERS => '0') WHEN unsignedMultiplier = 1 ELSE (OTHERS => carryIn(nrOfBits-1));
   s_extendedcarryIn(nrOfBits-1 DOWNTO 0) <= carryIn;
   s_newResult  <= std_logic_vector(unsigned(s_multResult) + unsigned(s_extendedcarryIn))
                       WHEN unsignedMultiplier= 1 ELSE
                    std_logic_vector(signed(s_multResult) + signed(s_extendedcarryIn));
   multHigh     <= s_newResult(calcBits-1 DOWNTO nrOfBits);
   multLow      <= s_newResult(nrOfBits-1 DOWNTO 0);

END arc;
