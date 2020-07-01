-- Version: v11.8 SP3 11.8.3.6

library ieee;
use ieee.std_logic_1164.all;
library proasic3l;
use proasic3l.all;

entity ddr_data_imx is

    port( PADP : in    std_logic_vector(3 downto 0);
          PADN : in    std_logic_vector(3 downto 0);
          Y    : out   std_logic_vector(3 downto 0)
        );

end ddr_data_imx;

architecture DEF_ARCH of ddr_data_imx is 

  component INBUF_LVDS
    port( PADP : in    std_logic := 'U';
          PADN : in    std_logic := 'U';
          Y    : out   std_logic
        );
  end component;


begin 


    \INBUF_LVDS[0]\ : INBUF_LVDS
      port map(PADP => PADP(0), PADN => PADN(0), Y => Y(0));
    
    \INBUF_LVDS[2]\ : INBUF_LVDS
      port map(PADP => PADP(2), PADN => PADN(2), Y => Y(2));
    
    \INBUF_LVDS[1]\ : INBUF_LVDS
      port map(PADP => PADP(1), PADN => PADN(1), Y => Y(1));
    
    \INBUF_LVDS[3]\ : INBUF_LVDS
      port map(PADP => PADP(3), PADN => PADN(3), Y => Y(3));
    

end DEF_ARCH; 

-- _Disclaimer: Please leave the following comments in the file, they are for internal purposes only._


-- _GEN_File_Contents_

-- Version:11.8.3.6
-- ACTGENU_CALL:1
-- BATCH:T
-- FAM:PA3LDP
-- OUTFORMAT:VHDL
-- LPMTYPE:LPM_IO_INBUF
-- LPM_HINT:INBUF_SP
-- INSERT_PAD:NO
-- INSERT_IOREG:NO
-- GEN_BHV_VHDL_VAL:F
-- GEN_BHV_VERILOG_VAL:F
-- MGNTIMER:F
-- MGNCMPL:T
-- DESDIR:G:/ACTELL/EKB/EKB/Libero/smartgen\ddr_data_imx
-- GEN_BEHV_MODULE:F
-- SMARTGEN_DIE:IT14X14M4LDP
-- SMARTGEN_PACKAGE:fg484
-- AGENIII_IS_SUBPROJECT_LIBERO:T
-- WIDTH:4
-- TYPE:LVDS
-- TRIEN_POLARITY:0
-- CLR_POLARITY:0

-- _End_Comments_

