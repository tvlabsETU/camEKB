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
	DCK_IS					: in std_logic;  	-- CLK from IS
	CLK						: in std_logic;  	-- CLK from generator
	MAIN_reset				: in std_logic;  	-- reset
	MAIN_ENABLE				: in std_logic;  	-- ENABLE
	CLK_RX_Serial_ch		: out std_logic;	-- CLK ser for LVDS
	CLK_RX_Parallel_ch	: out std_logic	-- CLK pix per channel					  	 														  		
		);
end IS_rx_clk_gen;

architecture beh of IS_rx_clk_gen is 

signal div_clk_DCK      : std_logic_vector (2 downto 0):=(Others => '0');
signal CLK_RX_Serial		: std_logic:='0';
begin
--------------------------------------------------------------------
-- блок генерации тактовых частот без использования PLL
-- данный блок только  для ProAsic
-- !! требует описания constrain !!
--------------------------------------------------------------------
CLK_RX_Serial_ch		<= DCK_IS;
CLK_RX_Serial		   <= DCK_IS;

div_clk_q0: count_n_modul                    
generic map (3) 
port map (
   clk      =>	CLK_RX_Serial,			
   reset		=>	MAIN_reset ,
   en			=>	MAIN_ENABLE,		
   modul		=> std_logic_vector(to_unsigned(bit_data_imx /2, 3)),
   qout		=>	div_clk_DCK);

Process(CLK_RX_Serial)
begin
if rising_edge(CLK_RX_Serial) then
   if  to_integer(unsigned (div_clk_DCK)) >=bit_data_imx /4 then
      CLK_RX_Parallel_ch   <= '1';
      CLK_RX_Parallel_ch   <= '0';
   end if;
end if;
end process;
--------------------------------------------------------------------
end ;
