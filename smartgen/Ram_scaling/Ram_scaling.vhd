-- Version: v11.8 SP3 11.8.3.6

library ieee;
use ieee.std_logic_1164.all;
library proasic3l;
use proasic3l.all;

entity Ram_scaling is

    port( WD    : in    std_logic_vector(11 downto 0);
          RD    : out   std_logic_vector(11 downto 0);
          WEN   : in    std_logic;
          REN   : in    std_logic;
          WADDR : in    std_logic_vector(9 downto 0);
          RADDR : in    std_logic_vector(9 downto 0);
          WCLK  : in    std_logic;
          RCLK  : in    std_logic;
          RESET : in    std_logic
        );

end Ram_scaling;

architecture DEF_ARCH of Ram_scaling is 

  component RAM4K9
    generic (MEMORYFILE:string := "");

    port( ADDRA11 : in    std_logic := 'U';
          ADDRA10 : in    std_logic := 'U';
          ADDRA9  : in    std_logic := 'U';
          ADDRA8  : in    std_logic := 'U';
          ADDRA7  : in    std_logic := 'U';
          ADDRA6  : in    std_logic := 'U';
          ADDRA5  : in    std_logic := 'U';
          ADDRA4  : in    std_logic := 'U';
          ADDRA3  : in    std_logic := 'U';
          ADDRA2  : in    std_logic := 'U';
          ADDRA1  : in    std_logic := 'U';
          ADDRA0  : in    std_logic := 'U';
          ADDRB11 : in    std_logic := 'U';
          ADDRB10 : in    std_logic := 'U';
          ADDRB9  : in    std_logic := 'U';
          ADDRB8  : in    std_logic := 'U';
          ADDRB7  : in    std_logic := 'U';
          ADDRB6  : in    std_logic := 'U';
          ADDRB5  : in    std_logic := 'U';
          ADDRB4  : in    std_logic := 'U';
          ADDRB3  : in    std_logic := 'U';
          ADDRB2  : in    std_logic := 'U';
          ADDRB1  : in    std_logic := 'U';
          ADDRB0  : in    std_logic := 'U';
          DINA8   : in    std_logic := 'U';
          DINA7   : in    std_logic := 'U';
          DINA6   : in    std_logic := 'U';
          DINA5   : in    std_logic := 'U';
          DINA4   : in    std_logic := 'U';
          DINA3   : in    std_logic := 'U';
          DINA2   : in    std_logic := 'U';
          DINA1   : in    std_logic := 'U';
          DINA0   : in    std_logic := 'U';
          DINB8   : in    std_logic := 'U';
          DINB7   : in    std_logic := 'U';
          DINB6   : in    std_logic := 'U';
          DINB5   : in    std_logic := 'U';
          DINB4   : in    std_logic := 'U';
          DINB3   : in    std_logic := 'U';
          DINB2   : in    std_logic := 'U';
          DINB1   : in    std_logic := 'U';
          DINB0   : in    std_logic := 'U';
          WIDTHA0 : in    std_logic := 'U';
          WIDTHA1 : in    std_logic := 'U';
          WIDTHB0 : in    std_logic := 'U';
          WIDTHB1 : in    std_logic := 'U';
          PIPEA   : in    std_logic := 'U';
          PIPEB   : in    std_logic := 'U';
          WMODEA  : in    std_logic := 'U';
          WMODEB  : in    std_logic := 'U';
          BLKA    : in    std_logic := 'U';
          BLKB    : in    std_logic := 'U';
          WENA    : in    std_logic := 'U';
          WENB    : in    std_logic := 'U';
          CLKA    : in    std_logic := 'U';
          CLKB    : in    std_logic := 'U';
          RESET   : in    std_logic := 'U';
          DOUTA8  : out   std_logic;
          DOUTA7  : out   std_logic;
          DOUTA6  : out   std_logic;
          DOUTA5  : out   std_logic;
          DOUTA4  : out   std_logic;
          DOUTA3  : out   std_logic;
          DOUTA2  : out   std_logic;
          DOUTA1  : out   std_logic;
          DOUTA0  : out   std_logic;
          DOUTB8  : out   std_logic;
          DOUTB7  : out   std_logic;
          DOUTB6  : out   std_logic;
          DOUTB5  : out   std_logic;
          DOUTB4  : out   std_logic;
          DOUTB3  : out   std_logic;
          DOUTB2  : out   std_logic;
          DOUTB1  : out   std_logic;
          DOUTB0  : out   std_logic
        );
  end component;

  component INV
    port( A : in    std_logic := 'U';
          Y : out   std_logic
        );
  end component;

  component GND
    port(Y : out std_logic); 
  end component;

  component VCC
    port(Y : out std_logic); 
  end component;

    signal WEAP, WEBP, RESETP, \VCC\, \GND\ : std_logic;
    signal GND_power_net1 : std_logic;
    signal VCC_power_net1 : std_logic;

