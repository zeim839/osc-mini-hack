LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY VMEM IS
   PORT ( CLK : IN  std_logic;
          IN0 : IN  std_logic_vector( 7 DOWNTO 0 );
          IN1 : IN  std_logic_vector( 7 DOWNTO 0 );
          RST : IN  std_logic;
          Y0  : OUT std_logic_vector( 7 DOWNTO 0 );
          Y1  : OUT std_logic_vector( 7 DOWNTO 0 ) );
END ENTITY VMEM;

-- The GEMV instruction is read while clock is low. The first
-- data bus is the instruction and the following 2 buses are the
-- first two operands. When the clock turns high, the rest of the
-- operands are written. The purpose of VMEM is to temporarily store
-- the first two memory operands (from low clock).
ARCHITECTURE arc OF VMEM IS 

      COMPONENT Reg
         GENERIC ( invertClock : INTEGER;
                   nrOfBits    : INTEGER );
         PORT ( clock       : IN  std_logic;
                clockEnable : IN  std_logic;
                d           : IN  std_logic_vector( (nrOfBits - 1) DOWNTO 0 );
                reset       : IN  std_logic;
                tick        : IN  std_logic;
                q           : OUT std_logic_vector( (nrOfBits - 1) DOWNTO 0 ) );
      END COMPONENT;

BEGIN

   MEMORY_1 : Reg
      GENERIC MAP ( invertClock => 0,
                    nrOfBits    => 8 )
      PORT MAP ( clock       => CLK,
                 clockEnable => '1',
                 d           => IN0(7 DOWNTO 0),
                 q           => Y0(7 DOWNTO 0),
                 reset       => RST,
                 tick        => '1' );

   MEMORY_2 : Reg
      GENERIC MAP ( invertClock => 0,
                    nrOfBits    => 8 )
      PORT MAP ( clock       => CLK,
                 clockEnable => '1',
                 d           => IN1(7 DOWNTO 0),
                 q           => Y1(7 DOWNTO 0),
                 reset       => RST,
                 tick        => '1' );

END arc;