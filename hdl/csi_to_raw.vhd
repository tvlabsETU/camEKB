library ieee;

use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.CONSTANTS.all;

entity csi_to_raw is

------------------------------------модуль приема данных IMX-----------------------------------------------------
port (
	CLK_RX_Parallel		: in std_logic;  									-- CLK Serial
	CLK_sys				: in std_logic;   
	ena_clk_x2			: in std_logic; 									-- разрешение частоты /2
	ena_clk_x4			: in std_logic; 									-- разрешение частоты /4
	ena_clk_x8			: in std_logic; 									-- разрешение частоты /8
	MAIN_reset			: in std_logic;  									-- reset
	MAIN_ENABLE			: in std_logic;  									-- ENABLE
	DATA_CSI_CH			: in std_logic_vector (bit_data_CSI-1 downto 0); 	-- отладка
	-- cnt_imx_word		: in std_logic_vector (bit_pix-1 downto 0); 	-- счетчик пикселей
	Mode_debug			: in std_logic_vector (7 downto 0); 				-- отладка
	qout_clk_IS			: in std_logic_vector (bit_pix-1 downto 0); 	-- счетчик пикселей
	qout_v				: in  std_logic_vector (bit_strok-1 downto 0); -- счетчик строк
	data_IMX			: out std_logic_vector (bit_data_imx-1 downto 0)	-- принятый сигнал							  	 														  		
		);
end csi_to_raw;

architecture beh of csi_to_raw is 

-------------------------------------------------------------------------------
component fifo_40_bit is
	-- Port list
	port(
        -- Inputs
        DATA      : in  std_logic_vector(39 downto 0);
        RCLOCK    : in  std_logic;
        RE        : in  std_logic;
        RESET     : in  std_logic;
        WCLOCK    : in  std_logic;
        WE        : in  std_logic;
        -- Outputs
		DVLD   : out std_logic;
		EMPTY  : out std_logic;
		FULL   : out std_logic;
		Q      : out std_logic_vector(39 downto 0)
);
end component;
signal RESET_fifo			: std_logic;
signal word_40bit_wr		: std_logic_vector (39 downto 0);
signal word_40bit_wr_1		: std_logic_vector (39 downto 0);


signal word_40bit_rd		: std_logic_vector (39 downto 0);
signal wrreq_40_bit			: std_logic;
signal rdreq_40_bit			: std_logic;
signal remain				: integer range 0 to 4;
signal shift_word_40_bit	: integer range 0 to 4;
signal DVLD					: std_logic;
signal EMPTY				: std_logic;
signal FULL					: std_logic;
----------------------------------счетчик -----------------------

-------------------------------------------------------------------------------
signal DATA_CSI_CH1_in		: std_logic_vector (7 downto 0);
-------------------------------------------------------------------------------
signal reset_cnt_pix_8bit	: std_logic;	
-------------------------------------------------------------------------------
signal data_imx_i			: std_logic_vector (9 downto 0);

signal cnt_imx_word	: std_logic_vector (bit_pix-1 downto 0);
type ram_byf is array (0 to 4) of std_logic_vector (bit_data_CSI-1 downto 0)	;
signal DATA_CSI_CH_q : ram_byf := (others => (others => '0'));
signal word_catch_40_bit	: std_logic;	
signal word_align			: std_logic_vector (39 downto 0);

-------------------------------------------------------------------------------
begin
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
cnt_imx_word0: count_n_modul                    
generic map (bit_pix) 
port map (
			clk			=>	CLK_RX_Parallel,			
			reset		=>	MAIN_reset ,
			en			=>	MAIN_ENABLE,		
			modul		=> 	std_logic_vector(to_unsigned(CEA_1920_1080p30.PixPerLine,bit_pix)),
			qout		=>	cnt_imx_word);

reset_cnt_pix_8bit	<=	MAIN_reset;
Process(CLK_RX_Parallel)
  begin
    if  rising_edge(CLK_RX_Parallel) then 	
		remain	<=	to_integer(unsigned(cnt_imx_word))	rem 5;
	end if;
end process;


p_Shift_0 : process (CLK_RX_Parallel)
begin
if rising_edge(CLK_RX_Parallel) then
	-- word_align	<=x"FF301c2bb8";
	word_align	<=x"00071c2bb8";
	DATA_CSI_CH_q(0)	<=	DATA_CSI_CH;
	for ii in 0 to 3 loop
		DATA_CSI_CH_q(ii+1) <= DATA_CSI_CH_q(ii);
	end loop;  

	if DATA_CSI_CH_q(0) &	DATA_CSI_CH_q(1) &	DATA_CSI_CH_q(2) &	DATA_CSI_CH_q(3) &	DATA_CSI_CH_q(4)	= word_align	then
		word_catch_40_bit	<='1';
	else
		word_catch_40_bit	<='0';
	end if;

