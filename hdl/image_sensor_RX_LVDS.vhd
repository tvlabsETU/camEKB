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
	IMX_CH_P			:in std_logic_vector(3 downto 0);	-- channel DDR IMX 1
	IMX_CH_N			:in std_logic_vector(3 downto 0);	-- channel DDR IMX 1
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
	QR_data_rx_Serial	: in std_logic;				-- видео данные DDR
	QF_data_rx_Serial	: in std_logic;				-- видео данные DDR
	main_reset			: in std_logic;  										-- reset
	main_enable			: in std_logic;  										-- ENABLE
	align_load			: in std_logic_vector (2 downto 0);				-- сдвиг момент выборки 
	data_rx_Parallel	: out std_logic_vector (bit_data-1 downto 0)	-- принятый сигнал							  	 														  		
		);
end component;
signal align_load		: std_logic_vector (2 downto 0):=(Others => '0');
signal data_rx_ch_0	: std_logic_vector (bit_data_imx-1 downto 0):=(Others => '0');
signal data_rx_ch_1	: std_logic_vector (bit_data_imx-1 downto 0):=(Others => '0');
signal data_rx_ch_2	: std_logic_vector (bit_data_imx-1 downto 0):=(Others => '0');
signal data_rx_ch_3	: std_logic_vector (bit_data_imx-1 downto 0):=(Others => '0');
----------------------------------------------------------------------
-- модуль синхронизации данных для 4 каналов
----------------------------------------------------------------------
component  sync_word_4ch is
generic  (
	bit_data		: integer;
	PixPerLine	: integer
	);
port (
	clk_rx_Parallel	: in std_logic;  										-- CLK Parallel
	data_rx_ch_0		: in std_logic_vector (bit_data-1 DOWNTO 0);	-- видео данные 
	data_rx_ch_1		: in std_logic_vector (bit_data-1 DOWNTO 0);	-- видео данные 
	data_rx_ch_2		: in std_logic_vector (bit_data-1 DOWNTO 0);	-- видео данные 
	data_rx_ch_3		: in std_logic_vector (bit_data-1 DOWNTO 0);	-- видео данные 
	main_enable			: in std_logic;  										-- enable
	main_reset			: in std_logic;  										-- reset
	cnt_imx_word_rx	: out std_logic_vector (bit_pix-1 DOWNTO 0);	-- счетчик слов от IMX по 1 каналу
	valid_data_rx		: out std_logic;										-- валидные данные по 1 каналу
	align_load_0		: out std_logic_vector (2 DOWNTO 0); 			-- сдвиг в 1 канале
	align_load_1 		: out std_logic_vector (2 DOWNTO 0); 			-- сдвиг в 2 канале
	align_load_2 		: out std_logic_vector (2 DOWNTO 0); 			-- сдвиг в 3 канале
	align_load_3 		: out std_logic_vector (2 DOWNTO 0)  			-- сдвиг в 4 канале
      );
end component;
signal align_load_0		: std_logic_vector (2 downto 0);
signal align_load_1		: std_logic_vector (2 downto 0);
signal align_load_2		: std_logic_vector (2 downto 0);
signal align_load_3		: std_logic_vector (2 downto 0);
<<<<<<< HEAD
signal align_load_00		: std_logic_vector (2 downto 0);


=======
>>>>>>> e296f02de89eba86bbe678e34dace66c718d9223
signal valid_data_rx		: std_logic:='0';
signal cnt_imx_word_rx	: std_logic_vector (bit_pix-1 DOWNTO 0);
----------------------------------------------------------------------
-- модуль мультиплексирования 1/2/4 каналов от фотоприемнка в RAW
----------------------------------------------------------------------
<<<<<<< HEAD
component mux_ch_to_raw is
=======
component rx_ch_to_raw is
>>>>>>> e296f02de89eba86bbe678e34dace66c718d9223
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
end component;
signal data_rx_raw	: std_logic_vector (bit_data_imx-1 downto 0);
<<<<<<< HEAD
-- data_RAW_RX_in
----------------------------------------------------------------------
-- lvds преобразователь
----------------------------------------------------------------------

