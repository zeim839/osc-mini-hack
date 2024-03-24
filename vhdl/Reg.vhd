LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY Reg IS
   GENERIC ( invertClock : INTEGER;
             nrOfBits    : INTEGER );
   PORT ( clock       : IN  std_logic;
          clockEnable : IN  std_logic;
          d           : IN  std_logic_vector( (nrOfBits - 1) DOWNTO 0 );
          reset       : IN  std_logic;
          tick        : IN  std_logic;
          q           : OUT std_logic_vector( (nrOfBits - 1) DOWNTO 0 ) );
END ENTITY Reg;

ARCHITECTURE arc OF Reg IS 

   SIGNAL s_clock        : std_logic;
   SIGNAL s_currentState : std_logic_vector( (nrOfBits - 1) DOWNTO 0 );

BEGIN

   q       <= s_currentState;
   s_clock <= clock WHEN invertClock = 0 ELSE NOT(clock);

   makeMemory : PROCESS(s_clock, reset, clockEnable, tick, d) IS
   BEGIN
      IF (reset = '1') THEN s_currentState <= (OTHERS => '0');
   ELSIF (rising_Edge(s_clock)) THEN
      IF (clockEnable = '1' AND tick = '1') THEN
         s_currentState <= d;
      END IF;
      END IF;
   END PROCESS makeMemory;

END arc;