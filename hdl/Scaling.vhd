library ieee;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.VIDEO_CONSTANTS.all;
use work.My_component_pkg.all;
----------------------------------------------------------------------
--	модуль downscaling
----------------------------------------------------------------------
entity Scaling is
generic  (
	PixPerLine_IS					: integer;
	HsyncShift_IS		   		: integer;
	ActivePixPerLine_IS  		: integer;
	PixPerLine_Inteface		   : integer;
	HsyncShift_Inteface		   : integer;
	ActivePixPerLine_Inteface  : integer
	);

port (		
			--image sensor IN--
	CLK_wr     				: in std_logic;   										-- тактовый 
	CLK_rd     				: in std_logic;   										-- тактовый 
   reset						: in std_logic;  											-- сброс
	data_in					: in std_logic_vector (bit_data_imx-1 downto 0);	-- channel DDR IMX 1
	main_enable				: in std_logic;  											-- разрешение работы
	Mode_debug				: in std_logic_vector (7 downto 0); 				-- отладка
	ena_clk_x_q_IS			: in std_logic_vector (3 downto 0); 				-- разрешение частоты /2 /4 /8/ 16
	qout_clk_IS				: in std_logic_vector (bit_pix-1 downto 0); 		-- счетчик пикселей
	qout_v_IS				: in  std_logic_vector (bit_strok-1 downto 0); 	-- счетчик строк
	qout_frame_IS			: in std_logic_vector (bit_frame-1 downto 0); 	-- счетчик кадров
	ena_clk_x_q_Inteface	: in std_logic_vector (3 downto 0); 				-- разрешение частоты /2 /4 /8/ 16
	qout_clk_Inteface		: in std_logic_vector (bit_pix-1 downto 0); 		-- счетчик пикселей
	qout_v_Inteface		: in  std_logic_vector (bit_strok-1 downto 0); 	-- счетчик строк
		---------Other------------
	data_out			: out std_logic_vector (bit_data_imx-1 downto 0)-- выходной RAW сигнал					  	 														  		
		);
end Scaling;

architecture beh of Scaling is 
----------------------------------------------------------------------
---модуль RAM
----------------------------------------------------------------------
component Ram_scaling is
port( WD    : in    std_logic_vector(11 downto 0);
		RD    : out   std_logic_vector(11 downto 0);
		WEN   : in    std_logic;
		REN   : in    std_logic;
		WADDR : in    std_logic_vector(9 downto 0);
		RADDR : in    std_logic_vector(9 downto 0);
		WCLK  : in    std_logic;
		RCLK  : in    std_logic;
		RESET : in    std_logic
		);
end component;

signal reset_ram_waddr	: std_logic:='0';
signal reset_ram_raddr	: std_logic:='0';
signal valid_ram_raddr	: std_logic:='0';
signal valid_ram_waddr	: std_logic:='0';
signal we_addr				: std_logic_vector (7 downto 0);
signal re_addr				: std_logic_vector (7 downto 0);
signal ram_raddr			: std_logic_vector (bit_RAM_scaling-1 downto 0);
signal ram_waddr			: std_logic_vector (bit_RAM_scaling-1 downto 0);

signal data_ram_0			: std_logic_vector (bit_data_imx-1 downto 0);
signal data_ram_1			: std_logic_vector (bit_data_imx-1 downto 0);
signal data_ram_2			: std_logic_vector (bit_data_imx-1 downto 0);
signal data_ram_3			: std_logic_vector (bit_data_imx-1 downto 0);
signal data_ram_4			: std_logic_vector (bit_data_imx-1 downto 0);
signal data_ram_5			: std_logic_vector (bit_data_imx-1 downto 0);
signal data_ram_6			: std_logic_vector (bit_data_imx-1 downto 0);
signal data_ram_7			: std_logic_vector (bit_data_imx-1 downto 0);
----------------------------------------------------------------------

signal data_ram_0_w		: std_logic_vector (bit_data_imx+1 downto 0);
signal data_ram_1_w		: std_logic_vector (bit_data_imx+1 downto 0);
signal data_ram_2_w		: std_logic_vector (bit_data_imx+1 downto 0);
signal data_ram_3_w		: std_logic_vector (bit_data_imx+1 downto 0);
signal data_ram_4_w		: std_logic_vector (bit_data_imx+1 downto 0);
signal data_ram_5_w		: std_logic_vector (bit_data_imx+1 downto 0);
signal data_ram_6_w		: std_logic_vector (bit_data_imx+1 downto 0);
signal data_ram_7_w		: std_logic_vector (bit_data_imx+1 downto 0);
signal data_bin			: std_logic_vector (bit_data_imx+1 downto 0);

----------------------------------------------------------------------
signal rd_ena_clk			: std_logic:='0';
signal wr_ena_clk			: std_logic:='0';
signal ram_ena				: std_logic_vector (1 downto 0);

----------------------------------------------------------------------


