LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY GEMV0 IS
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
END ENTITY GEMV0;

ARCHITECTURE arc OF GEMV0 IS 

      COMPONENT Multiplier
         GENERIC ( calcBits           : INTEGER;
                   nrOfBits           : INTEGER;
                   unsignedMultiplier : INTEGER );
         PORT ( carryIn  : IN  std_logic_vector( (nrOfBits - 1) DOWNTO 0 );
                inputA   : IN  std_logic_vector( (nrOfBits - 1) DOWNTO 0 );
                inputB   : IN  std_logic_vector( (nrOfBits - 1) DOWNTO 0 );
                multHigh : OUT std_logic_vector( (nrOfBits - 1) DOWNTO 0 );
                multLow  : OUT std_logic_vector( (nrOfBits - 1) DOWNTO 0 ) );
      END COMPONENT;

      COMPONENT Adder
         GENERIC ( extendedBits : INTEGER;
                   nrOfBits     : INTEGER );
         PORT ( carryIn  : IN  std_logic;
                dataA    : IN  std_logic_vector( (nrOfBits - 1) DOWNTO 0 );
                dataB    : IN  std_logic_vector( (nrOfBits - 1) DOWNTO 0 );
                carryOut : OUT std_logic;
                result   : OUT std_logic_vector( (nrOfBits - 1) DOWNTO 0 ) );
      END COMPONENT;

--------------------------------------------------------------------------------
-- All used signals are defined here                                          --
--------------------------------------------------------------------------------
   SIGNAL s_logisimBus0  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus1  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus10 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus11 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus12 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus13 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus14 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus15 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus16 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus17 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus18 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus19 : std_logic_vector( 7 DOWNTO 0 );
   SIGNAL s_logisimBus2  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus20 : std_logic_vector( 7 DOWNTO 0 );
   SIGNAL s_logisimBus21 : std_logic_vector( 7 DOWNTO 0 );
   SIGNAL s_logisimBus22 : std_logic_vector( 7 DOWNTO 0 );
   SIGNAL s_logisimBus23 : std_logic_vector( 7 DOWNTO 0 );
   SIGNAL s_logisimBus24 : std_logic_vector( 7 DOWNTO 0 );
   SIGNAL s_logisimBus25 : std_logic_vector( 7 DOWNTO 0 );
   SIGNAL s_logisimBus26 : std_logic_vector( 7 DOWNTO 0 );
   SIGNAL s_logisimBus27 : std_logic_vector( 7 DOWNTO 0 );
   SIGNAL s_logisimBus28 : std_logic_vector( 7 DOWNTO 0 );
   SIGNAL s_logisimBus3  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus4  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus5  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus6  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus7  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus8  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus9  : std_logic_vector( 31 DOWNTO 0 );