begin 

    \GND\ <= GND_power_net1;
    \VCC\ <= VCC_power_net1;

    Ram_scaling_R0C1 : RAM4K9
      port map(ADDRA11 => \GND\, ADDRA10 => \GND\, ADDRA9 => 
        WADDR(9), ADDRA8 => WADDR(8), ADDRA7 => WADDR(7), ADDRA6
         => WADDR(6), ADDRA5 => WADDR(5), ADDRA4 => WADDR(4), 
        ADDRA3 => WADDR(3), ADDRA2 => WADDR(2), ADDRA1 => 
        WADDR(1), ADDRA0 => WADDR(0), ADDRB11 => \GND\, ADDRB10
         => \GND\, ADDRB9 => RADDR(9), ADDRB8 => RADDR(8), ADDRB7
         => RADDR(7), ADDRB6 => RADDR(6), ADDRB5 => RADDR(5), 
        ADDRB4 => RADDR(4), ADDRB3 => RADDR(3), ADDRB2 => 
        RADDR(2), ADDRB1 => RADDR(1), ADDRB0 => RADDR(0), DINA8
         => \GND\, DINA7 => \GND\, DINA6 => \GND\, DINA5 => \GND\, 
        DINA4 => \GND\, DINA3 => WD(7), DINA2 => WD(6), DINA1 => 
        WD(5), DINA0 => WD(4), DINB8 => \GND\, DINB7 => \GND\, 
        DINB6 => \GND\, DINB5 => \GND\, DINB4 => \GND\, DINB3 => 
        \GND\, DINB2 => \GND\, DINB1 => \GND\, DINB0 => \GND\, 
        WIDTHA0 => \GND\, WIDTHA1 => \VCC\, WIDTHB0 => \GND\, 
        WIDTHB1 => \VCC\, PIPEA => \GND\, PIPEB => \VCC\, WMODEA
         => \GND\, WMODEB => \GND\, BLKA => WEAP, BLKB => WEBP, 
        WENA => \GND\, WENB => \VCC\, CLKA => WCLK, CLKB => RCLK, 
        RESET => RESETP, DOUTA8 => OPEN, DOUTA7 => OPEN, DOUTA6
         => OPEN, DOUTA5 => OPEN, DOUTA4 => OPEN, DOUTA3 => OPEN, 
        DOUTA2 => OPEN, DOUTA1 => OPEN, DOUTA0 => OPEN, DOUTB8
         => OPEN, DOUTB7 => OPEN, DOUTB6 => OPEN, DOUTB5 => OPEN, 
        DOUTB4 => OPEN, DOUTB3 => RD(7), DOUTB2 => RD(6), DOUTB1
         => RD(5), DOUTB0 => RD(4));
    
    RESETBUBBLE : INV
      port map(A => RESET, Y => RESETP);
    
    Ram_scaling_R0C0 : RAM4K9
      port map(ADDRA11 => \GND\, ADDRA10 => \GND\, ADDRA9 => 
        WADDR(9), ADDRA8 => WADDR(8), ADDRA7 => WADDR(7), ADDRA6
         => WADDR(6), ADDRA5 => WADDR(5), ADDRA4 => WADDR(4), 
        ADDRA3 => WADDR(3), ADDRA2 => WADDR(2), ADDRA1 => 
        WADDR(1), ADDRA0 => WADDR(0), ADDRB11 => \GND\, ADDRB10
         => \GND\, ADDRB9 => RADDR(9), ADDRB8 => RADDR(8), ADDRB7
         => RADDR(7), ADDRB6 => RADDR(6), ADDRB5 => RADDR(5), 
        ADDRB4 => RADDR(4), ADDRB3 => RADDR(3), ADDRB2 => 
        RADDR(2), ADDRB1 => RADDR(1), ADDRB0 => RADDR(0), DINA8
         => \GND\, DINA7 => \GND\, DINA6 => \GND\, DINA5 => \GND\, 
        DINA4 => \GND\, DINA3 => WD(3), DINA2 => WD(2), DINA1 => 
        WD(1), DINA0 => WD(0), DINB8 => \GND\, DINB7 => \GND\, 
        DINB6 => \GND\, DINB5 => \GND\, DINB4 => \GND\, DINB3 => 
        \GND\, DINB2 => \GND\, DINB1 => \GND\, DINB0 => \GND\, 
        WIDTHA0 => \GND\, WIDTHA1 => \VCC\, WIDTHB0 => \GND\, 
        WIDTHB1 => \VCC\, PIPEA => \GND\, PIPEB => \VCC\, WMODEA
         => \GND\, WMODEB => \GND\, BLKA => WEAP, BLKB => WEBP, 
        WENA => \GND\, WENB => \VCC\, CLKA => WCLK, CLKB => RCLK, 
        RESET => RESETP, DOUTA8 => OPEN, DOUTA7 => OPEN, DOUTA6
         => OPEN, DOUTA5 => OPEN, DOUTA4 => OPEN, DOUTA3 => OPEN, 
        DOUTA2 => OPEN, DOUTA1 => OPEN, DOUTA0 => OPEN, DOUTB8
         => OPEN, DOUTB7 => OPEN, DOUTB6 => OPEN, DOUTB5 => OPEN, 
        DOUTB4 => OPEN, DOUTB3 => RD(3), DOUTB2 => RD(2), DOUTB1
         => RD(1), DOUTB0 => RD(0));
    
    WEBUBBLEB : INV
      port map(A => REN, Y => WEBP);
    
    WEBUBBLEA : INV
      port map(A => WEN, Y => WEAP);
    
    Ram_scaling_R0C2 : RAM4K9
      port map(ADDRA11 => \GND\, ADDRA10 => \GND\, ADDRA9 => 
        WADDR(9), ADDRA8 => WADDR(8), ADDRA7 => WADDR(7), ADDRA6
         => WADDR(6), ADDRA5 => WADDR(5), ADDRA4 => WADDR(4), 
        ADDRA3 => WADDR(3), ADDRA2 => WADDR(2), ADDRA1 => 
        WADDR(1), ADDRA0 => WADDR(0), ADDRB11 => \GND\, ADDRB10
         => \GND\, ADDRB9 => RADDR(9), ADDRB8 => RADDR(8), ADDRB7
         => RADDR(7), ADDRB6 => RADDR(6), ADDRB5 => RADDR(5), 
        ADDRB4 => RADDR(4), ADDRB3 => RADDR(3), ADDRB2 => 
        RADDR(2), ADDRB1 => RADDR(1), ADDRB0 => RADDR(0), DINA8
         => \GND\, DINA7 => \GND\, DINA6 => \GND\, DINA5 => \GND\, 
        DINA4 => \GND\, DINA3 => WD(11), DINA2 => WD(10), DINA1
         => WD(9), DINA0 => WD(8), DINB8 => \GND\, DINB7 => \GND\, 
        DINB6 => \GND\, DINB5 => \GND\, DINB4 => \GND\, DINB3 => 
        \GND\, DINB2 => \GND\, DINB1 => \GND\, DINB0 => \GND\, 
        WIDTHA0 => \GND\, WIDTHA1 => \VCC\, WIDTHB0 => \GND\, 
        WIDTHB1 => \VCC\, PIPEA => \GND\, PIPEB => \VCC\, WMODEA
         => \GND\, WMODEB => \GND\, BLKA => WEAP, BLKB => WEBP, 
        WENA => \GND\, WENB => \VCC\, CLKA => WCLK, CLKB => RCLK, 
        RESET => RESETP, DOUTA8 => OPEN, DOUTA7 => OPEN, DOUTA6
         => OPEN, DOUTA5 => OPEN, DOUTA4 => OPEN, DOUTA3 => OPEN, 
        DOUTA2 => OPEN, DOUTA1 => OPEN, DOUTA0 => OPEN, DOUTB8
         => OPEN, DOUTB7 => OPEN, DOUTB6 => OPEN, DOUTB5 => OPEN, 
        DOUTB4 => OPEN, DOUTB3 => RD(11), DOUTB2 => RD(10), 
        DOUTB1 => RD(9), DOUTB0 => RD(8));
    
    GND_power_inst1 : GND
      port map( Y => GND_power_net1);

    VCC_power_inst1 : VCC
      port map( Y => VCC_power_net1);


