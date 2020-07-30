library ieee;

use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.VIDEO_CONSTANTS.all;
use work.My_component_pkg.all;
---------------------------------------------------------------
-- модель симцуляции цотоприемника
-- выходной сигнал в 3 вариантах паралелльный код / LVDS (1-2-4 линии) / CSI (1 линия)
-- в зависимости от mode_IMAGE_SENSOR (use work.VIDEO_CONSTANTS.all ) можно изменять режим симуляции
-- mode_IMAGE_SENSOR (3 downto 0) = 0 CSI - 1 линия
-- mode_IMAGE_SENSOR (3 downto 0) = 1 LVDS - 1 линия
-- mode_IMAGE_SENSOR (3 downto 0) = 2 LVDS - 2 линия
-- mode_IMAGE_SENSOR (3 downto 0) = 3 LVDS - 4 линия
-- разрядность данный определяется bit_data_imx 12 / 10 / 8 bit

-- mode_IMAGE_SENSOR (7 downto 4) = 0 B/W
-- mode_IMAGE_SENSOR (7 downto 4) = 1 COLOR

-- mode_generator определяет тип данных для передачи
-- младшие 4 бита отвечаю за тип сигнала, старшие за кастомизацию
-- 	[7..4]						[3..0]
-- 	сдвиг разрядов				0 градационный клин по горизонтали
-- 	сдвиг разрядов				1 градационный клин по вертикали
-- 	none							2 шумоподобный сигнал на основе полинома SMPTE
-- 	размер клеток				3 шахматное поле
-- 	интенсиыность полос		4 цветные полосы (color bar)
-- 	none							5 сигнал из файла
--------------------------------------------------------------
--------------------------------------------------------------
-- модель PLL для симуляции фотоприемника
-- для 2200х1250 50p пиксельаня частота (PixFreq)  137.5 МГц
-- для 2200х1125 30p пиксельаня частота (PixFreq)  74.25 МГц
-- для пиксельной частоты > 74.25 Мгц нельзя использвать CSI-2/ LVDS по 1 линии
--       mode                        SerFreq
-- CSI      8 bit       PixFreq*4      = 297 МГц
-- LVDS_1ch 8 bit       PixFreq*4      = 297 МГц
-- LVDS_1ch 10 bit      PixFreq*5      = 371.25 МГц
-- LVDS_1ch 12 bit      PixFreq*6      = 445.5 МГц
-- LVDS_2ch 8 bit       PixFreq*4 /2   = 148.5 МГц
-- LVDS_2ch 10 bit      PixFreq*5 /2   = 185.625 МГц
-- LVDS_2ch 12 bit      PixFreq*6 /2   = 222.75 МГц
-- LVDS_4ch 8 bit       PixFreq*4 /4   = 74.25 МГц
-- LVDS_4ch 10 bit      PixFreq*5 /4   = 92.8125 МГц
-- LVDS_4ch 12 bit      PixFreq*6 /4   = 111.375 МГц
--------------------------------------------------------------


entity tb_IS is
port (
		--входные сигналы--	
	CLK					: in std_logic;  												-- тактовый 
	mode_generator		: in std_logic_vector (7 downto 0);						-- задание генератора
		--выходные сигналы--	
	XVS_Imx_Sim			: out std_logic; 												-- синхронизация
	XHS_Imx_Sim			: out std_logic; 												-- синхронизация
	DATA_IS_PAR			: out	std_logic_vector (bit_data_imx-1 downto 0);	-- выходной сигнал
	DATA_IS_LVDS_ch_P	: out	std_logic_vector (3 downto 0);					-- выходной сигнал в канале 1
	DATA_IS_LVDS_ch_N	: out	std_logic_vector (3 downto 0);					-- выходной сигнал в канале 1
	DATA_IS_CSI_P		: out	std_logic; 												-- выходной сигнал CSI
	DATA_IS_CSI_N		: out	std_logic; 												-- выходной сигнал CSI
	CLK_DDR_P			: out std_logic;		
	CLK_DDR_N			: out std_logic		
		);
end tb_IS;

architecture beh of tb_IS is 

----------------------------------------------------------------------
-- PLL_SIM_IS entity declaration
----------------------------------------------------------------------
component PLL_SIM_IS is
port( POWERDOWN : in    std_logic;
		CLKA      : in    std_logic;
		LOCK      : out   std_logic;
		GLA       : out   std_logic
		);
end component;
----------------------------------------------------------------------
-- PLL_SIM_IS entity declaration
----------------------------------------------------------------------
component PLL_SIM_IS_1 is
port( POWERDOWN : in    std_logic;
		CLKA      : in    std_logic;
		LOCK      : out   std_logic;
		GLA       : out   std_logic;
		GLB       : out   std_logic;
		GLC       : out   std_logic
		);