begin
----------------------------------------------------------------------
-- сигналы для чтения
Process(CLK_rd)
begin
if rising_edge(CLK_rd) then
	rd_ena_clk	<=ena_clk_x_q_Inteface(0);
	if to_integer(unsigned (qout_clk_Inteface)) =1	then
		reset_ram_raddr	<= '1';
	else
		reset_ram_raddr	<= '0';
	end if;
	if rd_ena_clk='1' then
		if to_integer(unsigned (qout_clk_Inteface)) >= HsyncShift_Inteface and to_integer(unsigned (qout_clk_Inteface)) < HsyncShift_Inteface + ActivePixPerLine_Inteface	then
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
generic map (bit_RAM_scaling) 
port map (
	clk		=>	CLK_rd,			
	reset		=>	reset_ram_raddr ,
	en			=>	valid_ram_raddr,		
	modul		=>	std_logic_vector(to_unsigned(ActivePixPerLine_Inteface/2, bit_RAM_scaling))  ,
	qout		=>	ram_raddr);
----------------------------------------------------------------------

----------------------------------------------------------------------
-- сигналы для записи
Process(CLK_wr)
begin
if rising_edge(CLK_wr) then
	wr_ena_clk	<='1';
	if to_integer(unsigned (qout_clk_IS)) =1	then
		reset_ram_waddr	<= '1';
	else
		reset_ram_waddr	<= '0';
	end if;
	if wr_ena_clk='1' then
		if to_integer(unsigned (qout_clk_IS)) >= HsyncShift_IS and to_integer(unsigned (qout_clk_IS)) < HsyncShift_IS + ActivePixPerLine_IS	then
				valid_ram_waddr	<= '1';
			else
				valid_ram_waddr	<= '0';
		end if;
	else
		valid_ram_waddr	<= '0';
	end if;
end if;
end process;

ram_waddr_q: count_n_modul	--шина адреса для чтения      
generic map (bit_RAM_scaling) 
port map (
	clk		=>	CLK_wr,			
	reset		=>	reset_ram_waddr ,
	en			=>	valid_ram_waddr,		
	modul		=>	std_logic_vector(to_unsigned(ActivePixPerLine_IS, bit_RAM_scaling))  ,
	qout		=>	ram_waddr);
----------------------------------------------------------------------

----------------------------------------------------------------------
-- мультиплексирование памятей для сложения
----------------------------------------------------------------------
Process(CLK_wr)
begin
if rising_edge(CLK_wr) then
	if valid_ram_waddr='1' then
		case	qout_v_IS(2 downto 0)	is
			when "000" =>	we_addr	<=	"00000001";
			when "001" =>	we_addr	<=	"00000010";
			when "010" =>	we_addr	<=	"00000100";
			when "011" =>	we_addr	<=	"00001000";
			when "100" =>	we_addr	<=	"00010000";
			when "101" =>	we_addr	<=	"00100000";
			when "110" =>	we_addr	<=	"01000000";
			when "111" =>	we_addr	<=	"10000000";
			when others =>	null;
		end case;
	else 
		we_addr	<=	"00000000";
	end if;
end if;
end process;

Process(CLK_rd)
begin
if rising_edge(CLK_rd) then
	if valid_ram_raddr='1' then
		if	qout_frame_IS(0)='1'	then
			case	qout_v_IS(2 downto 0)	is
				when "000" =>	re_addr	<=	"11110000";	ram_ena	<="10";
				when "001" =>	re_addr	<=	"11110000";	ram_ena	<="10";
				when "010" =>	re_addr	<=	"11110000";	ram_ena	<="10";
				when "011" =>	re_addr	<=	"11110000";	ram_ena	<="10";
				when "100" =>	re_addr	<=	"00001111";	ram_ena	<="01";
				when "101" =>	re_addr	<=	"00001111";	ram_ena	<="01";
				when "110" =>	re_addr	<=	"00001111";	ram_ena	<="01";
				when "111" =>	re_addr	<=	"00001111";	ram_ena	<="01";
				when others =>	null;
			end case;
		else
			case	qout_v_IS(2 downto 0)	is
				when "000" =>	re_addr	<=	"00111100";	ram_ena	<="10";
				when "001" =>	re_addr	<=	"00111100";	ram_ena	<="10";
				when "010" =>	re_addr	<=	"11000011";	ram_ena	<="01";
				when "011" =>	re_addr	<=	"11000011";	ram_ena	<="01";
				when "100" =>	re_addr	<=	"11000011";	ram_ena	<="01";
				when "101" =>	re_addr	<=	"11000011";	ram_ena	<="01";
				when "110" =>	re_addr	<=	"00111100";	ram_ena	<="10";
				when "111" =>	re_addr	<=	"00111100";	ram_ena	<="10";
				when others =>	null;
			end case;
		end if;
	else 
		re_addr	<=	"00000000";
	end if;
end if;
end process;


