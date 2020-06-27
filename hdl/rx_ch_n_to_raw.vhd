library ieee;

use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.VIDEO_CONSTANTS.all;
use work.My_component_pkg.all;
----------------------------------------------------------------------
-- ?????? ??????????????????? 1/2/4 ??????? ?? ???????????? ? RAW
-- ? ???????????  ?? ?????????? ????????? ???????????? 
-- ??? FIFO ?????? ??????? ?? 8 ???? ???  two port RAM
-- ??? ?????? ?????????? ????????? ????? ???????? ?????? FIFO/ RAM
----------------------------------------------------------------------
entity rx_ch_n_to_raw is
port (
	main_reset			: in std_logic;  										-- reset
	main_enable			: in std_logic;  										-- ENABLE
   CLK_sys			   : in std_logic;   										-- ???????? 
	ena_clk_x_q_IS		: in std_logic_vector (3 downto 0); 				-- ?????????? ??????? /2 /4 /8/ 16
	qout_clk_IS		   : in std_logic_vector (bit_pix-1 downto 0); 		-- ??????? ????????
   clk_rx_Parallel	: in std_logic;  										-- CLK Parallel
   data_rx_ch_0		: in std_logic_vector (bit_data_imx-1 DOWNTO 0);	-- ????? ?????? 
   data_rx_ch_1		: in std_logic_vector (bit_data_imx-1 DOWNTO 0);	-- ????? ?????? 
   data_rx_ch_2		: in std_logic_vector (bit_data_imx-1 DOWNTO 0);	-- ????? ?????? 
   data_rx_ch_3		: in std_logic_vector (bit_data_imx-1 DOWNTO 0);	-- ????? ?????? 
	data_rx_raw    	: out std_logic_vector (bit_data_imx-1 downto 0)	-- ???????? ??????							  	 														  		
		);
end rx_ch_n_to_raw;

architecture beh of rx_ch_n_to_raw is 
----------------------------------------------------------------------
-- ?????? ????-???????? RAM ??? ProAsic
----------------------------------------------------------------------
component two_port_RAM is
port(	WD    : in	std_logic_vector(11 downto 0);
		WEN   : in	std_logic;
		REN   : in	std_logic;
		WADDR : in	std_logic;
		RADDR : in	std_logic;
		WCLK  : in	std_logic;
		RCLK  : in	std_logic;
		RESET : in	std_logic;
		RD    : out	std_logic_vector(11 downto 0)
		);
end component;

signal ram_data_rx_ch_0	: std_logic_vector (bit_data_imx-1 downto 0);
signal ram_data_rx_ch_1	: std_logic_vector (bit_data_imx-1 downto 0);
signal ram_data_rx_ch_2	: std_logic_vector (bit_data_imx-1 downto 0);
signal ram_data_rx_ch_3	: std_logic_vector (bit_data_imx-1 downto 0);
signal rd_ena_clk				: std_logic:='0';
signal flag_FF					: std_logic:='0';
signal mux_ch					: std_logic_vector (1 downto 0);
signal sel_pix					: std_logic_vector (1 downto 0);
signal cnt_pix_in_ff			: std_logic_vector (2 downto 0);

begin
----------------------------------------------------------------------
-- ??????? ?????????? ??? ?????? ?? RAM ? ??????????? ?? ???-?? ???????
----------------------------------------------------------------------
Process(CLK_sys)
begin
if rising_edge(CLK_sys) then
	case  mode_IMAGE_SENSOR(3 downto 0)	is
		when x"0"	=>	rd_ena_clk		<= '1';			
		when x"1"	=>	rd_ena_clk		<= '1';			
		when x"2"	=>	rd_ena_clk		<= ena_clk_x_q_IS(0);			
		when x"3"	=>	rd_ena_clk		<= ena_clk_x_q_IS(1);			
		WHEN others	=>	rd_ena_clk		<= '1';			
		END case;	
	end if;
end process;
----------------------------------------------------------------------
-- ?????? RAM ??? ???????? ? ?????? ???????? ?????
----------------------------------------------------------------------



two_port_RAM_q0: two_port_RAM   
port map (
		-- Inputs
	WD    	=> data_rx_ch_0,
	WEN   	=> '1',	
	REN   	=> rd_ena_clk,	
	WADDR 	=> ram_waddr,	
	RADDR 	=> ram_raddr,	
	WCLK  	=> clk_rx_Parallel,	
	RCLK  	=> CLK_sys,	
	RESET 	=> main_reset,	
		-- Outputs
	Q			=> ram_data_rx_ch_0);	
