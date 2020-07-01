library ieee;

use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.VIDEO_CONSTANTS.all;
use work.My_component_pkg.all;
----------------------------------------------------------------------
--модуль управления ФП
----------------------------------------------------------------------
entity imx_control is
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
end imx_control;

architecture beh of imx_control is 

----------------------------------модуль управления по SPI / master-----------------------
component spi_master IS
GENERIC(
	data_length : INTEGER := 16);     --data length in bits
PORT(
	clk     	: IN     STD_LOGIC;                            		 --system clock
	clk_en	: in		std_logic;								--	system clock enable
	reset_n	: IN     STD_LOGIC;                            	 	--asynchronous active low reset
	enable 	: IN     STD_LOGIC;                             	--initiate communication
	cpol   	: IN     STD_LOGIC;  								--clock polarity mode
	cpha   	: IN     STD_LOGIC;  								--clock phase mode
	miso   	: IN     STD_LOGIC;                             	--master in slave out
	sclk   	: OUT    STD_LOGIC;                             	--spi clock
	ss_n   	: OUT    STD_LOGIC;                             	--slave select
	mosi   	: OUT    STD_LOGIC;                             	--master out slave in
	busy   	: OUT    STD_LOGIC;                            	 	--master busy signal
	tx			: IN     STD_LOGIC_VECTOR(data_length-1 DOWNTO 0);  --data to transmit
	rx	   	: OUT    STD_LOGIC_VECTOR(data_length-1 DOWNTO 0)); 	--data received
END component;

signal reset_n_spi_master	: std_logic:='0';										
signal enable_spi_master	: std_logic:='0';										
signal cpol_spi_master		: std_logic:='0';										
signal cpha_spi_master		: std_logic:='0';										
signal miso_spi_master		: std_logic:='0';										
signal sclk_spi_master		: std_logic:='0';		
signal ss_n_spi_master		: std_logic:='0';		
signal mosi_spi_master		: std_logic:='0';										
signal busy_spi_master		: std_logic:='0';										
signal tx_spi_master		: std_logic_vector (23 downto 0):=(others => '0');										
signal rx_spi_master		: std_logic_vector (23 downto 0):=(others => '0');	
-------------------------------------------------------------------

-------------------------------------------------------------------
signal qout_imx				: std_logic_vector (29 downto 0):=(others => '0');			
signal reset_gs				: std_logic:='0';		
signal ena_spi_imx			: std_logic:='0';				
signal CLK_SPI				: std_logic:='0';			 		-- такт SPI
signal enable_clk_spi		: std_logic:='0';					--	сигнал разрешения тактов CLK для формирования частоты CLK_SPI						
signal addr_rom_reg			: std_logic_vector (7 downto 0):=(others => '0');											
signal addr_reg_ACTIVE		: std_logic_vector (7 downto 0):=(others => '0');	--адерес для регистров обновляемых каждый кадр											
signal ena_rw_reg			: std_logic:='0';			 		-- такт SPI				
					
type state_type is (st0, st1, st2, st_wait);					-- Register to hold the current state
signal state : state_type;										-- Register to hold the current state