end DEF_ARCH; 

-- _Disclaimer: Please leave the following comments in the file, they are for internal purposes only._


-- _GEN_File_Contents_

-- Version:11.8.3.6
-- ACTGENU_CALL:1
-- BATCH:T
-- FAM:PA3LDP
-- OUTFORMAT:VHDL
-- LPMTYPE:LPM_RAM
-- LPM_HINT:TWO
-- INSERT_PAD:NO
-- INSERT_IOREG:NO
-- GEN_BHV_VHDL_VAL:F
-- GEN_BHV_VERILOG_VAL:F
-- MGNTIMER:F
-- MGNCMPL:T
-- DESDIR:G:/ACTELL/EKB/EKB_v1/EKB/Libero/smartgen\Ram_scaling
-- GEN_BEHV_MODULE:F
-- SMARTGEN_DIE:IT14X14M4LDP
-- SMARTGEN_PACKAGE:fg484
-- AGENIII_IS_SUBPROJECT_LIBERO:T
-- WWIDTH:12
-- WDEPTH:1024
-- RWIDTH:12
-- RDEPTH:1024
-- CLKS:2
-- RESET_PN:RESET
-- RESET_POLARITY:1
-- INIT_RAM:F
-- DEFAULT_WORD:0x000
-- CASCADE:0
-- LP_POLARITY:2
-- FF_POLARITY:2
-- WCLK_EDGE:RISE
-- RCLK_EDGE:RISE
-- WCLOCK_PN:WCLK
-- RCLOCK_PN:RCLK
-- PMODE2:1
-- DATA_IN_PN:WD
-- WADDRESS_PN:WADDR
-- WE_PN:WEN
-- DATA_OUT_PN:RD
-- RADDRESS_PN:RADDR
-- RE_PN:REN
-- WE_POLARITY:1
-- RE_POLARITY:1
-- PTYPE:1

-- _End_Comments_

