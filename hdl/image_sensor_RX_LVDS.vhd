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
	IS_CH				: in STD_LOGIC_VECTOR (3 DOWNTO 0);	-- данные от 1 ФП 
	DCK_IS			: in std_logic; 							-- CLK от 1 ФП  
	XVS				: in std_logic; 
	XHS				: in std_logic; 
	---------Other------------
	CLK_sys			: in std_logic;   										-- тактовый 
	reset_1			: in std_logic;  											-- сигнал сброса
	reset_2			: in std_logic;  											-- сигнал сброса
	MAIN_ENABLE		: in std_logic;  											-- разрешение работы
	Mode_debug		: in std_logic_vector (7 downto 0); 				-- отладка
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
	DCK_IS					: in std_logic;  	-- CLK from IS
	CLK						: in std_logic;  	-- CLK from generator
	MAIN_reset				: in std_logic;  	-- reset
	MAIN_ENABLE				: in std_logic;  	-- ENABLE
	CLK_RX_Serial_ch		: out std_logic;	-- CLK ser for LVDS
	CLK_RX_Parallel_ch	: out std_logic	-- CLK pix per channel					  	 														  		
		);
end component;
signal CLK_RX_Serial_ch		: std_logic:='0';
signal CLK_RX_Parallel_ch	: std_logic:='0';
----------------------------------------------------------------------
-- модуль приема DDR данных по 1 каналу
----------------------------------------------------------------------
component RX_DDR_CH is
generic  (bit_data	: integer);
port (
	CLK_RX_Serial		: in std_logic;  										-- CLK Serial
	DATA_RX_Serial		: in std_logic;				-- видео данные DDR
	MAIN_reset			: in std_logic;  										-- reset
	MAIN_ENABLE			: in std_logic;  										-- ENABLE
	align_load			: in std_logic_vector (2 downto 0);				-- сдвиг момент выборки 
	DATA_RX_Parallel	: out std_logic_vector (bit_data-1 downto 0)	-- принятый сигнал							  	 														  		
		);
end component;
signal align_load	: std_logic_vector (2 downto 0):=(Others => '0');
signal DATA_RX_ch_0	: std_logic_vector (bit_data_imx-1 downto 0):=(Others => '0');
signal DATA_RX_ch_1	: std_logic_vector (bit_data_imx-1 downto 0):=(Others => '0');
signal DATA_RX_ch_2	: std_logic_vector (bit_data_imx-1 downto 0):=(Others => '0');
signal DATA_RX_ch_3	: std_logic_vector (bit_data_imx-1 downto 0):=(Others => '0');
----------------------------------------------------------------------
-- модуль синхронизации данных для 4 каналов
----------------------------------------------------------------------
component  sync_word_4ch is
generic  (bit_data	: integer);
port (
   CLK_RX_Parallel	: in std_logic;  										-- CLK Parallel
   DATA_RX_ch_0		: in STD_LOGIC_VECTOR (bit_data-1 DOWNTO 0);	-- видео данные 
   DATA_RX_ch_1		: in STD_LOGIC_VECTOR (bit_data-1 DOWNTO 0);	-- видео данные 
   DATA_RX_ch_2		: in STD_LOGIC_VECTOR (bit_data-1 DOWNTO 0);	-- видео данные 
   DATA_RX_ch_3		: in STD_LOGIC_VECTOR (bit_data-1 DOWNTO 0);	-- видео данные 
   MAIN_ENABLE			: in std_logic;  										-- reset
   MAIN_reset			: in std_logic;  										-- reset
   align_load_0		: out STD_LOGIC_VECTOR (2 DOWNTO 0); 			-- reset
   align_load_1		: out STD_LOGIC_VECTOR (2 DOWNTO 0); 			-- reset
   align_load_2		: out STD_LOGIC_VECTOR (2 DOWNTO 0); 			-- reset
   align_load_3		: out STD_LOGIC_VECTOR (2 DOWNTO 0)  			-- reset
      );