type ROM_array is array (0 to 255) of std_logic_vector (23 downto 0);
type ROM_array2 is array (0 to 31) of std_logic_vector (23 downto 0);
signal content2				: ROM_array2 ; 						--память для регистров обновляемых каждый кадр
constant content: ROM_array := (
0=>		X"C0"	& 	X"01"	& 	X"02"	,
1=>		X"20"	& 	X"05"	& 	X"02"	,--8(1h) ch LVDS /4(2h) ch LVDS  
2=>		X"01"	& 	X"0C"	& 	X"02"	,--1: 12 bit
3=>		X"0C"	& 	X"0D"	& 	X"02"	,-- 1080p-FULL HD mode 
4=>		X"65"	& 	X"10"	& 	X"02"	,--1125
5=>		X"04"	& 	X"11"	& 	X"02"	,
-- 4=>		X"ee"	& 	X"10"	& 	X"02"	,
-- 5=>		X"02"	& 	X"11"	& 	X"02"	,--750

6=>		X"50"	& 	X"14"	& 	X"02"	,
7=>		X"0a"	& 	X"15"	& 	X"02"	,
-- 6=>		X"78"	& 	X"14"	& 	X"02"	,
-- 7=>		X"0f"	& 	X"15"	& 	X"02"	,--3960



8=>		X"01"	& 	X"16"	& 	X"02"	,
9=>		X"01"	& 	X"19"	& 	X"02"	,
10=>	X"01"	& 	X"1B"	& 	X"02"	,--FREQ = 0h
11=>	X"30"	& 	X"1C"	& 	X"02"	,--8(1h) ch LVDS /4(3h) ch LVDS  
12=>	X"00"	& 	X"23"	& 	X"02"	,
13=>	X"08"	& 	X"79"	& 	X"02"	,
14=>	X"0C"	& 	X"89"	& 	X"02"	,
15=>	X"00"	& 	X"8A"	& 	X"02"	,
16=>	X"10"	& 	X"8B"	& 	X"02"	,
17=>	X"00"	& 	X"8C"	& 	X"02"	,
18=>	X"10"	& 	X"8D"	& 	X"02"	,
19=>	X"01"	& 	X"8E"	& 	X"02"	,
20=>	X"00"	& 	X"8F"	& 	X"02"	,
21=>	X"06"	& 	X"9E"	& 	X"02"	,
22=>	X"04"	& 	X"A0"	& 	X"02"	,
23=>	X"0A"	& 	X"AF"	& 	X"02"	,
24=>	X"D8"	& 	X"68"	& 	X"03"	,
25=>	X"A0"	& 	X"69"	& 	X"03"	,
26=>	X"A1"	& 	X"7D"	& 	X"03"	,
27=>	X"9B"	& 	X"90"	& 	X"03"	,
28=>	X"A0"	& 	X"91"	& 	X"03"	,
29=>	X"3F"	& 	X"A4"	& 	X"03"	,
30=>	X"B1"	& 	X"A5"	& 	X"03"	,
31=>	X"00"	& 	X"E2"	& 	X"03"	,
32=>	X"00"	& 	X"EA"	& 	X"03"	,
33=>	X"08"	& 	X"12"	& 	X"04"	,
34=>	X"03"	& 	X"26"	& 	X"04"	,
35=>	X"F0"	& 	X"54"	& 	X"04"	,
36=>	X"00"	& 	X"55"	& 	X"04"	,
37=>	X"B3"	& 	X"AA"	& 	X"07"	,
38=>	X"68"	& 	X"AC"	& 	X"07"	,
39=>	X"B4"	& 	X"1C"	& 	X"09"	,
40=>	X"00"	& 	X"1D"	& 	X"09"	,
41=>	X"DE"	& 	X"1E"	& 	X"09"	,
42=>	X"00"	& 	X"1F"	& 	X"09"	,
43=>	X"B4"	& 	X"28"	& 	X"09"	,
44=>	X"00"	& 	X"29"	& 	X"09"	,
45=>	X"DE"	& 	X"2A"	& 	X"09"	,
46=>	X"00"	& 	X"2B"	& 	X"09"	,
47=>	X"36"	& 	X"3A"	& 	X"09"	,
48=>	X"36"	& 	X"46"	& 	X"09"	,
49=>	X"EB"	& 	X"E0"	& 	X"0A"	,
50=>	X"00"	& 	X"E1"	& 	X"0A"	,
51=>	X"0D"	& 	X"E2"	& 	X"0A"	,
52=>	X"01"	& 	X"E3"	& 	X"0A"	,
53=>	X"EB"	& 	X"C4"	& 	X"0B"	,
54=>	X"00"	& 	X"C5"	& 	X"0B"	,
55=>	X"0C"	& 	X"C6"	& 	X"0B"	,
56=>	X"01"	& 	X"C7"	& 	X"0B"	,
57=>	X"6E"	& 	X"02"	& 	X"0F"	,
58=>	X"E3"	& 	X"04"	& 	X"0F"	,
59=>	X"00"	& 	X"05"	& 	X"0F"	,
60=>	X"73"	& 	X"0C"	& 	X"0F"	,
61=>	X"6E"	& 	X"0E"	& 	X"0F"	,
62=>	X"E8"	& 	X"10"	& 	X"0F"	,
63=>	X"00"	& 	X"11"	& 	X"0F"	,
64=>	X"E3"	& 	X"12"	& 	X"0F"	,
65=>	X"00"	& 	X"13"	& 	X"0F"	,
66=>	X"6B"	& 	X"14"	& 	X"0F"	,
67=>	X"1C"	& 	X"16"	& 	X"0F"	,
68=>	X"1C"	& 	X"18"	& 	X"0F"	,
69=>	X"6B"	& 	X"1A"	& 	X"0F"	,
70=>	X"6E"	& 	X"1C"	& 	X"0F"	,
71=>	X"9A"	& 	X"1E"	& 	X"0F"	,
72=>	X"12"	& 	X"20"	& 	X"0F"	,
73=>	X"3E"	& 	X"22"	& 	X"0F"	,
74=>	X"B4"	& 	X"28"	& 	X"0F"	,
75=>	X"00"	& 	X"29"	& 	X"0F"	,
76=>	X"66"	& 	X"2A"	& 	X"0F"	,
77=>	X"69"	& 	X"34"	& 	X"0F"	,
78=>	X"10"	& 	X"36"	& 	X"0F"	,
79=>	X"6A"	& 	X"38"	& 	X"0F"	,
80=>	X"11"	& 	X"3A"	& 	X"0F"	,
81=>	X"FF"	& 	X"46"	& 	X"0F"	,
82=>	X"3F"	& 	X"47"	& 	X"0F"	,
83=>	X"4C"	& 	X"4E"	& 	X"0F"	,
84=>	X"50"	& 	X"50"	& 	X"0F"	,
85=>	X"73"	& 	X"54"	& 	X"0F"	,
86=>	X"6E"	& 	X"56"	& 	X"0F"	,
87=>	X"E8"	& 	X"58"	& 	X"0F"	,
88=>	X"00"	& 	X"59"	& 	X"0F"	,
89=>	X"CF"	& 	X"5A"	& 	X"0F"	,
90=>	X"00"	& 	X"5B"	& 	X"0F"	,
91=>	X"64"	& 	X"5E"	& 	X"0F"	,
92=>	X"61"	& 	X"66"	& 	X"0F"	,
93=>	X"0D"	& 	X"6E"	& 	X"0F"	,
94=>	X"FF"	& 	X"70"	& 	X"0F"	,
95=>	X"0F"	& 	X"71"	& 	X"0F"	,
96=>	X"00"	& 	X"72"	& 	X"0F"	,
97=>	X"00"	& 	X"73"	& 	X"0F"	,
98=>	X"11"	& 	X"74"	& 	X"0F"	,
99=>	X"6A"	& 	X"76"	& 	X"0F"	,
100=>	X"7F"	& 	X"78"	& 	X"0F"	,
101=>	X"B3"	& 	X"7A"	& 	X"0F"	,
102=>	X"29"	& 	X"7C"	& 	X"0F"	,
103=>	X"64"	& 	X"7E"	& 	X"0F"	,
104=>	X"B1"	& 	X"80"	& 	X"0F"	,
105=>	X"B3"	& 	X"82"	& 	X"0F"	,
106=>	X"62"	& 	X"84"	& 	X"0F"	,
107=>	X"64"	& 	X"86"	& 	X"0F"	,
108=>	X"B1"	& 	X"88"	& 	X"0F"	,
109=>	X"B3"	& 	X"8A"	& 	X"0F"	,
110=>	X"62"	& 	X"8C"	& 	X"0F"	,
111=>	X"64"	& 	X"8E"	& 	X"0F"	,
112=>	X"6D"	& 	X"90"	& 	X"0F"	,
113=>	X"65"	& 	X"92"	& 	X"0F"	,
114=>	X"65"	& 	X"94"	& 	X"0F"	,
115=>	X"6D"	& 	X"96"	& 	X"0F"	,
116=>	X"20"	& 	X"98"	& 	X"0F"	,
117=>	X"28"	& 	X"9A"	& 	X"0F"	,
118=>	X"81"	& 	X"9C"	& 	X"0F"	,
119=>	X"89"	& 	X"9E"	& 	X"0F"	,
120=>	X"01"	& 	X"9F"	& 	X"0F"	,
121=>	X"66"	& 	X"A0"	& 	X"0F"	,
122=>	X"7B"	& 	X"A2"	& 	X"0F"	,
123=>	X"21"	& 	X"A4"	& 	X"0F"	,
124=>	X"27"	& 	X"A6"	& 	X"0F"	,
125=>	X"8B"	& 	X"A8"	& 	X"0F"	,
126=>	X"01"	& 	X"A9"	& 	X"0F"	,
127=>	X"95"	& 	X"AA"	& 	X"0F"	,
128=>	X"01"	& 	X"AB"	& 	X"0F"	,
129=>	X"12"	& 	X"AC"	& 	X"0F"	,
130=>	X"1C"	& 	X"AE"	& 	X"0F"	,
131=>	X"98"	& 	X"B0"	& 	X"0F"	,
132=>	X"01"	& 	X"B1"	& 	X"0F"	,
133=>	X"A0"	& 	X"B2"	& 	X"0F"	,
134=>	X"01"	& 	X"B3"	& 	X"0F"	,
135=>	X"13"	& 	X"B4"	& 	X"0F"	,
136=>	X"1D"	& 	X"B6"	& 	X"0F"	,
137=>	X"99"	& 	X"B8"	& 	X"0F"	,
138=>	X"01"	& 	X"B9"	& 	X"0F"	,
139=>	X"A1"	& 	X"BA"	& 	X"0F"	,
140=>	X"01"	& 	X"BB"	& 	X"0F"	,
141=>	X"14"	& 	X"BC"	& 	X"0F"	,
142=>	X"1E"	& 	X"BE"	& 	X"0F"	,
143=>	X"9A"	& 	X"C0"	& 	X"0F"	,
144=>	X"01"	& 	X"C1"	& 	X"0F"	,
145=>	X"A2"	& 	X"C2"	& 	X"0F"	,
146=>	X"01"	& 	X"C3"	& 	X"0F"	,
147=>	X"64"	& 	X"C4"	& 	X"0F"	,
148=>	X"6E"	& 	X"C6"	& 	X"0F"	,
149=>	X"17"	& 	X"C8"	& 	X"0F"	,
150=>	X"26"	& 	X"CA"	& 	X"0F"	,
151=>	X"9D"	& 	X"CC"	& 	X"0F"	,
152=>	X"01"	& 	X"CD"	& 	X"0F"	,
153=>	X"AC"	& 	X"CE"	& 	X"0F"	,
154=>	X"01"	& 	X"CF"	& 	X"0F"	,
155=>	X"65"	& 	X"D0"	& 	X"0F"	,
156=>	X"6F"	& 	X"D2"	& 	X"0F"	,
157=>	X"18"	& 	X"D4"	& 	X"0F"	,
158=>	X"27"	& 	X"D6"	& 	X"0F"	,
159=>	X"9E"	& 	X"D8"	& 	X"0F"	,
160=>	X"01"	& 	X"D9"	& 	X"0F"	,
161=>	X"AD"	& 	X"DA"	& 	X"0F"	,
162=>	X"01"	& 	X"DB"	& 	X"0F"	,
163=>	X"66"	& 	X"DC"	& 	X"0F"	,
164=>	X"70"	& 	X"DE"	& 	X"0F"	,
165=>	X"19"	& 	X"E0"	& 	X"0F"	,
166=>	X"28"	& 	X"E2"	& 	X"0F"	,
167=>	X"9F"	& 	X"E4"	& 	X"0F"	,
168=>	X"01"	& 	X"E5"	& 	X"0F"	,
169=>	X"AE"	& 	X"E6"	& 	X"0F"	,
170=>	X"01"	& 	X"E7"	& 	X"0F"	,
171=>	X"9D"	& 	X"04"	& 	X"10"	,
172=>	X"B0"	& 	X"06"	& 	X"10"	,
173=>	X"00"	& 	X"07"	& 	X"10"	,
174=>	X"6B"	& 	X"08"	& 	X"10"	,
175=>	X"7E"	& 	X"0A"	& 	X"10"	,
176=>	X"E3"	& 	X"24"	& 	X"10"	,
177=>	X"00"	& 	X"25"	& 	X"10"	,
178=>	X"9A"	& 	X"26"	& 	X"10"	,
179=>	X"01"	& 	X"27"	& 	X"10"	,
180=>	X"00"	& 	X"20"	& 	X"11"	,
181=>	X"00"	& 	X"21"	& 	X"11"	,
182=>	X"FF"	& 	X"22"	& 	X"11"	,
183=>	X"3F"	& 	X"23"	& 	X"11"	,
184=>	X"FF"	& 	X"05"	& 	X"12"	,
185=>	X"00"	& 	X"0B"	& 	X"12"	,
186=>	X"54"	& 	X"0C"	& 	X"12"	,
187=>	X"B8"	& 	X"0D"	& 	X"12"	,
188=>	X"48"	& 	X"0E"	& 	X"12"	,
189=>	X"A2"	& 	X"0F"	& 	X"12"	,
190=>	X"53"	& 	X"12"	& 	X"12"	,
191=>	X"0A"	& 	X"13"	& 	X"12"	,
192=>	X"0C"	& 	X"14"	& 	X"12"	,
193=>	X"0A"	& 	X"15"	& 	X"12"	,
194=>	X"7F"	& 	X"2A"	& 	X"12"	,
195=>	X"29"	& 	X"2C"	& 	X"12"	,
196=>	X"73"	& 	X"30"	& 	X"12"	,
197=>	X"8D"	& 	X"32"	& 	X"12"	,
198=>	X"01"	& 	X"33"	& 	X"12"	,
199=>	X"02"	& 	X"49"	& 	X"12"	,
200=>	X"9A"	& 	X"8C"	& 	X"12"	,
201=>	X"AA"	& 	X"8E"	& 	X"12"	,
202=>	X"3E"	& 	X"90"	& 	X"12"	,
203=>	X"5F"	& 	X"92"	& 	X"12"	,
204=>	X"0A"	& 	X"94"	& 	X"12"	,
205=>	X"0A"	& 	X"96"	& 	X"12"	,
206=>	X"7F"	& 	X"98"	& 	X"12"	,
207=>	X"B3"	& 	X"9A"	& 	X"12"	,
208=>	X"29"	& 	X"9C"	& 	X"12"	,
209=>	X"64"	& 	X"9E"	& 	X"12"	,

210=>	X"0c"	& 	X"0D"	& 	X"02"	,	--Drive mode setting of V direction 0h : All-pixel mode 
											-- 1h : 1/2 Subsampling mode 
											-- 2h : FD Binning mode 
											-- Ch : Full-HD 
											-- Others: Setting prohibited  

211=>	X"01"	& 	X"19"	& 	X"02"	,	--The value is set according to  drive mode. 
											-- 0: All-pixel, ROI, 1/2 Subsampling, FD Binning 
											-- 1: 1080p-Full HD 

212=>	X"0c"	& 	X"89"	& 	X"02"	,	--INCKSEL
213=>	X"00"	& 	X"8a"	& 	X"02"	,	--INCKSEL
214=>	X"10"	& 	X"8b"	& 	X"02"	,	--INCKSEL
215=>	X"00"	& 	X"8c"	& 	X"02"	,	--INCKSEL
216=>	X"06"	& 	X"9e"	& 	X"02"	,	--GTWAIT	The  value  is  set  according  to  drive mode. 
											-- 0Ah: All-pixel, ROI, 1/2 Subsampling, FD Binning 
											-- 06h: 1080p-Full HD 

217=>	X"04"	& 	X"a0"	& 	X"02"	,	-- GSDLY The  value  is  set  according  to  drive mode. 
											-- 08:  All-pixel,  ROI,  1/2  Subsampling, FD Binning 
											-- 04h: 1080p-Full HD 
											
218=>	X"08"	& 	X"af"	& 	X"02"	,	-- The  value  is  set  according  to  drive mode. 
											-- 0Eh: All-pixel, ROI, 1/2 Subsampling, FD Binning 
											-- 0Ah: 1080p-Full HD 										
219=>	X"50"	& 	X"8d"	& 	X"02"	,	-- SHS
220=>	X"04"	& 	X"8e"	& 	X"02"	,	-- SHS
221=>	X"00"	& 	X"8f"	& 	X"02"	,	-- SHS
222=>	X"00"	& 	X"04"	& 	X"04"	,	-- GAIN
223=>	X"00"	& 	X"05"	& 	X"04"	,	-- GAIN

224=>	X"00"	& 	X"08"	& 	X"02"	,	-- REGHOLD
225=>	X"00"	& 	X"00"	& 	X"02"	,	-- STANDBY
226=>	X"00"	& 	X"0a"	& 	X"02"	,	-- XMSTA

 others => X"00_00_82"); 
 
 
 
