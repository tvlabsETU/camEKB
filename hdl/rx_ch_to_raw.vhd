library ieee;

use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.VIDEO_CONSTANTS.all;
use work.My_component_pkg.all;
----------------------------------------------------------------------
-- модуль мультиплексирвоания принятых данных по 1/2/4 каналам от ФП 
-- для перехода в тактовый домен используется двух портовая память RAM
-- в данной  проекте ProAsic
----------------------------------------------------------------------
entity rx_ch_to_raw is
generic  (
	PixPerLine			: integer;
	HsyncShift			: integer;
	ActivePixPerLine	: integer
	);
port (
	main_reset			: in std_logic;  												-- reset
	main_enable			: in std_logic;  												-- ENABLE
	CLK_sys			   : in std_logic;   											-- тактовый 
	ena_clk_x_q_IS		: in std_logic_vector (3 downto 0); 					-- разрешение частоты /2 /4 /8/ 16
	qout_clk_IS		   : in std_logic_vector (bit_pix-1 downto 0);			-- счетчик пикселей
	clk_rx_Parallel	: in std_logic;  												-- CLK Parallel
	cnt_imx_word_rx	: in std_logic_vector (bit_pix-1 DOWNTO 0);			-- счетчик слов от IMX по 1 каналу
	valid_data_rx		: in std_logic;												-- валидные данные по 1 каналу
	data_rx_ch_0		: in std_logic_vector (bit_data_imx-1 DOWNTO 0);	-- видео данные 
	data_rx_ch_1		: in std_logic_vector (bit_data_imx-1 DOWNTO 0);	-- видео данные 
	data_rx_ch_2		: in std_logic_vector (bit_data_imx-1 DOWNTO 0);	-- видео данные 
	data_rx_ch_3		: in std_logic_vector (bit_data_imx-1 DOWNTO 0);	-- видео данные 
	data_rx_raw    	: out std_logic_vector (bit_data_imx-1 downto 0)	-- принятый сигнал					  	 														  		
		);
end rx_ch_to_raw;

architecture beh of rx_ch_to_raw is 
----------------------------------------------------------------------
-- двух портовая память RAM ProAsic
----------------------------------------------------------------------
component two_port_RAM is
port(	WD    : in    std_logic_vector(12 downto 0);
		RD    : out   std_logic_vector(12 downto 0);
		WEN   : in    std_logic;
		REN   : in    std_logic;
		WADDR : in    std_logic_vector(8 downto 0);
		RADDR : in    std_logic_vector(8 downto 0);
		WCLK  : in    std_logic;
		RCLK  : in    std_logic;
		RESET : in    std_logic
	);
end component;
signal reset_ram_waddr	: std_logic:='0';
signal reset_ram_raddr	: std_logic:='0';
signal valid_ram_raddr	: std_logic:='0';
signal ram_raddr			: std_logic_vector (bit_pix-1 downto 0);
signal ram_waddr			: std_logic_vector (bit_pix-1 downto 0);
signal ram_data_rx_ch_0	: std_logic_vector (bit_data_imx downto 0);
signal ram_data_rx_ch_1	: std_logic_vector (bit_data_imx downto 0);
-- signal ram_data_rx_ch_2	: std_logic_vector (bit_data_imx-1 downto 0);
-- signal ram_data_rx_ch_3	: std_logic_vector (bit_data_imx-1 downto 0);
signal data_rx_ch_0_w	: std_logic_vector (bit_data_imx downto 0);
signal data_rx_ch_1_w	: std_logic_vector (bit_data_imx downto 0);
signal data_rx_ch_2_w	: std_logic_vector (bit_data_imx downto 0);
signal data_rx_ch_3_w	: std_logic_vector (bit_data_imx downto 0);

signal data_rx_ch_0_1_w	: std_logic_vector (bit_data_imx downto 0);
signal data_rx_ch_2_3_w	: std_logic_vector (bit_data_imx downto 0);

----------------------------------------------------------------------
signal rd_ena_clk				: std_logic:='0';
signal sel_pix					: std_logic_vector (1 downto 0);

begin
----------------------------------------------------------------------
-- скорость чтения из памяти сокрашяется в 2/4/8 в зависимости от количества каналов
----------------------------------------------------------------------
rd_ena_clk		<= ena_clk_x_q_IS(0);	

-- Process(CLK_sys)
-- begin
-- if rising_edge(CLK_sys) then
-- 	case  mode_IMAGE_SENSOR(3 downto 0)	is
-- 		when x"0"	=>	rd_ena_clk		<= '1';			
-- 		when x"1"	=>	rd_ena_clk		<= '1';			
-- 		when x"2"	=>	rd_ena_clk		<= ena_clk_x_q_IS(0);			
-- 		when x"3"	=>	rd_ena_clk		<= ena_clk_x_q_IS(1);			
-- 		WHEN others	=>	rd_ena_clk		<= '1';			
-- 		END case;	
-- 	end if;
-- end process;
----------------------------------------------------------------------
-- сигналы управления для памяти RAM
----------------------------------------------------------------------
		-- сигналы для записи