end if;
end process;




process(CLK_RX_Parallel)
begin
	if rising_edge(CLK_RX_Parallel) then
		DATA_CSI_CH1_in<=DATA_CSI_CH;
		DATA_CSI_CH1_in<=DATA_CSI_CH;
		if word_catch_40_bit='1' then
			shift_word_40_bit	<=remain;
		end if ;

		case	shift_word_40_bit	is
			when	0	=>
				CASE remain IS
					WHEN 0  	=> 	
						word_40bit_wr(9 downto 2)	<=	DATA_CSI_CH1_in;
						wrreq_40_bit	<= '0';
					WHEN 1  	=> 	
						word_40bit_wr(9+10 downto 2+10)	<=	DATA_CSI_CH1_in;
						wrreq_40_bit	<= '0';
					WHEN 2  	=> 	
						word_40bit_wr(9+20 downto 2+20)	<=	DATA_CSI_CH1_in;
						wrreq_40_bit	<= '0';
					WHEN 3  	=> 	
						word_40bit_wr(9+30 downto 2+30)	<=	DATA_CSI_CH1_in;
						wrreq_40_bit	<= '0';
					WHEN 4  	=> 	
						word_40bit_wr(1 downto 0)		<=	DATA_CSI_CH1_in(1 downto 0);
						word_40bit_wr(1+10 downto 0+10)	<=	DATA_CSI_CH1_in(1+2 downto 0+2);
						word_40bit_wr(1+20 downto 0+20)	<=	DATA_CSI_CH1_in(1+4 downto 0+4);
						word_40bit_wr(1+30 downto 0+30)	<=	DATA_CSI_CH1_in(1+6 downto 0+6);
						wrreq_40_bit	<= '1';
					WHEN others => null;		
				END CASE;
			when	1	=>
				CASE remain IS
					WHEN 1  	=> 	
						word_40bit_wr(9 downto 2)	<=	DATA_CSI_CH1_in;
						wrreq_40_bit	<= '0';
					WHEN 2  	=> 	
						word_40bit_wr(9+10 downto 2+10)	<=	DATA_CSI_CH1_in;
						wrreq_40_bit	<= '0';
					WHEN 3  	=> 	
						word_40bit_wr(9+20 downto 2+20)	<=	DATA_CSI_CH1_in;
						wrreq_40_bit	<= '0';
					WHEN 4  	=> 	
						word_40bit_wr(9+30 downto 2+30)	<=	DATA_CSI_CH1_in;
						wrreq_40_bit	<= '0';
					WHEN 0  	=> 	
						word_40bit_wr(1 downto 0)		<=	DATA_CSI_CH1_in(1 downto 0);
						word_40bit_wr(1+10 downto 0+10)	<=	DATA_CSI_CH1_in(1+2 downto 0+2);
						word_40bit_wr(1+20 downto 0+20)	<=	DATA_CSI_CH1_in(1+4 downto 0+4);
						word_40bit_wr(1+30 downto 0+30)	<=	DATA_CSI_CH1_in(1+6 downto 0+6);
						wrreq_40_bit	<= '1';
					WHEN others => null;		
				END CASE;
			when	2	=>
				CASE remain IS
					WHEN 2  	=> 	
						word_40bit_wr(9 downto 2)	<=	DATA_CSI_CH1_in;
						wrreq_40_bit	<= '0';
					WHEN 3  	=> 	
						word_40bit_wr(9+10 downto 2+10)	<=	DATA_CSI_CH1_in;
						wrreq_40_bit	<= '0';
					WHEN 4  	=> 	
						word_40bit_wr(9+20 downto 2+20)	<=	DATA_CSI_CH1_in;
						wrreq_40_bit	<= '0';
					WHEN 0  	=> 	
						word_40bit_wr(9+30 downto 2+30)	<=	DATA_CSI_CH1_in;
						wrreq_40_bit	<= '0';
					WHEN 1  	=> 	
						word_40bit_wr(1 downto 0)		<=	DATA_CSI_CH1_in(1 downto 0);
						word_40bit_wr(1+10 downto 0+10)	<=	DATA_CSI_CH1_in(1+2 downto 0+2);
						word_40bit_wr(1+20 downto 0+20)	<=	DATA_CSI_CH1_in(1+4 downto 0+4);
						word_40bit_wr(1+30 downto 0+30)	<=	DATA_CSI_CH1_in(1+6 downto 0+6);
						wrreq_40_bit	<= '1';
					WHEN others => null;	
				END CASE;
			when	3	=>
				CASE remain IS
					WHEN 3  	=> 	
						word_40bit_wr(9 downto 2)	<=	DATA_CSI_CH1_in;
						wrreq_40_bit	<= '0';
					WHEN 4  	=> 	
						word_40bit_wr(9+10 downto 2+10)	<=	DATA_CSI_CH1_in;
						wrreq_40_bit	<= '0';
					WHEN 0  	=> 	
						word_40bit_wr(9+20 downto 2+20)	<=	DATA_CSI_CH1_in;
						wrreq_40_bit	<= '0';
					WHEN 1  	=> 	
						word_40bit_wr(9+30 downto 2+30)	<=	DATA_CSI_CH1_in;
						wrreq_40_bit	<= '0';
					WHEN 2  	=> 	
						word_40bit_wr(1 downto 0)		<=	DATA_CSI_CH1_in(1 downto 0);
						word_40bit_wr(1+10 downto 0+10)	<=	DATA_CSI_CH1_in(1+2 downto 0+2);
						word_40bit_wr(1+20 downto 0+20)	<=	DATA_CSI_CH1_in(1+4 downto 0+4);
						word_40bit_wr(1+30 downto 0+30)	<=	DATA_CSI_CH1_in(1+6 downto 0+6);
						wrreq_40_bit	<= '1';
					WHEN others => null;	
				END CASE;
			when	4	=>
				CASE remain IS
					WHEN 4  	=> 	
						word_40bit_wr(9 downto 2)	<=	DATA_CSI_CH1_in;
						wrreq_40_bit	<= '0';
					WHEN 0  	=> 	
						word_40bit_wr(9+10 downto 2+10)	<=	DATA_CSI_CH1_in;
						wrreq_40_bit	<= '0';
					WHEN 1  	=> 	
						word_40bit_wr(9+20 downto 2+20)	<=	DATA_CSI_CH1_in;
						wrreq_40_bit	<= '0';
					WHEN 2  	=> 	
						word_40bit_wr(9+30 downto 2+30)	<=	DATA_CSI_CH1_in;
						wrreq_40_bit	<= '0';
					WHEN 3  	=> 	
						word_40bit_wr(1 downto 0)		<=	DATA_CSI_CH1_in(1 downto 0);
						word_40bit_wr(1+10 downto 0+10)	<=	DATA_CSI_CH1_in(1+2 downto 0+2);
						word_40bit_wr(1+20 downto 0+20)	<=	DATA_CSI_CH1_in(1+4 downto 0+4);
						word_40bit_wr(1+30 downto 0+30)	<=	DATA_CSI_CH1_in(1+6 downto 0+6);
						wrreq_40_bit	<= '1';
					WHEN others => null;					
				END CASE;
			WHEN others => null;					

		END CASE;
	end if;
