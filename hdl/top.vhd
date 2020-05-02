library ieee;

use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.VIDEO_CONSTANTS.all;
use work.My_component_pkg.all;
-- проект ЭКБ для АО "НИИ Телевидения"
-- версия платы PCB ekb_ctrl (31.10.2019 19-41-31)
-- два фотоприемника IMX265 в режиме окна 2200х1250
-- кадровая частота 50 Гц
-- пиксельная частота 137.5 Мгц
-- цифрвой биннинг 2х2 с выбором центральной части изображения 
-- выходной сигнал (активной части) 768х576 пикселей
--	выходной сигнал на АЦП 1888х625 пикселей с частотой 29.5 МГц
-- два фотоприемника для широкого и узкого угла
-- ПЛИС A3PE3000L-FG484


entity EKB_top is

	port 
	(
		--IMX_252_first--
	IMX_1_XHS		:in std_logic;  
	IMX_1_XVS		:in std_logic;  
	IMX_1_XCLR		:out std_logic;  
	IMX_1_SCK		:out std_logic;  
	IMX_1_SDI		:out std_logic;  
	IMX_1_SDO		:out std_logic;  
	IMX_1_XCE		:out std_logic;  
	IMX_1_INCK		:out std_logic;  
	IMX_1_XTRIG		:out std_logic;  
	IMX_1_CH_0_P	:in std_logic_vector(0 to 0);	-- channel 0 DDR IMX 1
	IMX_1_CH_0_N	:in std_logic_vector(0 to 0);	-- channel 0 DDR IMX 1
	IMX_1_CH_1_P	:in std_logic_vector(0 to 0);	-- channel 1 DDR IMX 1
	IMX_1_CH_1_N	:in std_logic_vector(0 to 0);	-- channel 1 DDR IMX 1
	IMX_1_CH_2_P	:in std_logic_vector(0 to 0);	-- channel 2 DDR IMX 1
	IMX_1_CH_2_N	:in std_logic_vector(0 to 0);	-- channel 2 DDR IMX 1
	IMX_1_CH_3_P	:in std_logic_vector(0 to 0);	-- channel 3 DDR IMX 1
	IMX_1_CH_3_N	:in std_logic_vector(0 to 0);	-- channel 4 DDR IMX 1
	IMX_1_CLK_P		:in std_logic_vector(0 to 0);	-- channel 0 DDR IMX CLK 
	IMX_1_CLK_N		:in std_logic_vector(0 to 0);	-- channel 0 DDR IMX CLK 
		--IMX_252_second--	
	IMX_2_XHS		:in std_logic;  
	IMX_2_XVS		:in std_logic;  
	IMX_2_XCLR		:out std_logic;  
	IMX_2_SCK		:out std_logic;  
	IMX_2_SDI		:out std_logic;  
	IMX_2_SDO		:out std_logic;  
	IMX_2_XCE		:out std_logic;  
	IMX_2_INCK		:out std_logic;  
	IMX_2_XTRIG		:out std_logic;  
	IMX_2_CH_0_P	:in std_logic_vector(0 to 0);	-- channel 0 DDR IMX 2
	IMX_2_CH_0_N	:in std_logic_vector(0 to 0);	-- channel 0 DDR IMX 2
	IMX_2_CH_1_P	:in std_logic_vector(0 to 0);	-- channel 1 DDR IMX 2
	IMX_2_CH_1_N	:in std_logic_vector(0 to 0);	-- channel 1 DDR IMX 2
	IMX_2_CH_2_P	:in std_logic_vector(0 to 0);	-- channel 2 DDR IMX 2
	IMX_2_CH_2_N	:in std_logic_vector(0 to 0);	-- channel 2 DDR IMX 2
	IMX_2_CH_3_P	:in std_logic_vector(0 to 0);	-- channel 3 DDR IMX 2
	IMX_2_CH_3_N	:in std_logic_vector(0 to 0);	-- channel 3 DDR IMX 2
	IMX_2_CLK_P		:in std_logic_vector(0 to 0);	-- channel 0 DDR IMX CLK 
	IMX_2_CLK_N		:in std_logic_vector(0 to 0);	-- channel 0 DDR IMX CLK 
		--ADV7343--	
	DAC_Y				:out std_logic_vector(7 downto 0);
	DAC_PHSYNC		:out std_logic;
	DAC_PVSYNC		:out std_logic;
	DAC_PBLK			:out std_logic;
	DAC_LF1			:out std_logic;
	DAC_LF2			:out std_logic;
	DAC_SDA			:out std_logic;
	DAC_SCL			:out std_logic;
	DAC_CLK			:out std_logic;
	DAC_SFL			:out std_logic;
		--Memory 1--	
	DATA_Mem_1		:inout std_logic_vector(7 downto 0);
	ADDR_Mem_1		:out std_logic_vector(18 downto 0);
	WE_Mem_1			:out std_logic;
	CEn_Mem_1		:out std_logic;
	OE_Mem_1			:out std_logic;
		--Other--	
	Get_m				:out std_logic;
	Sync				:out std_logic;
	CMD1				:out std_logic;
	CMD2				:out std_logic;
	Wide_Narrow		:out std_logic;
	GPIO0				:out std_logic;
	GPIO1				:out std_logic;
	GPIO2				:out std_logic;
	GPIO3				:out std_logic;
	GPIO4				:out std_logic;
	GPIO5				:out std_logic;
	GPIO6				:out std_logic;
	GPIO7				:out std_logic;
	GPIO8				:out std_logic;
	GPIO9				:out std_logic;
	GPIO10			:out std_logic;
	GPIO				:out std_logic_vector(3 downto 0);
	CLK_in			:in std_logic;
	Reset_main		:in std_logic

	);