end component;

signal PLL_POWERDOWN_N	: std_logic;			
signal CLK_IS_pix			: std_logic;			
signal CLK_IS_DDR_0		: std_logic;			
signal CLK_IS_DDR_1		: std_logic;			
signal CLK_IS_DDR_2		: std_logic;			
signal locked_pll_0		: std_logic;
signal locked_pll_1		: std_logic;
signal main_enable		: std_logic;
signal main_reset			: std_logic;
signal locked_pll_q		: std_logic_vector(31 downto 0);
	
----------------------------------------------------------------------

----------------------------------------------------------------------
-- модуль генерации видеосигнала от фотоприемника в паралелльном коде
----------------------------------------------------------------------
component IS_SIM_Paralell is
generic  (
	PixPerLine_is			: integer;
	HsyncShift_is			: integer;
	ActivePixPerLine_is	: integer;
	HsyncWidth_is			: integer;
	LinePerFrame_is		: integer;
	VsyncShift_is			: integer;
	ActiveLine_is			: integer;
	VsyncWidth_is			: integer
);
port (
		--входные сигналы--	
	CLK					: in std_logic;  												-- тактовый 
	main_reset			: in std_logic;  												-- main_reset
	main_enable			: in std_logic;  												-- main_enable
	mode_generator		: in std_logic_vector (7 downto 0);						--задание режима
		--выходные сигналы--	
	qout_V_out			: out std_logic_vector (bit_strok-1 downto 0);		-- 
	qout_clk_out		: out std_logic_vector (bit_pix-1 downto 0 );		-- 
	XVS_Imx_Sim			: out std_logic; 												-- синхронизация
	XHS_Imx_Sim			: out std_logic; 												-- синхронизация
	DATA_IS_pix_ch_1	: out  std_logic_vector (bit_data_imx-1 downto 0);	-- выходной сигнал
	DATA_IS_pix_ch_2	: out  std_logic_vector (bit_data_imx-1 downto 0);	-- выходной сигнал
	DATA_IS_pix_ch_3	: out  std_logic_vector (bit_data_imx-1 downto 0);	-- выходной сигнал
	DATA_IS_pix_ch_4	: out  std_logic_vector (bit_data_imx-1 downto 0)	-- выходной сигнал
	);
end component;

signal qout_V_out				: std_logic_vector (bit_strok-1 downto 0);
signal qout_clk_out			: std_logic_vector (bit_pix-1 downto 0);
signal DATA_IS_pix_ch_1		: std_logic_vector (bit_data_imx-1 downto 0);
signal DATA_IS_pix_ch_2		: std_logic_vector (bit_data_imx-1 downto 0);
signal DATA_IS_pix_ch_3		: std_logic_vector (bit_data_imx-1 downto 0);
signal DATA_IS_pix_ch_4		: std_logic_vector (bit_data_imx-1 downto 0);
----------------------------------------------------------------------

----------------------------------------------------------------------
-- модуль генерации видеосигнала от фотоприемника после сериализатора
----------------------------------------------------------------------
component IS_SIM_serial_DDR is
generic  (bit_data	: integer);
port (
		--входные сигналы--	
	CLK_fast				: in std_logic;  												-- тактовый 
	main_reset			: in std_logic;  												-- main_reset
	main_enable			: in std_logic;  												-- main_enable
	DATA_IMX_OUT		: in std_logic_vector (bit_data_imx-1 downto 0);	-- входной сигнал
		--выходные сигналы--	
	IMX_DDR_VIDEO		: out std_logic												-- выходной сигнал
		);
end component;
signal DATA_IS_LVDS_ch	: std_logic_vector (3 downto 0);
------------------------------------------------------------------------------------

begin
----------------------------------------------------------------------
-- модули PLL для фомирования данных от фотоприемника
----------------------------------------------------------------------
PLL_POWERDOWN_N	<=	'1';
PLL_SIM_IS_q0: PLL_SIM_IS                   
port map (
	-- Inputs
	POWERDOWN	=> PLL_POWERDOWN_N,
	CLKA			=> CLK,				--74.25 МГц
	-- Outputs 
	GLA			=> CLK_IS_pix,		--137.5 МГц
	LOCK			=> locked_pll_0
);	
PLL_SIM_IS_q1: PLL_SIM_IS_1                   
port map (
	-- Inputs
	POWERDOWN	=> PLL_POWERDOWN_N,
	CLKA			=> CLK,				--74.25 МГц
	-- Outputs 
	GLA			=> CLK_IS_DDR_0, 	--206.25 МГц	// в режиме LVDS 4 ch 12 bit
	GLB			=> CLK_IS_DDR_1, 	--206.25 МГц	// 180 phase shift
	GLC			=> CLK_IS_DDR_2, 	--206.25 МГц	// 90 phase shift
	LOCK			=> locked_pll_1
);	
----------------------------------------------------------------------
-- задержка reset для корректного сброса 
----------------------------------------------------------------------
process (CLK)
begin
if  rising_edge(CLK) then
	locked_pll_q(0) <= locked_pll_0 or locked_pll_1;
	for i in 0 to 30 loop
		locked_pll_q(i+1) <= locked_pll_q(i);
	end loop;
	main_reset	<=	not 	locked_pll_q(31);
	main_enable	<=	locked_pll_q(31);