end process;



-- process(CLK_sys)
-- begin
--     if  rising_edge(CLK_sys) then 	
-- 		word_40bit_wr_1	<=word_40bit_wr;
-- 	end if;
-- end process;





RESET_fifo	<= not MAIN_reset;
fifo_40_bit_q: fifo_40_bit                    
port map (
		-- Inputs
	DATA		=>	word_40bit_wr,	
	RCLOCK		=>	CLK_sys ,
	RE			=>	rdreq_40_bit,		
	RESET		=>	RESET_fifo,		
	WCLOCK		=> 	CLK_RX_Parallel,
	WE			=>	wrreq_40_bit,
		-- Outputs
	DVLD		=>	DVLD, 
	EMPTY		=>	EMPTY, 
	FULL		=>	FULL, 
	Q			=>	word_40bit_rd 	);


process(CLK_sys)
begin
    if  rising_edge(CLK_sys) then 	
		CASE qout_clk_IS(1 downto 0) IS
			WHEN "10"  	=> 	
				data_imx_i		<=	word_40bit_rd(9 downto 0);
				rdreq_40_bit	<= '0';
			WHEN "11"  	=> 	
				data_imx_i		<=	word_40bit_rd(19 downto 10);
				rdreq_40_bit	<= '0';
			WHEN "00"   	=> 	
				data_imx_i		<=	word_40bit_rd(29 downto 20);
				rdreq_40_bit	<= '0';
			WHEN "01"   	=> 	
				data_imx_i		<=	word_40bit_rd(39 downto 30);
				rdreq_40_bit	<= '1';
			WHEN others => null;		
		END CASE;
	end if;
end process;




-- wraddress_ram_q: count_n_modul                    
-- generic map (10) 
-- port map (
-- 			clk			=>	CLK_RX_Parallel,			
-- 			reset		=>	reset_cnt_pix_8bit ,
-- 			en			=>	wrreq_40_bit,		
-- 			modul		=> 	std_logic_vector(to_unsigned(550,10)),
-- 			qout		=>	wraddress_ram1);