end EKB_top;

architecture rtl of EKB_top is
----------------------------------------------------------------------
---модель симцуляции цотоприемника
----------------------------------------------------------------------
component IMAGE_SENSOR_SIM is
port (
		--входные сигналы--	
	CLK					: in std_logic;  												-- тактовый 
	mode_generator		: in std_logic_vector (7 downto 0);						-- задание генератора
		--выходные сигналы--	
	XVS_Imx_Sim			: out std_logic; 												-- синхронизация
	XHS_Imx_Sim			: out std_logic; 												-- синхронизация
	DATA_IS_PAR			: out	std_logic_vector (bit_data_imx-1 downto 0);	-- выходной сигнал
	DATA_IS_LVDS_ch_n	: out	std_logic_vector (3 downto 0);					-- выходной сигнал в канале 1
	DATA_IS_CSI			: out	std_logic; 												-- выходной сигнал CSI
	CLK_DDR				: out std_logic		
		);
end component;
signal XVS_Imx_Sim				: std_logic:='0';
signal XHS_Imx_Sim				: std_logic:='0';
signal DATA_IS_LVDS_ch_n_Sim	: std_logic_vector (3 downto 0);
signal DATA_IS_CSI_Sim			: std_logic:='0';
signal CLK_DDR_Sim				: std_logic:='0';
signal DATA_IS_PAR_Sim			: std_logic_vector (bit_data_imx-1 downto 0):=(Others => '0'); 

