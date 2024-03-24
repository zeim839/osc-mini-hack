LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY main IS
   PORT ( CLK : IN  std_logic;
          IN0 : IN  std_logic_vector( 7 DOWNTO 0 );
          IN1 : IN  std_logic_vector( 7 DOWNTO 0 );
          IN2 : IN  std_logic_vector( 7 DOWNTO 0 );
          Y   : OUT std_logic_vector( 7 DOWNTO 0 ) );
END ENTITY main;

ARCHITECTURE arc OF main IS

      COMPONENT CTRL
         PORT ( CLK    : IN  std_logic;
                D0     : IN  std_logic_vector( 7 DOWNTO 0 );
                DDRCLK : OUT std_logic;
                MEMCLK : OUT std_logic;
                RST    : OUT std_logic );
      END COMPONENT;

      COMPONENT DDRMEM
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
      END COMPONENT;

      COMPONENT GEMV0
         PORT ( A0 : IN  std_logic_vector( 7 DOWNTO 0 );
                A1 : IN  std_logic_vector( 7 DOWNTO 0 );
                A2 : IN  std_logic_vector( 7 DOWNTO 0 );
                A3 : IN  std_logic_vector( 7 DOWNTO 0 );
                A4 : IN  std_logic_vector( 7 DOWNTO 0 );
                M0 : IN  std_logic_vector( 7 DOWNTO 0 );
                M1 : IN  std_logic_vector( 7 DOWNTO 0 );
                M2 : IN  std_logic_vector( 7 DOWNTO 0 );
                M3 : IN  std_logic_vector( 7 DOWNTO 0 );
                M4 : IN  std_logic_vector( 7 DOWNTO 0 );
                Y  : OUT std_logic_vector( 31 DOWNTO 0 ) );
      END COMPONENT;

      COMPONENT VMEM
         PORT ( CLK : IN  std_logic;
                IN0 : IN  std_logic_vector( 7 DOWNTO 0 );
                IN1 : IN  std_logic_vector( 7 DOWNTO 0 );
                RST : IN  std_logic;
                Y0  : OUT std_logic_vector( 7 DOWNTO 0 );
                Y1  : OUT std_logic_vector( 7 DOWNTO 0 ) );
      END COMPONENT;

		-- DDRMEM clock.
		SIGNAL s_ddrclk : std_logic;

		-- VMEM clock.
		SIGNAL s_memclk : std_logic;

		-- Reset signal.
		SIGNAL s_reset : std_logic;

		-- Intermediate.
		SIGNAL s_weight0 : std_logic_vector( 7 DOWNTO 0);
		SIGNAL s_weight1 : std_logic_vector( 7 DOWNTO 0);
		SIGNAL s_weight2 : std_logic_vector( 7 DOWNTO 0);
		SIGNAL s_weight3 : std_logic_vector( 7 DOWNTO 0);
		SIGNAL s_weight4 : std_logic_vector( 7 DOWNTO 0);

		SIGNAL s_op0 : std_logic_vector(7 DOWNTO 0);
		SIGNAL s_op1 : std_logic_vector(7 DOWNTO 0);

		-- GEMV Sum of products.
		SIGNAL s_sum : std_logic_vector(31 DOWNTO 0);

BEGIN

	-- Quantize sum of products to 8-bit.
	Y <= x"7F" WHEN (s_sum > x"7F" and s_sum < x"80000000")
		ELSE x"80" WHEN (s_sum > x"80000000" and s_sum < x"FFFFFF80")
		ELSE s_sum(7 DOWNTO 0);

   CTRL_1 : CTRL
      PORT MAP ( CLK    => CLK,
                 D0     => IN0( 7 DOWNTO 0),
                 DDRCLK => s_ddrclk,
                 MEMCLK => s_memclk,
                 RST    => s_reset );

   WDDR_1 : DDRMEM
      PORT MAP ( CLK => s_ddrclk,
                 IN0 => IN0( 7 DOWNTO 0),
                 IN1 => IN1( 7 DOWNTO 0),
                 IN2 => IN2( 7 DOWNTO 0),
                 RST => s_reset,
                 Y0  => s_weight0( 7 DOWNTO 0),
                 Y1  => s_weight1( 7 DOWNTO 0),
                 Y2  => s_weight2( 7 DOWNTO 0),
                 Y3  => s_weight3( 7 DOWNTO 0),
                 Y4  => s_weight4( 7 DOWNTO 0) );

   GEMV0_1 : GEMV0
      PORT MAP ( A0 => s_weight0( 7 DOWNTO 0),
                 A1 => s_weight1( 7 DOWNTO 0),
                 A2 => s_weight2( 7 DOWNTO 0),
                 A3 => s_weight3( 7 DOWNTO 0),
                 A4 => s_weight4( 7 DOWNTO 0),
                 M0 => s_op0(7 DOWNTO 0),
                 M1 => s_op1(7 DOWNTO 0),
                 M2 => IN0(7 DOWNTO 0),
                 M3 => IN1(7 DOWNTO 0),
                 M4 => IN2(7 DOWNTO 0),
                 Y  => s_sum(31 DOWNTO 0) );

   VMEM_1 : VMEM
      PORT MAP ( CLK => s_memclk,
                 IN0 => IN1(7 DOWNTO 0),
                 IN1 => IN2(7 DOWNTO 0),
                 RST => s_reset,
                 Y0  => s_op0(7 DOWNTO 0),
                 Y1  => s_op1(7 DOWNTO 0) );

END arc;
