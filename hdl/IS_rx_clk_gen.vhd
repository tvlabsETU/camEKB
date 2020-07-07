library ieee;

use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.VIDEO_CONSTANTS.all;
use work.My_component_pkg.all;
----------------------------------------------------------------------
-- модуль генерации тактовых частот 
-- для приема данных от фотоприемника в режиме LVDS
-- для Cyclone необходимо использовать PLL с динамической подстройкой фазы
-- для Igloo2 	необходимо использовать PLL с динамической подстройкой фазы
-- для ProAsic	напрямую используется сигнла от фотоприемника
-- пиксельная частота на канал зависит от разрядности данных в 4 / 5 / 6 раз ниже  
----------------------------------------------------------------------
entity IS_rx_clk_gen is
port (
	dck_is					: in std_logic;  	-- CLK from IS
	CLK						: in std_logic;  	-- CLK from generator
	main_reset				: in std_logic;  	-- reset
	main_enable				: in std_logic;  	-- ENABLE
	clk_rx_Serial_ch		: out std_logic;	-- CLK ser for LVDS
	clk_rx_Parallel_ch	: out std_logic	-- CLK pix per channel					  	 														  		
		);
end IS_rx_clk_gen;

architecture beh of IS_rx_clk_gen is 

signal div_clk_DCK      : std_logic_vector (2 downto 0):=(Others => '0');
signal clk_rx_Serial		: std_logic:='0';

Component pll_imx_dck is
port( POWERDOWN : in    std_logic;
      CLKA      : in    std_logic;
      LOCK      : out   std_logic;
      GLA       : out   std_logic
      );

end Component;

begin
--------------------------------------------------------------------
-- блок генерации тактовых частот без использования PLL
-- данный блок только  для ProAsic
-- !! требует описания constrain !!
--------------------------------------------------------------------
-- clk_rx_Serial_ch		<= dck_is;
-- clk_rx_Serial		   <= dck_is;

pll_imx_dck_q0: pll_imx_dck                    
port map (
   POWERDOWN   =>	'1',			
   CLKA		   =>	dck_is ,
   -- LOCK        =>	main_enable,		
   GLA		   => clk_rx_Serial);
clk_rx_Serial_ch		<= clk_rx_Serial;


image_sensor_RX_LVDS_q/IS_rx_clk_gen_q/pll_imx_dck_q0/Core:CLKA
div_clk_q0: count_n_modul                    
generic map (3) 
port map (
   clk      =>	clk_rx_Serial,			
   reset		=>	main_reset ,
   en			=>	main_enable,		
   modul		=> std_logic_vector(to_unsigned(bit_data_imx /2, 3)),
   qout		=>	div_clk_DCK);

Process(clk_rx_Serial)
begin
if rising_edge(clk_rx_Serial) then
   if  to_integer(unsigned (div_clk_DCK)) >=bit_data_imx /4 then
      clk_rx_Parallel_ch   <= '1';
   else
      clk_rx_Parallel_ch   <= '0';
   end if;
end if;
end process;
--------------------------------------------------------------------
end ;
