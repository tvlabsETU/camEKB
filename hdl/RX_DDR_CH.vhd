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
	QR_data_rx_Serial	: in std_logic;				-- видео данные DDR
	QF_data_rx_Serial	: in std_logic;				-- видео данные DDR
	main_reset			: in std_logic;  										-- reset
	main_enable			: in std_logic;  										-- ENABLE
	align_load			: in std_logic_vector (2 downto 0);				-- сдвиг момент выборки 
	data_rx_Parallel	: out std_logic_vector (bit_data-1 downto 0)	-- принятый сигнал							  	 														  		
		);
end RX_DDR_CH;

architecture beh of RX_DDR_CH is 
signal VIDEO_CH_0_reg		: std_logic_vector (bit_data/2-1 downto 0):=(others => '0');
signal VIDEO_CH_0_reg_1		: std_logic_vector (bit_data/2-1 downto 0):=(others => '0');
signal VIDEO_CH_0_reg_2		: std_logic_vector (bit_data/2-1 downto 0):=(others => '0');

signal CH_0_QR_reg			: std_logic:='0';
signal pattern_load			: std_logic:='0';
signal pattern_load_2		: std_logic:='0';

signal load_q					: std_logic_vector (2 downto 0):=(others => '0');
-- signal CH_0_QR					: std_logic;	
-- signal CH_0_QF					: std_logic;	
-- signal CH_0_QF_i				: std_logic;	

begin
----------------------------------------------------------------------
---прием DDR сигнала
----------------------------------------------------------------------
-- Process(clk_rx_Serial)
-- begin
-- if rising_edge (clk_rx_Serial) then
-- 	CH_0_QR	<=	data_rx_Serial;
-- 	end if;
-- end process;
-- Process(clk_rx_Serial)
-- begin
-- if falling_edge (clk_rx_Serial) then
-- 	CH_0_QF_i	<=	data_rx_Serial;
-- 	end if;
-- end process;
-- Process(clk_rx_Serial)
-- begin
-- if clk_rx_Serial='1' then
-- 	CH_0_QF	<=	CH_0_QF_i;
-- 	end if;
-- end process;
Process(clk_rx_Serial)
begin
if rising_edge (clk_rx_Serial) then
	VIDEO_CH_0_reg_1		<=	QF_data_rx_Serial 		& CH_0_QR_reg  &  VIDEO_CH_0_reg_1(bit_data/2-1 downto 2) ;
	CH_0_QR_reg				<=	QR_data_rx_Serial;
	-- VIDEO_CH_0_reg		<=	QF_data_rx_Serial 		& QR_data_rx_Serial  &  VIDEO_CH_0_reg(bit_data-1 downto 2) ;
	-- VIDEO_CH_0_reg		<=	CH_0_QF 		& CH_0_QR_reg  &  VIDEO_CH_0_reg(bit_data-1 downto 2) ;
	-- VIDEO_CH_0_reg		<=	VIDEO_CH_0_reg(bit_data-3 downto 0) & CH_0_QF 		& CH_0_QR_reg;
end if;
end process;

----------------------------------------------------------------------
---счетчик тактов для возможности перебора момента захвата паралелльного слова
----------------------------------------------------------------------
-- load_q0: count_n_modul                    
-- generic map (3) 
-- port map (
-- 			clk		=>	clk_rx_Serial,			
-- 			reset		=>	main_reset ,
-- 			en			=>	main_enable,		
-- 			modul		=> std_logic_vector(to_unsigned(bit_data /2,3)),
-- 			qout		=>	load_q
-- 			);

load_q0: count_fast                    
generic map (3,5) 
port map (
   clk      =>	clk_rx_Serial,			
   reset		=>	main_reset ,
   qout		=>	load_q);
