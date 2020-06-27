library ieee;

use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.VIDEO_CONSTANTS.all;
use work.My_component_pkg.all;
----------------------------------------------------------------------
-- модуль приема DDR данных по 1 каналу
-- в зависимости от разрядности данных от фотоприемника 
-- в зависимости от bit_data существует 4/5/6 вариантов для захвата правильность последовательности
-- align_load - перебираются до тех по пока трубеумы условия для синхронизации не выполнятся
----------------------------------------------------------------------
entity RX_DDR_CH is
generic  (bit_data	: integer);
port (
	clk_rx_Serial		: in std_logic;  										-- CLK Serial
	data_rx_Serial		: in std_logic;				-- видео данные DDR
	main_reset			: in std_logic;  										-- reset
	main_enable			: in std_logic;  										-- ENABLE
	align_load			: in std_logic_vector (2 downto 0);				-- сдвиг момент выборки 
	data_rx_Parallel	: out std_logic_vector (bit_data-1 downto 0)	-- принятый сигнал							  	 														  		
		);
end RX_DDR_CH;

architecture beh of RX_DDR_CH is 
signal VIDEO_CH_0_reg		: std_logic_vector (bit_data-1 downto 0):=(others => '0');
signal CH_0_QR_reg			: std_logic:='0';
signal pattern_load			: std_logic:='0';
signal load_q					: std_logic_vector (2 downto 0):=(others => '0');
signal CH_0_QR					: std_logic;	
signal CH_0_QF					: std_logic;	
signal CH_0_QF_i				: std_logic;	

begin
----------------------------------------------------------------------
---прием DDR сигнала
----------------------------------------------------------------------
Process(clk_rx_Serial)
begin
if rising_edge (clk_rx_Serial) then
	CH_0_QR	<=	data_rx_Serial;
	end if;
end process;
Process(clk_rx_Serial)
begin
if falling_edge (clk_rx_Serial) then
	CH_0_QF_i	<=	data_rx_Serial;
	end if;
end process;
Process(clk_rx_Serial)
begin
if clk_rx_Serial='1' then
	CH_0_QF	<=	CH_0_QF_i;
	end if;
end process;
Process(clk_rx_Serial)
begin
if rising_edge (clk_rx_Serial) then
	CH_0_QR_reg			<=	CH_0_QR;
	VIDEO_CH_0_reg		<=	CH_0_QF 		& CH_0_QR_reg  &  VIDEO_CH_0_reg(bit_data-1 downto 2) ;
end if;
end process;
----------------------------------------------------------------------
---счетчик тактов для возможности перебора момента захвата паралелльного слова
----------------------------------------------------------------------
load_q0: count_n_modul                    
generic map (3) 
port map (
			clk		=>	clk_rx_Serial,			
			reset		=>	main_reset ,
			en			=>	main_enable,		
			modul		=> std_logic_vector(to_unsigned(bit_data /2,3)),
			qout		=>	load_q
			);
----------------------------------------------------------------------
---захват параллельного слова на основе 
----------------------------------------------------------------------
Process(clk_rx_Serial)
begin
if rising_edge (clk_rx_Serial) then
	if  load_q(2 downto 0)	=	align_load then
		pattern_load	<='1';
	else
		pattern_load	<='0';
	end if;
	
	if pattern_load='1' then
		data_rx_Parallel	<=	VIDEO_CH_0_reg;
	end if;
end if;
end process;


end ;
