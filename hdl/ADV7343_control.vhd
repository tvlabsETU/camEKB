library ieee;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.VIDEO_CONSTANTS.all;
use work.My_component_pkg.all;
----------------------------------------------------------------------
---?????? ?????????? ADV7343
----------------------------------------------------------------------
entity ADV7343_control is
port (
------------------------------------??????? ???????-----------------------
   CLK				: in std_logic;  											-- ???????? ?? ?????????
   reset				: in std_logic;  											-- ?????
   main_enable		: in std_logic;  											-- ?????????? ??????
   qout_clk	    	: in	std_logic_vector (bit_pix-1 downto 0); 	-- ??????? ????????
   qout_v			: in	std_logic_vector (bit_strok-1 downto 0); 	-- ??????? ?????
   ena_clk_x_q		: in	std_logic_vector (3 downto 0); 				-- ?????????? ??????? /2 /4 /8/ 16
   data_in     	: in std_logic_vector (7 downto 0);             -- ????? ??????
   ------------------------------------???????? ???????----------------------
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
end ADV7343_control;

architecture beh of ADV7343_control is 


type state_type is (st0, st1, st2, st_wait);    -- Register to hold the current state
signal state : state_type;                      -- Register to hold the current state
signal dac_pblk_v    : std_logic:='0';		
signal dac_pblk_h    : std_logic:='0';	
signal cnt_reg       : integer range 0 to 10:=0;	

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
signal reg_adv7343   : ROM_array ;  --???????? ??? adv7343 
constant content: ROM_array := (
0  =>   X"17"	& 	X"02",   -- Software reset.
1  =>   X"00"	& 	X"1C",   -- All DACs enabled. PLL enabled (4×).
2  =>   X"01"	& 	X"10",   -- HD-SDR input mode..
-- 3  =>   X"30"	& 	X"28",   -- 720p at 60 Hz/59.94 Hz. HSYNC/VSYNC synchronization. EIA-770.3 output levels..
3  =>   X"30"	& 	X"80",   -- 720p at 60 Hz/59.94 Hz. HSYNC/VSYNC synchronization. EIA-770.3 output levels..
4  =>   X"31"	& 	X"01",   -- Pixel data valid. 4× oversampling.
-- 5  =>   X"17"	& 	X"02",   -- Software reset.
-- 6  =>   X"17"	& 	X"02",   -- Software reset.
others => X"00_1C"); 

begin

----------------------------------------------------------------------
-- ???????????? ???????????????
----------------------------------------------------------------------
Process(CLK)
begin
if rising_edge(CLK) then

   if to_integer(unsigned(qout_V)) >=EKD_ADV7343_1080p25.VsyncShift 
      and to_integer(unsigned(qout_V)) < EKD_ADV7343_1080p25.VsyncShift + EKD_ADV7343_1080p25.VsyncWidth then
         dac_pvsync  <= '0';
      else
         dac_pvsync  <= '1';
   end if;

   if to_integer(unsigned(qout_clk)) >=EKD_ADV7343_1080p25.HsyncShift 
      and to_integer(unsigned(qout_clk)) < EKD_ADV7343_1080p25.HsyncShift + EKD_ADV7343_1080p25.HsyncWidth then
         dac_phsync  <= '0';
         Get_m       <= '1';
      else
         dac_phsync  <= '1';
         Get_m       <= '0';
         end if;

   if to_integer(unsigned(qout_V)) >=EKD_ADV7343_1080p25.VsyncShift + EKD_ADV7343_1080p25.InActiveLine -  EKD_ADV7343_1080p25.VsyncWidth
      and to_integer(unsigned(qout_V)) < EKD_ADV7343_1080p25.VsyncShift + EKD_ADV7343_1080p25.InActiveLine -  EKD_ADV7343_1080p25.VsyncWidth + EKD_ADV7343_1080p25.ActiveLine  then
         dac_pblk_v  <= '1';
      else
         dac_pblk_v  <= '0';
   end if;

   if to_integer(unsigned(qout_clk)) >=EKD_ADV7343_1080p25.HsyncShift + EKD_ADV7343_1080p25.HsyncWidthGapRight 
      and to_integer(unsigned(qout_clk)) < EKD_ADV7343_1080p25.HsyncShift + EKD_ADV7343_1080p25.HsyncWidthGapRight  + EKD_ADV7343_1080p25.ActivePixPerLine  then
         dac_pblk_h  <= '1';
      else
         dac_pblk_h  <= '0';
   end if;
end if;
end process;
DAC_PBLK <= dac_pblk_v and dac_pblk_h;
-- DAC_PBLK    <= CLK;
DAC_CLK     <= CLK;
-- dac_phsync  <= CLK;
-- dac_pvsync  <= CLK;

DAC_Y       <= qout_clk(7 downto 0);
----------------------------------------------------------------------
-- -- PADDR_i2c   <="010101010";
-- PENABLE_i2c <= '0';
-- PRESETN_i2c <= '0';
-- PSEL_i2c    <= '0';
-- -- PWDATA_i2c  <= x"12";
-- PWRITE_i2c  <= '0';
-- SCLI_i2c    <= "0";
-- SDAI_i2c    <= "0";
-- ----------------------------------------------------------------------
-- adv7343_i2c_q: adv7343_i2c                   
-- port map (
-- 	-- Inputs
--    BCLK    => CLK,
--    PADDR   => "000000000",
--    PCLK    => CLK,
--    PENABLE => PENABLE_i2c ,
--    PRESETN => PRESETN_i2c ,
--    PSEL    => PSEL_i2c,    
--    PWDATA  => x"12",  
--    PWRITE  => PWRITE_i2c, 
--    SCLI    => SCLI_i2c,    
--    SDAI    => SDAI_i2c   
--    -- Outputs 
--    -- INT     => INT_i2c,   
--    -- PRDATA  => PRDATA_i2c,
--    -- SCLO    => SCLO_i2c,  
--    -- SDAO    => SDAO_i2c  

-- );	

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
-- enable_clk_spi <=	ena_clk_x_q(3);
-- reset_n_i2c    <= not reset;

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
      --c????--
	-- if 

	-- end if;
	
	CASE state IS
      --????????  ?????????? ?????? ????????--
	WHEN st_wait =>
	if  to_integer(unsigned(qout_v)) = 2	 
      then	
         ena_i2c        <= '1';
         reset_n_i2c    <= '1';
			state          <= st0;
			cnt_reg        <= 0;
			data_wr_i2c    <= content(cnt_reg)(15 downto 8);
   end if;
	--???????? ??????? ????????? --
   WHEN st0 =>
      if  qout_v(2 downto 0) = "000"	 then
         if cnt_reg  < 6   then           
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




-- I2C_minion_q: I2C_minion   
-- generic map ( "0101011", true,4) 
-- port map (
-- 	-- Inputs
--    scl               => scl_i2c,
--    sda               => sda_i2c,
--    clk               => CLK,
--    rst               => reset ,
--       -- User interface
--    -- read_req          => scl_i2c ,
--    data_to_master    => x"32" 
--    -- data_valid        => scl_i2c ,
--    -- data_from_master  => scl_i2c 
-- );	


end ;