----------------------------------------------------------------------
---модуль синхрогенератора
----------------------------------------------------------------------
component sync_gen_pix_str_frame is
port (
	------------------------------------входные сигналы-----------------------
	CLK						: in std_logic;  											-- тактовый от гнератора
	reset						: in std_logic;  											-- сброс
	MAIN_ENABLE				: in std_logic;  											-- разрешение работы
	------------------------------------выходные сигналы----------------------
	CLK_1_out				: out std_logic; 											-- тактовый с частотой 1
	CLK_2_out				: out std_logic; 											-- тактовый с частотой 2
	CLK_3_out				: out std_logic; 											-- тактовый с частотой 3
	CLK_4_out				: out std_logic; 											-- тактовый с частотой 4
	Lock_PLL_1				: out std_logic; 											-- 
	Lock_PLL_2				: out std_logic; 											-- 
	ena_clk_x_q_IS			: out std_logic_vector (3 downto 0); 				-- разрешение частоты /2 /4 /8/ 16
	qout_clk_IS				: out std_logic_vector (bit_pix-1 downto 0);		-- счетчик пикселей
	stroka_IS				: out std_logic; 	 										-- переполенение счетчика по строке
	qout_v_IS				: out std_logic_vector (bit_strok-1 downto 0); 	-- счетчик строк
	kadr_IS					: out std_logic; 	 										-- переполенени счетчика по строке	
	qout_frame_IS			: out std_logic_vector (bit_frame-1 downto 0); 	-- счетчик кадров
	ena_clk_x_q_Inteface	: out std_logic_vector (3 downto 0); 				-- разрешение частоты /2 /4 /8/ 16
	qout_clk_Inteface		: out std_logic_vector (bit_pix-1 downto 0); 	-- счетчик пикселей
	stroka_Inteface		: out std_logic; 	 										-- переполенение счетчика по строке
	qout_v_Inteface		: out std_logic_vector (bit_strok-1 downto 0); 	-- счетчик строк
	kadr_Inteface			: out std_logic; 	 										-- переполенени счетчика по строке	
	qout_frame_Inteface	: out std_logic_vector (bit_frame-1 downto 0) 	-- счетчик кадров
		);
end component;

signal stroka_IS					: std_logic:='0';
signal kadr_IS						: std_logic:='0';
signal qout_clk_IS				: std_logic_vector (bit_pix-1 downto 0):=(Others => '0'); 
signal qout_frame_IS				: std_logic_vector (bit_frame-1 downto 0):=(Others => '0');
signal qout_V_IS					: std_logic_vector (bit_strok-1 downto 0):=(Others => '0');
signal ena_clk_x_q_IS			: std_logic_vector (3 downto 0):=(Others => '0');
signal stroka_Inteface			: std_logic:='0';
signal kadr_Inteface				: std_logic:='0';
signal qout_clk_Inteface		: std_logic_vector (bit_pix-1 downto 0):=(Others => '0'); 
signal qout_frame_Inteface		: std_logic_vector (bit_frame-1 downto 0):=(Others => '0');
signal qout_V_Inteface			: std_logic_vector (bit_strok-1 downto 0):=(Others => '0');
signal ena_clk_x_q_Inteface	: std_logic_vector (3 downto 0):=(Others => '0');
signal CLK_1						: std_logic:='1';
signal CLK_2						: std_logic:='1';
signal CLK_3						: std_logic:='1';
signal CLK_4						: std_logic:='1';
----------------------------------------------------------------------
---модуль сброса
----------------------------------------------------------------------
component  reset_control is
	port (
	CLK_in			: in std_logic;  									
	Reset_main 		: in std_logic;  									
	Lock_PLL_1 		: in std_logic;  									
	Lock_PLL_2 		: in std_logic;  									
	Lock_PLL_3 		: in std_logic;  									
	Lock_PLL_4 		: in std_logic;  									
	Sync_x     		: in std_logic;  									
	XHS_imx			: in std_logic;  									
	XVS_imx			: in std_logic;  									
	Enable_main		: out std_logic;  									
	reset_1			: out std_logic;  									
	reset_2			: out std_logic;  									
	reset_3			: out std_logic;  									
	reset_4			: out std_logic
	);
end component;
signal LOCK_PLL_SYNC_GEN_1	: std_logic:='1';
signal LOCK_PLL_SYNC_GEN_2	: std_logic:='1';
signal LOCK_PLL_RX_1			: std_logic:='1';
signal LOCK_PLL_RX_2			: std_logic:='1';
signal reset_sync_gen		: std_logic:='1';
signal MAIN_ENABLE			: std_logic:='1';						
signal MAIN_reset				: std_logic:='1';		
signal reset_RX				: std_logic:='1';		
----------------------------------------------------------------------
---модуль приема сигнала изображения от фотоприеника
----------------------------------------------------------------------
component image_sensor_RX_LVDS is
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
end component;
signal sync_H				: std_logic:='1';						
signal sync_V				: std_logic:='1';						
signal data_RAW_RX		: std_logic_vector (bit_data_imx-1 downto 0);				
				

begin

