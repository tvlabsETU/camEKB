library ieee;

use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.CONSTANTS.all;

entity Control_reciever is
------------------------------------модуль приема данных IMX------------------
port (
	CLK_RX_Serial		: in std_logic;  									-- CLK Parallel
	CLK_RX_Parallel		: in std_logic;  									-- CLK Parallel
	DATA_RX_Parallel	: in STD_LOGIC_VECTOR (bit_data_CSI-1 DOWNTO 0);	-- видео данные 
	MAIN_reset			: in std_logic;  									-- reset
	MAIN_reset0			: in std_logic;  									-- reset
	MAIN_ENABLE			: in std_logic;  									-- ENABLE
	Sync_flag			: in std_logic;  									-- ENABLE
	valid_data			: out std_logic;  									-- reset
	Phase_shift			: out std_logic;  									-- ENABLE
	allign_byte			: out std_logic_vector (1 downto 0); 				-- отладка
	N_clk				: out std_logic_vector (3 downto 0) 				-- reset
		);
end Control_reciever;



architecture beh of Control_reciever is 


component  sync_word is
------------------------------------модуль приема данных IMX----------------
port (
	CLK_RX_Serial			: in std_logic;  									-- CLK Parallel
	CLK_RX_Parallel			: in std_logic;  									-- CLK Parallel
	DATA_RX_Parallel		: in STD_LOGIC_VECTOR (bit_data_CSI-1 DOWNTO 0);	-- видео данные 
	MAIN_ENABLE				: in std_logic;  									-- ENABLE
	MAIN_reset				: in std_logic;  									-- reset
	Sync_flag				: in std_logic;  									-- reset
	valid_data				: out std_logic;  									-- reset
	flag_sync_word_catch	: out std_logic  									-- reset
		);
end component;
signal flag_sync_word_catch		: std_logic:='0';
----------------------------------счетчик -----------------------
component count_n_modul
generic (n		: integer);
port (
		clk,
		reset,
		en			:	in std_logic;
		modul		: 	in std_logic_vector (n-1 downto 0);
		qout		: 	out std_logic_vector (n-1 downto 0);
		cout		:	out std_logic);
end component;


signal sync_word_catch         : std_logic:='0';
-- signal allign_byte_i_0		: integer range 0 to 3:=0;
signal cnt_ph				: integer range 0 to 30:=0;

type  stp_type is ( st00, st00_1, st0_1, st0_2, st1_1, st1_2, st2_1, st2_2, st3_1, st3_2 );
signal stp          : stp_type;

signal N_i_clk		: integer range 0 to 15:=0;

signal Sync_flag_0         : std_logic:='0';
signal Sync_flag_1         : std_logic:='0';
signal Sync_flag_2         : std_logic:='0';

signal Sync_flag_q: std_logic_vector (31 downto 0):=(Others => '0');
signal allign_byte_i_0: std_logic_vector (1 downto 0):=(Others => '0');


begin


sync_word_catch0: sync_word                    
port map (
			CLK_RX_Serial			=>	CLK_RX_Serial,			
			CLK_RX_Parallel			=>	CLK_RX_Parallel,			
			DATA_RX_Parallel		=>	DATA_RX_Parallel,
			MAIN_reset				=>	MAIN_reset,	
			MAIN_ENABLE				=>	MAIN_ENABLE,	
			Sync_flag				=> 	Sync_flag_q(5),
			valid_data				=> 	valid_data,
			flag_sync_word_catch	=>	flag_sync_word_catch);
			
			
			
Process(CLK_RX_Parallel)
begin
if rising_edge(CLK_RX_Parallel) then
	Sync_flag_q(0)	<=Sync_flag;
	for ii in 0 to 30 loop
		Sync_flag_q(ii+1) <= Sync_flag_q(ii);
	end loop;  end if;
end process;

Process(CLK_RX_Parallel,MAIN_reset)
begin

	if MAIN_reset='1'	then
		allign_byte_i_0	<=	"00";
		stp				<=	st00;
		cnt_ph			<=	0;
		N_i_clk			<=	0;
		Phase_shift		<=	'0';
	elsif	rising_edge (CLK_RX_Parallel) then
		case( stp ) is
		
			when st00 => --  проверка какой канал сихронизировался
				if Sync_flag	= '1'	then
					if		 flag_sync_word_catch ='0'	then	stp	<=	st0_1;		-- работаем с первым каналом
					else										stp	<=	st00;	
					end if;	
				end if;
------------------------------------------------------------------------------------------------------------
			when st0_1 => -- изменяем последрвательность байт синхронизации			
					if 	allign_byte_i_0 < "11"	then
						allign_byte_i_0	<=		std_logic_vector(to_unsigned(	to_integer(unsigned (allign_byte_i_0))+1,2))	;
						stp	<=	st00;
					else
						allign_byte_i_0	<=	"00";
						stp	<=	st0_2;	-- байт не найден. Нужно жвагать тактовый сигнал по фазе
					end if;

			when st0_2 => -- сдвиг по фазе тактовый сигнал в первом канале
					if 	N_i_clk < 7	then
						N_i_clk			<=	N_i_clk+1;
						stp	<=	st00;	-- байт не найден. Нужно жвагать тактовый сигнал по фазе
					else
						N_i_clk	<=	0;
						stp	<=	st00;	-- байт не найден. Нужно жвагать тактовый сигнал по фазе
					end if;

------------------------------------------------------------------------------------------------------------

			when others => -- что то делаем, например ждём a=0
				null;

			end case;
	end if;
-- end if;
end process;
-----------------------------------
allign_byte		<=allign_byte_i_0;
N_clk			<=std_logic_vector(to_unsigned(N_i_clk,4));









end ;
