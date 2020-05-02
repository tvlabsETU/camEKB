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
	allign_load			: in std_logic_vector (2 downto 0);				-- сдвиг момент выборки 
	DATA_RX_Parallel	: out std_logic_vector (bit_data-1 downto 0)	-- принятый сигнал							  	 														  		
		);
end component;
signal allign_load	: std_logic_vector (2 downto 0):=(Others => '0');
signal DATA_RX_ch_0	: std_logic_vector (bit_data_imx-1 downto 0):=(Others => '0');

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
-- модуль приема DDR данных по 1 каналу
----------------------------------------------------------------------
RX_DDR_CH_q0: RX_DDR_CH   
generic map (bit_data_imx) 
port map (
		-- Inputs
	CLK_RX_Serial			=> CLK_RX_Serial_ch,
	DATA_RX_Serial			=> IS_CH(0),	
	MAIN_reset				=> reset_1,	
	MAIN_ENABLE				=> MAIN_ENABLE,	
	allign_load				=> allign_load,	
		-- Outputs
	DATA_RX_Parallel		=> DATA_RX_ch_0
);	











-- Process(CLK_sys)
-- begin
-- if rising_edge(CLK_sys) then
-- 	if  to_integer(unsigned (qout_clk_IS)) = 50 	then
-- 			Sync_flag	<=	'1';
-- 	else	Sync_flag	<=	'0';
-- 	end if;
-- end if;
-- end process;


-- Control_reciever_q: Control_reciever                   
-- port map (
-- 		-- Inputs
-- 	CLK_RX_Serial		=>CLK_RX_Serial,
-- 	CLK_RX_Parallel		=>CLK_RX_Parallel,	
-- 	DATA_RX_Parallel	=>DATA_RX_Parallel,	
-- 	MAIN_reset			=>MAIN_reset_in,	
-- 	MAIN_reset0			=>MAIN_reset_in,	
-- 	MAIN_ENABLE			=>MAIN_ENABLE,	
-- 	Sync_flag			=>Sync_flag,	
-- 		-- Outputs
-- 	valid_data			=>valid_data_wr,
-- 	Phase_shift			=>Phase_shift,
-- 	allign_byte			=>allign_byte, 
-- 	N_clk				=>N_clk
-- );	


-- -- data_IMX1	<= DATA_CSI_CH1;

-- csi_to_raw_q0 : csi_to_raw
-- port map  (
-- --------------------IN signal---------
-- 		CLK_RX_Parallel		=>	CLK_RX_Parallel,			
-- 		CLK_sys				=>	CLK_sys,		
-- 		ena_clk_x2			=>	ena_clk_x2,		
-- 		ena_clk_x4			=>	ena_clk_x4,		
-- 		ena_clk_x8			=>	ena_clk_x8,		
-- 		MAIN_reset			=>	MAIN_reset_in,			
-- 		MAIN_ENABLE			=>	MAIN_ENABLE,		
-- 		Mode_debug			=>	Mode_debug,		
-- 		DATA_CSI_CH			=>	DATA_RX_Parallel,		
-- 		qout_clk_IS			=>	qout_clk_IS,		
-- 		qout_v				=>	qout_v,		
-- --------------------OUT signal---------
-- 		data_IMX			=>	data_IMX1	
-- 		);	 

end ;