----------------------------------------------------------------------
---модель симцуляции фотоприемника
----------------------------------------------------------------------
IMAGE_SENSOR_SIM_q: IMAGE_SENSOR_SIM                    
port map (
				-----in---------
	CLK						=>	CLK_in,			
	mode_generator 		=>	x"00",			
				------ out------
	XVS_Imx_Sim				=> XVS_Imx_Sim,
	XHS_Imx_Sim				=> XHS_Imx_Sim,
	DATA_IS_PAR				=>	DATA_IS_PAR_Sim,
	DATA_IS_LVDS_ch_n		=> DATA_IS_LVDS_ch_n_Sim,
	-- DATA_IS_CSI				=>	MAIN_reset
	CLK_DDR					=>	CLK_DDR_Sim	
	);

----------------------------------------------------------------------
---модуль сброса
----------------------------------------------------------------------
reset_control_q: reset_control                    
port map (
				-----in---------
	CLK_in  			=>	CLK_in,			
	Reset_main  	=>	Reset_main,			
	Lock_PLL_1  	=>	LOCK_PLL_SYNC_GEN_1,
	Lock_PLL_2  	=>	LOCK_PLL_SYNC_GEN_2,
	Lock_PLL_3  	=>	'1',
	Lock_PLL_4  	=>	'1',
	Sync_x      	=>	'1',
	XHS_imx			=>	IMX_1_XHS,
	XVS_imx			=>	IMX_1_XVS,
				------ out------
	Enable_main		=>	MAIN_ENABLE,
	reset_1			=>	reset_sync_gen,
	reset_2			=>	MAIN_reset,
	reset_3			=>	reset_RX
	);	
----------------------------------------------------------------------
---модуль синхрогенератора
----------------------------------------------------------------------
sync_gen_pix_str_frame_q: sync_gen_pix_str_frame                    
port map (
				--IN--
	CLK							=> CLK_IN,			
	reset							=> reset_sync_gen,			
	MAIN_ENABLE					=> MAIN_ENABLE,			
				--OUT--
	CLK_1_out					=> CLK_1,
	CLK_2_out					=> CLK_2,
	CLK_3_out					=> CLK_3,
	CLK_4_out					=> CLK_4,
	Lock_PLL_1					=> LOCK_PLL_SYNC_GEN_1,
	Lock_PLL_2					=> LOCK_PLL_SYNC_GEN_2,
			--синхроимпульсы фотоприемник
	qout_clk_IS					=> qout_clk_IS,			
	stroka_IS					=> stroka_IS,			
	qout_v_IS					=> qout_v_IS,			
	kadr_IS						=> kadr_IS,				
	qout_frame_IS				=> qout_frame_IS,		
			--синхроимпульсы интерфейс
	ena_clk_x_q_Inteface		=> ena_clk_x_q_Inteface,
	qout_clk_Inteface			=> qout_clk_Inteface,		
	stroka_Inteface			=> stroka_Inteface,			
	qout_v_Inteface			=> qout_v_Inteface,			
	kadr_Inteface				=> kadr_Inteface,			
	qout_frame_Inteface		=> qout_frame_Inteface	
	);
----------------------------------------------------------------------
---модуль приема сигнала изображения от фотоприеника
----------------------------------------------------------------------
image_sensor_RX_LVDS_q: image_sensor_RX_LVDS                    
port map (
				--image sensor IN--
	IS_CH					=> DATA_IS_LVDS_ch_n_Sim,			
	DCK_IS				=> CLK_DDR_Sim,			
	XVS					=> XVS_Imx_Sim,			
	XHS					=> XHS_Imx_Sim,			
		---------Other------------
	CLK_sys				=> CLK_1,
	reset_1				=> MAIN_reset,
	reset_2				=> reset_RX,
	MAIN_ENABLE			=> MAIN_ENABLE,
	Mode_debug			=> x"00",
	qout_clk_IS			=> qout_clk_IS,
	qout_v_IS			=> qout_v_IS,			
		---------out------------
	sync_H				=> sync_H,
	sync_V				=> sync_V,		
	data_RAW_RX			=> data_RAW_RX
	);
----------------------------------------------------------------------


end rtl;

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	