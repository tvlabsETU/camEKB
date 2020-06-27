library ieee;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.VIDEO_CONSTANTS.all;
use work.My_component_pkg.all;
--------------------------------------------------------
-- модуль синхронизации данных для 4 каналов
-- для каждого канала ищется в полседовательнисти пикселей нужный TRS код
-- если код не найден то:
-- сдвигается align_load для каждого канала ProAsic/Cyclone/Igloo2
-- меняется фаза клова для каждого канала Cyclone/Igloo2  !! нужно дописать при необходимости
--------------------------------------------------------
entity  sync_word_4ch is
generic  (bit_data	: integer);
port (
	clk_rx_Parallel	: in std_logic;  										-- CLK Parallel
	data_rx_ch_0		: in std_logic_vector (bit_data-1 DOWNTO 0);	-- видео данные 
	data_rx_ch_1		: in std_logic_vector (bit_data-1 DOWNTO 0);	-- видео данные 
	data_rx_ch_2		: in std_logic_vector (bit_data-1 DOWNTO 0);	-- видео данные 
	data_rx_ch_3		: in std_logic_vector (bit_data-1 DOWNTO 0);	-- видео данные 
	main_enable			: in std_logic;  										-- reset
	main_reset			: in std_logic;  										-- reset
	
	cnt_imx_word_rx	: out std_logic_vector (bit_pix-1 DOWNTO 0);	-- reset
	valid_data_rx		: out std_logic;										-- reset
	align_load_0		: out std_logic_vector (2 DOWNTO 0); 			-- reset
	align_load_1 		: out std_logic_vector (2 DOWNTO 0); 			-- reset
	align_load_2 		: out std_logic_vector (2 DOWNTO 0); 			-- reset
	align_load_3 		: out std_logic_vector (2 DOWNTO 0)  			-- reset
		);
end sync_word_4ch;


architecture beh of sync_word_4ch is 

type  stp_type is ( st00, st00_1, st0_1, st0_2, st1_1, st1_2, st2_1, st2_2, st3_1, st3_2 );
signal stp          : stp_type;
type ram_byf is array (0 to 3) of std_logic_vector (bit_data-1 downto 0)	;
signal data_rx_ch_0_q 			: ram_byf := (others => (others => '0'));
signal data_rx_ch_1_q 			: ram_byf := (others => (others => '0'));
signal data_rx_ch_2_q 			: ram_byf := (others => (others => '0'));
signal data_rx_ch_3_q 			: ram_byf := (others => (others => '0'));
signal word_align_SAV_valid	: std_logic_vector (bit_data*4-1 downto 0);
signal word_align_EAV_valid	: std_logic_vector (bit_data*4-1 downto 0);
signal word_align_SAV_invalid	: std_logic_vector (bit_data*4-1 downto 0);
signal word_align_EAV_invalid	: std_logic_vector (bit_data*4-1 downto 0);
signal word_ch_1					: std_logic_vector (bit_data*4-1 downto 0);
signal word_ch_2					: std_logic_vector (bit_data*4-1 downto 0);
signal word_ch_3					: std_logic_vector (bit_data*4-1 downto 0);
signal word_ch_4					: std_logic_vector (bit_data*4-1 downto 0);
signal catch_align				: std_logic_vector (3 downto 0);
--------------------------------------------------------
--TRS коды от IMX
--------------------------------------------------------
signal TRS_F0_V0_H0				: std_logic_vector (bit_data-1 downto 0);
signal TRS_F0_V0_H1				: std_logic_vector (bit_data-1 downto 0);
signal TRS_F0_V1_H0				: std_logic_vector (bit_data-1 downto 0);
signal TRS_F0_V1_H1				: std_logic_vector (bit_data-1 downto 0);
signal TRS_SYNC_3FF				: std_logic_vector (bit_data-1 downto 0);
signal TRS_SYNC_0					: std_logic_vector (bit_data-1 downto 0);
-- signal cnt_imx_word_rx			: std_logic_vector (bit_pix-1 downto 0);
signal Sync_flag					: std_logic:='0';
signal align_done					: std_logic:='0';

