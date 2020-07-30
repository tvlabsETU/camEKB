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

<<<<<<< HEAD
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
=======
  component MX2
    port( A : in    std_logic := 'U';
          B : in    std_logic := 'U';
          S : in    std_logic := 'U';
          Y : out   std_logic
        );
  end component;

  component OR2
    port( A : in    std_logic := 'U';
          B : in    std_logic := 'U';
          Y : out   std_logic
        );
  end component;

  component RAM512X18
    generic (MEMORYFILE:string := "");

    port( RADDR8 : in    std_logic := 'U';
          RADDR7 : in    std_logic := 'U';
          RADDR6 : in    std_logic := 'U';
          RADDR5 : in    std_logic := 'U';
          RADDR4 : in    std_logic := 'U';
          RADDR3 : in    std_logic := 'U';
          RADDR2 : in    std_logic := 'U';
          RADDR1 : in    std_logic := 'U';
          RADDR0 : in    std_logic := 'U';
          WADDR8 : in    std_logic := 'U';
          WADDR7 : in    std_logic := 'U';
          WADDR6 : in    std_logic := 'U';
          WADDR5 : in    std_logic := 'U';
          WADDR4 : in    std_logic := 'U';
          WADDR3 : in    std_logic := 'U';
          WADDR2 : in    std_logic := 'U';
          WADDR1 : in    std_logic := 'U';
          WADDR0 : in    std_logic := 'U';
          WD17   : in    std_logic := 'U';
          WD16   : in    std_logic := 'U';
          WD15   : in    std_logic := 'U';
          WD14   : in    std_logic := 'U';
          WD13   : in    std_logic := 'U';
          WD12   : in    std_logic := 'U';
          WD11   : in    std_logic := 'U';
          WD10   : in    std_logic := 'U';
          WD9    : in    std_logic := 'U';
          WD8    : in    std_logic := 'U';
          WD7    : in    std_logic := 'U';
          WD6    : in    std_logic := 'U';
          WD5    : in    std_logic := 'U';
          WD4    : in    std_logic := 'U';
          WD3    : in    std_logic := 'U';
          WD2    : in    std_logic := 'U';
          WD1    : in    std_logic := 'U';
          WD0    : in    std_logic := 'U';
          RW0    : in    std_logic := 'U';
          RW1    : in    std_logic := 'U';
          WW0    : in    std_logic := 'U';
          WW1    : in    std_logic := 'U';
          PIPE   : in    std_logic := 'U';
          REN    : in    std_logic := 'U';
          WEN    : in    std_logic := 'U';
          RCLK   : in    std_logic := 'U';
          WCLK   : in    std_logic := 'U';
          RESET  : in    std_logic := 'U';
          RD17   : out   std_logic;
          RD16   : out   std_logic;
          RD15   : out   std_logic;
          RD14   : out   std_logic;
          RD13   : out   std_logic;
          RD12   : out   std_logic;
          RD11   : out   std_logic;
          RD10   : out   std_logic;
          RD9    : out   std_logic;
          RD8    : out   std_logic;
          RD7    : out   std_logic;
          RD6    : out   std_logic;
          RD5    : out   std_logic;
          RD4    : out   std_logic;
          RD3    : out   std_logic;
          RD2    : out   std_logic;
          RD1    : out   std_logic;
          RD0    : out   std_logic
>>>>>>> e296f02de89eba86bbe678e34dace66c718d9223
        );
  end component;

  component INV
    port( A : in    std_logic := 'U';
          Y : out   std_logic
        );
  end component;

<<<<<<< HEAD
=======
  component BUFF
    port( A : in    std_logic := 'U';
          Y : out   std_logic
        );
  end component;

  component DFN1
    port( D   : in    std_logic := 'U';
          CLK : in    std_logic := 'U';
          Q   : out   std_logic
        );
  end component;

  component NAND2
    port( A : in    std_logic := 'U';
          B : in    std_logic := 'U';
          Y : out   std_logic
        );
  end component;

  component OR2A
    port( A : in    std_logic := 'U';
          B : in    std_logic := 'U';
          Y : out   std_logic
        );
  end component;

  component DFN1E1C0
    port( D   : in    std_logic := 'U';
          CLK : in    std_logic := 'U';
          CLR : in    std_logic := 'U';
          E   : in    std_logic := 'U';
          Q   : out   std_logic
        );
  end component;

