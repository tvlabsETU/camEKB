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

-- гамма 0.7
-- автоматика до 100к
-- синхронизация 
-- hrd - 

entity EKB_top is

	port 
	(
		--IMX_252_first--
	IMX_1_XHS		:in std_logic;  
	IMX_1_XVS		:in std_logic;  
	IMX_1_XCLR		:out std_logic;  
	IMX_1_SCK		:out std_logic;  
	IMX_1_SDI		:out std_logic;  
	IMX_1_SDO		:in std_logic;  
	IMX_1_XCE		:out std_logic;  
	IMX_1_INCK		:out std_logic;  
	IMX_1_XTRIG		:out std_logic;  

	IMX_1_CH_P		:in std_logic_vector(3 downto 0);	-- channel DDR IMX 1
	IMX_1_CH_N		:in std_logic_vector(3 downto 0);	-- channel DDR IMX 1
	IMX_1_CLK_P		:in std_logic;						-- channel DDR IMX CLK 
	IMX_1_CLK_N		:in std_logic;						-- channel DDR IMX CLK 
		--IMX_252_second--	
	IMX_2_XHS		:in std_logic;  
	IMX_2_XVS		:in std_logic;  
	IMX_2_XCLR		:out std_logic;  
	IMX_2_SCK		:out std_logic;  
	IMX_2_SDI		:out std_logic;  
	IMX_2_SDO		:in std_logic;  
	IMX_2_XCE		:out std_logic;  
	IMX_2_INCK		:out std_logic;  
	IMX_2_XTRIG		:out std_logic;  
	IMX_2_CH_P		:in std_logic_vector(3 downto 0);	-- channel DDR IMX 1
	IMX_2_CH_N		:in std_logic_vector(3 downto 0);	-- channel DDR IMX 1
	IMX_2_CLK_P		:in std_logic_vector(0 downto 0);	-- channel DDR IMX CLK 
	IMX_2_CLK_N		:in std_logic_vector(0 downto 0);	-- channel DDR IMX CLK 
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
	-- 	--Memory 1--	
	-- DATA_Mem_1		:inout std_logic_vector(7 downto 0);
	-- ADDR_Mem_1		:out std_logic_vector(18 downto 0);
	-- WE_Mem_1			:out std_logic;
	-- CEn_Mem_1		:out std_logic;
	-- OE_Mem_1			:out std_logic;
	-- 	--Other--	
	Get_m				:out std_logic;
	-- Sync				:out std_logic;
	-- CMD1				:out std_logic;
	-- CMD2				:out std_logic;
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

	CLK_in			:in std_logic;
	Reset_main		:in std_logic

	);

end EKB_top;

architecture rtl of EKB_top is
----------------------------------------------------------------------
---модель симцуляции цотоприемника
----------------------------------------------------------------------
-- component IMAGE_SENSOR_SIM is
-- port (
-- 		--входные сигналы--	
-- 	CLK					: in std_logic;  												-- тактовый 
-- 	mode_generator		: in std_logic_vector (7 downto 0);						-- задание генератора
-- 		--выходные сигналы--	
-- 	XVS_Imx_Sim			: out std_logic; 												-- синхронизация
-- 	XHS_Imx_Sim			: out std_logic; 												-- синхронизация
-- 	DATA_IS_PAR			: out	std_logic_vector (bit_data_imx-1 downto 0);	-- выходной сигнал
-- 	DATA_IS_LVDS_ch_n	: out	std_logic_vector (3 downto 0);					-- выходной сигнал в канале 1
-- 	DATA_IS_CSI			: out	std_logic; 												-- выходной сигнал CSI
-- 	CLK_DDR				: out std_logic		
-- 		);
-- end component;
-- signal XVS_Imx_Sim				: std_logic:='0';
-- signal XHS_Imx_Sim				: std_logic:='0';
-- signal DATA_IS_LVDS_ch_n_Sim	: std_logic_vector (3 downto 0);
-- signal DATA_IS_CSI_Sim			: std_logic:='0';
-- signal CLK_DDR_Sim				: std_logic:='0';
-- signal DATA_IS_PAR_Sim			: std_logic_vector (bit_data_imx-1 downto 0):=(Others => '0'); 

