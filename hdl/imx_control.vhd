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
signal tx_spi_master			: std_logic_vector (23 downto 0):=(others => '0');										
signal rx_spi_master			: std_logic_vector (23 downto 0):=(others => '0');	
-------------------------------------------------------------------

-------------------------------------------------------------------
signal qout_imx				: std_logic_vector (23 downto 0):=(others => '0');			
signal reset_gs				: std_logic:='0';		
signal ena_spi_imx			: std_logic:='0';				
signal CLK_SPI					: std_logic:='0';			 		-- такт SPI
signal enable_clk_spi		: std_logic:='0';					--	сигнал разрешения тактов CLK для формирования частоты CLK_SPI						
signal addr_rom_reg			: std_logic_vector (7 downto 0):=(others => '0');											
signal addr_reg_ACTIVE		: std_logic_vector (7 downto 0):=(others => '0');	--адерес для регистров обновляемых каждый кадр											
signal ena_rw_reg				: std_logic:='0';			 		-- такт SPI				
					
type state_type is (st0, st1, st2, st_wait);					-- Register to hold the current state
signal state : state_type;										-- Register to hold the current state
type ROM_array is array (0 to 255) of std_logic_vector (23 downto 0);
type ROM_array2 is array (0 to 31) of std_logic_vector (23 downto 0);
signal content2	: ROM_array2 ; 						--память для регистров обновляемых каждый кадр
constant content: ROM_array := (

0		=> x"D0" & x"01" & x"02",
1		=> x"AA" & x"02" & x"02",

-- 2		=> x"42" & x"10" & x"02",
-- 3		=> x"04" & x"11" & x"02",
-- 4		=> x"60" & x"14" & x"02",
-- 5		=> x"03" & x"15" & x"02",

2		=> x"E2" & x"10" & x"02",
3		=> x"04" & x"11" & x"02",
4		=> x"60" & x"14" & x"02",
5		=> x"03" & x"15" & x"02",



6		=> x"01" & x"18" & x"02",
7		=> x"00" & x"23" & x"02",
8		=> x"62" & x"80" & x"02",
9		=> x"10" & x"89" & x"02",
10		=> x"00" & x"8A" & x"02",
11		=> x"10" & x"8B" & x"02",
12		=> x"00" & x"8C" & x"02",
13		=> x"00" & x"8D" & x"02",
14		=> x"01" & x"8E" & x"02",
15		=> x"00" & x"8F" & x"02",
16		=> x"08" & x"9E" & x"02",
17		=> x"04" & x"A0" & x"02",
18		=> x"0E" & x"AF" & x"02",
19		=> x"D8" & x"68" & x"03",
20		=> x"A0" & x"69" & x"03",
21		=> x"A1" & x"7D" & x"03",
22		=> x"62" & x"80" & x"03",
23		=> x"9B" & x"90" & x"03",
24		=> x"A0" & x"91" & x"03",
25		=> x"3F" & x"A4" & x"03",
26		=> x"B1" & x"A5" & x"03",
27		=> x"00" & x"E2" & x"03",
28		=> x"00" & x"EA" & x"03",
29		=> x"08" & x"12" & x"04",
30		=> x"03" & x"26" & x"04",
31		=> x"00" & x"54" & x"04",
32		=> x"00" & x"55" & x"04",
33		=> x"B3" & x"AA" & x"07",
34		=> x"68" & x"AC" & x"07",
35		=> x"B4" & x"1C" & x"09",
36		=> x"00" & x"1D" & x"09",
37		=> x"DE" & x"1E" & x"09",
38		=> x"00" & x"1F" & x"09",
39		=> x"B4" & x"28" & x"09",
40		=> x"00" & x"29" & x"09",
41		=> x"DE" & x"2A" & x"09",
42		=> x"00" & x"2B" & x"09",
43		=> x"36" & x"3A" & x"09",
44		=> x"36" & x"46" & x"09",
45		=> x"EB" & x"E0" & x"0A",
46		=> x"00" & x"E1" & x"0A",
47		=> x"0D" & x"E2" & x"0A",
48		=> x"01" & x"E3" & x"0A",
49		=> x"EB" & x"C4" & x"0B",
50		=> x"00" & x"C5" & x"0B",
51		=> x"0C" & x"C6" & x"0B",
52		=> x"01" & x"C7" & x"0B",
53		=> x"6E" & x"02" & x"0F",
54		=> x"E3" & x"04" & x"0F",
55		=> x"00" & x"05" & x"0F",
56		=> x"73" & x"0C" & x"0F",
57		=> x"6E" & x"0E" & x"0F",
58		=> x"E8" & x"10" & x"0F",
59		=> x"00" & x"11" & x"0F",
60		=> x"E3" & x"12" & x"0F",
61		=> x"00" & x"13" & x"0F",
62		=> x"6B" & x"14" & x"0F",
63		=> x"1C" & x"16" & x"0F",
64		=> x"1C" & x"18" & x"0F",
65		=> x"6B" & x"1A" & x"0F",
66		=> x"6E" & x"1C" & x"0F",
67		=> x"9A" & x"1E" & x"0F",
68		=> x"12" & x"20" & x"0F",
69		=> x"3E" & x"22" & x"0F",
70		=> x"B4" & x"28" & x"0F",
71		=> x"00" & x"29" & x"0F",
72		=> x"66" & x"2A" & x"0F",
73		=> x"69" & x"34" & x"0F",
74		=> x"17" & x"36" & x"0F",
75		=> x"6A" & x"38" & x"0F",
76		=> x"18" & x"3A" & x"0F",
77		=> x"FF" & x"3E" & x"0F",
78		=> x"0F" & x"3F" & x"0F",
79		=> x"FF" & x"46" & x"0F",
80		=> x"0F" & x"47" & x"0F",
81		=> x"4C" & x"4E" & x"0F",
82		=> x"50" & x"50" & x"0F",
83		=> x"73" & x"54" & x"0F",
84		=> x"6E" & x"56" & x"0F",
85		=> x"E8" & x"58" & x"0F",
86		=> x"00" & x"59" & x"0F",
87		=> x"CF" & x"5A" & x"0F",
88		=> x"00" & x"5B" & x"0F",
89		=> x"64" & x"5E" & x"0F",
90		=> x"61" & x"66" & x"0F",
91		=> x"0D" & x"6E" & x"0F",
92		=> x"FF" & x"70" & x"0F",
93		=> x"0F" & x"71" & x"0F",
94		=> x"00" & x"72" & x"0F",
95		=> x"00" & x"73" & x"0F",
96		=> x"11" & x"74" & x"0F",
97		=> x"6A" & x"76" & x"0F",
98		=> x"7F" & x"78" & x"0F",
99		=> x"B3" & x"7A" & x"0F",
100	=> x"29" & x"7C" & x"0F",
101	=> x"64" & x"7E" & x"0F",
102	=> x"B1" & x"80" & x"0F",
103	=> x"B3" & x"82" & x"0F",
104	=> x"62" & x"84" & x"0F",
105	=> x"64" & x"86" & x"0F",
106	=> x"B1" & x"88" & x"0F",
107	=> x"B3" & x"8A" & x"0F",
108	=> x"62" & x"8C" & x"0F",
109	=> x"64" & x"8E" & x"0F",
110	=> x"6D" & x"90" & x"0F",
111	=> x"65" & x"92" & x"0F",
112	=> x"65" & x"94" & x"0F",
113	=> x"6D" & x"96" & x"0F",
114	=> x"20" & x"98" & x"0F",
115	=> x"28" & x"9A" & x"0F",
116	=> x"81" & x"9C" & x"0F",
117	=> x"89" & x"9E" & x"0F",
118	=> x"01" & x"9F" & x"0F",
119	=> x"66" & x"A0" & x"0F",
120	=> x"7B" & x"A2" & x"0F",
121	=> x"21" & x"A4" & x"0F",
122	=> x"27" & x"A6" & x"0F",
123	=> x"8B" & x"A8" & x"0F",
124	=> x"01" & x"A9" & x"0F",
125	=> x"95" & x"AA" & x"0F",
126	=> x"01" & x"AB" & x"0F",
127	=> x"12" & x"AC" & x"0F",
128	=> x"1C" & x"AE" & x"0F",
129	=> x"98" & x"B0" & x"0F",
130	=> x"01" & x"B1" & x"0F",
131	=> x"A0" & x"B2" & x"0F",
132	=> x"01" & x"B3" & x"0F",
133	=> x"13" & x"B4" & x"0F",
134	=> x"1D" & x"B6" & x"0F",
135	=> x"99" & x"B8" & x"0F",
136	=> x"01" & x"B9" & x"0F",
137	=> x"A1" & x"BA" & x"0F",
138	=> x"01" & x"BB" & x"0F",
139	=> x"14" & x"BC" & x"0F",
140	=> x"1E" & x"BE" & x"0F",
141	=> x"9A" & x"C0" & x"0F",
142	=> x"01" & x"C1" & x"0F",
143	=> x"A2" & x"C2" & x"0F",
144	=> x"01" & x"C3" & x"0F",
145	=> x"64" & x"C4" & x"0F",
146	=> x"6E" & x"C6" & x"0F",
147	=> x"17" & x"C8" & x"0F",
148	=> x"26" & x"CA" & x"0F",
149	=> x"9D" & x"CC" & x"0F",
150	=> x"01" & x"CD" & x"0F",
151	=> x"AC" & x"CE" & x"0F",
152	=> x"01" & x"CF" & x"0F",
153	=> x"65" & x"D0" & x"0F",
154	=> x"6F" & x"D2" & x"0F",
155	=> x"18" & x"D4" & x"0F",
156	=> x"27" & x"D6" & x"0F",
157	=> x"9E" & x"D8" & x"0F",
158	=> x"01" & x"D9" & x"0F",
159	=> x"AD" & x"DA" & x"0F",
160	=> x"01" & x"DB" & x"0F",
161	=> x"66" & x"DC" & x"0F",
162	=> x"70" & x"DE" & x"0F",
163	=> x"19" & x"E0" & x"0F",
164	=> x"28" & x"E2" & x"0F",
165	=> x"9F" & x"E4" & x"0F",
166	=> x"01" & x"E5" & x"0F",
167	=> x"AE" & x"E6" & x"0F",
168	=> x"01" & x"E7" & x"0F",
169	=> x"9D" & x"04" & x"10",
170	=> x"B0" & x"06" & x"10",
171	=> x"00" & x"07" & x"10",
172	=> x"6B" & x"08" & x"10",
173	=> x"7E" & x"0A" & x"10",
174	=> x"E3" & x"24" & x"10",
175	=> x"00" & x"25" & x"10",
176	=> x"9A" & x"26" & x"10",
177	=> x"01" & x"27" & x"10",
178	=> x"00" & x"20" & x"11",
179	=> x"00" & x"21" & x"11",
180	=> x"FF" & x"22" & x"11",
181	=> x"3F" & x"23" & x"11",
182	=> x"55" & x"03" & x"12",
183	=> x"FF" & x"05" & x"12",
184	=> x"00" & x"0B" & x"12",
185	=> x"54" & x"0C" & x"12",
186	=> x"B8" & x"0D" & x"12",
187	=> x"48" & x"0E" & x"12",
188	=> x"A2" & x"0F" & x"12",
189	=> x"53" & x"12" & x"12",
190	=> x"0A" & x"13" & x"12",
191	=> x"0C" & x"14" & x"12",
192	=> x"0A" & x"15" & x"12",
193	=> x"7F" & x"2A" & x"12",
194	=> x"29" & x"2C" & x"12",
195	=> x"73" & x"30" & x"12",
196	=> x"8D" & x"32" & x"12",
197	=> x"01" & x"33" & x"12",
198	=> x"02" & x"49" & x"12",
199	=> x"18" & x"56" & x"12",
200	=> x"9A" & x"8C" & x"12",
201	=> x"AA" & x"8E" & x"12",
202	=> x"3E" & x"90" & x"12",
203	=> x"5F" & x"92" & x"12",
204	=> x"0A" & x"94" & x"12",
205	=> x"0A" & x"96" & x"12",
206	=> x"7F" & x"98" & x"12",
207	=> x"B3" & x"9A" & x"12",
208	=> x"29" & x"9C" & x"12",
209	=> x"64" & x"9E" & x"12",
	











210=>	X"00"	& 	X"0D"	& 	X"02"	,	--
											--
											--
											--
											--

211=>	X"00"	& 	X"19"	& 	X"02"	,	--
											--
											--

216=>	X"08"	& 	X"9e"	& 	X"02"	,	--
											--
											--

217=>	X"04"	& 	X"a0"	& 	X"02"	,	--
											--
											--
											
218=>	X"0e"	& 	X"af"	& 	X"02"	,	--

222=>	X"40"	& 	X"04"	& 	X"04"	,	-- GAIN
223=>	X"00"	& 	X"05"	& 	X"04"	,	-- GAIN



224=>	X"03"	& 	X"00"	& 	X"05"	,	-- enable ROI
225=>	X"10"	& 	X"10"	& 	X"05"	,	-- position H
226=>	X"00"	& 	X"11"	& 	X"05"	,	-- position H
227=>	X"10"	& 	X"12"	& 	X"05"	,	-- position V
228=>	X"00"	& 	X"13"	& 	X"05"	,	-- position V
229=>	X"00"	& 	X"14"	& 	X"05"	,	-- size ROI H
230=>	X"05"	& 	X"15"	& 	X"05"	,	-- size ROI H
231=>	X"00"	& 	X"16"	& 	X"05"	,	-- size ROI V
232=>	X"04"	& 	X"17"	& 	X"05"	,	-- size ROI V



233=>	X"00"	& 	X"08"	& 	X"02"	,	-- REGHOLD
234=>	X"00"	& 	X"00"	& 	X"02"	,	-- STANDBY
235=>	X"00"	& 	X"0a"	& 	X"02"	,	-- XMSTA

-- constant content: ROM_array := (
-- 0=>	X"C0"	& 	X"01"	& 	X"02"	,
-- 1=>	X"20"	& 	X"05"	& 	X"02"	,--8(1h) ch LVDS /4(2h) ch LVDS  
-- 2=>	X"01"	& 	X"0C"	& 	X"02"	,--1: 12 bit
-- -- 3=>	X"0C"	& 	X"0D"	& 	X"02"	,-- 1080p-FULL HD mode 
-- 3=>	X"00"	& 	X"0D"	& 	X"02"	,-- ROI mode 

-- -- 4=>	X"65"	& 	X"10"	& 	X"02"	,--1125
-- -- 5=>	X"04"	& 	X"11"	& 	X"02"	,--1125
-- -- 6=>	X"50"	& 	X"14"	& 	X"02"	,--2640
-- -- 7=>	X"0a"	& 	X"15"	& 	X"02"	,--2640

-- 4=>	X"E2"	& 	X"10"	& 	X"02"	,--1250
-- 5=>	X"04"	& 	X"11"	& 	X"02"	,--1250
-- 6=>	X"39"	& 	X"14"	& 	X"02"	,--2200
-- 7=>	X"03"	& 	X"15"	& 	X"02"	,--2200


-- -- 6=>	X"78"	& 	X"14"	& 	X"02"	,--3960
-- -- 7=>	X"0f"	& 	X"15"	& 	X"02"	,--3960



-- 8=>	X"01"	& 	X"16"	& 	X"02"	,
-- 9=>	X"00"	& 	X"19"	& 	X"02"	,
-- 10=>	X"01"	& 	X"1B"	& 	X"02"	,--FREQ = 0h
-- 11=>	X"30"	& 	X"1C"	& 	X"02"	,--8(1h) ch LVDS /4(3h) ch LVDS  
-- 12=>	X"00"	& 	X"23"	& 	X"02"	,
-- 13=>	X"00"	& 	X"79"	& 	X"02"	,
-- 14=>	X"10"	& 	X"89"	& 	X"02"	,
-- 15=>	X"00"	& 	X"8A"	& 	X"02"	,
-- 16=>	X"10"	& 	X"8B"	& 	X"02"	,
-- 17=>	X"00"	& 	X"8C"	& 	X"02"	,
-- 18=>	X"10"	& 	X"8D"	& 	X"02"	,
-- 19=>	X"01"	& 	X"8E"	& 	X"02"	,
-- 20=>	X"00"	& 	X"8F"	& 	X"02"	,
-- 21=>	X"08"	& 	X"9E"	& 	X"02"	,
-- 22=>	X"04"	& 	X"A0"	& 	X"02"	,
-- 23=>	X"0E"	& 	X"AF"	& 	X"02"	,






-- 24=>	X"D8"	& 	X"68"	& 	X"03"	,
-- 25=>	X"A0"	& 	X"69"	& 	X"03"	,
-- 26=>	X"A1"	& 	X"7D"	& 	X"03"	,
-- 27=>	X"9B"	& 	X"90"	& 	X"03"	,
-- 28=>	X"A0"	& 	X"91"	& 	X"03"	,
-- 29=>	X"3F"	& 	X"A4"	& 	X"03"	,
-- 30=>	X"B1"	& 	X"A5"	& 	X"03"	,
-- 31=>	X"00"	& 	X"E2"	& 	X"03"	,
-- 32=>	X"00"	& 	X"EA"	& 	X"03"	,
-- 33=>	X"08"	& 	X"12"	& 	X"04"	,
-- 34=>	X"03"	& 	X"26"	& 	X"04"	,
-- 35=>	X"F0"	& 	X"54"	& 	X"04"	,
-- 36=>	X"00"	& 	X"55"	& 	X"04"	,
-- 37=>	X"B3"	& 	X"AA"	& 	X"07"	,
-- 38=>	X"68"	& 	X"AC"	& 	X"07"	,
-- 39=>	X"B4"	& 	X"1C"	& 	X"09"	,
-- 40=>	X"00"	& 	X"1D"	& 	X"09"	,
-- 41=>	X"DE"	& 	X"1E"	& 	X"09"	,
-- 42=>	X"00"	& 	X"1F"	& 	X"09"	,
-- 43=>	X"B4"	& 	X"28"	& 	X"09"	,
-- 44=>	X"00"	& 	X"29"	& 	X"09"	,
-- 45=>	X"DE"	& 	X"2A"	& 	X"09"	,
-- 46=>	X"00"	& 	X"2B"	& 	X"09"	,
-- 47=>	X"36"	& 	X"3A"	& 	X"09"	,
-- 48=>	X"36"	& 	X"46"	& 	X"09"	,
-- 49=>	X"EB"	& 	X"E0"	& 	X"0A"	,
-- 50=>	X"00"	& 	X"E1"	& 	X"0A"	,
-- 51=>	X"0D"	& 	X"E2"	& 	X"0A"	,
-- 52=>	X"01"	& 	X"E3"	& 	X"0A"	,
-- 53=>	X"EB"	& 	X"C4"	& 	X"0B"	,
-- 54=>	X"00"	& 	X"C5"	& 	X"0B"	,
-- 55=>	X"0C"	& 	X"C6"	& 	X"0B"	,
-- 56=>	X"01"	& 	X"C7"	& 	X"0B"	,
-- 57=>	X"6E"	& 	X"02"	& 	X"0F"	,
-- 58=>	X"E3"	& 	X"04"	& 	X"0F"	,
-- 59=>	X"00"	& 	X"05"	& 	X"0F"	,
-- 60=>	X"73"	& 	X"0C"	& 	X"0F"	,
-- 61=>	X"6E"	& 	X"0E"	& 	X"0F"	,
-- 62=>	X"E8"	& 	X"10"	& 	X"0F"	,
-- 63=>	X"00"	& 	X"11"	& 	X"0F"	,
-- 64=>	X"E3"	& 	X"12"	& 	X"0F"	,
-- 65=>	X"00"	& 	X"13"	& 	X"0F"	,
-- 66=>	X"6B"	& 	X"14"	& 	X"0F"	,
-- 67=>	X"1C"	& 	X"16"	& 	X"0F"	,
-- 68=>	X"1C"	& 	X"18"	& 	X"0F"	,
-- 69=>	X"6B"	& 	X"1A"	& 	X"0F"	,
-- 70=>	X"6E"	& 	X"1C"	& 	X"0F"	,
-- 71=>	X"9A"	& 	X"1E"	& 	X"0F"	,
-- 72=>	X"12"	& 	X"20"	& 	X"0F"	,
-- 73=>	X"3E"	& 	X"22"	& 	X"0F"	,
-- 74=>	X"B4"	& 	X"28"	& 	X"0F"	,
-- 75=>	X"00"	& 	X"29"	& 	X"0F"	,
-- 76=>	X"66"	& 	X"2A"	& 	X"0F"	,
-- 77=>	X"69"	& 	X"34"	& 	X"0F"	,
-- 78=>	X"10"	& 	X"36"	& 	X"0F"	,
-- 79=>	X"6A"	& 	X"38"	& 	X"0F"	,
-- 80=>	X"11"	& 	X"3A"	& 	X"0F"	,
-- 81=>	X"FF"	& 	X"46"	& 	X"0F"	,
-- 82=>	X"3F"	& 	X"47"	& 	X"0F"	,
-- 83=>	X"4C"	& 	X"4E"	& 	X"0F"	,
-- 84=>	X"50"	& 	X"50"	& 	X"0F"	,
-- 85=>	X"73"	& 	X"54"	& 	X"0F"	,
-- 86=>	X"6E"	& 	X"56"	& 	X"0F"	,
-- 87=>	X"E8"	& 	X"58"	& 	X"0F"	,
-- 88=>	X"00"	& 	X"59"	& 	X"0F"	,
-- 89=>	X"CF"	& 	X"5A"	& 	X"0F"	,
-- 90=>	X"00"	& 	X"5B"	& 	X"0F"	,
-- 91=>	X"64"	& 	X"5E"	& 	X"0F"	,
-- 92=>	X"61"	& 	X"66"	& 	X"0F"	,
-- 93=>	X"0D"	& 	X"6E"	& 	X"0F"	,
-- 94=>	X"FF"	& 	X"70"	& 	X"0F"	,
-- 95=>	X"0F"	& 	X"71"	& 	X"0F"	,
-- 96=>	X"00"	& 	X"72"	& 	X"0F"	,
-- 97=>	X"00"	& 	X"73"	& 	X"0F"	,
-- 98=>	X"11"	& 	X"74"	& 	X"0F"	,
-- 99=>	X"6A"	& 	X"76"	& 	X"0F"	,
-- 100=>	X"7F"	& 	X"78"	& 	X"0F"	,
-- 101=>	X"B3"	& 	X"7A"	& 	X"0F"	,
-- 102=>	X"29"	& 	X"7C"	& 	X"0F"	,
-- 103=>	X"64"	& 	X"7E"	& 	X"0F"	,
-- 104=>	X"B1"	& 	X"80"	& 	X"0F"	,
-- 105=>	X"B3"	& 	X"82"	& 	X"0F"	,
-- 106=>	X"62"	& 	X"84"	& 	X"0F"	,
-- 107=>	X"64"	& 	X"86"	& 	X"0F"	,
-- 108=>	X"B1"	& 	X"88"	& 	X"0F"	,
-- 109=>	X"B3"	& 	X"8A"	& 	X"0F"	,
-- 110=>	X"62"	& 	X"8C"	& 	X"0F"	,
-- 111=>	X"64"	& 	X"8E"	& 	X"0F"	,
-- 112=>	X"6D"	& 	X"90"	& 	X"0F"	,
-- 113=>	X"65"	& 	X"92"	& 	X"0F"	,
-- 114=>	X"65"	& 	X"94"	& 	X"0F"	,
-- 115=>	X"6D"	& 	X"96"	& 	X"0F"	,
-- 116=>	X"20"	& 	X"98"	& 	X"0F"	,
-- 117=>	X"28"	& 	X"9A"	& 	X"0F"	,
-- 118=>	X"81"	& 	X"9C"	& 	X"0F"	,
-- 119=>	X"89"	& 	X"9E"	& 	X"0F"	,
-- 120=>	X"01"	& 	X"9F"	& 	X"0F"	,
-- 121=>	X"66"	& 	X"A0"	& 	X"0F"	,
-- 122=>	X"7B"	& 	X"A2"	& 	X"0F"	,
-- 123=>	X"21"	& 	X"A4"	& 	X"0F"	,
-- 124=>	X"27"	& 	X"A6"	& 	X"0F"	,
-- 125=>	X"8B"	& 	X"A8"	& 	X"0F"	,
-- 126=>	X"01"	& 	X"A9"	& 	X"0F"	,
-- 127=>	X"95"	& 	X"AA"	& 	X"0F"	,
-- 128=>	X"01"	& 	X"AB"	& 	X"0F"	,
-- 129=>	X"12"	& 	X"AC"	& 	X"0F"	,
-- 130=>	X"1C"	& 	X"AE"	& 	X"0F"	,
-- 131=>	X"98"	& 	X"B0"	& 	X"0F"	,
-- 132=>	X"01"	& 	X"B1"	& 	X"0F"	,
-- 133=>	X"A0"	& 	X"B2"	& 	X"0F"	,
-- 134=>	X"01"	& 	X"B3"	& 	X"0F"	,
-- 135=>	X"13"	& 	X"B4"	& 	X"0F"	,
-- 136=>	X"1D"	& 	X"B6"	& 	X"0F"	,
-- 137=>	X"99"	& 	X"B8"	& 	X"0F"	,
-- 138=>	X"01"	& 	X"B9"	& 	X"0F"	,
-- 139=>	X"A1"	& 	X"BA"	& 	X"0F"	,
-- 140=>	X"01"	& 	X"BB"	& 	X"0F"	,
-- 141=>	X"14"	& 	X"BC"	& 	X"0F"	,
-- 142=>	X"1E"	& 	X"BE"	& 	X"0F"	,
-- 143=>	X"9A"	& 	X"C0"	& 	X"0F"	,
-- 144=>	X"01"	& 	X"C1"	& 	X"0F"	,
-- 145=>	X"A2"	& 	X"C2"	& 	X"0F"	,
-- 146=>	X"01"	& 	X"C3"	& 	X"0F"	,
-- 147=>	X"64"	& 	X"C4"	& 	X"0F"	,
-- 148=>	X"6E"	& 	X"C6"	& 	X"0F"	,
-- 149=>	X"17"	& 	X"C8"	& 	X"0F"	,
-- 150=>	X"26"	& 	X"CA"	& 	X"0F"	,
-- 151=>	X"9D"	& 	X"CC"	& 	X"0F"	,
-- 152=>	X"01"	& 	X"CD"	& 	X"0F"	,
-- 153=>	X"AC"	& 	X"CE"	& 	X"0F"	,
-- 154=>	X"01"	& 	X"CF"	& 	X"0F"	,
-- 155=>	X"65"	& 	X"D0"	& 	X"0F"	,
-- 156=>	X"6F"	& 	X"D2"	& 	X"0F"	,
-- 157=>	X"18"	& 	X"D4"	& 	X"0F"	,
-- 158=>	X"27"	& 	X"D6"	& 	X"0F"	,
-- 159=>	X"9E"	& 	X"D8"	& 	X"0F"	,
-- 160=>	X"01"	& 	X"D9"	& 	X"0F"	,
-- 161=>	X"AD"	& 	X"DA"	& 	X"0F"	,
-- 162=>	X"01"	& 	X"DB"	& 	X"0F"	,
-- 163=>	X"66"	& 	X"DC"	& 	X"0F"	,
-- 164=>	X"70"	& 	X"DE"	& 	X"0F"	,
-- 165=>	X"19"	& 	X"E0"	& 	X"0F"	,
-- 166=>	X"28"	& 	X"E2"	& 	X"0F"	,
-- 167=>	X"9F"	& 	X"E4"	& 	X"0F"	,
-- 168=>	X"01"	& 	X"E5"	& 	X"0F"	,
-- 169=>	X"AE"	& 	X"E6"	& 	X"0F"	,
-- 170=>	X"01"	& 	X"E7"	& 	X"0F"	,
-- 171=>	X"9D"	& 	X"04"	& 	X"10"	,
-- 172=>	X"B0"	& 	X"06"	& 	X"10"	,
-- 173=>	X"00"	& 	X"07"	& 	X"10"	,
-- 174=>	X"6B"	& 	X"08"	& 	X"10"	,
-- 175=>	X"7E"	& 	X"0A"	& 	X"10"	,
-- 176=>	X"E3"	& 	X"24"	& 	X"10"	,
-- 177=>	X"00"	& 	X"25"	& 	X"10"	,
-- 178=>	X"9A"	& 	X"26"	& 	X"10"	,
-- 179=>	X"01"	& 	X"27"	& 	X"10"	,
-- 180=>	X"00"	& 	X"20"	& 	X"11"	,
-- 181=>	X"00"	& 	X"21"	& 	X"11"	,
-- 182=>	X"FF"	& 	X"22"	& 	X"11"	,
-- 183=>	X"3F"	& 	X"23"	& 	X"11"	,
-- 184=>	X"FF"	& 	X"05"	& 	X"12"	,
-- 185=>	X"00"	& 	X"0B"	& 	X"12"	,
-- 186=>	X"54"	& 	X"0C"	& 	X"12"	,
-- 187=>	X"B8"	& 	X"0D"	& 	X"12"	,
-- 188=>	X"48"	& 	X"0E"	& 	X"12"	,
-- 189=>	X"A2"	& 	X"0F"	& 	X"12"	,
-- 190=>	X"53"	& 	X"12"	& 	X"12"	,
-- 191=>	X"0A"	& 	X"13"	& 	X"12"	,
-- 192=>	X"0C"	& 	X"14"	& 	X"12"	,
-- 193=>	X"0A"	& 	X"15"	& 	X"12"	,
-- 194=>	X"7F"	& 	X"2A"	& 	X"12"	,
-- 195=>	X"29"	& 	X"2C"	& 	X"12"	,
-- 196=>	X"73"	& 	X"30"	& 	X"12"	,
-- 197=>	X"8D"	& 	X"32"	& 	X"12"	,
-- 198=>	X"01"	& 	X"33"	& 	X"12"	,
-- 199=>	X"02"	& 	X"49"	& 	X"12"	,
-- 200=>	X"9A"	& 	X"8C"	& 	X"12"	,
-- 201=>	X"AA"	& 	X"8E"	& 	X"12"	,
-- 202=>	X"3E"	& 	X"90"	& 	X"12"	,
-- 203=>	X"5F"	& 	X"92"	& 	X"12"	,
-- 204=>	X"0A"	& 	X"94"	& 	X"12"	,
-- 205=>	X"0A"	& 	X"96"	& 	X"12"	,
-- 206=>	X"7F"	& 	X"98"	& 	X"12"	,
-- 207=>	X"B3"	& 	X"9A"	& 	X"12"	,
-- 208=>	X"29"	& 	X"9C"	& 	X"12"	,
-- 209=>	X"64"	& 	X"9E"	& 	X"12"	,

-- 210=>	X"00"	& 	X"0D"	& 	X"02"	,	--Drive mode setting of V direction 0h : All-pixel mode 
-- 											-- 1h : 1/2 Subsampling mode 
-- 											-- 2h : FD Binning mode 
-- 											-- Ch : Full-HD 
-- 											-- Others: Setting prohibited  

-- 211=>	X"00"	& 	X"19"	& 	X"02"	,	--The value is set according to  drive mode. 
-- 											-- 0: All-pixel, ROI, 1/2 Subsampling, FD Binning 
-- 											-- 1: 1080p-Full HD 

-- 212=>	X"10"	& 	X"89"	& 	X"02"	,	--INCKSEL
-- 213=>	X"00"	& 	X"8a"	& 	X"02"	,	--INCKSEL
-- 214=>	X"10"	& 	X"8b"	& 	X"02"	,	--INCKSEL
-- 215=>	X"00"	& 	X"8c"	& 	X"02"	,	--INCKSEL
-- 216=>	X"08"	& 	X"9e"	& 	X"02"	,	--GTWAIT	The  value  is  set  according  to  drive mode. 
-- 											-- 0Ah: All-pixel, ROI, 1/2 Subsampling, FD Binning 
-- 											-- 06h: 1080p-Full HD 

-- 217=>	X"04"	& 	X"a0"	& 	X"02"	,	-- GSDLY The  value  is  set  according  to  drive mode. 
-- 											-- 08:  All-pixel,  ROI,  1/2  Subsampling, FD Binning 
-- 											-- 04h: 1080p-Full HD 
											
-- 218=>	X"0e"	& 	X"af"	& 	X"02"	,	-- The  value  is  set  according  to  drive mode. 
-- 											-- 0Eh: All-pixel, ROI, 1/2 Subsampling, FD Binning 
-- 											-- 0Ah: 1080p-Full HD 										
-- 219=>	X"00"	& 	X"8d"	& 	X"02"	,	-- SHS
-- 220=>	X"01"	& 	X"8e"	& 	X"02"	,	-- SHS
-- 221=>	X"00"	& 	X"8f"	& 	X"02"	,	-- SHS
-- 222=>	X"40"	& 	X"04"	& 	X"04"	,	-- GAIN
-- 223=>	X"00"	& 	X"05"	& 	X"04"	,	-- GAIN



-- 224=>	X"03"	& 	X"00"	& 	X"05"	,	-- enable ROI
-- 225=>	X"10"	& 	X"10"	& 	X"05"	,	-- position H
-- 226=>	X"00"	& 	X"11"	& 	X"05"	,	-- position H
-- 227=>	X"10"	& 	X"12"	& 	X"05"	,	-- position V
-- 228=>	X"00"	& 	X"13"	& 	X"05"	,	-- position V
-- 229=>	X"00"	& 	X"14"	& 	X"05"	,	-- size ROI H
-- 230=>	X"01"	& 	X"15"	& 	X"05"	,	-- size ROI H
-- 231=>	X"00"	& 	X"16"	& 	X"05"	,	-- size ROI V
-- 232=>	X"01"	& 	X"17"	& 	X"05"	,	-- size ROI V



-- 233=>	X"00"	& 	X"08"	& 	X"02"	,	-- REGHOLD
-- 234=>	X"00"	& 	X"00"	& 	X"02"	,	-- STANDBY
-- 235=>	X"00"	& 	X"0a"	& 	X"02"	,	-- XMSTA

others => X"00_00_82"); 

begin
--
enable_clk_spi		<=	ena_clk;
--
------------------------------------счетчик пикселей для глобальных сигналов запуска/сброса -----------------------------
pix_str_reset_imx: count_n_modul                   
generic map (24) 
port map (
		----IN signal---------
	clk			=>CLK,	
	reset		=>MAIN_reset,
	en			=>ena_clk,
	modul		=> std_logic_vector(to_unsigned(1073741821,24)),
		----OUT signal---------
	qout		=>qout_imx);	
----------------------------------------------------------------------------------------------------
Process(CLK)
begin
if rising_edge(CLK) then
	if ena_clk='1' then
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
end if;
end process;	
--
------------------------------------modification by VS
--
------------------------------------автомат для записи и чтения--------------------
-----------------------------------------------------------------------------------
Process(CLK, enable_clk_spi)
begin
if rising_edge(CLK)  then
	if enable_clk_spi = '1' then
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
		if to_integer(unsigned(addr_rom_reg))<240
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
	clk		=> CLK,
	clk_en	=> enable_clk_spi,
	reset_n	=> reset_n_spi_master,
	enable	=> enable_spi_master,
	cpol		=> cpol_spi_master,
	cpha		=> cpha_spi_master,
	miso		=> miso_spi_master,
	tx			=> tx_spi_master,
			-- OUT----
	sclk		=> sclk_spi_master,
	ss_n		=> ss_n_spi_master,
	mosi		=> mosi_spi_master,
	busy		=> busy_spi_master,
	rx			=> rx_spi_master
	);	
----------------------регистры обновляемые каждый кадр ---------------------
content2(0)<=AGC_VGA(7 downto 0)		& X"04"	& X"04";
content2(1)<=AGC_VGA(15 downto 8)	& X"05"	& X"04";
content2(2)<=AGC_str(7 downto 0)		& X"8d"	& X"02";
content2(3)<=AGC_str(15 downto 8)	& X"8e"	& X"02";
-- content2(4)<=black_lavel_imx(7 downto 0)	& X"54"	& X"84";
-- content2(5)<=black_lavel_imx(15 downto 8)	& X"55"	& X"84";
-- content2(6)<=Vmax(7 downto 0)				& X"10"	& X"82";
-- content2(7)<=Vmax(15 downto 8)				& X"11"	& X"82";
----------------------OUT--------------------
SDI_imx		<=	mosi_spi_master;
XCE_imx		<=	ss_n_spi_master;
SCK_imx		<=	sclk_spi_master;

end ;