begin
--
enable_clk_spi		<=	ena_clk;
--
------------------------------------счетчик пикселей для глобальных сигналов запуска/сброса -----------------------------
pix_str_reset_imx: count_n_modul                   
generic map (30) 
port map (
				----IN signal---------
			clk			=>CLK,	
			reset		=>MAIN_reset,
			en			=>'1',
			modul		=> std_logic_vector(to_unsigned(1073741821,30)),
				----OUT signal---------
			qout		=>qout_imx);	
----------------------------------------------------------------------------------------------------
Process(CLK)
begin
if rising_edge(CLK) then
	if MAIN_reset='0'	
		then
			if (to_integer(unsigned(qout_imx)))>8000		then reset_imx		<='1' ;	end if;-- 1 мс (80 МГц)		сброс IMX
			-- if (to_integer(unsigned(qout_imx)))>16000		then ena_imx_clk	<='1';	end if;-- 2 мс (80 МГц)		разрешение такт на IMX
			if (to_integer(unsigned(qout_imx)))>4000		then ena_spi_imx	<='1';	end if;-- 50 мс (80 МГц)	разрешение SPI
			if (to_integer(unsigned(qout_imx)))>8015		then reset_gs		<='1';	end if;-- 1 с (80 МГц)		начало цикла инициализации
			if (to_integer(unsigned(qout_imx)))>10000000	then ena_rw_reg		<='1';	end if;-- 1 с (80 МГц)		начало цикла инициализации
		else
			reset_imx		<='0';	
			-- ena_imx_clk		<='0';	
			ena_spi_imx		<='0';	
			reset_gs		<='0';	
			ena_rw_reg		<='0';	
	end if;
	end if;