begin

cnt_imx_word0: count_n_modul                    
generic map (bit_pix) 
port map (
	clk			=>	clk_rx_Parallel,			
	reset			=>	main_reset ,
	en				=>	main_enable,		
	modul			=>	std_logic_vector(to_unsigned(EKD_2200_1250p50.PixPerLine / N_channel_imx, bit_pix)),
	qout			=>	cnt_imx_word_rx,
	cout			=>	Sync_flag
	);
---------------------------------------------------
---модуль генерации TRS кодов для IMX
---------------------------------------------------
TRS_gen_q: TRS_gen                    
generic map (bit_data) 
port map (
	CLK				=>	clk_rx_Parallel,		
   TRS_SYNC_3FF   => TRS_SYNC_3FF,
   TRS_SYNC_0     => TRS_SYNC_0  ,
   TRS_F0_V0_H0   => TRS_F0_V0_H0,
   TRS_F0_V0_H1   => TRS_F0_V0_H1,
   TRS_F0_V1_H0   => TRS_F0_V1_H0,
   TRS_F0_V1_H1   => TRS_F0_V1_H1
	);
word_align_SAV_valid		<=TRS_F0_V0_H0 & TRS_SYNC_0 & TRS_SYNC_0 & TRS_SYNC_3FF;	-- SAV
word_align_EAV_valid		<=TRS_F0_V0_H1 & TRS_SYNC_0 & TRS_SYNC_0 & TRS_SYNC_3FF;	-- EAV
word_align_SAV_invalid	<=TRS_F0_V1_H0 & TRS_SYNC_0 & TRS_SYNC_0 & TRS_SYNC_3FF;	-- SAV
word_align_EAV_invalid	<=TRS_F0_V1_H1 & TRS_SYNC_0 & TRS_SYNC_0 & TRS_SYNC_3FF;	-- EAV

---------------------------------------------------
-- формирование слова из 4 пикселей для каждого из 4-х каналов
---------------------------------------------------
process (clk_rx_Parallel)
begin
if rising_edge(clk_rx_Parallel) then
	data_rx_ch_0_q(0)	<=	data_rx_ch_0;
	for ii in 0 to 2 loop
		data_rx_ch_0_q(ii+1) <= data_rx_ch_0_q(ii);
	end loop;  
	data_rx_ch_1_q(0)	<=	data_rx_ch_1;
	for ii in 0 to 2 loop
		data_rx_ch_1_q(ii+1) <= data_rx_ch_1_q(ii);
	end loop;  
	data_rx_ch_2_q(0)	<=	data_rx_ch_2;
	for ii in 0 to 2 loop
		data_rx_ch_2_q(ii+1) <= data_rx_ch_2_q(ii);
	end loop;  
	data_rx_ch_3_q(0)	<=	data_rx_ch_3;
	for ii in 0 to 2 loop
		data_rx_ch_3_q(ii+1) <= data_rx_ch_3_q(ii);
	end loop;  
end if;
end process;
process (clk_rx_Parallel)
begin
if rising_edge(clk_rx_Parallel) then
	word_ch_1 <= data_rx_ch_0_q(0) &	data_rx_ch_0_q(1) & data_rx_ch_0_q(2) & data_rx_ch_0_q(3);
	word_ch_2 <= data_rx_ch_1_q(0) &	data_rx_ch_1_q(1) & data_rx_ch_1_q(2) & data_rx_ch_1_q(3);
	word_ch_3 <= data_rx_ch_2_q(0) &	data_rx_ch_2_q(1) & data_rx_ch_2_q(2) & data_rx_ch_2_q(3);
	word_ch_4 <= data_rx_ch_3_q(0) &	data_rx_ch_3_q(1) & data_rx_ch_3_q(2) & data_rx_ch_3_q(3);
end if;
end process;
---------------------------------------------------


