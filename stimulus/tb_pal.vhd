----------------------------------------------------------------------
-- Created by Microsemi SmartDesign Thu Jul 02 02:56:57 2020
-- Testbench Template
-- This is a basic testbench that instantiates your design with basic 
-- clock and reset pins connected.  If your design has special
-- clock/reset or testbench driver requirements then you should 
-- copy this file and modify it. 
----------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File: tb_pal.vhd
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
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.VIDEO_CONSTANTS.all;
use work.My_component_pkg.all;
entity tb_pal is
end tb_pal;

architecture behavioral of tb_pal is

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
            IMX_1_CH_P : in std_logic_vector(3 downto 0);
            IMX_1_CH_N : in std_logic_vector(3 downto 0);
            IMX_1_CLK_P : in std_logic;
            IMX_1_CLK_N : in std_logic;
            IMX_2_XHS : in std_logic;
            IMX_2_XVS : in std_logic;
            IMX_2_SDO : in std_logic;
            IMX_2_CH_P : in std_logic_vector(3 downto 0);
            IMX_2_CH_N : in std_logic_vector(3 downto 0);
            IMX_2_CLK_P : in std_logic;
            IMX_2_CLK_N : in std_logic;
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
            DAC_SFL : out std_logic;
            Get_m : out std_logic;
            Wide_Narrow : out std_logic;
            GPIO0 : out std_logic;
            GPIO1 : out std_logic;
            GPIO2 : out std_logic;
            GPIO3 : out std_logic;
            GPIO4 : out std_logic;
            GPIO5 : out std_logic;
            GPIO6 : out std_logic;
            GPIO7 : out std_logic;
            GPIO8 : out std_logic;
            GPIO9 : out std_logic;
            GPIO10 : out std_logic

            -- Inouts

        );
    end component;


    
    -- signal qout_clk			: std_logic_vector (bit_pix-1 downto 0):=(Others => '0'); 
    -- signal stroka_in        : std_logic := '0';


component tb_IS is
port (
    --??????? ???????--	
    CLK					: in std_logic;  								        -- ???????? 
    mode_generator		: in std_logic_vector (7 downto 0);						-- ??????? ??????????
        --???????? ???????--	
    XVS_Imx_Sim			: out std_logic; 									    -- ?????????????
    XHS_Imx_Sim			: out std_logic; 									    -- ?????????????
    DATA_IS_PAR			: out std_logic_vector (bit_data_imx-1 downto 0);	    -- ???????? ??????
    DATA_IS_LVDS_ch_P	: out std_logic_vector (3 downto 0);					-- ???????? ?????? ? ?????? 1
    DATA_IS_LVDS_ch_N	: out std_logic_vector (3 downto 0);					-- ???????? ?????? ? ?????? 1
    DATA_IS_CSI_P		: out std_logic; 									    -- ???????? ?????? CSI
    DATA_IS_CSI_N		: out std_logic; 									    -- ???????? ?????? CSI
    CLK_DDR_P			: out std_logic;		
    CLK_DDR_N			: out std_logic		
    );
end component;

signal XVS_Imx_Sim          :std_logic; 			
signal XHS_Imx_Sim          :std_logic; 				
signal DATA_IS_LVDS_ch_P    :std_logic_vector (3 downto 0); 	
signal DATA_IS_LVDS_ch_N    :std_logic_vector (3 downto 0); 	
signal DATA_IS_CSI_P        :std_logic; 				
signal DATA_IS_CSI_N        :std_logic; 				
signal CLK_DDR_P            :std_logic; 					
signal CLK_DDR_N            :std_logic; 					

begin


IMAGE_SENSOR_SIM_new_q: tb_IS	   
port map (
    --??????? ???????--	
    clk                 =>	SYSCLK,			
    mode_generator      =>	x"00",
    --???????? ???????--	
    XVS_Imx_Sim         =>	XVS_Imx_Sim,		
    XHS_Imx_Sim		    =>	XHS_Imx_Sim,
    DATA_IS_LVDS_ch_P   =>	DATA_IS_LVDS_ch_P,
    DATA_IS_LVDS_ch_N   =>	DATA_IS_LVDS_ch_N,
    -- XHS_Imx_Sim		    =>	XHS_Imx_Sim,
    -- XHS_Imx_Sim		    =>	XHS_Imx_Sim,
    CLK_DDR_P		    =>	CLK_DDR_P,
    CLK_DDR_N		    =>	CLK_DDR_N
);





    process
        variable vhdl_initial : BOOLEAN := TRUE;

    begin
        if ( vhdl_initial ) then
            -- Assert Reset
            NSYSRESET <= '1';
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
            IMX_1_XHS => XHS_Imx_Sim,
            IMX_1_XVS => XVS_Imx_Sim,
            IMX_1_SDO => '0',
            IMX_1_CH_P => DATA_IS_LVDS_ch_P,
            IMX_1_CH_N => DATA_IS_LVDS_ch_N,
            IMX_1_CLK_P => CLK_DDR_P,
            IMX_1_CLK_N => CLK_DDR_N,
            IMX_2_XHS => '0',
            IMX_2_XVS => '0',
            IMX_2_SDO => '0',
            IMX_2_CH_P => (others=> '0'),
            IMX_2_CH_N => (others=> '0'),
            IMX_2_CLK_P => '0',
            IMX_2_CLK_N => '0',
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
            DAC_SFL =>  open,
            Get_m =>  open,
            Wide_Narrow =>  open,
            GPIO0 =>  open,
            GPIO1 =>  open,
            GPIO2 =>  open,
            GPIO3 =>  open,
            GPIO4 =>  open,
            GPIO5 =>  open,
            GPIO6 =>  open,
            GPIO7 =>  open,
            GPIO8 =>  open,
            GPIO9 =>  open,
            GPIO10 =>  open

            -- Inouts

        );

end behavioral;