end process;	
--
------------------------------------modification by VS
--
------------------------------------автомат для записи и чтения--------------------
-----------------------------------------------------------------------------------
Process(CLK, enable_clk_spi)
begin
if rising_edge(CLK) and enable_clk_spi = '1' then
	-- Vmax	<= n_strok;
---------------------------------cброс--------------------------------
	if reset_gs='0'	 
		then	
			reset_n_spi_master	<='0';
			enable_spi_master		<='0';
			state					<= st_wait;
	end if;
	
	CASE state IS
	---------------------------------ожидание  разрешения начала прошивки--------------------------------
	WHEN st_wait =>
	if reset_gs='1'	 
		then	
			state				<= st0;
			reset_n_spi_master	<='1';
			enable_spi_master	<='1';
			addr_rom_reg		<=std_logic_vector(to_unsigned(0,8));
			tx_spi_master		<=content(to_integer(unsigned(addr_rom_reg)));
	end if;
	---------------------------------Загрузка основых регистров --------------------------------
	WHEN st0 =>
	-- if reset_gs='1'	 
		-- then	
		tx_spi_master	<=	content(to_integer(unsigned(addr_rom_reg)))	;
		if to_integer(unsigned(addr_rom_reg))<230
			then			
				if busy_spi_master='0'
					then	
						addr_rom_reg<=std_logic_vector(to_unsigned(to_integer(unsigned(addr_rom_reg))+1,8));--счетчик записанных регистров
				end if;
			else
				if ena_rw_reg='1'	-- можно зациклить загрузку оснвоых регистров	
				-- if DEBUG(7)='1'	-- можно зациклить загрузку оснвоых регистров	
					then 
						state				<= st1;		-- перейти к нормальной работе с обновлением только несколких
						reset_n_spi_master	<='0';
						enable_spi_master	<='0';
					else 
						state				<= st_wait;--  вернутся к обновлению всех регистров
						reset_n_spi_master	<='1';
						enable_spi_master	<='1';
				end if;
		end if;
	-- end if;