>>>>>>> e296f02de89eba86bbe678e34dace66c718d9223
  component GND
    port(Y : out std_logic); 
  end component;

  component VCC
    port(Y : out std_logic); 
  end component;

<<<<<<< HEAD
    signal WEAP, WEBP, RESETP, \VCC\, \GND\ : std_logic;
=======
    signal WEAP, WEBP, RESETP, \ADDRB_FF1[0]\, \ADDRB_FF2[0]\, 
        \READB_EN_2[0]\, \ADDRB_FF1[1]\, \ADDRB_FF2[1]\, 
        \READB_EN_2[1]\, \ENABLE_ADDRA[0]\, \ENABLE_ADDRA[1]\, 
        \ENABLE_ADDRA[2]\, \ENABLE_ADDRA[3]\, \ENABLE_ADDRB[0]\, 
        \ENABLE_ADDRB[1]\, \ENABLE_ADDRB[2]\, \ENABLE_ADDRB[3]\, 
        \BLKA_EN[0]\, \BLKB_EN[0]\, \BLKA_EN[1]\, \BLKB_EN[1]\, 
        \BLKA_EN[2]\, \BLKB_EN[2]\, \BLKA_EN[3]\, \BLKB_EN[3]\, 
        \READB_EN[0]\, \READB_EN[1]\, \READB_EN[2]\, 
        \READB_EN_2[2]\, \READB_EN[3]\, \READB_EN_2[3]\, 
        \QX_TEMPR0[0]\, \QX_TEMPR0[1]\, \QX_TEMPR0[2]\, 
        \QX_TEMPR0[3]\, \QX_TEMPR0[4]\, \QX_TEMPR0[5]\, 
        \QX_TEMPR0[6]\, \QX_TEMPR0[7]\, \QX_TEMPR0[8]\, 
        \QX_TEMPR0[9]\, \QX_TEMPR0[10]\, \QX_TEMPR0[11]\, 
        \QX_TEMPR1[0]\, \QX_TEMPR1[1]\, \QX_TEMPR1[2]\, 
        \QX_TEMPR1[3]\, \QX_TEMPR1[4]\, \QX_TEMPR1[5]\, 
        \QX_TEMPR1[6]\, \QX_TEMPR1[7]\, \QX_TEMPR1[8]\, 
        \QX_TEMPR1[9]\, \QX_TEMPR1[10]\, \QX_TEMPR1[11]\, 
        \QX_TEMPR2[0]\, \QX_TEMPR2[1]\, \QX_TEMPR2[2]\, 
        \QX_TEMPR2[3]\, \QX_TEMPR2[4]\, \QX_TEMPR2[5]\, 
        \QX_TEMPR2[6]\, \QX_TEMPR2[7]\, \QX_TEMPR2[8]\, 
        \QX_TEMPR2[9]\, \QX_TEMPR2[10]\, \QX_TEMPR2[11]\, 
        \QX_TEMPR3[0]\, \QX_TEMPR3[1]\, \QX_TEMPR3[2]\, 
        \QX_TEMPR3[3]\, \QX_TEMPR3[4]\, \QX_TEMPR3[5]\, 
        \QX_TEMPR3[6]\, \QX_TEMPR3[7]\, \QX_TEMPR3[8]\, 
        \QX_TEMPR3[9]\, \QX_TEMPR3[10]\, \QX_TEMPR3[11]\, 
        BUFF_1_Y, BUFF_2_Y, BUFF_3_Y, BUFF_4_Y, BUFF_0_Y, MX2_1_Y, 
        MX2_0_Y, MX2_16_Y, MX2_14_Y, MX2_4_Y, MX2_6_Y, MX2_21_Y, 
        MX2_8_Y, MX2_13_Y, MX2_9_Y, MX2_2_Y, MX2_12_Y, MX2_23_Y, 
        MX2_3_Y, MX2_22_Y, MX2_18_Y, MX2_20_Y, MX2_7_Y, MX2_19_Y, 
        MX2_11_Y, MX2_17_Y, MX2_5_Y, MX2_15_Y, MX2_10_Y, \VCC\, 
        \GND\ : std_logic;