-- signal is_ch	: std_logic_vector (3 downto 0);
signal QF_ddr	: std_logic_vector (3 downto 0);
signal QR_ddr	: std_logic_vector (3 downto 0);

=======
----------------------------------------------------------------------
-- lvds преобразователь
----------------------------------------------------------------------
component ddr_data_imx is
port( PADP : in    std_logic_vector(3 downto 0);
		PADN : in    std_logic_vector(3 downto 0);
		Y    : out   std_logic_vector(3 downto 0)
	);
end component;
signal is_ch	: std_logic_vector (3 downto 0);
>>>>>>> e296f02de89eba86bbe678e34dace66c718d9223

component INBUF_LVDS is
port( PADP : in    std_logic;
		PADN : in    std_logic;
		Y    : out   std_logic
	);
end component;
signal dck_is	: std_logic;
----------------------------------------------------------------------
<<<<<<< HEAD
signal data_rx_ch_0_w	: std_logic_vector (bit_data_imx downto 0);
signal data_rx_ch_1_w	: std_logic_vector (bit_data_imx downto 0);
signal data_rx_ch_2_w	: std_logic_vector (bit_data_imx downto 0);
signal data_rx_ch_3_w	: std_logic_vector (bit_data_imx downto 0);

signal data_rx_ch_0_1_w	: std_logic_vector (bit_data_imx downto 0);
signal data_rx_ch_2_3_w	: std_logic_vector (bit_data_imx downto 0);
=======
>>>>>>> e296f02de89eba86bbe678e34dace66c718d9223

signal reset_1_0	: std_logic;
signal reset_1_1	: std_logic;
signal reset_2_0	: std_logic;
signal reset_2_1	: std_logic;
signal reset_3_0	: std_logic;
signal reset_3_1	: std_logic;

begin

Process(dck_is)
begin
if rising_edge(dck_is) then
	
	reset_1_0	<=	reset_1;
	reset_1_1	<=	reset_1_0;

end if;
end process;
Process(clk_rx_Serial_ch)
begin
if rising_edge(clk_rx_Serial_ch) then
	
	reset_2_0	<=	reset_2;
	reset_2_1	<=	reset_2_0;

end if;
end process;

Process(clk_rx_Parallel_ch)
begin
if rising_edge(clk_rx_Parallel_ch) then
	
	reset_3_0	<=	reset_2;
	reset_3_1	<=	reset_3_0;

end if;
end process;

----------------------------------------------------------------------
-- lvds преобразователь
----------------------------------------------------------------------
-- ddr_data_imx_q: ddr_data_imx                   
-- port map (
-- 		PADP	=> IMX_CH_P,
-- 		PADN	=> IMX_CH_N,
-- 		Y		=> is_ch
-- );	

ddr_data_imx_q: ddr_lvds                   
port map (
		PADP	=> IMX_CH_P,
		PADN	=> IMX_CH_N,
		CLR	=> reset_1_1,
		CLK	=> clk_rx_Serial_ch,
		QR		=> QR_ddr,
		QF		=> QF_ddr
);	



INBUF_LVDS_q: INBUF_LVDS                   
port map (
		PADP	=> IMX_CLK_P,
		PADN	=> IMX_CLK_N,
		Y		=> dck_is
);	

----------------------------------------------------------------------
-- lvds преобразователь
----------------------------------------------------------------------
ddr_data_imx_q: ddr_data_imx                   
port map (
		PADP	=> IMX_CH_P,
		PADN	=> IMX_CH_N,
		Y		=> is_ch
);	
INBUF_LVDS_q: INBUF_LVDS                   
port map (
		PADP	=> IMX_CLK_P,
		PADN	=> IMX_CLK_N,
		Y		=> dck_is
);	

