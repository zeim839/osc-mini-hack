LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY DDRMEM IS
   PORT ( CLK : IN  std_logic;
          IN0 : IN  std_logic_vector( 7 DOWNTO 0 );
          IN1 : IN  std_logic_vector( 7 DOWNTO 0 );
          IN2 : IN  std_logic_vector( 7 DOWNTO 0 );
          RST : IN  std_logic;
          Y0  : OUT std_logic_vector( 7 DOWNTO 0 );
          Y1  : OUT std_logic_vector( 7 DOWNTO 0 );
          Y2  : OUT std_logic_vector( 7 DOWNTO 0 );
          Y3  : OUT std_logic_vector( 7 DOWNTO 0 );
          Y4  : OUT std_logic_vector( 7 DOWNTO 0 ) );
END ENTITY DDRMEM;

ARCHITECTURE arc OF DDRMEM IS 

		-- Data register.
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

	-- When clock is low, IN0 is the instruction, IN0 and IN1 are
	-- data. On clock rise, write IN0 and IN1 to CELL_0 and CELL_1,
	-- respectively.
	CELL_0 : Reg
      GENERIC MAP ( invertClock => 0,
                    nrOfBits    => 8 )
      PORT MAP ( clock       => CLK,
                 clockEnable => '1',
                 d           => IN1(7 DOWNTO 0),
                 q           => Y0(7 DOWNTO 0),
                 reset       => RST,
                 tick        => '1' );
					  
	CELL_1 : Reg
      GENERIC MAP ( invertClock => 0,
                    nrOfBits    => 8 )
      PORT MAP ( clock       => CLK,
                 clockEnable => '1',
                 d           => IN2(7 DOWNTO 0),
                 q           => Y1(7 DOWNTO 0),
                 reset       => RST,
                 tick        => '1' );
	
	-- When clock is high, all inputs IN0 IN1 IN2 are data.
	-- Write to cells CELL_2, CELL_3, CELL_4.
	CELL_2 : Reg
      GENERIC MAP ( invertClock => 1,
                    nrOfBits    => 8 )
      PORT MAP ( clock       => CLK,
                 clockEnable => '1',
                 d           => IN0(7 DOWNTO 0),
                 q           => Y2(7 DOWNTO 0),
                 reset       => RST,
                 tick        => '1' );
					  
	CELL_3 : Reg
      GENERIC MAP ( invertClock => 1,
                    nrOfBits    => 8 )
      PORT MAP ( clock       => CLK,
                 clockEnable => '1',
                 d           => IN1(7 DOWNTO 0),
                 q           => Y3(7 DOWNTO 0),
                 reset       => RST,
                 tick        => '1' );
	
   CELL_4 : Reg
      GENERIC MAP ( invertClock => 1,
                    nrOfBits    => 8 )
      PORT MAP ( clock       => CLK,
                 clockEnable => '1',
                 d           => IN2(7 DOWNTO 0),
                 q           => Y4(7 DOWNTO 0),
                 reset       => RST,
                 tick        => '1' );

END arc;