end if;
end process;

----------------------------------------------------------------------
-- модуль генерации видеосигнала от фотоприемника в паралелльном коде
----------------------------------------------------------------------
IS_SIM_Paralell_q: IS_SIM_Paralell    
generic map (
	IMX_2200_1250p50.PixPerLine,
	IMX_2200_1250p50.HsyncShift,
	IMX_2200_1250p50.ActivePixPerLine,
	IMX_2200_1250p50.HsyncWidth,
	IMX_2200_1250p50.LinePerFrame,
	IMX_2200_1250p50.VsyncShift,
	IMX_2200_1250p50.ActiveLine,
	IMX_2200_1250p50.VsyncWidth
	)
port map (
				------входные сигналы-----------
	CLK					=>	CLK_IS_pix,			
	main_reset			=>	main_reset ,
	main_enable			=>	main_enable  ,		
	mode_generator		=>	mode_generator,
				------выходные сигналы-----------
	qout_V_out			=> qout_V_out,
	qout_clk_out		=> qout_clk_out,
	XVS_Imx_Sim			=> XVS_Imx_Sim,
	XHS_Imx_Sim			=> XHS_Imx_Sim,
	DATA_IS_pix_ch_1	=> DATA_IS_pix_ch_1,
	DATA_IS_pix_ch_2	=> DATA_IS_pix_ch_2,
	DATA_IS_pix_ch_3	=> DATA_IS_pix_ch_3,
	DATA_IS_pix_ch_4	=> DATA_IS_pix_ch_4
	);	
----------------------------------------------------------------------
-- модуль генерации видеосигнала от фотоприемника после сериализатора
-- каждый канал передачи обрабатывается независимо
----------------------------------------------------------------------
IS_SIM_serial_DDR_q1: IS_SIM_serial_DDR                   
generic map (bit_data_imx) 
port map (
				------входные сигналы-----------
	CLK_fast				=>	CLK_IS_DDR_0,			
	main_reset			=>	main_reset ,
	main_enable			=>	main_enable  ,		
	DATA_IMX_OUT		=>	DATA_IS_pix_ch_1,
				------выходные сигналы-----------
	IMX_DDR_VIDEO		=>	DATA_IS_LVDS_ch(0)
	);	
IS_SIM_serial_DDR_q2: IS_SIM_serial_DDR                   
generic map (bit_data_imx) 
port map (
				------входные сигналы-----------
	CLK_fast				=>	CLK_IS_DDR_0,			
	main_reset			=>	main_reset ,
	main_enable			=>	main_enable  ,		
	DATA_IMX_OUT		=>	DATA_IS_pix_ch_2,
				------выходные сигналы-----------
	IMX_DDR_VIDEO		=>	DATA_IS_LVDS_ch(1)
	);	
IS_SIM_serial_DDR_q3: IS_SIM_serial_DDR                   
generic map (bit_data_imx) 
port map (
				------входные сигналы-----------
	CLK_fast				=>	CLK_IS_DDR_0,			
	main_reset			=>	main_reset ,
	main_enable			=>	main_enable  ,		
	DATA_IMX_OUT		=>	DATA_IS_pix_ch_3,
				------выходные сигналы-----------
	IMX_DDR_VIDEO		=>	DATA_IS_LVDS_ch(2)
	);	
IS_SIM_serial_DDR_q4: IS_SIM_serial_DDR                   
generic map (bit_data_imx) 
port map (
				------входные сигналы-----------
	CLK_fast				=>	CLK_IS_DDR_0,			
	main_reset			=>	main_reset ,
	main_enable			=>	main_enable  ,		
	DATA_IMX_OUT		=>	DATA_IS_pix_ch_4,
				------выходные сигналы-----------
	IMX_DDR_VIDEO		=>	DATA_IS_LVDS_ch(3)
	);	
CLK_DDR_P			<=	 CLK_IS_DDR_2;
CLK_DDR_N			<=	not CLK_IS_DDR_2;
DATA_IS_LVDS_ch_P <= DATA_IS_LVDS_ch;
DATA_IS_LVDS_ch_N <= not DATA_IS_LVDS_ch;

end ;