end component;
signal align_load_0	: std_logic_vector (2 downto 0);
signal align_load_1	: std_logic_vector (2 downto 0);
signal align_load_2	: std_logic_vector (2 downto 0);
signal align_load_3	: std_logic_vector (2 downto 0);

begin

----------------------------------------------------------------------
-- модуль генерации тактовых частот  
----------------------------------------------------------------------
IS_rx_clk_gen_q: IS_rx_clk_gen                   
port map (
		-- Inputs
	DCK_IS					=> DCK_IS,
	CLK						=> '0',	-- не используется для  ProAsic
	MAIN_reset				=> reset_1,	
	MAIN_ENABLE				=> MAIN_ENABLE,	
		-- Outputs
	CLK_RX_Serial_ch		=> CLK_RX_Serial_ch,
	CLK_RX_Parallel_ch	=> CLK_RX_Parallel_ch
);	

----------------------------------------------------------------------
-- модуль приема DDR данных по 1..4 каналу
----------------------------------------------------------------------
RX_DDR_CH_q0: RX_DDR_CH   
generic map (bit_data_imx) 
port map (
		-- Inputs
	CLK_RX_Serial			=> CLK_RX_Serial_ch,
	DATA_RX_Serial			=> IS_CH(0),	
	MAIN_reset				=> reset_2,	
	MAIN_ENABLE				=> MAIN_ENABLE,	
	align_load				=> align_load_0,	
		-- Outputs
	DATA_RX_Parallel		=> DATA_RX_ch_0
);	

RX_DDR_CH_q1: RX_DDR_CH   
generic map (bit_data_imx) 
port map (
		-- Inputs
	CLK_RX_Serial			=> CLK_RX_Serial_ch,
	DATA_RX_Serial			=> IS_CH(1),	
	MAIN_reset				=> reset_2,	
	MAIN_ENABLE				=> MAIN_ENABLE,	
	align_load				=> align_load_1,	
		-- Outputs
	DATA_RX_Parallel		=> DATA_RX_ch_1
);	

RX_DDR_CH_q2: RX_DDR_CH   
generic map (bit_data_imx) 
port map (
		-- Inputs
	CLK_RX_Serial			=> CLK_RX_Serial_ch,
	DATA_RX_Serial			=> IS_CH(2),	
	MAIN_reset				=> reset_2,	
	MAIN_ENABLE				=> MAIN_ENABLE,	
	align_load				=> align_load_2,	
		-- Outputs
	DATA_RX_Parallel		=> DATA_RX_ch_2
);	
RX_DDR_CH_q3: RX_DDR_CH   
generic map (bit_data_imx) 
port map (
		-- Inputs
	CLK_RX_Serial			=> CLK_RX_Serial_ch,
	DATA_RX_Serial			=> IS_CH(3),	
	MAIN_reset				=> reset_2,	
	MAIN_ENABLE				=> MAIN_ENABLE,	
	align_load				=> align_load_3,	
		-- Outputs
	DATA_RX_Parallel		=> DATA_RX_ch_3
);	
----------------------------------------------------------------------
-- модуль синхронизации по 4 каналам
----------------------------------------------------------------------
sync_word_4ch_q: sync_word_4ch   
generic map (bit_data_imx) 
port map (
		-- Inputs
   CLK_RX_Parallel	=> CLK_RX_Parallel_ch,
	DATA_RX_ch_0		=> DATA_RX_ch_0,	
	DATA_RX_ch_1		=> DATA_RX_ch_1,	
	DATA_RX_ch_2		=> DATA_RX_ch_2,	
   DATA_RX_ch_3		=> DATA_RX_ch_3,	
   MAIN_ENABLE		   => MAIN_ENABLE,	
   MAIN_reset		   => reset_2,	
		-- Outputs
	align_load_0		=> align_load_0,
   align_load_1     => align_load_1,
   align_load_2     => align_load_2,
   align_load_3     => align_load_3
);	




end ;
