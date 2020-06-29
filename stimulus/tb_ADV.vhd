----------------------------------------------------------------------
-- Created by Microsemi SmartDesign Sat Jun 27 13:25:08 2020
-- Testbench Template
-- This is a basic testbench that instantiates your design with basic 
-- clock and reset pins connected.  If your design has special
-- clock/reset or testbench driver requirements then you should 
-- copy this file and modify it. 
----------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File: tb_ADV.vhd
-- File history:
--      <Revision number>: <Date>: <Comments>
--      <Revision number>: <Date>: <Comments>
--      <Revision number>: <Date>: <Comments>
--
-- Description: 
--
-- <Description here>
--
-- Targeted device: <Family::ProASIC3L> <Die::A3PE3000L> <Package::484 FBGA>
-- Author: <Name>
--
--------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;

entity tb_ADV is
end tb_ADV;

architecture behavioral of tb_ADV is

    constant SYSCLK_PERIOD : time := 13 ns; -- 76.9231MHZ

    signal SYSCLK : std_logic := '0';
    signal NSYSRESET : std_logic := '0';

    component EKB_top
        -- ports
        port( 
            -- Inputs
            IMX_1_XHS : in std_logic;
            IMX_1_XVS : in std_logic;
            IMX_1_SDO : in std_logic;
            IMX_2_XHS : in std_logic;
            IMX_2_XVS : in std_logic;
            IMX_2_SDO : in std_logic;
            CLK_in : in std_logic;
            Reset_main : in std_logic;

            -- Outputs
            IMX_1_XCLR : out std_logic;
            IMX_1_SCK : out std_logic;
            IMX_1_SDI : out std_logic;
            IMX_1_XCE : out std_logic;
            IMX_1_INCK : out std_logic;
            IMX_1_XTRIG : out std_logic;
            IMX_2_XCLR : out std_logic;
            IMX_2_SCK : out std_logic;
            IMX_2_SDI : out std_logic;
            IMX_2_XCE : out std_logic;
            IMX_2_INCK : out std_logic;
            IMX_2_XTRIG : out std_logic;
            DAC_Y : out std_logic_vector(7 downto 0);
            DAC_PHSYNC : out std_logic;
            DAC_PVSYNC : out std_logic;
            DAC_PBLK : out std_logic;
            DAC_LF1 : out std_logic;
            DAC_LF2 : out std_logic;
            DAC_SDA : out std_logic;
            DAC_SCL : out std_logic;
            DAC_CLK : out std_logic;
            DAC_SFL : out std_logic

            -- Inouts

        );
    end component;

begin

    process
        variable vhdl_initial : BOOLEAN := TRUE;

    begin
        if ( vhdl_initial ) then
            -- Assert Reset
            NSYSRESET <= '0';
            wait for ( SYSCLK_PERIOD * 10 );
            
            NSYSRESET <= '1';
            wait;
        end if;
    end process;

    -- Clock Driver
    SYSCLK <= not SYSCLK after (SYSCLK_PERIOD / 2.0 );

    -- Instantiate Unit Under Test:  EKB_top
    EKB_top_0 : EKB_top
        -- port map
        port map( 
            -- Inputs
            IMX_1_XHS => '0',
            IMX_1_XVS => '0',
            IMX_1_SDO => '0',
            IMX_2_XHS => '0',
            IMX_2_XVS => '0',
            IMX_2_SDO => '0',
            CLK_in => SYSCLK,
            Reset_main => NSYSRESET,

            -- Outputs
            IMX_1_XCLR =>  open,
            IMX_1_SCK =>  open,
            IMX_1_SDI =>  open,
            IMX_1_XCE =>  open,
            IMX_1_INCK =>  open,
            IMX_1_XTRIG =>  open,
            IMX_2_XCLR =>  open,
            IMX_2_SCK =>  open,
            IMX_2_SDI =>  open,
            IMX_2_XCE =>  open,
            IMX_2_INCK =>  open,
            IMX_2_XTRIG =>  open,
            DAC_Y => open,
            DAC_PHSYNC =>  open,
            DAC_PVSYNC =>  open,
            DAC_PBLK =>  open,
            DAC_LF1 =>  open,
            DAC_LF2 =>  open,
            DAC_SDA =>  open,
            DAC_SCL =>  open,
            DAC_CLK =>  open,
            DAC_SFL =>  open

            -- Inouts

        );

end behavioral;

