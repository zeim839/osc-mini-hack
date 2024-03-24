LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY SRLatch IS
   GENERIC ( invertClockEnable : INTEGER );
   PORT ( clock  : IN  std_logic;
          preset : IN  std_logic;
          r      : IN  std_logic;
          reset  : IN  std_logic;
          s      : IN  std_logic;
          tick   : IN  std_logic;
          q      : OUT std_logic;
          qBar   : OUT std_logic );
END ENTITY SRLatch;

ARCHITECTURE arc OF SRLatch IS 

   SIGNAL s_clock        : std_logic;
   SIGNAL s_currentState : std_logic;
   SIGNAL s_nextState    : std_logic;

BEGIN

   q           <= s_currentState;
   qBar        <=  NOT (s_currentState);
   s_clock     <= clock WHEN invertClockEnable = 0 ELSE NOT(clock);
   s_nextState <= (s_currentState OR s) AND  NOT (r);
	
   makeMemory : PROCESS( s_clock , reset , preset , tick , s_nextState ) IS
   BEGIN
      IF (reset = '1') THEN s_currentState <= '0';
      ELSIF (preset = '1') THEN s_currentState <= '1';
      ELSIF (rising_edge(s_clock)) THEN
         IF (tick = '1') THEN
            s_currentState <= s_nextState;
         END IF;
      END IF;
   END PROCESS makeMemory;

END arc;