>>>>>>> e296f02de89eba86bbe678e34dace66c718d9223
    signal GND_power_net1 : std_logic;
    signal VCC_power_net1 : std_logic;

begin 

    \GND\ <= GND_power_net1;
    \VCC\ <= VCC_power_net1;

<<<<<<< HEAD
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
=======
    MX2_18 : MX2
      port map(A => \QX_TEMPR2[4]\, B => \QX_TEMPR3[4]\, S => 
        BUFF_2_Y, Y => MX2_18_Y);
    
    \MX2_RD[11]\ : MX2
      port map(A => MX2_17_Y, B => MX2_5_Y, S => BUFF_0_Y, Y => 
        RD(11));
    
    MX2_12 : MX2
      port map(A => \QX_TEMPR2[10]\, B => \QX_TEMPR3[10]\, S => 
        BUFF_3_Y, Y => MX2_12_Y);
    
    \MX2_RD[5]\ : MX2
      port map(A => MX2_23_Y, B => MX2_3_Y, S => BUFF_4_Y, Y => 
        RD(5));
    
    MX2_10 : MX2
      port map(A => \QX_TEMPR2[0]\, B => \QX_TEMPR3[0]\, S => 
        BUFF_1_Y, Y => MX2_10_Y);
    
    \MX2_RD[2]\ : MX2
      port map(A => MX2_13_Y, B => MX2_9_Y, S => BUFF_4_Y, Y => 
        RD(2));
    
    MX2_7 : MX2
      port map(A => \QX_TEMPR2[1]\, B => \QX_TEMPR3[1]\, S => 
        BUFF_1_Y, Y => MX2_7_Y);
    
    MX2_15 : MX2
      port map(A => \QX_TEMPR0[0]\, B => \QX_TEMPR1[0]\, S => 
        BUFF_1_Y, Y => MX2_15_Y);
    
    \ORA_GATE[0]\ : OR2
      port map(A => \ENABLE_ADDRA[0]\, B => WEAP, Y => 
        \BLKA_EN[0]\);
    
    Ram_scaling_R1C0 : RAM512X18
      port map(RADDR8 => \GND\, RADDR7 => RADDR(7), RADDR6 => 
        RADDR(6), RADDR5 => RADDR(5), RADDR4 => RADDR(4), RADDR3
         => RADDR(3), RADDR2 => RADDR(2), RADDR1 => RADDR(1), 
        RADDR0 => RADDR(0), WADDR8 => \GND\, WADDR7 => WADDR(7), 
        WADDR6 => WADDR(6), WADDR5 => WADDR(5), WADDR4 => 
        WADDR(4), WADDR3 => WADDR(3), WADDR2 => WADDR(2), WADDR1
         => WADDR(1), WADDR0 => WADDR(0), WD17 => \GND\, WD16 => 
        \GND\, WD15 => \GND\, WD14 => \GND\, WD13 => \GND\, WD12
         => \GND\, WD11 => WD(11), WD10 => WD(10), WD9 => WD(9), 
        WD8 => WD(8), WD7 => WD(7), WD6 => WD(6), WD5 => WD(5), 
        WD4 => WD(4), WD3 => WD(3), WD2 => WD(2), WD1 => WD(1), 
        WD0 => WD(0), RW0 => \GND\, RW1 => \VCC\, WW0 => \GND\, 
        WW1 => \VCC\, PIPE => \VCC\, REN => \BLKB_EN[1]\, WEN => 
        \BLKA_EN[1]\, RCLK => RCLK, WCLK => WCLK, RESET => RESETP, 
        RD17 => OPEN, RD16 => OPEN, RD15 => OPEN, RD14 => OPEN, 
        RD13 => OPEN, RD12 => OPEN, RD11 => \QX_TEMPR1[11]\, RD10
         => \QX_TEMPR1[10]\, RD9 => \QX_TEMPR1[9]\, RD8 => 
        \QX_TEMPR1[8]\, RD7 => \QX_TEMPR1[7]\, RD6 => 
        \QX_TEMPR1[6]\, RD5 => \QX_TEMPR1[5]\, RD4 => 
        \QX_TEMPR1[4]\, RD3 => \QX_TEMPR1[3]\, RD2 => 
        \QX_TEMPR1[2]\, RD1 => \QX_TEMPR1[1]\, RD0 => 
        \QX_TEMPR1[0]\);
    
    \INVB_READ_EN_GATE[1]\ : INV
      port map(A => WEBP, Y => \READB_EN[1]\);
    
    BUFF_0 : BUFF
      port map(A => \ADDRB_FF2[1]\, Y => BUFF_0_Y);
    
    \OR2_ENABLE_ADDRA[0]\ : OR2
      port map(A => WADDR(9), B => WADDR(8), Y => 
        \ENABLE_ADDRA[0]\);
    
    \ORB_GATE[2]\ : OR2
      port map(A => \ENABLE_ADDRB[2]\, B => WEBP, Y => 
        \BLKB_EN[2]\);
    
    \ORB_GATE[3]\ : OR2
      port map(A => \ENABLE_ADDRB[3]\, B => WEBP, Y => 
        \BLKB_EN[3]\);
    
    \MX2_RD[4]\ : MX2
      port map(A => MX2_22_Y, B => MX2_18_Y, S => BUFF_4_Y, Y => 
        RD(4));
    
    MX2_16 : MX2
      port map(A => \QX_TEMPR0[6]\, B => \QX_TEMPR1[6]\, S => 
        BUFF_2_Y, Y => MX2_16_Y);
    
    MX2_2 : MX2
      port map(A => \QX_TEMPR0[10]\, B => \QX_TEMPR1[10]\, S => 
        BUFF_3_Y, Y => MX2_2_Y);
    
    \READEN_BFF1[0]\ : DFN1
      port map(D => \READB_EN[0]\, CLK => RCLK, Q => 
        \READB_EN_2[0]\);
    
    \ORB_GATE[1]\ : OR2
      port map(A => \ENABLE_ADDRB[1]\, B => WEBP, Y => 
        \BLKB_EN[1]\);
    
    MX2_1 : MX2
      port map(A => \QX_TEMPR0[9]\, B => \QX_TEMPR1[9]\, S => 
        BUFF_3_Y, Y => MX2_1_Y);
    
    \MX2_RD[10]\ : MX2
      port map(A => MX2_2_Y, B => MX2_12_Y, S => BUFF_0_Y, Y => 
        RD(10));
