library ieee;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.VIDEO_CONSTANTS.all;
use work.My_component_pkg.all;
----------------------------------------------------------------------
---модуль интерфейса ADV7343
----------------------------------------------------------------------
entity ADV7343_cntrl is
port (
	------------------------------------входные сигналы-----------------------
   CLK				: in std_logic;  											-- тактовый от гнератора
   reset				: in std_logic;  											-- сброс
   main_enable		: in std_logic;  											-- разрешение работы
   qout_clk	    	: in	std_logic_vector (bit_pix-1 downto 0); 	-- счетчик пикселей
   qout_v			: in	std_logic_vector (bit_strok-1 downto 0); 	-- счетчик строк
   ena_clk_x_q		: in	std_logic_vector (3 downto 0); 				-- разрешение частоты /2 /4 /8/ 16
   data_in     	: in std_logic_vector (bit_data_imx-1 downto 0);             -- режим работы
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
end ADV7343_cntrl;

architecture beh of ADV7343_cntrl is 


---------------------------------------------------
-- преобразование RGB в YCrCb согласно REC601/REC709
-- коэффициенты преобразования зависят от рекомендации
---------------------------------------------------
component REC_RGB_to_YCrCb is
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
end component;

signal data_Y_rec	   : std_logic_vector(bit_data_imx-1 DOWNTO 0);	
signal data_Cr_rec   : std_logic_vector(bit_data_imx-1 DOWNTO 0);	
signal data_Cb_rec   : std_logic_vector(bit_data_imx-1 DOWNTO 0);	

signal DAC_YCrCb  : std_logic_vector(bit_data_imx-1 DOWNTO 0);	

----------------------------------------------------------------------
---модуль вставки TRS кодовв видеопоток
----------------------------------------------------------------------
component SAV_EAV_insert is
generic  (
   HsyncShift		   : integer;
   ActivePixPerLine  : integer
   );
port (
   ------------------------------------входные сигналы-----------------------
   CLK			   : in std_logic;  											      -- тактовый от гнератора
   reset			   : in std_logic;  											      -- сброс
   main_enable	   : in std_logic;  											      -- разрешение работы
   ena_clk_x_q	   : in std_logic_vector (3 downto 0); 				      -- разрешение частоты /2 /4 /8/ 16
   qout_clk		   : in std_logic_vector (bit_pix-1 downto 0);		      -- счетчик пикселей
   qout_v		   : in std_logic_vector (bit_strok-1 downto 0); 	      -- счетчик строк
   data_in		   : in std_logic_vector (bit_data_ADV7343-1 downto 0); 	-- входные данные
   ------------------------------------выходные сигналы----------------------
   data_out		   : out std_logic_vector (bit_data_ADV7343-1 downto 0) 	-- выходные данные
      );
end component;
signal data_TRS	   : std_logic_vector(bit_data_ADV7343-1 DOWNTO 0);	
----------------------------------------------------------------------

type state_type is (st0, st1, st2, st_wait);    -- Register to hold the current state
signal state : state_type;                      -- Register to hold the current state
signal dac_pblk_v    : std_logic:='0';		
signal dac_pblk_h    : std_logic:='0';	
signal cnt_reg       : integer range 0 to 31:=0;	

----------------------------------------------------------------------
component i2c_master IS
GENERIC(
input_clk : INTEGER := 100_000_000; --input clock speed from user logic in Hz
bus_clk   : INTEGER := 400_000);   --speed the i2c bus (scl) will run at in Hz
PORT(
   clk       : IN     STD_LOGIC;                    --system clock
   reset_n   : IN     STD_LOGIC;                    --active low reset
   ena       : IN     STD_LOGIC;                    --latch in command
   addr      : IN     STD_LOGIC_VECTOR(6 DOWNTO 0); --address of target slave
   rw        : IN     STD_LOGIC;                    --'0' is write, '1' is read
   data_wr   : IN     STD_LOGIC_VECTOR(7 DOWNTO 0); --data to write to slave
   busy      : OUT    STD_LOGIC;                    --indicates transaction in progress
   data_rd   : OUT    STD_LOGIC_VECTOR(7 DOWNTO 0); --data read from slave
   ack_error : BUFFER STD_LOGIC;                    --flag if improper acknowledge from slave
   sda       : INOUT  STD_LOGIC;                    --serial data output of i2c bus
   scl       : INOUT  STD_LOGIC);                   --serial clock output of i2c bus
END component;

signal reset_n_i2c	: std_logic:='0';		    
signal ena_i2c    	: std_logic:='0';		    
signal addr_i2c	   : std_logic_vector(6 DOWNTO 0);	
signal rw_i2c     	: std_logic:='0';		    
signal data_wr_i2c   : std_logic_vector(7 DOWNTO 0);	
signal busy_i2c     	: std_logic:='0';		    
signal data_rd_i2c   : std_logic_vector(7 DOWNTO 0);	
signal ack_error_i2c : std_logic:='0';		    
signal sda_i2c       : std_logic:='0';		    
signal scl_i2c       : std_logic:='0';		    

component I2C_minion is
generic (
   MINION_ADDR            : std_logic_vector(6 downto 0);
   -- noisy SCL/SDA lines can confuse the minion
   -- use low-pass filter to smooth the signal
   -- (this might not be necessary!)
   USE_INPUT_DEBOUNCING   : boolean := false;
   -- play with different number of wait cycles
   -- larger wait cycles increase the resource usage
   DEBOUNCING_WAIT_CYCLES : integer := 4);
port (
   scl              : inout std_logic;
   sda              : inout std_logic;
   clk              : in    std_logic;
   rst              : in    std_logic;
   -- User interface
   read_req         : out   std_logic;
   data_to_master   : in    std_logic_vector(7 downto 0);
   data_valid       : out   std_logic;
   data_from_master : out   std_logic_vector(7 downto 0));
end component;

type ROM_array is array (0 to 31) of std_logic_vector (15 downto 0);
signal reg_adv7343   : ROM_array ;  --регистры adv7343 

-- --1080p25--
-- constant content: ROM_array := (
-- 0  =>   X"17"	& 	X"02",   -- Software reset.
-- 1  =>   X"00"	& 	X"1C",   -- All DACs enabled. PLL enabled (4×).
-- 2  =>   X"01"	& 	X"10",   -- HD-SDR input mode..
-- 3  =>   X"30"	& 	X"80",   -- SMPTE 274M-9 1080p at 25 Hz
-- 4  =>   X"31"	& 	X"01",   -- Pixel data valid. 4× oversampling.
-- others => X"00_1C"); 

-- -- 8-Bit PAL Square Pixel YCrCb In (EAV/SAV), CVBS/Y-C Out--
-- constant content: ROM_array := (
-- 0  =>   X"17"	& 	X"02",   -- Software reset.
-- 1  =>   X"00"	& 	X"1C",   -- All DACs enabled. PLL enabled (16×).
-- 2  =>   X"01"	& 	X"00",   -- SD input mode.
-- 3  =>   X"80"	& 	X"11",   -- PAL standard. SSAF luma filter enabled. 1.3 MHz chroma filter enabled.
-- 4  =>   X"82"	& 	X"D3",   -- Pixel data valid. CVBS/Y-C (S-Video) out. SSAF PrPb filter enabled. Active video edge control enabled. Square pixel mode enabled.
-- 5  =>   X"8C"	& 	X"0C",   -- Subcarrier frequency register values for CVBS and/or S-Video (Y-C) output in PAL square pixel mode (29.5 MHz input clock).
-- 6  =>   X"8D"	& 	X"8C",   -- -//-
-- 7  =>   X"8E"	& 	X"79",   -- -//-
-- 8  =>   X"8F"	& 	X"26",   -- -//-
-- others => X"00_1C"); 

-- 16-Bit PAL Square Pixel RGB In, CVBS/Y-C Out--
constant content: ROM_array := (
0  =>   X"17"	& 	X"02",   -- Software reset.
1  =>   X"00"	& 	X"1C",   -- All DACs enabled. PLL enabled (16×).
2  =>   X"01"	& 	X"80",   -- SD input mode.
3  =>   X"80"	& 	X"11",   -- PAL standard. SSAF luma filter enabled. 1.3 MHz chroma filter enabled.
4  =>   X"82"	& 	X"d3",   -- Pixel data valid. CVBS/Y-C (S-Video) out. SSAF PrPb filter enabled. Active video edge control enabled. Square pixel mode enabled.

5  =>   X"87"	& 	X"00",   -- YCrCb input enabled.
6  =>   X"88"	& 	X"00",   -- 16-bit YCbCr input enabled.

7  =>   X"8C"	& 	X"0C",   -- Subcarrier frequency register values for CVBS and/or S-Video (Y-C) output in PAL square pixel mode (29.5 MHz input clock).
8  =>   X"8D"	& 	X"8C",   -- -//-
9 =>   X"8E"	& 	X"79",   -- -//-
10  =>   X"8F"	& 	X"26",   -- -//-
others => X"00_1C"); 

begin

---------------------------------------------------
-- преобразование RGB в YCrCb согласно REC601/REC709
-- коэффициенты преобразования зависят от рекомендации
---------------------------------------------------
REC_RGB_to_YCrCb_q: REC_RGB_to_YCrCb   
generic map (  
   REC_601.koef_Y_r, 
   REC_601.koef_Y_g, 
   REC_601.koef_Y_b, 
   REC_601.koef_Cr_r, 
   REC_601.koef_Cr_g, 
   REC_601.koef_Cr_b, 
   REC_601.koef_Cb_r, 
   REC_601.koef_Cb_g, 
   REC_601.koef_Cb_b   
   ) 
port map (
   -- Inputs
   CLK         => CLK,
   main_reset  => reset,
   ena_clk     => '1',
   data_R      => data_in ,
   data_G      => data_in ,
   data_B      => data_in, 
   -- Outputs 
   data_Y      => data_Y_rec,
   data_Cr     => data_Cr_rec,
   data_Cb     => data_Cb_rec
);	   


SAV_EAV_insert_q: SAV_EAV_insert   
generic map (  
   EKD_ADV7343_PAL.HsyncShift, 
   EKD_ADV7343_PAL.ActivePixPerLine ) 
port map (
   -- Inputs
   CLK			   => CLK,
   reset			   => reset,
   main_enable	   => main_enable,
   ena_clk_x_q	   => ena_clk_x_q ,
   qout_clk		   => qout_clk ,
   qout_v		   => qout_v, 
   data_in		   => DAC_YCrCb(11 downto 4), 
   -- Outputs 
   data_out       => data_TRS
);	

----------------------------------------------------------------------
-- синхросигналы
----------------------------------------------------------------------
Process(CLK)
begin
if rising_edge(CLK) then


   if qout_clk(0)='0' then
      DAC_YCrCb <= data_Y_rec;
      -- DAC_YCrCb <= x"400";
      else 
      DAC_YCrCb <= x"800";
   end if;

   -- if to_integer(unsigned(qout_V)) >=EKD_ADV7343_PAL.VsyncShift 
   --    and to_integer(unsigned(qout_V)) < EKD_ADV7343_PAL.VsyncShift + EKD_ADV7343_PAL.VsyncWidth then
   --       dac_pvsync  <= '0';
   --    else
   --       dac_pvsync  <= '1';
   -- end if;

   -- if to_integer(unsigned(qout_clk)) >=EKD_ADV7343_1080p25.HsyncShift 
   --    and to_integer(unsigned(qout_clk)) < EKD_ADV7343_1080p25.HsyncShift + EKD_ADV7343_1080p25.HsyncWidth then
   --       dac_phsync  <= '0';
   --       Get_m       <= '1';
   --    else
   --       dac_phsync  <= '1';
   --       Get_m       <= '0';
   --       end if;

   -- if to_integer(unsigned(qout_V)) >=EKD_ADV7343_1080p25.VsyncShift + EKD_ADV7343_1080p25.InActiveLine -  EKD_ADV7343_1080p25.VsyncWidth
   --    and to_integer(unsigned(qout_V)) < EKD_ADV7343_1080p25.VsyncShift + EKD_ADV7343_1080p25.InActiveLine -  EKD_ADV7343_1080p25.VsyncWidth + EKD_ADV7343_1080p25.ActiveLine  then
   --       dac_pblk_v  <= '1';
   --    else
   --       dac_pblk_v  <= '0';
   -- end if;

   -- if to_integer(unsigned(qout_clk)) >=EKD_ADV7343_1080p25.HsyncShift + EKD_ADV7343_1080p25.HsyncWidthGapRight 
   --    and to_integer(unsigned(qout_clk)) < EKD_ADV7343_1080p25.HsyncShift + EKD_ADV7343_1080p25.HsyncWidthGapRight  + EKD_ADV7343_1080p25.ActivePixPerLine  then
   --       dac_pblk_h  <= '1';
   --    else
   --       dac_pblk_h  <= '0';
   -- end if;
end if;
end process;
-- DAC_PBLK <= dac_pblk_v and dac_pblk_h;
DAC_PBLK    <= '1';
dac_phsync  <= '1';
dac_pvsync  <= '1';


DAC_CLK     <= CLK;
DAC_Y       <= data_TRS;

----------------------------------------------------------------------

----------------------------------------------------------------------


i2c_master_q: i2c_master   
generic map (  100000000, 400000 ) 
port map (
	-- Inputs
   clk         => CLK,
   reset_n     => reset_n_i2c,
   ena         => ena_i2c,
   addr        => addr_i2c ,
   rw          => rw_i2c ,
   data_wr     => data_wr_i2c,   
   -- Outputs 
   busy        => busy_i2c,   
   data_rd     => data_rd_i2c,
   -- buffer 
   ack_error   => ack_error_i2c,
   -- INOUT 
   sda         => sda_i2c,
   scl         => scl_i2c
);	

-----------------------------------------------------------------------------------
Process(CLK)
begin
if reset='1'   then	
   ena_i2c     <= '0';
   addr_i2c    <= "0101011";
   rw_i2c      <= '0';
   data_wr_i2c <= x"00";
   state       <= st_wait;
   reset_n_i2c <= '0';
else 
   if rising_edge(CLK) then

	CASE state IS
      --ожидание начала загрузки регистров.--
	WHEN st_wait =>
	if  to_integer(unsigned(qout_v)) = 2	 
      then	
         ena_i2c        <= '1';
         reset_n_i2c    <= '1';
			state          <= st0;
			cnt_reg        <= 0;
			data_wr_i2c    <= content(cnt_reg)(15 downto 8);
   end if;
	--прогрузка регистров синхронно с каждой 8 строкой --
   WHEN st0 =>
      if  qout_v(2 downto 0) = "000"	 then
         if cnt_reg  < 12   then           
            ena_i2c  <= '1';
         else
            state       <= st2;
            ena_i2c     <= '0';
            reset_n_i2c <= '0';
         end if;

      end if;
      data_wr_i2c  <= content(cnt_reg)(15 downto 8);
      if busy_i2c ='1' then 
         state          <= st1;
         data_wr_i2c  <= content(cnt_reg)(7 downto 0);
      end if;

   WHEN st1 =>
      data_wr_i2c  <= content(cnt_reg)(7 downto 0);

         if busy_i2c ='1' then 
            state          <= st0;
            ena_i2c        <= '0';

            cnt_reg        <= cnt_reg+1;
            data_wr_i2c    <= content(cnt_reg)(15 downto 8);
         end if;
      -- else
      --    state       <= st_wait;
      --    ena_i2c     <= '0';
      --    reset_n_i2c <= '0';
      -- end if;
   WHEN st2 =>
      ena_i2c     <= '0';
      reset_n_i2c <= '0';

   when others =>  null;
   end case;
end if;
end if;

end process;

DAC_SDA	<= sda_i2c;
DAC_SCL  <= scl_i2c;


end ;