---------------------------------------------------
-- проверка на ключевое слово
---------------------------------------------------
process (clk_rx_Parallel,main_reset)
begin
if	rising_edge(clk_rx_Parallel) then
	if main_reset='1'	then
		catch_align	<=x"0";		
	else
		if Sync_flag='1' 	then	
		catch_align	<=x"0";		
		else	 		
			if	 	word_ch_1	= word_align_SAV_valid 		then	catch_align(0)	<='1';
			elsif	word_ch_1	= word_align_SAV_invalid	then	catch_align(0)	<='1';
			end if;
			if	 	word_ch_2	= word_align_SAV_valid 		then	catch_align(1)	<='1';
			elsif	word_ch_2	= word_align_SAV_invalid	then	catch_align(1)	<='1';
			end if;
			if	 	word_ch_3	= word_align_SAV_valid 		then	catch_align(2)	<='1';
			elsif	word_ch_3	= word_align_SAV_invalid	then	catch_align(2)	<='1';
			end if;
			if	 	word_ch_4	= word_align_SAV_valid 		then	catch_align(3)	<='1';
			elsif	word_ch_4	= word_align_SAV_invalid	then	catch_align(3)	<='1';
			end if;
		end if;
	end if;
end if;
end process;

---------------------------------------------------
-- конечный автома управления 
---------------------------------------------------
Process(clk_rx_Parallel,main_reset)
begin
if	rising_edge (clk_rx_Parallel) then
	if main_reset='1'	then
		align_load_0		<=	"000";
		align_load_1		<=	"000";
		align_load_2		<=	"000";
		align_load_3		<=	"000";
		align_done			<=	'0';
		stp					<=	st00;
	else
		case( stp ) is
			when st00 => --  проверка какой канал сихронизировался
				if Sync_flag	= '1'	then
					if		 catch_align(0) ='0'	then	stp	<=	st0_1;		-- работаем с 1 каналом
					elsif	 catch_align(1) ='0'	then	stp	<=	st1_1;		-- работаем с 2 каналом
					elsif	 catch_align(2) ='0'	then	stp	<=	st2_1;		-- работаем с 3 каналом
					elsif	 catch_align(3) ='0'	then	stp	<=	st3_1;		-- работаем с 4 каналом
					else										stp	<=	st00;		align_done	<='1';
					end if;	
				end if;
			--------------------------------управление для канала 1-----------------------------
			when st0_1 => -- изменяем последрвательность байт синхронизации			
					if align_load_0 < "111"	then
						align_load_0	<=		std_logic_vector(unsigned (align_load_0)+1);
						stp	<=	st00;
					else
						align_load_0	<=	"000";
						stp	<=	st00;	-- байт не найден. поиск продолжаем
					end if;
			--------------------------------управление для канала 2-----------------------------
			when st1_1 => -- изменяем последрвательность байт синхронизации			
					if align_load_1 < "111"	then
						align_load_1	<=		std_logic_vector(unsigned (align_load_1)+1);
						stp	<=	st00;
					else
						align_load_1	<=	"000";
						stp	<=	st00;	-- байт не найден. поиск продолжаем
					end if;
			--------------------------------управление для канала 3-----------------------------
			when st2_1 => -- изменяем последрвательность байт синхронизации			
					if align_load_2 < "111"	then
						align_load_2	<=		std_logic_vector(unsigned (align_load_2)+1);
						stp	<=	st00;
					else
						align_load_2	<=	"000";
						stp	<=	st00;	-- байт не найден. поиск продолжаем
					end if;
			--------------------------------управление для канала 4-----------------------------
			when st3_1 => -- изменяем последрвательность байт синхронизации			
					if align_load_3 < "111"	then
						align_load_3	<=		std_logic_vector(unsigned (align_load_3)+1);
						stp	<=	st00;
					else
						align_load_3	<=	"000";
						stp	<=	st00;	-- байт не найден. поиск продолжаем
					end if;
			when others => -- что то делаем, например ждём a=0
				null;
			end case;
	end if;
end if;
end process;
-----------------------------------


valid_data_rx




end ;
