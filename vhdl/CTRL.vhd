LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

-- CTRL decodes instructions, routes data buses, and handles
-- the VMEM and DDRMEM clocks.
ENTITY CTRL IS
   PORT ( CLK    : IN  std_logic;
          D0     : IN  std_logic_vector( 7 DOWNTO 0 );
          DDRCLK : OUT std_logic;
          MEMCLK : OUT std_logic;
          RST    : OUT std_logic );
END ENTITY CTRL;

ARCHITECTURE arc OF CTRL IS 

      COMPONENT ANDGate
         GENERIC ( BubblesMask : std_logic_vector );
         PORT ( input1 : IN  std_logic;
                input2 : IN  std_logic;
                result : OUT std_logic );
      END COMPONENT;

      COMPONENT SRLatch
         GENERIC ( invertClockEnable : INTEGER );
         PORT ( clock  : IN  std_logic;
                preset : IN  std_logic;
                r      : IN  std_logic;
                reset  : IN  std_logic;
                s      : IN  std_logic;
                tick   : IN  std_logic;
                q      : OUT std_logic;
                qBar   : OUT std_logic );
      END COMPONENT;

      COMPONENT ANDGateX3
         GENERIC ( BubblesMask : std_logic_vector );
         PORT ( input1 : IN  std_logic;
                input2 : IN  std_logic;
                input3 : IN  std_logic;
                result : OUT std_logic );
      END COMPONENT;
	
	SIGNAL s_ddrCount   : std_logic;
	SIGNAL s_ddrMemRst  : std_logic;
	SIGNAL s_execCount  : std_logic;
	SIGNAL s_execMemRst : std_logic;
	
	SIGNAL s_ddrclk : std_logic;
	SIGNAL s_memclk : std_logic;

BEGIN

	-- Pipe output.
	DDRCLK <= s_ddrclk;
	MEMCLK <= s_memclk;

	-- RST instruction.
	DECODE_RST : ANDGateX3
      GENERIC MAP ( BubblesMask => "111" )
      PORT MAP ( input1 => CLK,
                 input2 => D0(0),
                 input3 => D0(1),
                 result => RST );
	
	-- LOAD instruction.
	DECODE_LOAD : ANDGateX3
      GENERIC MAP ( BubblesMask => "110" )
      PORT MAP ( input1 => D0(0),
                 input2 => CLK,
                 input3 => D0(1),
                 result => s_ddrclk );
	
	MEMORY_LOAD : SRLatch
      GENERIC MAP ( invertClockEnable => 0 )
      PORT MAP ( clock  => s_ddrclk,
                 preset => '0',
                 q      => s_ddrCount,
                 qBar   => OPEN,
                 r      => '0',
                 reset  => s_ddrMemRst,
                 s      => '1',
                 tick   => '1' );
					  
	GATE_LOAD : ANDGate
      GENERIC MAP ( BubblesMask => "00" )
      PORT MAP ( input1 => s_ddrCount,
                 input2 => CLK,
                 result => s_ddrMemRst );
					  
	-- EXEC instruction.
	DECODE_EXEC : ANDGateX3
      GENERIC MAP ( BubblesMask => "001" )
      PORT MAP ( input1 => D0(0),
                 input2 => D0(1),
                 input3 => CLK,
                 result => s_memclk );
	
	MEMORY_EXEC : SRLatch
      GENERIC MAP ( invertClockEnable => 0 )
      PORT MAP ( clock  => s_memclk,
                 preset => '0',
                 q      => s_execCount,
                 qBar   => OPEN,
                 r      => '0',
                 reset  => s_execMemRst,
                 s      => '1',
                 tick   => '1' );

   GATES_EXEC : ANDGate
      GENERIC MAP ( BubblesMask => "00" )
      PORT MAP ( input1 => s_execCount,
                 input2 => CLK,
                 result => s_execMemRst );
 
END arc;