Process(clk_rx_Parallel)
begin
if rising_edge(clk_rx_Parallel) then
	if to_integer(unsigned (cnt_imx_word_rx)) =1	then
		reset_ram_waddr	<= '1';
	else
		reset_ram_waddr	<= '0';
	end if;
end if;
end process;

ram_waddr_q: count_n_modul	-- шина адреса для записи   
generic map (bit_pix) 
port map (
	clk		=>	clk_rx_Parallel,			
	reset		=>	reset_ram_waddr ,
	en			=>	valid_data_rx,		
	modul		=>	std_logic_vector(to_unsigned(PixPerLine, bit_pix))  ,
	qout		=>	ram_waddr);

Process(clk_rx_Parallel)
begin
if rising_edge(clk_rx_Parallel) then
	data_rx_ch_0_w		<= '0' & data_rx_ch_0;
	data_rx_ch_1_w		<= '0' & data_rx_ch_1;
	data_rx_ch_2_w		<= '0' & data_rx_ch_2;
	data_rx_ch_3_w		<= '0' & data_rx_ch_3;
	data_rx_ch_0_1_w	<=	std_logic_vector(unsigned (data_rx_ch_0_w) + unsigned (data_rx_ch_1_w));
	data_rx_ch_2_3_w	<=	std_logic_vector(unsigned (data_rx_ch_2_w) + unsigned (data_rx_ch_3_w));
	end if;
end process;


----------------------------------------------------------------------
		-- сигналы для чтения
Process(CLK_sys)
begin
if rising_edge(CLK_sys) then
	if to_integer(unsigned (qout_clk_IS)) =1	then
		reset_ram_raddr	<= '1';
	else
		reset_ram_raddr	<= '0';
	end if;

	if rd_ena_clk='1' then
		if to_integer(unsigned (qout_clk_IS)) >= HsyncShift and to_integer(unsigned (qout_clk_IS)) < HsyncShift + ActivePixPerLine/2	then
				valid_ram_raddr	<= '1';
			else
				valid_ram_raddr	<= '0';
		end if;
	else
		valid_ram_raddr	<= '0';
	end if;

end if;
end process;

ram_raddr_q: count_n_modul	--шина адреса для чтения      
generic map (bit_pix) 
port map (
	clk		=>	CLK_sys,			
	reset		=>	reset_ram_raddr ,
	en			=>	valid_ram_raddr,		
	modul		=>	std_logic_vector(to_unsigned(PixPerLine, bit_pix))  ,
	qout		=>	ram_raddr);
----------------------------------------------------------------------

----------------------------------------------------------------------
-- буфер для перехода в другой тактовый домен через двух портовую память
----------------------------------------------------------------------
two_port_RAM_q0: two_port_RAM   
port map (
		-- Inputs
	WD    	=> data_rx_ch_0_1_w,
	WEN   	=> '1',	
	REN   	=> rd_ena_clk,	
	WADDR 	=> ram_waddr(bit_RAM_1_str-1 downto 0),	
	RADDR 	=> ram_raddr(bit_RAM_1_str-1 downto 0),		
	WCLK  	=> clk_rx_Parallel,	
	RCLK  	=> CLK_sys,	
	RESET 	=> main_reset,	
		-- Outputs
	RD			=> ram_data_rx_ch_0);

two_port_RAM_q1: two_port_RAM   
port map (
		-- Inputs
	WD    	=> data_rx_ch_2_3_w,
	WEN   	=> '1',	
	REN   	=> rd_ena_clk,	
	WADDR 	=> ram_waddr(bit_RAM_1_str-1 downto 0),	
	RADDR 	=> ram_raddr(bit_RAM_1_str-1 downto 0),		
	WCLK  	=> clk_rx_Parallel,	
	RCLK  	=> CLK_sys,	
	RESET 	=> main_reset,	
		-- Outputs
	RD			=> ram_data_rx_ch_1);	
----------------------------------------------------------------------

----------------------------------------------------------------------
-- мультиплексирования  1/2/4 каналов
----------------------------------------------------------------------
Process(CLK_sys)
begin
if rising_edge(CLK_sys) then
	if qout_clk_IS(0)	then
		data_rx_raw		<= ram_data_rx_ch_0(12 downto 1);			
	else
		data_rx_raw		<= ram_data_rx_ch_1(12 downto 1);			
	end if;
end if;
end process;

end ;
