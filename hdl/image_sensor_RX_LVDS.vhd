library ieee;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.VIDEO_CONSTANTS.all;
use work.My_component_pkg.all;
----------------------------------------------------------------------
---модуль приема сигнала изображения от фотоприеника
----------------------------------------------------------------------
entity image_sensor_RX_LVDS is
port (		
			--image sensor IN--
	is_ch				: in std_logic_vector (3 DOWNTO 0);	-- данные от 1 ФП 
	dck_is			: in std_logic; 							-- CLK от 1 ФП  
	XVS				: in std_logic; 
	XHS				: in std_logic; 
	---------Other------------
	CLK_sys			: in std_logic;   										-- тактовый 
	reset_1			: in std_logic;  											-- сигнал сброса
	reset_2			: in std_logic;  											-- сигнал сброса
	main_enable		: in std_logic;  											-- разрешение работы
	Mode_debug		: in std_logic_vector (7 downto 0); 				-- отладка
	ena_clk_x_q_IS	: in std_logic_vector (3 downto 0); 				-- разрешение частоты /2 /4 /8/ 16
	qout_clk_IS		: in std_logic_vector (bit_pix-1 downto 0); 		-- счетчик пикселей
	qout_v_IS		: in  std_logic_vector (bit_strok-1 downto 0); 	-- счетчик строк
	sync_H			: out std_logic;   										-- выходные синхроимпульсы по синхрокодам  		
	sync_V			: out std_logic;    										-- выходные синхроимпульсы по синхрокодам  		
	data_RAW_RX		: out std_logic_vector (bit_data_imx-1 downto 0)-- выходной RAW сигнал					  	 														  		
		);
end image_sensor_RX_LVDS;

architecture beh of image_sensor_RX_LVDS is 
----------------------------------------------------------------------
-- модуль генерации тактовых частот  
----------------------------------------------------------------------
component IS_rx_clk_gen is
port (
	dck_is					: in std_logic;  	-- CLK from IS
	CLK						: in std_logic;  	-- CLK from generator
	main_reset				: in std_logic;  	-- reset
	main_enable				: in std_logic;  	-- ENABLE
	clk_rx_Serial_ch		: out std_logic;	-- CLK ser for LVDS
	clk_rx_Parallel_ch	: out std_logic	-- CLK pix per channel					  	 														  		
		);
end component;
signal clk_rx_Serial_ch		: std_logic:='0';
signal clk_rx_Parallel_ch	: std_logic:='0';
----------------------------------------------------------------------
-- модуль приема DDR данных по 1 каналу
----------------------------------------------------------------------
component RX_DDR_CH is
generic  (bit_data	: integer);
port (
	clk_rx_Serial		: in std_logic;  										-- CLK Serial
	data_rx_Serial		: in std_logic;				-- видео данные DDR
	main_reset			: in std_logic;  										-- reset
	main_enable			: in std_logic;  										-- ENABLE
	align_load			: in std_logic_vector (2 downto 0);				-- сдвиг момент выборки 
	data_rx_Parallel	: out std_logic_vector (bit_data-1 downto 0)	-- принятый сигнал							  	 														  		
		);
end component;
signal align_load	: std_logic_vector (2 downto 0):=(Others => '0');
signal data_rx_ch_0	: std_logic_vector (bit_data_imx-1 downto 0):=(Others => '0');
signal data_rx_ch_1	: std_logic_vector (bit_data_imx-1 downto 0):=(Others => '0');
signal data_rx_ch_2	: std_logic_vector (bit_data_imx-1 downto 0):=(Others => '0');
signal data_rx_ch_3	: std_logic_vector (bit_data_imx-1 downto 0):=(Others => '0');
----------------------------------------------------------------------
-- модуль синхронизации данных для 4 каналов
----------------------------------------------------------------------
component  sync_word_4ch is
generic  (bit_data	: integer);
port (
   clk_rx_Parallel	: in std_logic;  										-- CLK Parallel
   data_rx_ch_0		: in std_logic_vector (bit_data-1 DOWNTO 0);	-- видео данные 
   data_rx_ch_1		: in std_logic_vector (bit_data-1 DOWNTO 0);	-- видео данные 
   data_rx_ch_2		: in std_logic_vector (bit_data-1 DOWNTO 0);	-- видео данные 
   data_rx_ch_3		: in std_logic_vector (bit_data-1 DOWNTO 0);	-- видео данные 
   main_enable			: in std_logic;  										-- reset
   main_reset			: in std_logic;  										-- reset
   align_load_0		: out std_logic_vector (2 DOWNTO 0); 			-- reset
   align_load_1		: out std_logic_vector (2 DOWNTO 0); 			-- reset
   align_load_2		: out std_logic_vector (2 DOWNTO 0); 			-- reset
   align_load_3		: out std_logic_vector (2 DOWNTO 0)  			-- reset
      );