----------------------------------------------------------------------
---модуль синхрогенератора
----------------------------------------------------------------------
component sync_gen_pix_str_frame is
port (
	------------------------------------входные сигналы-----------------------
	CLK						: in std_logic;  											-- тактовый от гнератора
	reset						: in std_logic;  											-- сброс
	main_enable				: in std_logic;  											-- разрешение работы
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
signal main_enable			: std_logic:='1';						
signal main_reset				: std_logic:='1';		
signal reset_RX				: std_logic:='1';		
signal CLK_in_1				: std_logic:='1';			
----------------------------------------------------------------------
---модуль приема сигнала изображения от фотоприеника
----------------------------------------------------------------------
component image_sensor_RX_LVDS is
port (		
			--image sensor IN--
	IMX_CH_P			:in std_logic_vector(3 to 0);	-- channel DDR IMX 1
	IMX_CH_N			:in std_logic_vector(3 to 0);	-- channel DDR IMX 1
	IMX_CLK_P		:in std_logic;						-- channel DDR IMX CLK 
	IMX_CLK_N		:in std_logic;						-- channel DDR IMX CLK 	
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
end component;
signal sync_H				: std_logic:='1';						
signal sync_V				: std_logic:='1';						
signal data_RAW_RX		: std_logic_vector (bit_data_imx-1 downto 0);				
				
----------------------------------------------------------------------
--модуль управления ФП
----------------------------------------------------------------------
component imx_control is
port (
	CLK				: in std_logic;  								-- тактовый для SPI
	ena_clk			: in std_logic;  								-- сигнал разрешения тактовый 
	MAIN_reset		: in std_logic;  								-- MAIN_reset
	qout_v			: in std_logic_vector (bit_strok-1 downto 0);	-- счетчик строк
	AGC_VGA			: in  std_logic_vector (15 downto 0); 			-- значение усиления
	AGC_str			: in  std_logic_vector (15 downto 0); 			-- время накопления
	DEBUG				: in  std_logic_vector (7 downto 0);  			-- настройка			 
	reset_imx		: out std_logic;  							--  сигнал SPI
	SDI_imx			: out std_logic;  								--  сигнал SPI
	XCE_imx			: out std_logic;  								--  сигнал SPI
	SCK_imx			: out std_logic									--  сигнал SPI
		);
end component;

signal AGC_VGA		: std_logic_vector (15 downto 0);				
signal AGC_str		: std_logic_vector (15 downto 0);				
signal DEBUG_0		: std_logic_vector (7 downto 0);				
signal reset_imx	: std_logic:='1';						

----------------------------------------------------------------------
---модуль интерфейса ADV7343
----------------------------------------------------------------------
component ADV7343_cntrl is
	port (
	------------------------------------входные сигналы-----------------------
		CLK				: in std_logic;  												-- тактовый от гнератора
		reset				: in std_logic;  												-- сброс
		main_enable		: in std_logic;  												-- разрешение работы
		qout_clk	    	: in	std_logic_vector (bit_pix-1 downto 0); 		-- счетчик пикселей
		qout_v			: in	std_logic_vector (bit_strok-1 downto 0); 		-- счетчик строк
		ena_clk_x_q		: in	std_logic_vector (3 downto 0); 					-- разрешение частоты /2 /4 /8/ 16
		data_in     	: in std_logic_vector (bit_data_imx-1 downto 0);	-- режим работы
		------------------------------------выходные сигналы----------------------
		DAC_Y				:out std_logic_vector(7 downto 0);
		DAC_PHSYNC		:out std_logic;
		DAC_PVSYNC		:out std_logic;
		DAC_PBLK			:out std_logic;
		Get_m			   :out std_logic;
		DAC_LF1			:out std_logic;
		DAC_LF2			:out std_logic;
		DAC_SDA			:out std_logic;
		DAC_SCL			:out std_logic;
		DAC_CLK			:out std_logic;
		DAC_SFL			:out std_logic
			);
end component;
signal data_Inteface	: std_logic_vector (7 downto 0);				


begin

----------------------------------------------------------------------
---модуль сброса
----------------------------------------------------------------------
inpuf_q: INBUF
port map (
	PAD	=>	CLK_in,
	Y		=>	CLK_in_1
);

reset_control_q: reset_control                    
port map (
				-----in---------
	CLK_in  			=>	CLK_in_1,			
	Reset_main  	=>	Reset_main,			
	Lock_PLL_1  	=>	LOCK_PLL_SYNC_GEN_1,
	Lock_PLL_2  	=>	LOCK_PLL_SYNC_GEN_2,
	Lock_PLL_3  	=>	'1',
	Lock_PLL_4  	=>	'1',
	Sync_x      	=>	'1',
	XHS_imx			=>	IMX_1_XHS,
	XVS_imx			=>	IMX_1_XVS,
				------ out------
	Enable_main		=>	main_enable,
	reset_1			=>	reset_sync_gen,
	reset_2			=>	main_reset,
	reset_3			=>	reset_RX
	);	
----------------------------------------------------------------------
---модуль синхрогенератора
----------------------------------------------------------------------
sync_gen_pix_str_frame_q: sync_gen_pix_str_frame                    
port map (
				--IN--
	CLK							=> CLK_in_1,			
	reset							=> reset_sync_gen,			
	main_enable					=> main_enable,			
				--OUT--
	CLK_1_out					=> CLK_1,
	CLK_2_out					=> CLK_2,
	CLK_3_out					=> CLK_3,
	CLK_4_out					=> CLK_4,
	Lock_PLL_1					=> LOCK_PLL_SYNC_GEN_1,
	Lock_PLL_2					=> LOCK_PLL_SYNC_GEN_2,
			--синхроимпульсы фотоприемник
	ena_clk_x_q_IS				=> ena_clk_x_q_IS,
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


-- ----------------------------------------------------------------------
-- --модуль управления ФП
-- ----------------------------------------------------------------------
-- imx_control_q1: imx_control                    
-- port map (
-- 				--IN--
-- 	CLK						=> CLK_1,				
-- 	ena_clk					=> ena_clk_x_q_IS(3),			
-- 	MAIN_reset				=> main_reset,		
-- 	qout_v					=> qout_v_IS,			
-- 	AGC_VGA					=> AGC_VGA,			
-- 	AGC_str					=> AGC_str,			
-- 	DEBUG						=> DEBUG_0,			
-- 				--OUT--
-- 	reset_imx				=> IMX_1_XCLR,		
-- 	SDI_imx					=> IMX_1_SDI,			
-- 	XCE_imx					=> IMX_1_XCE,			
-- 	SCK_imx					=> IMX_1_SCK			
-- 	);
-- 	IMX_1_INCK		<=	CLK_2;
-- 	IMX_1_XTRIG		<=	'1';
-- --------------------------------------------------------------------
-- -- модуль управления ФП
-- --------------------------------------------------------------------
-- imx_control_q2: imx_control                    
-- port map (
-- 				--IN--
-- 	CLK						=> CLK_1,				
-- 	ena_clk					=> ena_clk_x_q_IS(3),			
-- 	MAIN_reset				=> main_reset,		
-- 	qout_v					=> qout_v_IS,			
-- 	AGC_VGA					=> AGC_VGA,			
-- 	AGC_str					=> AGC_str,			
-- 	DEBUG						=> DEBUG_0,			
-- 				--OUT--
-- 	reset_imx				=> IMX_2_XCLR,		
-- 	SDI_imx					=> IMX_2_SDI,			
-- 	XCE_imx					=> IMX_2_XCE,			
-- 	SCK_imx					=> IMX_2_SCK			
-- 	);
-- 	IMX_2_INCK		<=	CLK_2;
-- 	IMX_2_XTRIG		<=	'1';


-- ----------------------------------------------------------------------
-- ---модуль приема сигнала изображения от фотоприеника
-- ----------------------------------------------------------------------
-- image_sensor_RX_LVDS_q: image_sensor_RX_LVDS                    
-- port map (
-- 				--image sensor IN--
-- 	IMX_CH_P				=> IMX_1_CH_P,			
-- 	IMX_CH_N				=> IMX_1_CH_N,			
-- 	IMX_CLK_P			=> IMX_1_CLK_P,			
-- 	IMX_CLK_N			=> IMX_1_CLK_N,			
-- 	XVS					=> XVS_Imx_Sim,			
-- 	XHS					=> XHS_Imx_Sim,			
-- 		---------Other------------
-- 	CLK_sys				=> CLK_1,
-- 	reset_1				=> main_reset,
-- 	reset_2				=> reset_RX,
-- 	main_enable			=> main_enable,
-- 	Mode_debug			=> x"00",
-- 	ena_clk_x_q_IS		=> ena_clk_x_q_IS,
-- 	qout_clk_IS			=> qout_clk_IS,
-- 	qout_v_IS			=> qout_v_IS,			
-- 		---------out------------
-- 	sync_H				=> sync_H,
-- 	sync_V				=> sync_V,		
-- 	data_RAW_RX			=> data_RAW_RX
-- 	);
-- ----------------------------------------------------------------------


----------------------------------------------------------------------
---модуль интерфейса ADV7343
----------------------------------------------------------------------
ADV7343_control_q0: ADV7343_cntrl                    
port map (
				--IN--
	CLK				=>	CLK_3,
	reset				=>	main_reset,
	main_enable		=> main_enable,
	qout_clk	    	=> qout_clk_Inteface,
	qout_v			=> qout_v_Inteface,
	ena_clk_x_q		=> ena_clk_x_q_Inteface,
	data_in     	=> qout_clk_Inteface(7 downto 0) & x"f",
	-- data_in     	=> x"80",

				--OUT--
	DAC_Y				=>	DAC_Y,			
	DAC_PHSYNC		=>	DAC_PHSYNC,	
	DAC_PVSYNC		=>	DAC_PVSYNC,	
	DAC_PBLK			=>	DAC_PBLK,		
	Get_m				=>	Get_m,		
	DAC_LF1			=>	DAC_LF1,		
	DAC_LF2			=>	DAC_LF2,		
	DAC_SDA			=>	DAC_SDA,		
	DAC_SCL			=>	DAC_SCL,		
	DAC_CLK			=>	DAC_CLK,		
	DAC_SFL			=>	DAC_SFL		
	);
	
	-- DAC_Y	<=data_Inteface;
	
-----------------------------------------------------------------------
GPIO0		<=	qout_clk_IS(0);
GPIO1		<=	qout_clk_IS(1);
GPIO2		<=	qout_clk_IS(2);
GPIO3		<=	qout_clk_IS(3);
GPIO4		<=	qout_clk_IS(4);
GPIO5		<=	qout_clk_IS(5);
GPIO6		<=	qout_clk_IS(6);
GPIO7		<=	qout_clk_IS(7);
GPIO8		<=	IMX_1_XHS;
GPIO9		<=	sync_H;
GPIO10	<=	kadr_Inteface;
end rtl;


	
	
	
	
	
	
	
	
	
	
	
	
	
	
	