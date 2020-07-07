library ieee;

use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.VIDEO_CONSTANTS.all;
use work.My_component_pkg.all;
----------------------------------------------------------------------
---модуль вставки TRS кодовв видеопоток
----------------------------------------------------------------------
entity SAV_EAV_insert is
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
end SAV_EAV_insert;

architecture beh of SAV_EAV_insert is 

signal data_anc      : std_logic_vector (bit_data_ADV7343-1 downto 0):=(Others => '0'); 
signal data_video    : std_logic_vector (bit_data_ADV7343-1 downto 0):=(Others => '0'); 
signal ena_clk_in    : std_logic:='0';
signal VALID_DATA    : std_logic:='0';
signal TRS_SYNC_3FF  : std_logic_vector (bit_data_ADV7343-1 downto 0); 
signal TRS_SYNC_0    : std_logic_vector (bit_data_ADV7343-1 downto 0); 
signal TRS_F0_V0_H0  : std_logic_vector (bit_data_ADV7343-1 downto 0); 
signal TRS_F0_V0_H1  : std_logic_vector (bit_data_ADV7343-1 downto 0); 
signal TRS_F0_V1_H0  : std_logic_vector (bit_data_ADV7343-1 downto 0); 
signal TRS_F0_V1_H1  : std_logic_vector (bit_data_ADV7343-1 downto 0); 
signal TRS_F1_V0_H0  : std_logic_vector (bit_data_ADV7343-1 downto 0); 
signal TRS_F1_V0_H1  : std_logic_vector (bit_data_ADV7343-1 downto 0); 
signal TRS_F1_V1_H0  : std_logic_vector (bit_data_ADV7343-1 downto 0); 
signal TRS_F1_V1_H1  : std_logic_vector (bit_data_ADV7343-1 downto 0); 

begin
---------------------------------------------------
---модуль генерации TRS кодов ---------------------------------------------------
TRS_gen_q: TRS_gen                    
generic map (bit_data_ADV7343) 
port map (
	CLK				=>	CLK,		
   TRS_SYNC_3FF   => TRS_SYNC_3FF,
   TRS_SYNC_0     => TRS_SYNC_0  ,
   TRS_F0_V0_H0   => TRS_F0_V0_H0,
   TRS_F0_V0_H1   => TRS_F0_V0_H1,
   TRS_F0_V1_H0   => TRS_F0_V1_H0,
   TRS_F0_V1_H1   => TRS_F0_V1_H1,
   TRS_F1_V0_H0   => TRS_F1_V0_H0,
   TRS_F1_V0_H1   => TRS_F1_V0_H1,
   TRS_F1_V1_H0   => TRS_F1_V1_H0,
   TRS_F1_V1_H1   => TRS_F1_V1_H1
   );
   TRS_F0_V0_H0	<=	x"80" ;		
   TRS_F0_V0_H1	<=	x"9D" ;		
   TRS_F0_V1_H0	<=	x"AB" ;		
   TRS_F0_V1_H1	<=	x"B6" ;		
   TRS_F1_V0_H0	<=	x"C7" ;		
   TRS_F1_V0_H1	<=	x"DA" ;		
   TRS_F1_V1_H0	<=	x"EC" ;		
   TRS_F1_V1_H1	<=	x"F1" ;		
   TRS_SYNC_3FF	<=	x"FF" ;		
   TRS_SYNC_0		<=	x"00" ;
------------------------------------------------------------
-- вставка синхро кодов TRS к передаваемую последовательность
------------------------------------------------------------
-- | LINE NUMBER | F | V | H (EAV) | H (SAV) |
-- |     0-21    | 0 | 1 |   1     |    0    |  TRS_F0_V1_H1	<=	x"B6" ;	   TRS_F0_V1_H0	<=	x"AB" ;			
-- |    22-309   | 0 | 0 |   1     |    0    |  TRS_F0_V0_H1	<=	x"9D" ;		TRS_F0_V0_H0	<=	x"80" ;	
-- |   310-311   | 0 | 1 |   1     |    0    |  TRS_F0_V1_H1	<=	x"B6" ;	   TRS_F0_V1_H0	<=	x"AB" ;	
-- |   312-334   | 1 | 0 |   1     |    0    |  TRS_F1_V0_H1	<=	x"DA" ;     TRS_F1_V0_H0	<=	x"C7" ;
-- |   335-622   | 1 | 1 |   1     |    0    |  TRS_F1_V1_H1	<=	x"F1" ;     TRS_F1_V1_H0	<=	x"EC" ;
-- |   623-624   | 1 | 0 |   1     |    0    |
-- ena_clk_in  <= ena_clk_x_q(0);
ena_clk_in  <= '1';