end component;
signal align_load_0	: std_logic_vector (2 downto 0);
signal align_load_1	: std_logic_vector (2 downto 0);
signal align_load_2	: std_logic_vector (2 downto 0);
signal align_load_3	: std_logic_vector (2 downto 0);
----------------------------------------------------------------------
-- модуль мультиплексирования 1/2/4 каналов от фотоприемнка в RAW
----------------------------------------------------------------------
component rx_ch_n_to_raw is
port (
	main_reset			: in std_logic;  										-- reset
	main_enable			: in std_logic;  										-- ENABLE
	CLK_sys			   : in std_logic;   										-- тактовый 
	ena_clk_x_q_IS		: in std_logic_vector (3 downto 0); 				-- разрешение частоты /2 /4 /8/ 16
	qout_clk_IS		   : in std_logic_vector (bit_pix-1 downto 0); 		-- счетчик пикселей
	clk_rx_Parallel	: in std_logic;  										-- CLK Parallel
	data_rx_ch_0		: in std_logic_vector (bit_data_imx-1 DOWNTO 0);	-- видео данные 
	data_rx_ch_1		: in std_logic_vector (bit_data_imx-1 DOWNTO 0);	-- видео данные 
	data_rx_ch_2		: in std_logic_vector (bit_data_imx-1 DOWNTO 0);	-- видео данные 
	data_rx_ch_3		: in std_logic_vector (bit_data_imx-1 DOWNTO 0);	-- видео данные 
	data_rx_raw    	: out std_logic_vector (bit_data_imx-1 downto 0)	-- принятый сигнал							  	 														  		
		);
end component;
signal data_rx_raw	: std_logic_vector (bit_data_imx-1 downto 0);

begin

----------------------------------------------------------------------
-- модуль генерации тактовых частот  
----------------------------------------------------------------------
IS_rx_clk_gen_q: IS_rx_clk_gen                   
port map (
		-- Inputs
	dck_is					=> dck_is,
	CLK						=> '0',	-- не используется для  ProAsic
	main_reset				=> reset_1,	
	main_enable				=> main_enable,	
		-- Outputs
	clk_rx_Serial_ch		=> clk_rx_Serial_ch,
	clk_rx_Parallel_ch	=> clk_rx_Parallel_ch
);	

----------------------------------------------------------------------
-- модуль приема DDR данных по 1..4 каналу
----------------------------------------------------------------------
RX_DDR_CH_q0: RX_DDR_CH   
generic map (bit_data_imx) 
port map (
		-- Inputs
	clk_rx_Serial			=> clk_rx_Serial_ch,
	data_rx_Serial			=> is_ch(0),	
	main_reset				=> reset_2,	
	main_enable				=> main_enable,	
	align_load				=> align_load_0,	
		-- Outputs
	data_rx_Parallel		=> data_rx_ch_0
);	

RX_DDR_CH_q1: RX_DDR_CH   
generic map (bit_data_imx) 
port map (
		-- Inputs
	clk_rx_Serial			=> clk_rx_Serial_ch,
	data_rx_Serial			=> is_ch(1),	
	main_reset				=> reset_2,	
	main_enable				=> main_enable,	
	align_load				=> align_load_1,	
		-- Outputs
	data_rx_Parallel		=> data_rx_ch_1
);	

RX_DDR_CH_q2: RX_DDR_CH   
generic map (bit_data_imx) 
port map (
		-- Inputs
	clk_rx_Serial			=> clk_rx_Serial_ch,
	data_rx_Serial			=> is_ch(2),	
	main_reset				=> reset_2,	
	main_enable				=> main_enable,	
	align_load				=> align_load_2,	
		-- Outputs
	data_rx_Parallel		=> data_rx_ch_2
);	
RX_DDR_CH_q3: RX_DDR_CH   
generic map (bit_data_imx) 
port map (
		-- Inputs
	clk_rx_Serial			=> clk_rx_Serial_ch,
	data_rx_Serial			=> is_ch(3),	
	main_reset				=> reset_2,	
	main_enable				=> main_enable,	
	align_load				=> align_load_3,	
		-- Outputs
	data_rx_Parallel		=> data_rx_ch_3
);	
----------------------------------------------------------------------
-- модуль синхронизации по 4 каналам
----------------------------------------------------------------------
sync_word_4ch_q: sync_word_4ch   
generic map (bit_data_imx) 
port map (
		-- Inputs
   clk_rx_Parallel	=> clk_rx_Parallel_ch,
	data_rx_ch_0		=> data_rx_ch_0,	
	data_rx_ch_1		=> data_rx_ch_1,	
	data_rx_ch_2		=> data_rx_ch_2,	
   data_rx_ch_3		=> data_rx_ch_3,	
   main_enable		   => main_enable,	
   main_reset		   => reset_2,	
		-- Outputs
	align_load_0		=> align_load_0,
   align_load_1     	=> align_load_1,
   align_load_2     	=> align_load_2,
   align_load_3     	=> align_load_3
);	

----------------------------------------------------------------------
-- модуль мультиплексирования 1/2/4 каналов от фотоприемнка в RAW
----------------------------------------------------------------------
rx_ch_n_to_raw_q: rx_ch_n_to_raw   
port map (
		-- Inputs
   main_reset			=> reset_2,
	main_enable			=> main_enable,	
	CLK_sys				=> CLK_sys,	
	ena_clk_x_q_IS		=> ena_clk_x_q_IS,	
   qout_clk_IS			=> qout_clk_IS,	
   clk_rx_Parallel  	=> clk_rx_Parallel_ch,	
   data_rx_ch_0	  	=> data_rx_ch_0,	
   data_rx_ch_1	  	=> data_rx_ch_1,	
   data_rx_ch_2	  	=> data_rx_ch_2,	
   data_rx_ch_3	  	=> data_rx_ch_3,	
		-- Outputs
	data_rx_raw			=> data_rx_raw
);	

end ;
