library ieee;

use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.CONSTANTS.all;

entity  sync_word is
------------------------------------модуль приема данных IMX-----------------------------------------------------
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
end sync_word;


architecture beh of sync_word is 

type ram_byf is array (0 to 4) of std_logic_vector (bit_data_CSI-1 downto 0)	;
signal DATA_RX_Parallel_in_q : ram_byf := (others => (others => '0'));
signal word_align: std_logic_vector (39 downto 0);

signal cnt_imx_word_i: std_logic_vector (11 downto 0);
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

signal DATA_RX_Parallel_in_q_1: std_logic_vector (bit_data_CSI-1 downto 0);
signal DATA_RX_Parallel_in_q_2: std_logic_vector (bit_data_CSI-1 downto 0);
signal DATA_RX_Parallel_in_q_3: std_logic_vector (bit_data_CSI-1 downto 0);
signal DATA_RX_Parallel_in_q_4: std_logic_vector (bit_data_CSI-1 downto 0);
signal DATA_RX_Parallel_in_q_5: std_logic_vector (bit_data_CSI-1 downto 0);



begin



p_Shift_0 : process (CLK_RX_Parallel)
begin
if rising_edge(CLK_RX_Parallel) then
	-- word_align	<=x"FF301c2bb8";
	word_align	<=x"00071c2bb8";
	DATA_RX_Parallel_in_q(0)	<=	DATA_RX_Parallel;
	for ii in 0 to 3 loop
		DATA_RX_Parallel_in_q(ii+1) <= DATA_RX_Parallel_in_q(ii);
	end loop;  
	
end if;
end process;

	

p_Shift_1 : process (CLK_RX_Serial,MAIN_reset)
begin

	if	rising_edge(CLK_RX_Serial) then
		if MAIN_reset='1'	then
			flag_sync_word_catch	<='0';		
		else
			if Sync_flag='1' 	then	
				flag_sync_word_catch	<='0';
			else	 		
				if DATA_RX_Parallel_in_q(0) &	DATA_RX_Parallel_in_q(1) &	DATA_RX_Parallel_in_q(2) &	DATA_RX_Parallel_in_q(3) &	DATA_RX_Parallel_in_q(4)	= word_align	then
						flag_sync_word_catch	<='1';
				end if;
			end if;
		end if;
	end if;
end process;
end ;