Process(CLK)
begin
if rising_edge(CLK) then
	if ena_clk_in='1'	then
		data_anc	   <=std_logic_vector(to_unsigned(16,bit_data_ADV7343));
      data_video	<=data_in(bit_data_ADV7343-1 downto 0);
      -- | LINE NUMBER | F | V | H (EAV) | H (SAV) |
      -- |     0-21    | 0 | 1 |   1     |    0    |
		if (to_integer(unsigned (qout_V)) >= 0)	and (to_integer(unsigned (qout_V)) <= 21 ) then
			if		to_integer(unsigned (qout_clk))	= HsyncShift - 1																						   then	data_out <= TRS_F0_V1_H0;  VALID_DATA<='0';
			elsif	to_integer(unsigned (qout_clk))	= HsyncShift - 2																						   then	data_out <= TRS_SYNC_0;	   VALID_DATA<='0';
			elsif	to_integer(unsigned (qout_clk))	= HsyncShift - 3																						   then	data_out <= TRS_SYNC_0;	   VALID_DATA<='0';
			elsif	to_integer(unsigned (qout_clk))	= HsyncShift - 4																						   then	data_out <= TRS_SYNC_3FF;  VALID_DATA<='0';
			elsif	to_integer(unsigned (qout_clk))	= HsyncShift + ActivePixPerLine + 0																   then	data_out <= TRS_SYNC_3FF;  VALID_DATA<='0';
			elsif	to_integer(unsigned (qout_clk))	= HsyncShift + ActivePixPerLine + 1																   then	data_out <= TRS_SYNC_0;	   VALID_DATA<='0';
			elsif	to_integer(unsigned (qout_clk))	= HsyncShift + ActivePixPerLine + 2																   then	data_out <= TRS_SYNC_0;	   VALID_DATA<='0';
			elsif	to_integer(unsigned (qout_clk))	= HsyncShift + ActivePixPerLine + 3																   then	data_out <= TRS_F0_V1_H1;  VALID_DATA<='0';
			elsif	to_integer(unsigned (qout_clk))	>= HsyncShift and to_integer(unsigned (qout_clk)) < HsyncShift + ActivePixPerLine	then	data_out <= data_video;	   VALID_DATA<='0';
			else																																							         data_out <= data_anc;      VALID_DATA<='0';
         end if;
      -- | LINE NUMBER | F | V | H (EAV) | H (SAV) |
      -- |    22-309   | 0 | 0 |   1     |    0    |
      elsif (to_integer(unsigned (qout_V)) >= 22)	and (to_integer(unsigned (qout_V)) <= 309 ) then
         if		to_integer(unsigned (qout_clk))	= HsyncShift - 1																					      then	data_out <= TRS_F0_V0_H0;  VALID_DATA<='0';
         elsif	to_integer(unsigned (qout_clk))	= HsyncShift - 2																					      then	data_out <= TRS_SYNC_0;	   VALID_DATA<='0';
         elsif	to_integer(unsigned (qout_clk))	= HsyncShift - 3																					      then	data_out <= TRS_SYNC_0;	   VALID_DATA<='0';
         elsif	to_integer(unsigned (qout_clk))	= HsyncShift - 4																					      then	data_out <= TRS_SYNC_3FF;  VALID_DATA<='0';
         elsif	to_integer(unsigned (qout_clk))	= HsyncShift + ActivePixPerLine + 0															      then	data_out <= TRS_SYNC_3FF;  VALID_DATA<='0';
         elsif	to_integer(unsigned (qout_clk))	= HsyncShift + ActivePixPerLine + 1															      then	data_out <= TRS_SYNC_0;	   VALID_DATA<='0';
         elsif	to_integer(unsigned (qout_clk))	= HsyncShift + ActivePixPerLine + 2															      then	data_out <= TRS_SYNC_0;	   VALID_DATA<='0';
         elsif	to_integer(unsigned (qout_clk))	= HsyncShift + ActivePixPerLine + 3															      then	data_out <= TRS_F0_V0_H1;  VALID_DATA<='0';
         elsif	to_integer(unsigned (qout_clk))	>= HsyncShift and to_integer(unsigned (qout_clk)) < HsyncShift + ActivePixPerLine   then	data_out <= data_video;		VALID_DATA<='1';
         else																																									   data_out <= data_anc;      VALID_DATA<='0';
         end if;
      -- | LINE NUMBER | F | V | H (EAV) | H (SAV) |
      -- |   310-311   | 0 | 1 |   1     |    0    |
      elsif (to_integer(unsigned (qout_V)) >= 310)	and (to_integer(unsigned (qout_V)) <= 311 ) then
         if		to_integer(unsigned (qout_clk))	= HsyncShift - 1																						   then	data_out <= TRS_F0_V1_H0;  VALID_DATA<='0';
         elsif	to_integer(unsigned (qout_clk))	= HsyncShift - 2																						   then	data_out <= TRS_SYNC_0;	   VALID_DATA<='0';
         elsif	to_integer(unsigned (qout_clk))	= HsyncShift - 3																						   then	data_out <= TRS_SYNC_0;	   VALID_DATA<='0';
         elsif	to_integer(unsigned (qout_clk))	= HsyncShift - 4																						   then	data_out <= TRS_SYNC_3FF;  VALID_DATA<='0';
         elsif	to_integer(unsigned (qout_clk))	= HsyncShift + ActivePixPerLine + 0																   then	data_out <= TRS_SYNC_3FF;  VALID_DATA<='0';
         elsif	to_integer(unsigned (qout_clk))	= HsyncShift + ActivePixPerLine + 1																   then	data_out <= TRS_SYNC_0;	   VALID_DATA<='0';
         elsif	to_integer(unsigned (qout_clk))	= HsyncShift + ActivePixPerLine + 2																   then	data_out <= TRS_SYNC_0;	   VALID_DATA<='0';
         elsif	to_integer(unsigned (qout_clk))	= HsyncShift + ActivePixPerLine + 3																   then	data_out <= TRS_F0_V1_H1;  VALID_DATA<='0';
         elsif	to_integer(unsigned (qout_clk))	>= HsyncShift and to_integer(unsigned (qout_clk)) < HsyncShift + ActivePixPerLine	then	data_out <= data_video;		VALID_DATA<='0';
         else																																									   data_out <= data_anc;      VALID_DATA<='0';
         end if;
      -- | LINE NUMBER | F | V | H (EAV) | H (SAV) |
      -- |   312-334   | 1 | 0 |   1     |    0    |
      elsif (to_integer(unsigned (qout_V)) >= 312)	and (to_integer(unsigned (qout_V)) <= 334 ) then
         if		to_integer(unsigned (qout_clk))	= HsyncShift - 1																						   then	data_out <= TRS_F1_V1_H0;  VALID_DATA<='0';
         elsif	to_integer(unsigned (qout_clk))	= HsyncShift - 2																						   then	data_out <= TRS_SYNC_0;	   VALID_DATA<='0';
         elsif	to_integer(unsigned (qout_clk))	= HsyncShift - 3																						   then	data_out <= TRS_SYNC_0;	   VALID_DATA<='0';
         elsif	to_integer(unsigned (qout_clk))	= HsyncShift - 4																						   then	data_out <= TRS_SYNC_3FF;  VALID_DATA<='0';
         elsif	to_integer(unsigned (qout_clk))	= HsyncShift + ActivePixPerLine + 0																   then	data_out <= TRS_SYNC_3FF;  VALID_DATA<='0';
         elsif	to_integer(unsigned (qout_clk))	= HsyncShift + ActivePixPerLine + 1																   then	data_out <= TRS_SYNC_0;	   VALID_DATA<='0';
         elsif	to_integer(unsigned (qout_clk))	= HsyncShift + ActivePixPerLine + 2																   then	data_out <= TRS_SYNC_0;	   VALID_DATA<='0';
         elsif	to_integer(unsigned (qout_clk))	= HsyncShift + ActivePixPerLine + 3																   then	data_out <= TRS_F1_V1_H1;  VALID_DATA<='0';
         elsif	to_integer(unsigned (qout_clk))	>= HsyncShift and to_integer(unsigned (qout_clk)) < HsyncShift + ActivePixPerLine	then	data_out <= data_video;		VALID_DATA<='0';
         else																																									   data_out <= data_anc;      VALID_DATA<='0';
         end if;
      -- | LINE NUMBER | F | V | H (EAV) | H (SAV) |
      -- |   335-622   | 1 | 1 |   1     |    0    |
      elsif (to_integer(unsigned (qout_V)) >= 335)	and (to_integer(unsigned (qout_V)) <= 622 ) then
         if		to_integer(unsigned (qout_clk))	= HsyncShift - 1																						   then	data_out <= TRS_F1_V0_H0;  VALID_DATA<='0';
         elsif	to_integer(unsigned (qout_clk))	= HsyncShift - 2																						   then	data_out <= TRS_SYNC_0;	   VALID_DATA<='0';
         elsif	to_integer(unsigned (qout_clk))	= HsyncShift - 3																						   then	data_out <= TRS_SYNC_0;	   VALID_DATA<='0';
         elsif	to_integer(unsigned (qout_clk))	= HsyncShift - 4																						   then	data_out <= TRS_SYNC_3FF;  VALID_DATA<='0';
         elsif	to_integer(unsigned (qout_clk))	= HsyncShift + ActivePixPerLine + 0																   then	data_out <= TRS_SYNC_3FF;  VALID_DATA<='0';
         elsif	to_integer(unsigned (qout_clk))	= HsyncShift + ActivePixPerLine + 1																   then	data_out <= TRS_SYNC_0;	   VALID_DATA<='0';
         elsif	to_integer(unsigned (qout_clk))	= HsyncShift + ActivePixPerLine + 2																   then	data_out <= TRS_SYNC_0;	   VALID_DATA<='0';
         elsif	to_integer(unsigned (qout_clk))	= HsyncShift + ActivePixPerLine + 3																   then	data_out <= TRS_F1_V0_H1;  VALID_DATA<='0';
         elsif	to_integer(unsigned (qout_clk))	>= HsyncShift and to_integer(unsigned (qout_clk)) < HsyncShift + ActivePixPerLine	then	data_out <= data_video;		VALID_DATA<='1';
         else																																									   data_out <= data_anc;      VALID_DATA<='0';
         end if;
      -- | LINE NUMBER | F | V | H (EAV) | H (SAV) |
      -- |   623-624   | 1 | 0 |   1     |    0    |
      elsif (to_integer(unsigned (qout_V)) >= 623)	and (to_integer(unsigned (qout_V)) <= 624 ) then
         if		to_integer(unsigned (qout_clk))	= HsyncShift - 1																						   then	data_out <= TRS_F1_V1_H0;  VALID_DATA<='0';
         elsif	to_integer(unsigned (qout_clk))	= HsyncShift - 2																						   then	data_out <= TRS_SYNC_0;	   VALID_DATA<='0';
         elsif	to_integer(unsigned (qout_clk))	= HsyncShift - 3																						   then	data_out <= TRS_SYNC_0;	   VALID_DATA<='0';
         elsif	to_integer(unsigned (qout_clk))	= HsyncShift - 4																						   then	data_out <= TRS_SYNC_3FF;  VALID_DATA<='0';
         elsif	to_integer(unsigned (qout_clk))	= HsyncShift + ActivePixPerLine + 0																   then	data_out <= TRS_SYNC_3FF;  VALID_DATA<='0';
         elsif	to_integer(unsigned (qout_clk))	= HsyncShift + ActivePixPerLine + 1																   then	data_out <= TRS_SYNC_0;	   VALID_DATA<='0';
         elsif	to_integer(unsigned (qout_clk))	= HsyncShift + ActivePixPerLine + 2																   then	data_out <= TRS_SYNC_0;	   VALID_DATA<='0';
         elsif	to_integer(unsigned (qout_clk))	= HsyncShift + ActivePixPerLine + 3																   then	data_out <= TRS_F1_V1_H1;  VALID_DATA<='0';
         elsif	to_integer(unsigned (qout_clk))	>= HsyncShift and to_integer(unsigned (qout_clk)) < HsyncShift + ActivePixPerLine	then	data_out <= data_video;		VALID_DATA<='0';
         else																																									   data_out <= data_anc;      VALID_DATA<='0';
         end if;
		end if;
	end if;
end if;
end process;








end ;

