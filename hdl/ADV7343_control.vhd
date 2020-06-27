library ieee;

use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.VIDEO_CONSTANTS.all;
use work.My_component_pkg.all;
----------------------------------------------------------------------
---?????? ?????????? ADV7343
----------------------------------------------------------------------
entity ADV7343_control is
port (
------------------------------------??????? ???????-----------------------
	CLK				: in std_logic;  											-- ???????? ?? ?????????
	reset				: in std_logic;  											-- ?????
	main_enable		: in std_logic;  											-- ?????????? ??????
	qout_clk	    	: in	std_logic_vector (bit_pix-1 downto 0); 	-- ??????? ????????
   qout_v			: in	std_logic_vector (bit_strok-1 downto 0); 	-- ??????? ?????
	ena_clk_x_q		: in	std_logic_vector (3 downto 0); 				-- ?????????? ??????? /2 /4 /8/ 16
   data_in     	: in std_logic_vector (7 downto 0);             -- ????? ??????
	------------------------------------???????? ???????----------------------
   DAC_Y				:out std_logic_vector(7 downto 0);
   DAC_PHSYNC		:out std_logic;
   DAC_PVSYNC		:out std_logic;
   DAC_PBLK			:out std_logic;
   DAC_LF1			:out std_logic;
   DAC_LF2			:out std_logic;
   DAC_SDA			:out std_logic;
   DAC_SCL			:out std_logic;
   DAC_CLK			:out std_logic;
   DAC_SFL			:out std_logic
      );
end ADV7343_control;

architecture beh of ADV7343_control is 
signal dac_pblk_v				: std_logic:='0';		
signal dac_pblk_h				: std_logic:='0';		

begin

----------------------------------------------------------------------
-- ???????????? ???????????????
----------------------------------------------------------------------
Process(CLK)
begin
if rising_edge(CLK) then

   if to_integer(unsigned(qout_V)) >=EKD_ADV7343_1080p25.VsyncShift 
      and to_integer(unsigned(qout_V)) < EKD_ADV7343_1080p25.VsyncShift + EKD_ADV7343_1080p25.VsyncWidth then
         dac_pvsync  <= '0';
      else
         dac_pvsync  <= '1';
   end if;

   if to_integer(unsigned(qout_clk)) >=EKD_ADV7343_1080p25.HsyncShift 
      and to_integer(unsigned(qout_clk)) < EKD_ADV7343_1080p25.HsyncShift + EKD_ADV7343_1080p25.HsyncWidth then
         dac_phsync  <= '0';
      else
         dac_phsync  <= '1';
   end if;

   if to_integer(unsigned(qout_V)) >=EKD_ADV7343_1080p25.VsyncShift + EKD_ADV7343_1080p25.InActiveLine -  EKD_ADV7343_1080p25.VsyncWidth
      and to_integer(unsigned(qout_V)) < EKD_ADV7343_1080p25.VsyncShift + EKD_ADV7343_1080p25.InActiveLine -  EKD_ADV7343_1080p25.VsyncWidth + EKD_ADV7343_1080p25.ActiveLine  then
         dac_pblk_v  <= '1';
      else
         dac_pblk_v  <= '0';
   end if;

   if to_integer(unsigned(qout_clk)) >=EKD_ADV7343_1080p25.HsyncShift + EKD_ADV7343_1080p25.HsyncWidthGapRight 
      and to_integer(unsigned(qout_clk)) < EKD_ADV7343_1080p25.HsyncShift + EKD_ADV7343_1080p25.HsyncWidthGapRight  + EKD_ADV7343_1080p25.ActivePixPerLine  then
         dac_pblk_h  <= '1';
      else
         dac_pblk_h  <= '0';
   end if;
end if;
end process;
DAC_PBLK <= dac_pblk_v and dac_pblk_h;
----------------------------------------------------------------------




end ;