----------------------------------------------------------------------
-- модуль генерации тактовых частот  
----------------------------------------------------------------------
IS_rx_clk_gen_q: IS_rx_clk_gen                   
port map (
		-- Inputs
	dck_is					=> dck_is,
	CLK						=> '0',	-- не используется для  ProAsic
	main_reset				=> reset_1_1,	
	main_enable				=> main_enable,	
		-- Outputs
	clk_rx_Serial_ch		=> clk_rx_Serial_ch,
	clk_rx_Parallel_ch	=> clk_rx_Parallel_ch
);	

----------------------------------------------------------------------
-- модуль приема DDR данных по 1..4 каналу
----------------------------------------------------------------------

<<<<<<< HEAD
-- Process(clk_rx_Serial_ch)
-- begin
-- if rising_edge(clk_rx_Serial_ch) then
	
-- 	align_load_00	<=	qout_v_IS(9 downto 7);
-- 	align_load_0	<=	align_load_00;

-- end if;
-- end process;

-- align_load_0	<=	"010" 	;


=======
-- align_load_0	<=	qout_v_IS(9 downto 7) 	;
>>>>>>> e296f02de89eba86bbe678e34dace66c718d9223
RX_DDR_CH_q0: RX_DDR_CH   
generic map (bit_data_imx) 
port map (
		-- Inputs
	clk_rx_Serial			=> clk_rx_Serial_ch,
	-- data_rx_Serial			=> is_ch(0),
	QR_data_rx_Serial		=> QR_ddr(0),
	QF_data_rx_Serial		=> QF_ddr(0),
	main_reset				=> reset_2_1,	
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
	QR_data_rx_Serial		=> QR_ddr(1),
	QF_data_rx_Serial		=> QF_ddr(1),
	main_reset				=> reset_2_1,	
	main_enable				=> main_enable,	
	align_load				=> align_load_0,	
		-- Outputs
	data_rx_Parallel		=> data_rx_ch_1
);	

RX_DDR_CH_q2: RX_DDR_CH   
generic map (bit_data_imx) 
port map (
		-- Inputs
	clk_rx_Serial			=> clk_rx_Serial_ch,
	QR_data_rx_Serial		=> QR_ddr(2),
	QF_data_rx_Serial		=> QF_ddr(2),
	main_reset				=> reset_2_1,	
	main_enable				=> main_enable,	
	align_load				=> align_load_0,	
		-- Outputs
	data_rx_Parallel		=> data_rx_ch_2
);	
RX_DDR_CH_q3: RX_DDR_CH   
generic map (bit_data_imx) 
port map (
		-- Inputs
	clk_rx_Serial			=> clk_rx_Serial_ch,
	QR_data_rx_Serial		=> QR_ddr(3),
	QF_data_rx_Serial		=> QF_ddr(3),
	main_reset				=> reset_2_1,	
	main_enable				=> main_enable,	
	align_load				=> align_load_0,	
		-- Outputs
	data_rx_Parallel		=> data_rx_ch_3
);	
----------------------------------------------------------------------
-- модуль синхронизации по 4 каналам
----------------------------------------------------------------------
sync_word_4ch_q: sync_word_4ch   
generic map (
		bit_data_imx,
		IMX_2200_1250p50.PixPerLine
		) 
port map (
		-- Inputs
   clk_rx_Parallel	=> clk_rx_Parallel_ch,
	data_rx_ch_0		=> data_rx_ch_0,	
	data_rx_ch_1		=> data_rx_ch_1,	
	data_rx_ch_2		=> data_rx_ch_2,	
   data_rx_ch_3		=> data_rx_ch_3,	
   main_enable		   => main_enable,	
   main_reset		   => reset_3_1,	
		-- Outputs
	cnt_imx_word_rx	=> cnt_imx_word_rx,
	valid_data_rx		=> valid_data_rx,
<<<<<<< HEAD
	align_load_0		=> align_load_0
   -- align_load_1     	=> align_load_1,
   -- align_load_2     	=> align_load_2,
   -- align_load_3     	=> align_load_3
);	
-- ----------------------------------------------------------------------
-- -- модуль мультиплексирования 1/2/4 каналов от фотоприемнка в RAW
-- ----------------------------------------------------------------------

