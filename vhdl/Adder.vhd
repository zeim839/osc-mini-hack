LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY Adder IS
   GENERIC ( extendedBits : INTEGER := 33;
             nrOfBits     : INTEGER := 32);
   PORT ( carryIn  : IN  std_logic;
          dataA    : IN  std_logic_vector( (nrOfBits - 1) DOWNTO 0 );
          dataB    : IN  std_logic_vector( (nrOfBits - 1) DOWNTO 0 );
          carryOut : OUT std_logic;
          result   : OUT std_logic_vector( (nrOfBits - 1) DOWNTO 0 ) );
END ENTITY Adder;

ARCHITECTURE arc OF Adder IS 

   SIGNAL s_extendedDataA : std_logic_vector( (extendedBits - 1) DOWNTO 0 );
   SIGNAL s_extendedDataB : std_logic_vector( (extendedBits - 1) DOWNTO 0 );
   SIGNAL s_sumResult     : std_logic_vector( (extendedBits - 1) DOWNTO 0 );

BEGIN

   s_extendedDataA <= "0"&dataA;
   s_extendedDataB <= "0"&dataB;
   s_sumResult     <= std_logic_vector(unsigned(s_extendedDataA) +
                                        unsigned(s_extendedDataB) +
                                        (""&carryIn));

   result   <= s_sumResult( (nrOfBits-1) DOWNTO 0 );
   carryOut <= s_sumResult(extendedBits-1);

END arc;