----------------------------------------------------------------------
---захват параллельного слова на основе 
----------------------------------------------------------------------
Process(clk_rx_Serial)
begin
if rising_edge (clk_rx_Serial) then
	-- if  load_q(2 downto 0)	=	align_load then
	case align_load is
		when "000" =>
			if  load_q(2 downto 0)	=	"000" or load_q(2 downto 0)	=	"011"then
				pattern_load_2	<='1';
			else
				pattern_load_2	<='0';
			end if;
		when "001" =>
			if  load_q(2 downto 0)	=	"001" or load_q(2 downto 0)	=	"100" then
				pattern_load_2	<='1';
			else
				pattern_load_2	<='0';
			end if;
		when "010" =>
			if  load_q(2 downto 0)	=	"010" or load_q(2 downto 0)	=	"101"  then
				pattern_load_2	<='1';
			else
				pattern_load_2	<='0';
			end if;
		when "011" =>
			if  load_q(2 downto 0)	=	"000" or load_q(2 downto 0)	=	"011"then
				pattern_load_2	<='1';
			else
				pattern_load_2	<='0';
			end if;
		when "100" =>
			if  load_q(2 downto 0)	=	"001" or load_q(2 downto 0)	=	"100" then
				pattern_load_2	<='1';
			else
				pattern_load_2	<='0';
			end if;
		when "101" =>
			if  load_q(2 downto 0)	=	"010" or load_q(2 downto 0)	=	"101"  then
				pattern_load_2	<='1';
			else
				pattern_load_2	<='0';
			end if;
		when "110" =>
			if  load_q(2 downto 0)	=	"000" or load_q(2 downto 0)	=	"011"then
				pattern_load_2	<='1';
			else
				pattern_load_2	<='0';
			end if;
		when "111" =>
			if  load_q(2 downto 0)	=	"000" or load_q(2 downto 0)	=	"011"then
				pattern_load_2	<='1';
			else
				pattern_load_2	<='0';
			end if;
		when others =>
			null;
	end case;
end if;
end process;


Process(clk_rx_Serial)
begin
if rising_edge (clk_rx_Serial) then
	if pattern_load_2='1' then
		VIDEO_CH_0_reg_2	<=	VIDEO_CH_0_reg_1;
	end if;
end if;
end process;


Process(clk_rx_Serial)
begin
if rising_edge (clk_rx_Serial) then
	-- if  load_q(2 downto 0)	=	align_load then
	case align_load is
		when "000" =>
			if  load_q(2 downto 0)	=	"000" then
				pattern_load	<='1';
			else
				pattern_load	<='0';
			end if;
		when "001" =>
			if  load_q(2 downto 0)	=	"001" then
				pattern_load	<='1';
			else
				pattern_load	<='0';
			end if;
		when "010" =>
			if  load_q(2 downto 0)	=	"010" then
				pattern_load	<='1';
			else
				pattern_load	<='0';
			end if;
		when "011" =>
			if  load_q(2 downto 0)	=	"011" then
				pattern_load	<='1';
			else
				pattern_load	<='0';
			end if;
		when "100" =>
			if  load_q(2 downto 0)	=	"100" then
				pattern_load	<='1';
			else
				pattern_load	<='0';
			end if;
		when "101" =>
			if  load_q(2 downto 0)	=	"101" then
				pattern_load	<='1';
			else
				pattern_load	<='0';
			end if;
		when "110" =>
			if  load_q(2 downto 0)	=	"110" then
				pattern_load	<='1';
			else
				pattern_load	<='0';
			end if;
		when "111" =>
			if  load_q(2 downto 0)	=	"111" then
				pattern_load	<='1';
			else
				pattern_load	<='0';
			end if;
		when others =>
			null;
	end case;
end if;
end process;




Process(clk_rx_Serial)
begin
if rising_edge (clk_rx_Serial) then
	if pattern_load='1' then
		-- data_rx_Parallel	<=	VIDEO_CH_0_reg;
		data_rx_Parallel(0)	<=	VIDEO_CH_0_reg_1(5);
		data_rx_Parallel(1)	<=	VIDEO_CH_0_reg_1(4);
		data_rx_Parallel(2)	<=	VIDEO_CH_0_reg_1(3);
		data_rx_Parallel(3)	<=	VIDEO_CH_0_reg_1(2);
		data_rx_Parallel(4)	<=	VIDEO_CH_0_reg_1(1);
		data_rx_Parallel(5)	<=	VIDEO_CH_0_reg_1(0);
		data_rx_Parallel(6)	<=	VIDEO_CH_0_reg_2(5);
		data_rx_Parallel(7)	<=	VIDEO_CH_0_reg_2(4);
		data_rx_Parallel(8)	<=	VIDEO_CH_0_reg_2(3);
		data_rx_Parallel(9)	<=	VIDEO_CH_0_reg_2(2);
		data_rx_Parallel(10)	<=	VIDEO_CH_0_reg_2(1);
		data_rx_Parallel(11)	<=	VIDEO_CH_0_reg_2(0);
	end if;
end if;
end process;


end ;