---------------------------------ожидание начала прошивки регистров (автоматика и проч.)--------------------------------
	WHEN st1 =>
		if to_integer(unsigned(qout_v)) = 1	-- выбор строки от которой можно начинать обновление регистров
			then
				reset_n_spi_master	<='0';
				addr_reg_ACTIVE		<=std_logic_vector(to_unsigned(0,8));
				state				<= st1;
				enable_spi_master	<='0';
		end if;
---------------------------------прошивка регистров которые регулярно обновляются--------------------------------
	WHEN st2 =>
			if to_integer(unsigned(addr_reg_ACTIVE))<7 and to_integer(unsigned(qout_v)) >=2	-- 16 регистров для обновления
			then		
				enable_spi_master	<='1';
				reset_n_spi_master	<='1';
				tx_spi_master		<=	content2(to_integer(unsigned(addr_reg_ACTIVE)));
				if busy_spi_master='0'
					then	
						addr_reg_ACTIVE<=std_logic_vector(to_unsigned(to_integer(unsigned(addr_reg_ACTIVE))+1,8));	--счетчик записанных регистров
				end if;
			else
				enable_spi_master	<='0';
				state				<= st1;	-- переход к ожиданию строки когда можно будет снова обновить регитсры
				reset_n_spi_master	<='0';
		end if;