BEGIN

   --------------------------------------------------------------------------------
   -- Here all input connections are defined                                     --
   --------------------------------------------------------------------------------
   s_logisimBus19(7 DOWNTO 0) <= M0;
   s_logisimBus20(7 DOWNTO 0) <= M1;
   s_logisimBus21(7 DOWNTO 0) <= M2;
   s_logisimBus22(7 DOWNTO 0) <= M3;
   s_logisimBus23(7 DOWNTO 0) <= M4;
   s_logisimBus24(7 DOWNTO 0) <= A0;
   s_logisimBus25(7 DOWNTO 0) <= A1;
   s_logisimBus26(7 DOWNTO 0) <= A2;
   s_logisimBus27(7 DOWNTO 0) <= A3;
   s_logisimBus28(7 DOWNTO 0) <= A4;

   --------------------------------------------------------------------------------
   -- Here all output connections are defined                                    --
   --------------------------------------------------------------------------------
   Y <= s_logisimBus5(31 DOWNTO 0);

   --------------------------------------------------------------------------------
   -- Here all in-lined components are defined                                   --
   --------------------------------------------------------------------------------

   -- Bit Extender
    s_logisimBus1(0)  <=  s_logisimBus19(0);
    s_logisimBus1(1)  <=  s_logisimBus19(1);
    s_logisimBus1(2)  <=  s_logisimBus19(2);
    s_logisimBus1(3)  <=  s_logisimBus19(3);
    s_logisimBus1(4)  <=  s_logisimBus19(4);
    s_logisimBus1(5)  <=  s_logisimBus19(5);
    s_logisimBus1(6)  <=  s_logisimBus19(6);
    s_logisimBus1(7)  <=  s_logisimBus19(7);
    s_logisimBus1(8)  <=  s_logisimBus19(7);
    s_logisimBus1(9)  <=  s_logisimBus19(7);
    s_logisimBus1(10)  <=  s_logisimBus19(7);
    s_logisimBus1(11)  <=  s_logisimBus19(7);
    s_logisimBus1(12)  <=  s_logisimBus19(7);
    s_logisimBus1(13)  <=  s_logisimBus19(7);
    s_logisimBus1(14)  <=  s_logisimBus19(7);
    s_logisimBus1(15)  <=  s_logisimBus19(7);
    s_logisimBus1(16)  <=  s_logisimBus19(7);
    s_logisimBus1(17)  <=  s_logisimBus19(7);
    s_logisimBus1(18)  <=  s_logisimBus19(7);
    s_logisimBus1(19)  <=  s_logisimBus19(7);
    s_logisimBus1(20)  <=  s_logisimBus19(7);
    s_logisimBus1(21)  <=  s_logisimBus19(7);
    s_logisimBus1(22)  <=  s_logisimBus19(7);
    s_logisimBus1(23)  <=  s_logisimBus19(7);
    s_logisimBus1(24)  <=  s_logisimBus19(7);
    s_logisimBus1(25)  <=  s_logisimBus19(7);
    s_logisimBus1(26)  <=  s_logisimBus19(7);
    s_logisimBus1(27)  <=  s_logisimBus19(7);
    s_logisimBus1(28)  <=  s_logisimBus19(7);
    s_logisimBus1(29)  <=  s_logisimBus19(7);
    s_logisimBus1(30)  <=  s_logisimBus19(7);
    s_logisimBus1(31)  <=  s_logisimBus19(7);


   -- Bit Extender
    s_logisimBus15(0)  <=  s_logisimBus24(0);
    s_logisimBus15(1)  <=  s_logisimBus24(1);
    s_logisimBus15(2)  <=  s_logisimBus24(2);
    s_logisimBus15(3)  <=  s_logisimBus24(3);
    s_logisimBus15(4)  <=  s_logisimBus24(4);
    s_logisimBus15(5)  <=  s_logisimBus24(5);
    s_logisimBus15(6)  <=  s_logisimBus24(6);
    s_logisimBus15(7)  <=  s_logisimBus24(7);
    s_logisimBus15(8)  <=  s_logisimBus24(7);
    s_logisimBus15(9)  <=  s_logisimBus24(7);
    s_logisimBus15(10)  <=  s_logisimBus24(7);
    s_logisimBus15(11)  <=  s_logisimBus24(7);
    s_logisimBus15(12)  <=  s_logisimBus24(7);
    s_logisimBus15(13)  <=  s_logisimBus24(7);
    s_logisimBus15(14)  <=  s_logisimBus24(7);
    s_logisimBus15(15)  <=  s_logisimBus24(7);
    s_logisimBus15(16)  <=  s_logisimBus24(7);
    s_logisimBus15(17)  <=  s_logisimBus24(7);
    s_logisimBus15(18)  <=  s_logisimBus24(7);
    s_logisimBus15(19)  <=  s_logisimBus24(7);
    s_logisimBus15(20)  <=  s_logisimBus24(7);
    s_logisimBus15(21)  <=  s_logisimBus24(7);
    s_logisimBus15(22)  <=  s_logisimBus24(7);
    s_logisimBus15(23)  <=  s_logisimBus24(7);
    s_logisimBus15(24)  <=  s_logisimBus24(7);
    s_logisimBus15(25)  <=  s_logisimBus24(7);
    s_logisimBus15(26)  <=  s_logisimBus24(7);
    s_logisimBus15(27)  <=  s_logisimBus24(7);
    s_logisimBus15(28)  <=  s_logisimBus24(7);
    s_logisimBus15(29)  <=  s_logisimBus24(7);
    s_logisimBus15(30)  <=  s_logisimBus24(7);
    s_logisimBus15(31)  <=  s_logisimBus24(7);


   -- Bit Extender
    s_logisimBus9(0)  <=  s_logisimBus20(0);
    s_logisimBus9(1)  <=  s_logisimBus20(1);
    s_logisimBus9(2)  <=  s_logisimBus20(2);
    s_logisimBus9(3)  <=  s_logisimBus20(3);
    s_logisimBus9(4)  <=  s_logisimBus20(4);
    s_logisimBus9(5)  <=  s_logisimBus20(5);
    s_logisimBus9(6)  <=  s_logisimBus20(6);
    s_logisimBus9(7)  <=  s_logisimBus20(7);
    s_logisimBus9(8)  <=  s_logisimBus20(7);
    s_logisimBus9(9)  <=  s_logisimBus20(7);
    s_logisimBus9(10)  <=  s_logisimBus20(7);
    s_logisimBus9(11)  <=  s_logisimBus20(7);
    s_logisimBus9(12)  <=  s_logisimBus20(7);
    s_logisimBus9(13)  <=  s_logisimBus20(7);
    s_logisimBus9(14)  <=  s_logisimBus20(7);
    s_logisimBus9(15)  <=  s_logisimBus20(7);
    s_logisimBus9(16)  <=  s_logisimBus20(7);
    s_logisimBus9(17)  <=  s_logisimBus20(7);
    s_logisimBus9(18)  <=  s_logisimBus20(7);
    s_logisimBus9(19)  <=  s_logisimBus20(7);
    s_logisimBus9(20)  <=  s_logisimBus20(7);
    s_logisimBus9(21)  <=  s_logisimBus20(7);
    s_logisimBus9(22)  <=  s_logisimBus20(7);
    s_logisimBus9(23)  <=  s_logisimBus20(7);
    s_logisimBus9(24)  <=  s_logisimBus20(7);
    s_logisimBus9(25)  <=  s_logisimBus20(7);
    s_logisimBus9(26)  <=  s_logisimBus20(7);
    s_logisimBus9(27)  <=  s_logisimBus20(7);
    s_logisimBus9(28)  <=  s_logisimBus20(7);
    s_logisimBus9(29)  <=  s_logisimBus20(7);
    s_logisimBus9(30)  <=  s_logisimBus20(7);
    s_logisimBus9(31)  <=  s_logisimBus20(7);


   -- Bit Extender
    s_logisimBus0(0)  <=  s_logisimBus25(0);
    s_logisimBus0(1)  <=  s_logisimBus25(1);
    s_logisimBus0(2)  <=  s_logisimBus25(2);
    s_logisimBus0(3)  <=  s_logisimBus25(3);
    s_logisimBus0(4)  <=  s_logisimBus25(4);
    s_logisimBus0(5)  <=  s_logisimBus25(5);
    s_logisimBus0(6)  <=  s_logisimBus25(6);
    s_logisimBus0(7)  <=  s_logisimBus25(7);
    s_logisimBus0(8)  <=  s_logisimBus25(7);
    s_logisimBus0(9)  <=  s_logisimBus25(7);
    s_logisimBus0(10)  <=  s_logisimBus25(7);
    s_logisimBus0(11)  <=  s_logisimBus25(7);
    s_logisimBus0(12)  <=  s_logisimBus25(7);
    s_logisimBus0(13)  <=  s_logisimBus25(7);
    s_logisimBus0(14)  <=  s_logisimBus25(7);
    s_logisimBus0(15)  <=  s_logisimBus25(7);
    s_logisimBus0(16)  <=  s_logisimBus25(7);
    s_logisimBus0(17)  <=  s_logisimBus25(7);
    s_logisimBus0(18)  <=  s_logisimBus25(7);
    s_logisimBus0(19)  <=  s_logisimBus25(7);
    s_logisimBus0(20)  <=  s_logisimBus25(7);
    s_logisimBus0(21)  <=  s_logisimBus25(7);
    s_logisimBus0(22)  <=  s_logisimBus25(7);
    s_logisimBus0(23)  <=  s_logisimBus25(7);
    s_logisimBus0(24)  <=  s_logisimBus25(7);
    s_logisimBus0(25)  <=  s_logisimBus25(7);
    s_logisimBus0(26)  <=  s_logisimBus25(7);
    s_logisimBus0(27)  <=  s_logisimBus25(7);
    s_logisimBus0(28)  <=  s_logisimBus25(7);
    s_logisimBus0(29)  <=  s_logisimBus25(7);
    s_logisimBus0(30)  <=  s_logisimBus25(7);
    s_logisimBus0(31)  <=  s_logisimBus25(7);


   -- Bit Extender
    s_logisimBus2(0)  <=  s_logisimBus21(0);
    s_logisimBus2(1)  <=  s_logisimBus21(1);
    s_logisimBus2(2)  <=  s_logisimBus21(2);
    s_logisimBus2(3)  <=  s_logisimBus21(3);
    s_logisimBus2(4)  <=  s_logisimBus21(4);
    s_logisimBus2(5)  <=  s_logisimBus21(5);
    s_logisimBus2(6)  <=  s_logisimBus21(6);
    s_logisimBus2(7)  <=  s_logisimBus21(7);
    s_logisimBus2(8)  <=  s_logisimBus21(7);
    s_logisimBus2(9)  <=  s_logisimBus21(7);
    s_logisimBus2(10)  <=  s_logisimBus21(7);
    s_logisimBus2(11)  <=  s_logisimBus21(7);
    s_logisimBus2(12)  <=  s_logisimBus21(7);
    s_logisimBus2(13)  <=  s_logisimBus21(7);
    s_logisimBus2(14)  <=  s_logisimBus21(7);
    s_logisimBus2(15)  <=  s_logisimBus21(7);
    s_logisimBus2(16)  <=  s_logisimBus21(7);
    s_logisimBus2(17)  <=  s_logisimBus21(7);
    s_logisimBus2(18)  <=  s_logisimBus21(7);
    s_logisimBus2(19)  <=  s_logisimBus21(7);
    s_logisimBus2(20)  <=  s_logisimBus21(7);
    s_logisimBus2(21)  <=  s_logisimBus21(7);
    s_logisimBus2(22)  <=  s_logisimBus21(7);
    s_logisimBus2(23)  <=  s_logisimBus21(7);
    s_logisimBus2(24)  <=  s_logisimBus21(7);
    s_logisimBus2(25)  <=  s_logisimBus21(7);
    s_logisimBus2(26)  <=  s_logisimBus21(7);
    s_logisimBus2(27)  <=  s_logisimBus21(7);
    s_logisimBus2(28)  <=  s_logisimBus21(7);
    s_logisimBus2(29)  <=  s_logisimBus21(7);
    s_logisimBus2(30)  <=  s_logisimBus21(7);
    s_logisimBus2(31)  <=  s_logisimBus21(7);


   -- Bit Extender
    s_logisimBus16(0)  <=  s_logisimBus26(0);
    s_logisimBus16(1)  <=  s_logisimBus26(1);
    s_logisimBus16(2)  <=  s_logisimBus26(2);
    s_logisimBus16(3)  <=  s_logisimBus26(3);
    s_logisimBus16(4)  <=  s_logisimBus26(4);
    s_logisimBus16(5)  <=  s_logisimBus26(5);
    s_logisimBus16(6)  <=  s_logisimBus26(6);
    s_logisimBus16(7)  <=  s_logisimBus26(7);
    s_logisimBus16(8)  <=  s_logisimBus26(7);
    s_logisimBus16(9)  <=  s_logisimBus26(7);
    s_logisimBus16(10)  <=  s_logisimBus26(7);
    s_logisimBus16(11)  <=  s_logisimBus26(7);
    s_logisimBus16(12)  <=  s_logisimBus26(7);
    s_logisimBus16(13)  <=  s_logisimBus26(7);
    s_logisimBus16(14)  <=  s_logisimBus26(7);
    s_logisimBus16(15)  <=  s_logisimBus26(7);
    s_logisimBus16(16)  <=  s_logisimBus26(7);
    s_logisimBus16(17)  <=  s_logisimBus26(7);
    s_logisimBus16(18)  <=  s_logisimBus26(7);
    s_logisimBus16(19)  <=  s_logisimBus26(7);
    s_logisimBus16(20)  <=  s_logisimBus26(7);
    s_logisimBus16(21)  <=  s_logisimBus26(7);
    s_logisimBus16(22)  <=  s_logisimBus26(7);
    s_logisimBus16(23)  <=  s_logisimBus26(7);
    s_logisimBus16(24)  <=  s_logisimBus26(7);
    s_logisimBus16(25)  <=  s_logisimBus26(7);
    s_logisimBus16(26)  <=  s_logisimBus26(7);
    s_logisimBus16(27)  <=  s_logisimBus26(7);
    s_logisimBus16(28)  <=  s_logisimBus26(7);
    s_logisimBus16(29)  <=  s_logisimBus26(7);
    s_logisimBus16(30)  <=  s_logisimBus26(7);
    s_logisimBus16(31)  <=  s_logisimBus26(7);


   -- Bit Extender
    s_logisimBus3(0)  <=  s_logisimBus27(0);
    s_logisimBus3(1)  <=  s_logisimBus27(1);
    s_logisimBus3(2)  <=  s_logisimBus27(2);
    s_logisimBus3(3)  <=  s_logisimBus27(3);
    s_logisimBus3(4)  <=  s_logisimBus27(4);
    s_logisimBus3(5)  <=  s_logisimBus27(5);
    s_logisimBus3(6)  <=  s_logisimBus27(6);
    s_logisimBus3(7)  <=  s_logisimBus27(7);
    s_logisimBus3(8)  <=  s_logisimBus27(7);
    s_logisimBus3(9)  <=  s_logisimBus27(7);
    s_logisimBus3(10)  <=  s_logisimBus27(7);
    s_logisimBus3(11)  <=  s_logisimBus27(7);
    s_logisimBus3(12)  <=  s_logisimBus27(7);
    s_logisimBus3(13)  <=  s_logisimBus27(7);
    s_logisimBus3(14)  <=  s_logisimBus27(7);
    s_logisimBus3(15)  <=  s_logisimBus27(7);
    s_logisimBus3(16)  <=  s_logisimBus27(7);
    s_logisimBus3(17)  <=  s_logisimBus27(7);
    s_logisimBus3(18)  <=  s_logisimBus27(7);
    s_logisimBus3(19)  <=  s_logisimBus27(7);
    s_logisimBus3(20)  <=  s_logisimBus27(7);
    s_logisimBus3(21)  <=  s_logisimBus27(7);
    s_logisimBus3(22)  <=  s_logisimBus27(7);
    s_logisimBus3(23)  <=  s_logisimBus27(7);
    s_logisimBus3(24)  <=  s_logisimBus27(7);
    s_logisimBus3(25)  <=  s_logisimBus27(7);
    s_logisimBus3(26)  <=  s_logisimBus27(7);
    s_logisimBus3(27)  <=  s_logisimBus27(7);
    s_logisimBus3(28)  <=  s_logisimBus27(7);
    s_logisimBus3(29)  <=  s_logisimBus27(7);
    s_logisimBus3(30)  <=  s_logisimBus27(7);
    s_logisimBus3(31)  <=  s_logisimBus27(7);


   -- Bit Extender
    s_logisimBus10(0)  <=  s_logisimBus22(0);
    s_logisimBus10(1)  <=  s_logisimBus22(1);
    s_logisimBus10(2)  <=  s_logisimBus22(2);
    s_logisimBus10(3)  <=  s_logisimBus22(3);
    s_logisimBus10(4)  <=  s_logisimBus22(4);
    s_logisimBus10(5)  <=  s_logisimBus22(5);
    s_logisimBus10(6)  <=  s_logisimBus22(6);
    s_logisimBus10(7)  <=  s_logisimBus22(7);
    s_logisimBus10(8)  <=  s_logisimBus22(7);
    s_logisimBus10(9)  <=  s_logisimBus22(7);
    s_logisimBus10(10)  <=  s_logisimBus22(7);
    s_logisimBus10(11)  <=  s_logisimBus22(7);
    s_logisimBus10(12)  <=  s_logisimBus22(7);
    s_logisimBus10(13)  <=  s_logisimBus22(7);
    s_logisimBus10(14)  <=  s_logisimBus22(7);
    s_logisimBus10(15)  <=  s_logisimBus22(7);
    s_logisimBus10(16)  <=  s_logisimBus22(7);
    s_logisimBus10(17)  <=  s_logisimBus22(7);
    s_logisimBus10(18)  <=  s_logisimBus22(7);
    s_logisimBus10(19)  <=  s_logisimBus22(7);
    s_logisimBus10(20)  <=  s_logisimBus22(7);
    s_logisimBus10(21)  <=  s_logisimBus22(7);
    s_logisimBus10(22)  <=  s_logisimBus22(7);
    s_logisimBus10(23)  <=  s_logisimBus22(7);
    s_logisimBus10(24)  <=  s_logisimBus22(7);
    s_logisimBus10(25)  <=  s_logisimBus22(7);
    s_logisimBus10(26)  <=  s_logisimBus22(7);
    s_logisimBus10(27)  <=  s_logisimBus22(7);
    s_logisimBus10(28)  <=  s_logisimBus22(7);
    s_logisimBus10(29)  <=  s_logisimBus22(7);
    s_logisimBus10(30)  <=  s_logisimBus22(7);
    s_logisimBus10(31)  <=  s_logisimBus22(7);


   -- Bit Extender
    s_logisimBus14(0)  <=  s_logisimBus28(0);
    s_logisimBus14(1)  <=  s_logisimBus28(1);
    s_logisimBus14(2)  <=  s_logisimBus28(2);
    s_logisimBus14(3)  <=  s_logisimBus28(3);
    s_logisimBus14(4)  <=  s_logisimBus28(4);
    s_logisimBus14(5)  <=  s_logisimBus28(5);
    s_logisimBus14(6)  <=  s_logisimBus28(6);
    s_logisimBus14(7)  <=  s_logisimBus28(7);
    s_logisimBus14(8)  <=  s_logisimBus28(7);
    s_logisimBus14(9)  <=  s_logisimBus28(7);
    s_logisimBus14(10)  <=  s_logisimBus28(7);
    s_logisimBus14(11)  <=  s_logisimBus28(7);
    s_logisimBus14(12)  <=  s_logisimBus28(7);
    s_logisimBus14(13)  <=  s_logisimBus28(7);
    s_logisimBus14(14)  <=  s_logisimBus28(7);
    s_logisimBus14(15)  <=  s_logisimBus28(7);
    s_logisimBus14(16)  <=  s_logisimBus28(7);
    s_logisimBus14(17)  <=  s_logisimBus28(7);
    s_logisimBus14(18)  <=  s_logisimBus28(7);
    s_logisimBus14(19)  <=  s_logisimBus28(7);
    s_logisimBus14(20)  <=  s_logisimBus28(7);
    s_logisimBus14(21)  <=  s_logisimBus28(7);
    s_logisimBus14(22)  <=  s_logisimBus28(7);
    s_logisimBus14(23)  <=  s_logisimBus28(7);
    s_logisimBus14(24)  <=  s_logisimBus28(7);
    s_logisimBus14(25)  <=  s_logisimBus28(7);
    s_logisimBus14(26)  <=  s_logisimBus28(7);
    s_logisimBus14(27)  <=  s_logisimBus28(7);
    s_logisimBus14(28)  <=  s_logisimBus28(7);
    s_logisimBus14(29)  <=  s_logisimBus28(7);
    s_logisimBus14(30)  <=  s_logisimBus28(7);
    s_logisimBus14(31)  <=  s_logisimBus28(7);


   -- Bit Extender
    s_logisimBus4(0)  <=  s_logisimBus23(0);
    s_logisimBus4(1)  <=  s_logisimBus23(1);
    s_logisimBus4(2)  <=  s_logisimBus23(2);
    s_logisimBus4(3)  <=  s_logisimBus23(3);
    s_logisimBus4(4)  <=  s_logisimBus23(4);
    s_logisimBus4(5)  <=  s_logisimBus23(5);
    s_logisimBus4(6)  <=  s_logisimBus23(6);
    s_logisimBus4(7)  <=  s_logisimBus23(7);
    s_logisimBus4(8)  <=  s_logisimBus23(7);
    s_logisimBus4(9)  <=  s_logisimBus23(7);
    s_logisimBus4(10)  <=  s_logisimBus23(7);
    s_logisimBus4(11)  <=  s_logisimBus23(7);
    s_logisimBus4(12)  <=  s_logisimBus23(7);
    s_logisimBus4(13)  <=  s_logisimBus23(7);
    s_logisimBus4(14)  <=  s_logisimBus23(7);
    s_logisimBus4(15)  <=  s_logisimBus23(7);
    s_logisimBus4(16)  <=  s_logisimBus23(7);
    s_logisimBus4(17)  <=  s_logisimBus23(7);
    s_logisimBus4(18)  <=  s_logisimBus23(7);
    s_logisimBus4(19)  <=  s_logisimBus23(7);
    s_logisimBus4(20)  <=  s_logisimBus23(7);
    s_logisimBus4(21)  <=  s_logisimBus23(7);
    s_logisimBus4(22)  <=  s_logisimBus23(7);
    s_logisimBus4(23)  <=  s_logisimBus23(7);
    s_logisimBus4(24)  <=  s_logisimBus23(7);
    s_logisimBus4(25)  <=  s_logisimBus23(7);
    s_logisimBus4(26)  <=  s_logisimBus23(7);
    s_logisimBus4(27)  <=  s_logisimBus23(7);
    s_logisimBus4(28)  <=  s_logisimBus23(7);
    s_logisimBus4(29)  <=  s_logisimBus23(7);
    s_logisimBus4(30)  <=  s_logisimBus23(7);
    s_logisimBus4(31)  <=  s_logisimBus23(7);


   --------------------------------------------------------------------------------
   -- Here all normal components are defined                                     --
   --------------------------------------------------------------------------------
   ARITH_1 : Multiplier
      GENERIC MAP ( calcBits           => 64,
                    nrOfBits           => 32,
                    unsignedMultiplier => 1 )
      PORT MAP ( carryIn  => X"00000000",
                 inputA   => s_logisimBus1(31 DOWNTO 0),
                 inputB   => s_logisimBus15(31 DOWNTO 0),
                 multHigh => OPEN,
                 multLow  => s_logisimBus6(31 DOWNTO 0) );

   ARITH_2 : Multiplier
      GENERIC MAP ( calcBits           => 64,
                    nrOfBits           => 32,
                    unsignedMultiplier => 1 )
      PORT MAP ( carryIn  => X"00000000",
                 inputA   => s_logisimBus9(31 DOWNTO 0),
                 inputB   => s_logisimBus0(31 DOWNTO 0),
                 multHigh => OPEN,
                 multLow  => s_logisimBus8(31 DOWNTO 0) );

   ARITH_3 : Multiplier
      GENERIC MAP ( calcBits           => 64,
                    nrOfBits           => 32,
                    unsignedMultiplier => 1 )
      PORT MAP ( carryIn  => X"00000000",
                 inputA   => s_logisimBus2(31 DOWNTO 0),
                 inputB   => s_logisimBus16(31 DOWNTO 0),
                 multHigh => OPEN,
                 multLow  => s_logisimBus12(31 DOWNTO 0) );

   ARITH_4 : Multiplier
      GENERIC MAP ( calcBits           => 64,
                    nrOfBits           => 32,
                    unsignedMultiplier => 1 )
      PORT MAP ( carryIn  => X"00000000",
                 inputA   => s_logisimBus10(31 DOWNTO 0),
                 inputB   => s_logisimBus3(31 DOWNTO 0),
                 multHigh => OPEN,
                 multLow  => s_logisimBus11(31 DOWNTO 0) );

   ARITH_5 : Multiplier
      GENERIC MAP ( calcBits           => 64,
                    nrOfBits           => 32,
                    unsignedMultiplier => 1 )
      PORT MAP ( carryIn  => X"00000000",
                 inputA   => s_logisimBus4(31 DOWNTO 0),
                 inputB   => s_logisimBus14(31 DOWNTO 0),
                 multHigh => OPEN,
                 multLow  => s_logisimBus13(31 DOWNTO 0) );

   ARITH_6 : Adder
      GENERIC MAP ( extendedBits => 33,
                    nrOfBits     => 32 )
      PORT MAP ( carryIn  => '0',
                 carryOut => OPEN,
                 dataA    => s_logisimBus6(31 DOWNTO 0),
                 dataB    => s_logisimBus8(31 DOWNTO 0),
                 result   => s_logisimBus18(31 DOWNTO 0) );

   ARITH_7 : Adder
      GENERIC MAP ( extendedBits => 33,
                    nrOfBits     => 32 )
      PORT MAP ( carryIn  => '0',
                 carryOut => OPEN,
                 dataA    => s_logisimBus18(31 DOWNTO 0),
                 dataB    => s_logisimBus12(31 DOWNTO 0),
                 result   => s_logisimBus7(31 DOWNTO 0) );

   ARITH_8 : Adder
      GENERIC MAP ( extendedBits => 33,
                    nrOfBits     => 32 )
      PORT MAP ( carryIn  => '0',
                 carryOut => OPEN,
                 dataA    => s_logisimBus7(31 DOWNTO 0),
                 dataB    => s_logisimBus11(31 DOWNTO 0),
                 result   => s_logisimBus17(31 DOWNTO 0) );

   ARITH_9 : Adder
      GENERIC MAP ( extendedBits => 33,
                    nrOfBits     => 32 )
      PORT MAP ( carryIn  => '0',
                 carryOut => OPEN,
                 dataA    => s_logisimBus17(31 DOWNTO 0),
                 dataB    => s_logisimBus13(31 DOWNTO 0),
                 result   => s_logisimBus5(31 DOWNTO 0) );


END arc;