-- process(CLK_sys)
-- begin
--     if  rising_edge(CLK_sys) then 	
-- 		if qout_clk_IS(1 downto 0)="00"	then
-- 			if to_integer(unsigned (qout_clk_IS)) >= 4   and  to_integer(unsigned (qout_clk_IS)) < 375*4 +4
-- 				then valid_rdaddress_ram<= '1';
-- 				else valid_rdaddress_ram<= '0';
-- 			end if;
-- 		else valid_rdaddress_ram<= '0';
-- 		end if;	
-- 	end if;
-- end process;

-- process(CLK_sys)
-- begin
--     if  rising_edge(CLK_sys) then 	
-- 		if  qout_clk_IS(1 downto 0)="00"	then
-- 			if to_integer(unsigned (qout_clk_IS)) >= 4 +30   and  to_integer(unsigned (qout_clk_IS)) < 1400 +4 +30  
-- 				then valid_data_ram<= '1';
-- 				else valid_data_ram<= '0';
-- 			end if;
-- 		end if;	
-- 	end if;
-- end process;
	
-- rdaddress_ram_q: count_n_modul                    
-- generic map (10) 
-- port map (
-- 			clk			=>	CLK_sys,			
-- 			reset		=>	reset_cnt_pix_8bit ,
-- 			en			=>	valid_rdaddress_ram,		
-- 			modul		=> 	std_logic_vector(to_unsigned(550,10)),
-- 			qout		=>	rdaddress_ram1);
			
-- process(CLK_RX_Parallel)
-- begin
-- 	if rising_edge(CLK_RX_Parallel) then
-- 		wren_ram1	<=	qout_v(0)		and wrreq_40_bit;
-- 		wren_ram2	<=	not qout_v(0)	and wrreq_40_bit;
-- 	end if;
-- end process;

-- ram_40bit_line_q0: ram_40bit_line                   
-- port map (
-- --------------------IN signal---------
-- 	WD		=>	word_40bit_wr,	
-- 	RADDR	=>	rdaddress_ram1,
-- 	REN		=>	'1' ,	
-- 	RCLK	=>	CLK_sys ,	
-- 	WADDR	=>	wraddress_ram1,
-- 	WCLK	=>	CLK_RX_Parallel,
-- 	WEN		=>	wren_ram1,
-- --------------------OUT signal---------
-- 	RD		=>	data_ram1_rd
-- 			);	

-- ram_40bit_line_q1: ram_40bit_line                   
-- port map (
-- --------------------IN signal---------
-- 	WD		=>	word_40bit_wr,	
-- 	RADDR	=>	rdaddress_ram1,
-- 	REN		=>	'1' ,	
-- 	RCLK	=>	CLK_sys ,	
-- 	WADDR	=>	wraddress_ram1,
-- 	WCLK	=>	CLK_RX_Parallel,
-- 	WEN		=>	wren_ram2,
-- --------------------OUT signal---------
-- 	RD		=>	data_ram2_rd
-- 			);	

-- ------------------------------------сигналы разрешения для счетчиков-----------------------------------------------------
-- Process(CLK_sys)
-- begin
-- if rising_edge(CLK_sys) then
-- 	if valid_data_ram='1'	then
-- 		if qout_v(0)='1'	then	
-- 			case qout_clk_IS(1 downto 0)	is
-- 				when "00"	=>	data_imx_i(9 downto 0)	<=	data_ram2_rd(9 downto 0);
-- 				when "01"	=>	data_imx_i(9 downto 0)	<=	data_ram2_rd(19 downto 10);
-- 				when "10"	=>	data_imx_i(9 downto 0)	<=	data_ram2_rd(29 downto 20);
-- 				when "11"	=>	data_imx_i(9 downto 0)	<=	data_ram2_rd(39 downto 30);
-- 				when others	=> null;
-- 			end case;
-- 		else
-- 			case qout_clk_IS(1 downto 0)	is
-- 				when "00"	=>	data_imx_i(9 downto 0)	<=	data_ram1_rd(9 downto 0);
-- 				when "01"	=>	data_imx_i(9 downto 0)	<=	data_ram1_rd(19 downto 10);
-- 				when "10"	=>	data_imx_i(9 downto 0)	<=	data_ram1_rd(29 downto 20);
-- 				when "11"	=>	data_imx_i(9 downto 0)	<=	data_ram1_rd(39 downto 30);
-- 				when others	=> null;
-- 			end case;
-- 		end if;
-- 	else
-- 	data_imx_i(9 downto 0)	<=	"0000000000";
-- 	end if;	
-- end if;
-- end process;
data_IMX	<=data_imx_i(9 downto 0);



end ;