>>>>>>> e296f02de89eba86bbe678e34dace66c718d9223
    
    WEBUBBLEA : INV
      port map(A => WEN, Y => WEAP);
    
<<<<<<< HEAD
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
=======
    \ORA_GATE[2]\ : OR2
      port map(A => \ENABLE_ADDRA[2]\, B => WEAP, Y => 
        \BLKA_EN[2]\);
    
    \NAND2_ENABLE_ADDRB[3]\ : NAND2
      port map(A => RADDR(9), B => RADDR(8), Y => 
        \ENABLE_ADDRB[3]\);
    
    \ORA_GATE[3]\ : OR2
      port map(A => \ENABLE_ADDRA[3]\, B => WEAP, Y => 
        \BLKA_EN[3]\);
    
    \READEN_BFF1[3]\ : DFN1
      port map(D => \READB_EN[3]\, CLK => RCLK, Q => 
        \READB_EN_2[3]\);
    
    MX2_0 : MX2
      port map(A => \QX_TEMPR2[9]\, B => \QX_TEMPR3[9]\, S => 
        BUFF_3_Y, Y => MX2_0_Y);
    
    BUFF_1 : BUFF
      port map(A => \ADDRB_FF2[0]\, Y => BUFF_1_Y);
    
    \OR2_ENABLE_ADDRB[0]\ : OR2
      port map(A => RADDR(9), B => RADDR(8), Y => 
        \ENABLE_ADDRB[0]\);
    
    \MX2_RD[8]\ : MX2
      port map(A => MX2_4_Y, B => MX2_6_Y, S => BUFF_0_Y, Y => 
        RD(8));
    
    \MX2_RD[7]\ : MX2
      port map(A => MX2_19_Y, B => MX2_11_Y, S => BUFF_0_Y, Y => 
        RD(7));
    
    \ORA_GATE[1]\ : OR2
      port map(A => \ENABLE_ADDRA[1]\, B => WEAP, Y => 
        \BLKA_EN[1]\);
    
    MX2_5 : MX2
      port map(A => \QX_TEMPR2[11]\, B => \QX_TEMPR3[11]\, S => 
        BUFF_3_Y, Y => MX2_5_Y);
    
    \READEN_BFF1[2]\ : DFN1
      port map(D => \READB_EN[2]\, CLK => RCLK, Q => 
        \READB_EN_2[2]\);
    
    MX2_14 : MX2
      port map(A => \QX_TEMPR2[6]\, B => \QX_TEMPR3[6]\, S => 
        BUFF_2_Y, Y => MX2_14_Y);
    
    MX2_9 : MX2
      port map(A => \QX_TEMPR2[2]\, B => \QX_TEMPR3[2]\, S => 
        BUFF_1_Y, Y => MX2_9_Y);
    
    \INVB_READ_EN_GATE[2]\ : INV
      port map(A => WEBP, Y => \READB_EN[2]\);
    
    MX2_4 : MX2
      port map(A => \QX_TEMPR0[8]\, B => \QX_TEMPR1[8]\, S => 
        BUFF_3_Y, Y => MX2_4_Y);
    
    \OR2A_ENABLE_ADDRA[2]\ : OR2A
      port map(A => WADDR(9), B => WADDR(8), Y => 
        \ENABLE_ADDRA[2]\);
    
    \NAND2_ENABLE_ADDRA[3]\ : NAND2
      port map(A => WADDR(9), B => WADDR(8), Y => 
        \ENABLE_ADDRA[3]\);
    
    \MX2_RD[0]\ : MX2
      port map(A => MX2_15_Y, B => MX2_10_Y, S => BUFF_4_Y, Y => 
        RD(0));
    
    WEBUBBLEB : INV
      port map(A => REN, Y => WEBP);
    
    \READEN_BFF1[1]\ : DFN1
      port map(D => \READB_EN[1]\, CLK => RCLK, Q => 
        \READB_EN_2[1]\);
    
    \OR2A_ENABLE_ADDRB[2]\ : OR2A
      port map(A => RADDR(9), B => RADDR(8), Y => 
        \ENABLE_ADDRB[2]\);
    
    \MX2_RD[9]\ : MX2
      port map(A => MX2_1_Y, B => MX2_0_Y, S => BUFF_0_Y, Y => 
        RD(9));
    
    Ram_scaling_R3C0 : RAM512X18
      port map(RADDR8 => \GND\, RADDR7 => RADDR(7), RADDR6 => 
        RADDR(6), RADDR5 => RADDR(5), RADDR4 => RADDR(4), RADDR3
         => RADDR(3), RADDR2 => RADDR(2), RADDR1 => RADDR(1), 
        RADDR0 => RADDR(0), WADDR8 => \GND\, WADDR7 => WADDR(7), 
        WADDR6 => WADDR(6), WADDR5 => WADDR(5), WADDR4 => 
        WADDR(4), WADDR3 => WADDR(3), WADDR2 => WADDR(2), WADDR1
         => WADDR(1), WADDR0 => WADDR(0), WD17 => \GND\, WD16 => 
        \GND\, WD15 => \GND\, WD14 => \GND\, WD13 => \GND\, WD12
         => \GND\, WD11 => WD(11), WD10 => WD(10), WD9 => WD(9), 
        WD8 => WD(8), WD7 => WD(7), WD6 => WD(6), WD5 => WD(5), 
        WD4 => WD(4), WD3 => WD(3), WD2 => WD(2), WD1 => WD(1), 
        WD0 => WD(0), RW0 => \GND\, RW1 => \VCC\, WW0 => \GND\, 
        WW1 => \VCC\, PIPE => \VCC\, REN => \BLKB_EN[3]\, WEN => 
        \BLKA_EN[3]\, RCLK => RCLK, WCLK => WCLK, RESET => RESETP, 
        RD17 => OPEN, RD16 => OPEN, RD15 => OPEN, RD14 => OPEN, 
        RD13 => OPEN, RD12 => OPEN, RD11 => \QX_TEMPR3[11]\, RD10
         => \QX_TEMPR3[10]\, RD9 => \QX_TEMPR3[9]\, RD8 => 
        \QX_TEMPR3[8]\, RD7 => \QX_TEMPR3[7]\, RD6 => 
        \QX_TEMPR3[6]\, RD5 => \QX_TEMPR3[5]\, RD4 => 
        \QX_TEMPR3[4]\, RD3 => \QX_TEMPR3[3]\, RD2 => 
        \QX_TEMPR3[2]\, RD1 => \QX_TEMPR3[1]\, RD0 => 
        \QX_TEMPR3[0]\);
    
    \BFF1[0]\ : DFN1
      port map(D => RADDR(8), CLK => RCLK, Q => \ADDRB_FF1[0]\);
    
    \MX2_RD[6]\ : MX2
      port map(A => MX2_16_Y, B => MX2_14_Y, S => BUFF_0_Y, Y => 
        RD(6));
    
    \OR2A_ENABLE_ADDRA[1]\ : OR2A
      port map(A => WADDR(8), B => WADDR(9), Y => 
        \ENABLE_ADDRA[1]\);
    
    MX2_23 : MX2
      port map(A => \QX_TEMPR0[5]\, B => \QX_TEMPR1[5]\, S => 
        BUFF_2_Y, Y => MX2_23_Y);
    
    \BFF2[1]\ : DFN1E1C0
      port map(D => \ADDRB_FF1[1]\, CLK => RCLK, CLR => RESETP, E
         => \READB_EN_2[1]\, Q => \ADDRB_FF2[1]\);
    
    MX2_6 : MX2
      port map(A => \QX_TEMPR2[8]\, B => \QX_TEMPR3[8]\, S => 
        BUFF_3_Y, Y => MX2_6_Y);
    
    \BFF1[1]\ : DFN1
      port map(D => RADDR(9), CLK => RCLK, Q => \ADDRB_FF1[1]\);
    
    \ORB_GATE[0]\ : OR2
      port map(A => \ENABLE_ADDRB[0]\, B => WEBP, Y => 
        \BLKB_EN[0]\);
    
    MX2_13 : MX2
      port map(A => \QX_TEMPR0[2]\, B => \QX_TEMPR1[2]\, S => 
        BUFF_1_Y, Y => MX2_13_Y);
    
    \BFF2[0]\ : DFN1E1C0
      port map(D => \ADDRB_FF1[0]\, CLK => RCLK, CLR => RESETP, E
         => \READB_EN_2[0]\, Q => \ADDRB_FF2[0]\);
    
    \INVB_READ_EN_GATE[3]\ : INV
      port map(A => WEBP, Y => \READB_EN[3]\);
    
    \MX2_RD[3]\ : MX2
      port map(A => MX2_21_Y, B => MX2_8_Y, S => BUFF_4_Y, Y => 
        RD(3));
    
    MX2_17 : MX2
      port map(A => \QX_TEMPR0[11]\, B => \QX_TEMPR1[11]\, S => 
        BUFF_3_Y, Y => MX2_17_Y);
    
    \INVB_READ_EN_GATE[0]\ : INV
      port map(A => WEBP, Y => \READB_EN[0]\);
    
    Ram_scaling_R2C0 : RAM512X18
      port map(RADDR8 => \GND\, RADDR7 => RADDR(7), RADDR6 => 
        RADDR(6), RADDR5 => RADDR(5), RADDR4 => RADDR(4), RADDR3
         => RADDR(3), RADDR2 => RADDR(2), RADDR1 => RADDR(1), 
        RADDR0 => RADDR(0), WADDR8 => \GND\, WADDR7 => WADDR(7), 
        WADDR6 => WADDR(6), WADDR5 => WADDR(5), WADDR4 => 
        WADDR(4), WADDR3 => WADDR(3), WADDR2 => WADDR(2), WADDR1
         => WADDR(1), WADDR0 => WADDR(0), WD17 => \GND\, WD16 => 
        \GND\, WD15 => \GND\, WD14 => \GND\, WD13 => \GND\, WD12
         => \GND\, WD11 => WD(11), WD10 => WD(10), WD9 => WD(9), 
        WD8 => WD(8), WD7 => WD(7), WD6 => WD(6), WD5 => WD(5), 
        WD4 => WD(4), WD3 => WD(3), WD2 => WD(2), WD1 => WD(1), 
        WD0 => WD(0), RW0 => \GND\, RW1 => \VCC\, WW0 => \GND\, 
        WW1 => \VCC\, PIPE => \VCC\, REN => \BLKB_EN[2]\, WEN => 
        \BLKA_EN[2]\, RCLK => RCLK, WCLK => WCLK, RESET => RESETP, 
        RD17 => OPEN, RD16 => OPEN, RD15 => OPEN, RD14 => OPEN, 
        RD13 => OPEN, RD12 => OPEN, RD11 => \QX_TEMPR2[11]\, RD10
         => \QX_TEMPR2[10]\, RD9 => \QX_TEMPR2[9]\, RD8 => 
        \QX_TEMPR2[8]\, RD7 => \QX_TEMPR2[7]\, RD6 => 
        \QX_TEMPR2[6]\, RD5 => \QX_TEMPR2[5]\, RD4 => 
        \QX_TEMPR2[4]\, RD3 => \QX_TEMPR2[3]\, RD2 => 
        \QX_TEMPR2[2]\, RD1 => \QX_TEMPR2[1]\, RD0 => 
        \QX_TEMPR2[0]\);
    
    MX2_21 : MX2
      port map(A => \QX_TEMPR0[3]\, B => \QX_TEMPR1[3]\, S => 
        BUFF_1_Y, Y => MX2_21_Y);
    
    MX2_22 : MX2
      port map(A => \QX_TEMPR0[4]\, B => \QX_TEMPR1[4]\, S => 
        BUFF_2_Y, Y => MX2_22_Y);
    
    Ram_scaling_R0C0 : RAM512X18
      port map(RADDR8 => \GND\, RADDR7 => RADDR(7), RADDR6 => 
        RADDR(6), RADDR5 => RADDR(5), RADDR4 => RADDR(4), RADDR3
         => RADDR(3), RADDR2 => RADDR(2), RADDR1 => RADDR(1), 
        RADDR0 => RADDR(0), WADDR8 => \GND\, WADDR7 => WADDR(7), 
        WADDR6 => WADDR(6), WADDR5 => WADDR(5), WADDR4 => 
        WADDR(4), WADDR3 => WADDR(3), WADDR2 => WADDR(2), WADDR1
         => WADDR(1), WADDR0 => WADDR(0), WD17 => \GND\, WD16 => 
        \GND\, WD15 => \GND\, WD14 => \GND\, WD13 => \GND\, WD12
         => \GND\, WD11 => WD(11), WD10 => WD(10), WD9 => WD(9), 
        WD8 => WD(8), WD7 => WD(7), WD6 => WD(6), WD5 => WD(5), 
        WD4 => WD(4), WD3 => WD(3), WD2 => WD(2), WD1 => WD(1), 
        WD0 => WD(0), RW0 => \GND\, RW1 => \VCC\, WW0 => \GND\, 
        WW1 => \VCC\, PIPE => \VCC\, REN => \BLKB_EN[0]\, WEN => 
        \BLKA_EN[0]\, RCLK => RCLK, WCLK => WCLK, RESET => RESETP, 
        RD17 => OPEN, RD16 => OPEN, RD15 => OPEN, RD14 => OPEN, 
        RD13 => OPEN, RD12 => OPEN, RD11 => \QX_TEMPR0[11]\, RD10
         => \QX_TEMPR0[10]\, RD9 => \QX_TEMPR0[9]\, RD8 => 
        \QX_TEMPR0[8]\, RD7 => \QX_TEMPR0[7]\, RD6 => 
        \QX_TEMPR0[6]\, RD5 => \QX_TEMPR0[5]\, RD4 => 
        \QX_TEMPR0[4]\, RD3 => \QX_TEMPR0[3]\, RD2 => 
        \QX_TEMPR0[2]\, RD1 => \QX_TEMPR0[1]\, RD0 => 
        \QX_TEMPR0[0]\);
    
    \OR2A_ENABLE_ADDRB[1]\ : OR2A
      port map(A => RADDR(8), B => RADDR(9), Y => 
        \ENABLE_ADDRB[1]\);
    
    MX2_20 : MX2
      port map(A => \QX_TEMPR0[1]\, B => \QX_TEMPR1[1]\, S => 
        BUFF_1_Y, Y => MX2_20_Y);
    
    MX2_19 : MX2
      port map(A => \QX_TEMPR0[7]\, B => \QX_TEMPR1[7]\, S => 
        BUFF_2_Y, Y => MX2_19_Y);
    
    \MX2_RD[1]\ : MX2
      port map(A => MX2_20_Y, B => MX2_7_Y, S => BUFF_4_Y, Y => 
        RD(1));
    
    BUFF_4 : BUFF
      port map(A => \ADDRB_FF2[1]\, Y => BUFF_4_Y);
    
    RESETBUBBLE : INV
      port map(A => RESET, Y => RESETP);
    
    BUFF_3 : BUFF
      port map(A => \ADDRB_FF2[0]\, Y => BUFF_3_Y);
    
    MX2_3 : MX2
      port map(A => \QX_TEMPR2[5]\, B => \QX_TEMPR3[5]\, S => 
        BUFF_2_Y, Y => MX2_3_Y);
    
    MX2_8 : MX2
      port map(A => \QX_TEMPR2[3]\, B => \QX_TEMPR3[3]\, S => 
        BUFF_1_Y, Y => MX2_8_Y);
    
    MX2_11 : MX2
      port map(A => \QX_TEMPR2[7]\, B => \QX_TEMPR3[7]\, S => 
        BUFF_2_Y, Y => MX2_11_Y);
    
    BUFF_2 : BUFF
      port map(A => \ADDRB_FF2[0]\, Y => BUFF_2_Y);
>>>>>>> e296f02de89eba86bbe678e34dace66c718d9223
    
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
<<<<<<< HEAD
-- DESDIR:G:/ACTELL/EKB/EKB_v1/EKB/Libero/smartgen\Ram_scaling
=======
-- DESDIR:G:/ACTELL/EKB/EKB/Libero/smartgen\Ram_scaling
>>>>>>> e296f02de89eba86bbe678e34dace66c718d9223
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
<<<<<<< HEAD
-- CASCADE:0
=======
-- CASCADE:1
>>>>>>> e296f02de89eba86bbe678e34dace66c718d9223
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

