library ieee;

use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.VIDEO_CONSTANTS.all;
use work.My_component_pkg.all;
----------------------------------------------------------------------
-- Модуль генерации сигналов сброс и разрешения 
----------------------------------------------------------------------
entity  reset_control is
port (
	CLK_in          : in std_logic;  									
	Reset_main      : in std_logic;  									
	Lock_PLL_1      : in std_logic;  									
	Lock_PLL_2      : in std_logic;  									
	Lock_PLL_3      : in std_logic;  									
	Lock_PLL_4      : in std_logic;  									
    Sync_x          : in std_logic;  									
    XHS_imx		    : in std_logic;  									
	XVS_imx		    : in std_logic;  									
	Enable_main	    : out std_logic;  									
	reset_1		    : out std_logic;  									
	reset_2		    : out std_logic;  									
	reset_3		    : out std_logic;  									
	reset_4		    : out std_logic
		);
end reset_control;

architecture beh of reset_control is 

signal lock_pll_all         : std_logic;
signal sync_V_imx           : std_logic;
signal cnt_V_imx            : integer range 0 to 30000;
signal lock_pll_all_q       : std_logic_vector(31 downto 0);
constant N_frame_imx_sync   : integer:=20000;
signal sunc_imx              : std_logic;
signal ena_sync              : std_logic;


signal qout_imx       : std_logic_vector(29 downto 0);

begin
----------------------------------------------------------------------
--Захват первых N кадров от фотоприемника для синхронизации
----------------------------------------------------------------------
------------------------------------счетчик пикселей для глобальных сигналов запуска/сброса -----------------------------
process (XVS_imx,lock_pll_all)
begin
if lock_pll_all='0' then
    sync_V_imx  <='1';
    ena_sync    <='0';    
else
    if falling_edge(XVS_imx) then
        if  cnt_V_imx   >100 and cnt_V_imx  <200  then   
            ena_sync    <='1';
        else
            ena_sync    <='0';
        end if ;
        if cnt_V_imx >= N_frame_imx_sync   then
            sync_V_imx  <='0';
        end if ;
    end if;
end if;
end process;

process (XVS_imx,lock_pll_all)   -- счетчик кадров от фотоприемника
begin
if lock_pll_all='0' then
    cnt_V_imx  <=0;
else
    if falling_edge(XVS_imx) then
        if sync_V_imx='1'   then
            cnt_V_imx   <=cnt_V_imx+1;
        end if ;
    end if;
end if;
end process;

sunc_imx    <=  not (XVS_imx);

------------------------------------счетчик пикселей для глобальных сигналов запуска/сброса -----------------------------
-- process (XHS_imx,lock_pll_all)
-- begin
-- if lock_pll_all='0' then
--     sync_V_imx  <='1';
--     ena_sync    <='0';    
-- else
--     if falling_edge(XHS_imx) then
--         if  cnt_V_imx   >=1 and cnt_V_imx  <2  then   
--             ena_sync    <='1';
--         else
--             ena_sync    <='0';
--         end if ;
--         if cnt_V_imx >= N_frame_imx_sync   then
--             sync_V_imx  <='0';
--         end if ;
--     end if;
-- end if;
-- end process;

-- process (XHS_imx,lock_pll_all)   -- счетчик кадров от фотоприемника
-- begin
-- if lock_pll_all='0' then
--     cnt_V_imx  <=0;
-- else
--     if falling_edge(XHS_imx) then
--         if sync_V_imx='1'   then
--             cnt_V_imx   <=cnt_V_imx+1;
--         end if ;
--     end if;
-- end if;
-- end process;

-- sunc_imx    <=  not (XHS_imx);

----------------------------------------------------------------------
-- для организации правльного синхронного сброса FLASH FPGA 
-- задержка на 32 такта сигнала LOCK от всех PLL
----------------------------------------------------------------------
process (CLK_in)
begin
if  rising_edge(CLK_in) then
    lock_pll_all_q(0) <= lock_pll_all;
    for i in 0 to 30 loop
        lock_pll_all_q(i+1) <= lock_pll_all_q(i);
    end loop;
end if;
end process;
----------------------------------------------------------------------
--выходные сигналы
----------------------------------------------------------------------
lock_pll_all  <=  Lock_PLL_1 and Lock_PLL_2 and Lock_PLL_3 and Lock_PLL_4;   --work when ALL PLL LOCK
-- reset_1         <=not  Lock_PLL_1 or sync_V_imx;
reset_1         <= not lock_pll_all_q(15)   or (sunc_imx and  ena_sync);
reset_2         <= not lock_pll_all_q(15)   ;
reset_3         <= not lock_pll_all_q(15)   or (sunc_imx and  ena_sync);
reset_4         <= not Lock_PLL_4 ;
Enable_main     <= lock_pll_all_q(15);
end ;