----------------------------------------------------------------------
-- мультиплексирование памятей для сложения
----------------------------------------------------------------------
Ram_scaling_q0: Ram_scaling   
port map (
   -- Inputs
   WD			=> data_in,
   WEN		=> we_addr(0),
   REN	   => re_addr(0),
   WADDR	   => ram_waddr ,
   RADDR		=> ram_raddr ,
   WCLK		=> CLK_wr, 
   RCLK		=> CLK_rd, 
   RESET		=> reset, 
   -- Outputs 
   RD       => data_ram_0
);	

Ram_scaling_q1: Ram_scaling   
port map (
   -- Inputs
   WD			=> data_in,
   WEN		=> we_addr(1),
   REN	   => re_addr(1),
   WADDR	   => ram_waddr ,
   RADDR		=> ram_raddr ,
   WCLK		=> CLK_wr, 
   RCLK		=> CLK_rd, 
   RESET		=> reset, 
   -- Outputs 
   RD       => data_ram_1
);	

Ram_scaling_q2: Ram_scaling   
port map (
   -- Inputs
   WD			=> data_in,
   WEN		=> we_addr(2),
   REN	   => re_addr(2),
   WADDR	   => ram_waddr ,
   RADDR		=> ram_raddr ,
   WCLK		=> CLK_wr, 
   RCLK		=> CLK_rd, 
   RESET		=> reset, 
   -- Outputs 
   RD       => data_ram_2
);	

Ram_scaling_q3: Ram_scaling   
port map (
   -- Inputs
   WD			=> data_in,
   WEN		=> we_addr(3),
   REN	   => re_addr(3),
   WADDR	   => ram_waddr ,
   RADDR		=> ram_raddr ,
   WCLK		=> CLK_wr, 
   RCLK		=> CLK_rd, 
   RESET		=> reset, 
   -- Outputs 
   RD       => data_ram_3
);	

Ram_scaling_q4: Ram_scaling   
port map (
   -- Inputs
   WD			=> data_in,
   WEN		=> we_addr(4),
   REN	   => re_addr(4),
   WADDR	   => ram_waddr ,
   RADDR		=> ram_raddr ,
   WCLK		=> CLK_wr, 
   RCLK		=> CLK_rd, 
   RESET		=> reset, 
   -- Outputs 
   RD       => data_ram_4
);	

Ram_scaling_q5: Ram_scaling   
port map (
   -- Inputs
   WD			=> data_in,
   WEN		=> we_addr(5),
   REN	   => re_addr(5),
   WADDR	   => ram_waddr ,
   RADDR		=> ram_raddr ,
   WCLK		=> CLK_wr, 
   RCLK		=> CLK_rd, 
   RESET		=> reset, 
   -- Outputs 
   RD       => data_ram_5
);	

Ram_scaling_q6: Ram_scaling   
port map (
   -- Inputs
   WD			=> data_in,
   WEN		=> we_addr(6),
   REN	   => re_addr(6),
   WADDR	   => ram_waddr ,
   RADDR		=> ram_raddr ,
   WCLK		=> CLK_wr, 
   RCLK		=> CLK_rd, 
   RESET		=> reset, 
   -- Outputs 
   RD       => data_ram_6
);	

Ram_scaling_q7: Ram_scaling   
port map (
   -- Inputs
   WD			=> data_in,
   WEN		=> we_addr(7),
   REN	   => re_addr(7),
   WADDR	   => ram_waddr ,
   RADDR		=> ram_raddr ,
   WCLK		=> CLK_wr, 
   RCLK		=> CLK_rd, 
   RESET		=> reset, 
   -- Outputs 
   RD       => data_ram_7
);	

Process(CLK_rd)
begin
if rising_edge(CLK_rd) then
	data_ram_0_w	<=	"00" & data_ram_0;
	data_ram_1_w	<=	"00" & data_ram_1;
	data_ram_2_w	<=	"00" & data_ram_2;
	data_ram_3_w	<=	"00" & data_ram_3;
	data_ram_4_w	<=	"00" & data_ram_4;
	data_ram_5_w	<=	"00" & data_ram_5;
	data_ram_6_w	<=	"00" & data_ram_6;
	data_ram_7_w	<=	"00" & data_ram_7;
	if	qout_frame_IS(0)='1'	then

		if ram_ena(0)	= '0'	then
			data_bin	<=	std_logic_vector(unsigned (data_ram_4_w) + unsigned (data_ram_5_w) + unsigned (data_ram_6_w) + unsigned (data_ram_7_w));
		else
			data_bin	<=	std_logic_vector(unsigned (data_ram_0_w) + unsigned (data_ram_1_w) + unsigned (data_ram_2_w) + unsigned (data_ram_3_w));
		end if;
	else
		if  ram_ena(0)	= '0'	then
			data_bin	<=	std_logic_vector(unsigned (data_ram_2_w) + unsigned (data_ram_3_w) + unsigned (data_ram_4_w) + unsigned (data_ram_5_w));
		else
			data_bin	<=	std_logic_vector(unsigned (data_ram_0_w) + unsigned (data_ram_1_w) + unsigned (data_ram_6_w) + unsigned (data_ram_7_w));
		end if;
	end if;
	data_out	<=	data_bin(13 downto 2);

end if;
end process;



end ;