------------------------------------------------------------
	WHEN others =>
	END CASE;
end if;
end process;	

-------------------------модуль управления по SPI----------------------------
--CLK_SPI				<=div_clk(3);
cpol_spi_master		<='1';	-- фаза клока
cpha_spi_master		<='1';	-- полярность клока
miso_spi_master		<='0';
--
--
spi_master_q: spi_master                   
generic map (24) 
port map (
					-- IN-----
--			clk			=>CLK_SPI,
			clk			=>CLK,
			clk_en		=>enable_clk_spi,
			reset_n		=>reset_n_spi_master,
			enable		=>enable_spi_master,
			cpol		=>cpol_spi_master,
			cpha		=>cpha_spi_master,
			miso		=>miso_spi_master,
			tx			=>tx_spi_master,
					-- OUT----
			sclk		=>sclk_spi_master,
			ss_n		=>ss_n_spi_master,
			mosi		=>mosi_spi_master,
			busy		=>busy_spi_master,
			rx			=>rx_spi_master
			);	

 -- ----------------------регистры обновляемые каждый кадр ---------------------
content2(0)<=AGC_VGA(7 downto 0)			& X"04"	& X"04";
content2(1)<=AGC_VGA(15 downto 8)			& X"05"	& X"04";
content2(2)<=AGC_str(7 downto 0)			& X"8d"	& X"02";
content2(3)<=AGC_str(15 downto 8)			& X"8e"	& X"02";
-- content2(4)<=black_lavel_imx(7 downto 0)	& X"54"	& X"84";
-- content2(5)<=black_lavel_imx(15 downto 8)	& X"55"	& X"84";
-- content2(6)<=Vmax(7 downto 0)				& X"10"	& X"82";
-- content2(7)<=Vmax(15 downto 8)				& X"11"	& X"82";
----------------------OUT--------------------
SDI_imx		<=	mosi_spi_master;
XCE_imx		<=	ss_n_spi_master;
SCK_imx		<=	sclk_spi_master;

end ;
