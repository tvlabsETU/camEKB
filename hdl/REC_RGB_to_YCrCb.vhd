library ieee;

use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.VIDEO_CONSTANTS.all;
use work.My_component_pkg.all;
---------------------------------------------------
-- преобразование RGB в YCrCb согласно REC601/REC709
-- коэффициенты преобразования зависят от рекомендации
---------------------------------------------------
entity REC_RGB_to_YCrCb is
generic 
(
   koef_Y_r	   : integer :=66;			
   koef_Y_g	   : integer :=129;			
   koef_Y_b	   : integer :=24;			
   koef_Cr_r	: integer :=112;			
   koef_Cr_g	: integer :=94;			
   koef_Cr_b	: integer :=18;			
   koef_Cb_r	: integer :=38;			
   koef_Cb_g	: integer :=74;			
   koef_Cb_b	: integer :=112	
);
port (
	CLK			: in std_logic; 												--	тактовый сигнал данных	
	main_reset	: in std_logic;  												-- main_reset
	ena_clk		: in std_logic;  												-- разрешение по частоте
   data_R		: in std_logic_vector (bit_data_imx-1 downto 0);	-- data IN R
   data_G		: in std_logic_vector (bit_data_imx-1 downto 0); 	-- data IN G
   data_B		: in std_logic_vector (bit_data_imx-1 downto 0); 	-- data IN B
   data_Y		: out std_logic_vector (bit_data_imx-1 downto 0);	-- data OUT Y
   data_Cr		: out std_logic_vector (bit_data_imx-1 downto 0);	-- data OUT Cr
   data_Cb		: out std_logic_vector (bit_data_imx-1 downto 0) 	-- data OUT Cb
		);	
end REC_RGB_to_YCrCb;

architecture beh of REC_RGB_to_YCrCb is 

component mult_x_x is
port( DataA : in    std_logic_vector(11 downto 0);
		DataB : in    std_logic_vector(11 downto 0);
		Mult  : out   std_logic_vector(23 downto 0);
		Clock : in    std_logic
		);
end component;

signal data_Y_r	   : std_logic_vector(23 DOWNTO 0);	
signal data_Y_g	   : std_logic_vector(23 DOWNTO 0);	
signal data_Y_b	   : std_logic_vector(23 DOWNTO 0);	
signal data_Cr_r	   : std_logic_vector(23 DOWNTO 0);	
signal data_Cr_g	   : std_logic_vector(23 DOWNTO 0);	
signal data_Cr_b	   : std_logic_vector(23 DOWNTO 0);	
signal data_Cb_r	   : std_logic_vector(23 DOWNTO 0);	
signal data_Cb_g	   : std_logic_vector(23 DOWNTO 0);	
signal data_Cb_b	   : std_logic_vector(23 DOWNTO 0);	
signal data_Y_1	   : unsigned(bit_data_imx-1 DOWNTO 0);	
signal data_Y_2	   : unsigned(bit_data_imx-1 DOWNTO 0);	
signal data_Cr_1	   : unsigned(bit_data_imx-1 DOWNTO 0);	
signal data_Cr_2	   : unsigned(bit_data_imx-1 DOWNTO 0);	
signal data_Cb_1	   : unsigned(bit_data_imx-1 DOWNTO 0);	
signal data_Cb_2	   : unsigned(bit_data_imx-1 DOWNTO 0);	


begin
---------------------------------------------------
-- формирование сигнала яркости
---------------------------------------------------
data_Y_r_q: mult_x_x   
port map (
	-- Inputs
	DataA		=> data_R,
	DataB		=>	std_logic_vector(to_unsigned(koef_Y_r, 12)) ,
	Mult	   => data_Y_r,
	Clock	   => CLK 
);	
data_Y_g_q: mult_x_x   
port map (
	-- Inputs
	DataA		=> data_G,
	DataB		=>	std_logic_vector(to_unsigned(koef_Y_g, 12)) ,
	Mult	   => data_Y_g,
	Clock	   => CLK 
);	
data_Y_b_q: mult_x_x   
port map (
	-- Inputs
	DataA		=> data_B,
	DataB		=>	std_logic_vector(to_unsigned(koef_Y_b, 12)) ,
	Mult	   => data_Y_b,
	Clock	   => CLK 
);	

process (clk)
begin 
	if(rising_edge(clk)) then 
      data_Y_1 <=	unsigned(data_Y_r(23 downto 12))		               + unsigned(data_Y_g(23 downto 12));
      data_Y_2 <=	to_unsigned(16*(2**(bit_data_imx-8)),bit_data_imx) + unsigned(data_Y_b(23 downto 12));
		data_Y   <= std_logic_vector (data_Y_1 + data_Y_2) ;
   end if;
end process;
---------------------------------------------------

---------------------------------------------------
-- формирование сигнала Cr
---------------------------------------------------
data_Cr_r_q: mult_x_x   
port map (
	-- Inputs
	DataA		=> data_R,
	DataB		=>	std_logic_vector(to_unsigned(koef_Cr_r, 12)) ,
	Mult	   => data_Cr_r,
	Clock	   => CLK 
);	
data_Cr_g_q: mult_x_x   
port map (
	-- Inputs
	DataA		=> data_G,
	DataB		=>	std_logic_vector(to_unsigned(koef_Cr_g, 12)) ,
	Mult	   => data_Cr_g,
	Clock	   => CLK 
);	
data_Cr_b_q: mult_x_x   
port map (
	-- Inputs
	DataA		=> data_B,
	DataB		=>	std_logic_vector(to_unsigned(koef_Cr_b, 12)) ,
	Mult	   => data_Cr_b,
	Clock	   => CLK 
);	
process (clk)
begin 
	if(rising_edge(clk)) then 
      data_Cr_1 <=	unsigned(data_Cr_r(23 downto 12))		            + unsigned(data_Cr_g(23 downto 12));
      data_Cr_2 <=	to_unsigned(2**(bit_data_imx-1),bit_data_imx)   + unsigned(data_Cr_b(23 downto 12));
		data_Cr   <= std_logic_vector (data_Cr_1 + data_Cr_2) ;
   end if;
end process;
---------------------------------------------------

---------------------------------------------------
-- формирование сигнала Cb
---------------------------------------------------
data_Cb_r_q: mult_x_x   
port map (
	-- Inputs
	DataA		=> data_R,
	DataB		=>	std_logic_vector(to_unsigned(koef_Cb_r, 12)) ,
	Mult	   => data_Cb_r,
	Clock	   => CLK 
);	
data_Cb_g_q: mult_x_x   
port map (
	-- Inputs
	DataA		=> data_G,
	DataB		=>	std_logic_vector(to_unsigned(koef_Cb_g, 12)) ,
	Mult	   => data_Cb_g,
	Clock	   => CLK 
);	
data_Cb_b_q: mult_x_x   
port map (
	-- Inputs
	DataA		=> data_B,
	DataB		=>	std_logic_vector(to_unsigned(koef_Cb_b, 12)) ,
	Mult	   => data_Cb_b,
	Clock	   => CLK 
);	
process (clk)
begin 
	if(rising_edge(clk)) then 
      data_Cb_1 <=	unsigned(data_Cb_r(23 downto 12))		            + unsigned(data_Cb_g(23 downto 12));
      data_Cb_2 <=	to_unsigned(2**(bit_data_imx-1),bit_data_imx)   + unsigned(data_Cb_b(23 downto 12));
		data_Cb   <= std_logic_vector (data_Cb_1 + data_Cb_2) ;
   end if;
end process;

end ;