-- Process(clk_rx_Parallel_ch)
-- begin
-- if rising_edge(clk_rx_Parallel_ch) then
-- 	data_rx_ch_0_w		<= '0' & data_rx_ch_0;
-- 	data_rx_ch_1_w		<= '0' & data_rx_ch_1;
-- 	data_rx_ch_2_w		<= '0' & data_rx_ch_2;
-- 	data_rx_ch_3_w		<= '0' & data_rx_ch_3;
-- 	data_rx_ch_0_1_w	<=	std_logic_vector(unsigned (data_rx_ch_0_w) + unsigned (data_rx_ch_1_w));
-- 	data_rx_ch_2_3_w	<=	std_logic_vector(unsigned (data_rx_ch_0_w) + unsigned (data_rx_ch_0_w));
-- 	end if;
-- end process;
-- Process(clk_rx_Parallel_ch)
-- begin
-- if rising_edge(clk_rx_Parallel_ch) then

-- 	if qout_clk_IS(9)='1'	then
-- 		-- data_RAW_RX		<= data_rx_ch_0_1_w(12 downto 1);			
-- 		data_RAW_RX		<= data_rx_ch_0;			
-- 	else
-- 		data_RAW_RX		<= data_rx_ch_2_3_w(12 downto 1);			
-- 	end if;
-- end if;
-- end process;




-- data_RAW_RX	<=	data_rx_ch_0;




mux_ch_to_raw_q: mux_ch_to_raw   
=======
	align_load_0		=> align_load_0,
   align_load_1     	=> align_load_1,
   align_load_2     	=> align_load_2,
   align_load_3     	=> align_load_3
);	
----------------------------------------------------------------------
-- модуль мультиплексирования 1/2/4 каналов от фотоприемнка в RAW
----------------------------------------------------------------------

-- data_RAW_RX	<=	data_rx_ch_0;

rx_ch_n_to_raw_q: rx_ch_to_raw   
>>>>>>> e296f02de89eba86bbe678e34dace66c718d9223
generic map (
	EKD_2200_1250p50.PixPerLine,
	EKD_2200_1250p50.HsyncShift,
	EKD_2200_1250p50.ActivePixPerLine
		) 
port map (
		-- Inputs
   main_reset			=> reset_3_1,
	main_enable			=> main_enable,	
	CLK_sys				=> CLK_sys,	
	ena_clk_x_q_IS		=> ena_clk_x_q_IS,	
   qout_clk_IS			=> qout_clk_IS,	
	clk_rx_Parallel  	=> clk_rx_Parallel_ch,
	cnt_imx_word_rx	=> cnt_imx_word_rx,
	valid_data_rx		=> valid_data_rx,
	data_rx_ch_0	  	=> data_rx_ch_0,	
   data_rx_ch_1	  	=> data_rx_ch_1,	
   data_rx_ch_2	  	=> data_rx_ch_2,	
   data_rx_ch_3	  	=> data_rx_ch_3,	
		-- Outputs
	data_rx_raw			=> data_RAW_RX
);	
sync_H	<=valid_data_rx;
sync_V	<=valid_data_rx;

-- Process(CLK_sys)
-- begin
-- if rising_edge(CLK_sys) then
-- 	if qout_clk_IS(9)='1'	then
-- 		-- data_RAW_RX	<=	data_rx_ch_0;
-- 		data_RAW_RX	<=	data_rx_raw;

-- 	else
-- 		data_RAW_RX	<=	data_rx_raw;
-- 	end if;
-- end if;
-- end process;



-- sync_H	<=valid_data_rx;
-- sync_V	<=data_rx_ch_0(0);

end ;