two_port_RAM_q1: two_port_RAM   
port map (
		-- Inputs
	WD    	=> data_rx_ch_1,
	WEN   	=> '1',	
	REN   	=> rd_ena_clk,	
	WADDR 	=> ram_waddr,	
	RADDR 	=> ram_raddr,	
	WCLK  	=> clk_rx_Parallel,	
	RCLK  	=> CLK_sys,	
	RESET 	=> main_reset,	
		-- Outputs
	Q			=> ram_data_rx_ch_1);	
two_port_RAM_q2: two_port_RAM   
port map (
		-- Inputs
	WD    	=> data_rx_ch_2,
	WEN   	=> '1',	
	REN   	=> rd_ena_clk,	
	WADDR 	=> ram_waddr,	
	RADDR 	=> ram_raddr,	
	WCLK  	=> clk_rx_Parallel,	
	RCLK  	=> CLK_sys,	
	RESET 	=> main_reset,	
		-- Outputs
	Q			=> ram_data_rx_ch_2);	
two_port_RAM_q3: two_port_RAM   
port map (
		-- Inputs
	WD    	=> data_rx_ch_3,
	WEN   	=> '1',	
	REN   	=> rd_ena_clk,	
	WADDR 	=> ram_waddr,	
	RADDR 	=> ram_raddr,	
	WCLK  	=> clk_rx_Parallel,	
	RCLK  	=> CLK_sys,	
	RESET 	=> main_reset,	
		-- Outputs
	Q			=> ram_data_rx_ch_3);	
----------------------------------------------------------------------
----------------------------------------------------------------------
-- ??????????????????? 1/2/4 ??????? ? RAW ??????
----------------------------------------------------------------------
Process(CLK_sys)
begin
if rising_edge(CLK_sys) then
	sel_pix <= qout_clk_IS(1 downto 0);
	case  mode_IMAGE_SENSOR(3 downto 0)	is
		when x"0"	=>	
			data_rx_raw		<= fifo_data_rx_ch_0;	
		when x"1"	=>	
			data_rx_raw		<= fifo_data_rx_ch_0;		
		when x"2"	=>	
			if sel_pix(1)	='0'	then
				data_rx_raw		<= fifo_data_rx_ch_0;			
			else
				data_rx_raw		<= fifo_data_rx_ch_1;			
			end if;
		when x"3"	=>	
			case sel_pix is
				when "10" =>	data_rx_raw		<= fifo_data_rx_ch_0;			
				when "11" =>	data_rx_raw		<= fifo_data_rx_ch_1;			
				when "00" =>	data_rx_raw		<= fifo_data_rx_ch_2;			
				when "01" =>	data_rx_raw		<= fifo_data_rx_ch_3;			
				when others =>
					null;
			end case; 
		when others =>
			data_rx_raw		<= fifo_data_rx_ch_0;			
		END case;	
	end if;
end process;


-- Process(CLK_sys)
-- begin
-- if rising_edge(CLK_sys) then
-- 	if rd_ena_clk='1' then
-- 		if fifo_data_rx_ch_0 = std_logic_vector(to_unsigned(2**bit_data_imx-1, bit_data_imx))  then
-- 			flag_FF   <= '0';
-- 		else
-- 			flag_FF   <= '1';
-- 		end if;
-- 	end if;
-- end if;
-- end process;

-- flag_FF_q0: count_n_modul                    
-- generic map (3) 
-- port map (
--    clk      =>	CLK_sys,			
--    reset		=>	flag_FF ,
--    en			=>	'1',		
--    modul		=> std_logic_vector(to_unsigned(8, 3)),
--    qout		=>	cnt_pix_in_ff);


-- Process(CLK_sys)
-- begin
-- if rising_edge(CLK_sys) then
-- 	if main_reset='1'	then
-- 		mux_ch	<="00";
-- 	else
-- 		if flag_FF	='0' and cnt_pix_in_ff = "000" then
-- 			case sel_pix is
-- 				when "00" =>	mux_ch	<="00";
-- 				when "01" =>	mux_ch	<="01";
-- 				when "10" =>	mux_ch	<="10";
-- 				when "11" =>	mux_ch	<="11";
-- 				when others =>
-- 					null;
-- 			end case;
-- 		end if;
-- 	end if;
-- end if;
-- end process;



end ;
