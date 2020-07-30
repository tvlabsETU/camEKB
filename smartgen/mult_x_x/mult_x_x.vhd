-- Version: v11.8 SP3 11.8.3.6

library ieee;
use ieee.std_logic_1164.all;
library proasic3l;
use proasic3l.all;

entity mult_x_x is

    port( DataA : in    std_logic_vector(11 downto 0);
          DataB : in    std_logic_vector(11 downto 0);
          Mult  : out   std_logic_vector(23 downto 0);
          Clock : in    std_logic
        );

end mult_x_x;

architecture DEF_ARCH of mult_x_x is 

  component BUFF
    port( A : in    std_logic := 'U';
          Y : out   std_logic
        );
  end component;

  component DFN1
    port( D   : in    std_logic := 'U';
          CLK : in    std_logic := 'U';
          Q   : out   std_logic
        );
  end component;

  component XOR2
    port( A : in    std_logic := 'U';
          B : in    std_logic := 'U';
          Y : out   std_logic
        );
  end component;

  component XOR3
    port( A : in    std_logic := 'U';
          B : in    std_logic := 'U';
          C : in    std_logic := 'U';
          Y : out   std_logic
        );
  end component;

  component AND2
    port( A : in    std_logic := 'U';
          B : in    std_logic := 'U';
          Y : out   std_logic
        );
  end component;

  component AO1
    port( A : in    std_logic := 'U';
          B : in    std_logic := 'U';
          C : in    std_logic := 'U';
          Y : out   std_logic
        );
  end component;

  component MAJ3
    port( A : in    std_logic := 'U';
          B : in    std_logic := 'U';
          C : in    std_logic := 'U';
          Y : out   std_logic
        );
  end component;

  component NOR2
    port( A : in    std_logic := 'U';
          B : in    std_logic := 'U';
          Y : out   std_logic
        );
  end component;

  component MX2
    port( A : in    std_logic := 'U';
          B : in    std_logic := 'U';
          S : in    std_logic := 'U';
          Y : out   std_logic
        );
  end component;

  component XNOR2
    port( A : in    std_logic := 'U';
          B : in    std_logic := 'U';
          Y : out   std_logic
        );
  end component;

  component INV
    port( A : in    std_logic := 'U';
          Y : out   std_logic
        );
  end component;

  component AND2A
    port( A : in    std_logic := 'U';
          B : in    std_logic := 'U';
          Y : out   std_logic
        );
  end component;

  component VCC
    port(Y : out std_logic); 
  end component;

    signal \S[0]\, \S[1]\, \S[2]\, \S[3]\, \S[4]\, \S[5]\, \E[0]\, 
        \E[1]\, \E[2]\, \E[3]\, \E[4]\, \E[5]\, \PP0[0]\, 
        \PP0[1]\, \PP0[2]\, \PP0[3]\, \PP0[4]\, \PP0[5]\, 
        \PP0[6]\, \PP0[7]\, \PP0[8]\, \PP0[9]\, \PP0[10]\, 
        \PP0[11]\, \PP0[12]\, \PP1[0]\, \PP1[1]\, \PP1[2]\, 
        \PP1[3]\, \PP1[4]\, \PP1[5]\, \PP1[6]\, \PP1[7]\, 
        \PP1[8]\, \PP1[9]\, \PP1[10]\, \PP1[11]\, \PP1[12]\, 
        \PP2[0]\, \PP2[1]\, \PP2[2]\, \PP2[3]\, \PP2[4]\, 
        \PP2[5]\, \PP2[6]\, \PP2[7]\, \PP2[8]\, \PP2[9]\, 
        \PP2[10]\, \PP2[11]\, \PP2[12]\, \PP3[0]\, \PP3[1]\, 
        \PP3[2]\, \PP3[3]\, \PP3[4]\, \PP3[5]\, \PP3[6]\, 
        \PP3[7]\, \PP3[8]\, \PP3[9]\, \PP3[10]\, \PP3[11]\, 
        \PP3[12]\, \PP4[0]\, \PP4[1]\, \PP4[2]\, \PP4[3]\, 
        \PP4[4]\, \PP4[5]\, \PP4[6]\, \PP4[7]\, \PP4[8]\, 
        \PP4[9]\, \PP4[10]\, \PP4[11]\, \PP4[12]\, \PP5[0]\, 
        \PP5[1]\, \PP5[2]\, \PP5[3]\, \PP5[4]\, \PP5[5]\, 
        \PP5[6]\, \PP5[7]\, \PP5[8]\, \PP5[9]\, \PP5[10]\, 
        \PP5[11]\, \PP5[12]\, \PP6[0]\, \PP6[1]\, \PP6[2]\, 
        \PP6[3]\, \PP6[4]\, \PP6[5]\, \PP6[6]\, \PP6[7]\, 
        \PP6[8]\, \PP6[9]\, \PP6[10]\, \PP6[11]\, \SumA[0]\, 
        \SumA[1]\, \SumA[2]\, \SumA[3]\, \SumA[4]\, \SumA[5]\, 
        \SumA[6]\, \SumA[7]\, \SumA[8]\, \SumA[9]\, \SumA[10]\, 
        \SumA[11]\, \SumA[12]\, \SumA[13]\, \SumA[14]\, 
        \SumA[15]\, \SumA[16]\, \SumA[17]\, \SumA[18]\, 
        \SumA[19]\, \SumA[20]\, \SumA[21]\, \SumA[22]\, \SumB[0]\, 
        \SumB[1]\, \SumB[2]\, \SumB[3]\, \SumB[4]\, \SumB[5]\, 
        \SumB[6]\, \SumB[7]\, \SumB[8]\, \SumB[9]\, \SumB[10]\, 
        \SumB[11]\, \SumB[12]\, \SumB[13]\, \SumB[14]\, 
        \SumB[15]\, \SumB[16]\, \SumB[17]\, \SumB[18]\, 
        \SumB[19]\, \SumB[20]\, \SumB[21]\, \SumB[22]\, XOR2_15_Y, 
        AND2_142_Y, XOR3_19_Y, MAJ3_16_Y, XOR3_12_Y, MAJ3_32_Y, 
        XOR2_30_Y, AND2_146_Y, XOR3_7_Y, MAJ3_30_Y, XOR3_21_Y, 
        MAJ3_3_Y, XOR3_27_Y, MAJ3_27_Y, XOR3_23_Y, MAJ3_35_Y, 
        XOR3_30_Y, MAJ3_38_Y, XOR3_39_Y, MAJ3_9_Y, XOR3_24_Y, 
        MAJ3_33_Y, XOR3_28_Y, MAJ3_39_Y, XOR3_14_Y, MAJ3_31_Y, 
        XOR2_1_Y, AND2_66_Y, XOR3_29_Y, MAJ3_23_Y, XOR2_14_Y, 
        AND2_134_Y, DFN1_64_Q, DFN1_9_Q, DFN1_52_Q, DFN1_48_Q, 
        DFN1_54_Q, DFN1_32_Q, DFN1_72_Q, DFN1_71_Q, DFN1_22_Q, 
        DFN1_36_Q, DFN1_12_Q, DFN1_61_Q, DFN1_17_Q, DFN1_57_Q, 
        DFN1_44_Q, DFN1_67_Q, DFN1_20_Q, DFN1_5_Q, DFN1_8_Q, 
        DFN1_73_Q, DFN1_40_Q, DFN1_39_Q, DFN1_35_Q, DFN1_24_Q, 
        DFN1_69_Q, DFN1_11_Q, DFN1_1_Q, DFN1_62_Q, DFN1_56_Q, 
        DFN1_30_Q, DFN1_19_Q, DFN1_3_Q, DFN1_63_Q, DFN1_34_Q, 
        DFN1_21_Q, DFN1_4_Q, DFN1_27_Q, DFN1_14_Q, DFN1_58_Q, 
        DFN1_41_Q, DFN1_50_Q, DFN1_49_Q, DFN1_10_Q, DFN1_70_Q, 
        DFN1_0_Q, DFN1_16_Q, DFN1_60_Q, DFN1_46_Q, DFN1_65_Q, 
        DFN1_38_Q, DFN1_51_Q, DFN1_29_Q, DFN1_75_Q, DFN1_45_Q, 
        DFN1_47_Q, DFN1_28_Q, DFN1_23_Q, DFN1_7_Q, DFN1_18_Q, 
        DFN1_2_Q, DFN1_43_Q, DFN1_42_Q, DFN1_53_Q, DFN1_31_Q, 
        DFN1_76_Q, DFN1_13_Q, DFN1_15_Q, DFN1_77_Q, DFN1_59_Q, 
        DFN1_33_Q, DFN1_68_Q, DFN1_37_Q, DFN1_6_Q, DFN1_66_Q, 
        DFN1_26_Q, DFN1_25_Q, DFN1_55_Q, DFN1_74_Q, XOR2_58_Y, 
        AND2_111_Y, XOR3_17_Y, MAJ3_37_Y, XOR3_5_Y, MAJ3_26_Y, 
        XOR3_0_Y, MAJ3_5_Y, XOR3_18_Y, MAJ3_20_Y, XOR3_13_Y, 
        MAJ3_12_Y, XOR3_25_Y, MAJ3_22_Y, XOR3_33_Y, MAJ3_34_Y, 
        XOR3_31_Y, MAJ3_2_Y, XOR3_22_Y, MAJ3_8_Y, XOR3_1_Y, 
        MAJ3_14_Y, XOR3_8_Y, MAJ3_18_Y, XOR3_36_Y, MAJ3_10_Y, 
        XOR3_34_Y, MAJ3_24_Y, XOR3_10_Y, MAJ3_0_Y, XOR3_4_Y, 
        MAJ3_28_Y, XOR3_15_Y, MAJ3_4_Y, XOR2_25_Y, AND2_40_Y, 
        XOR3_2_Y, MAJ3_15_Y, XOR3_20_Y, MAJ3_21_Y, XOR3_6_Y, 
        MAJ3_29_Y, XOR2_72_Y, AND2_127_Y, XOR3_38_Y, MAJ3_7_Y, 
        XOR3_16_Y, MAJ3_6_Y, XOR3_26_Y, MAJ3_17_Y, XOR3_11_Y, 
        MAJ3_1_Y, XOR3_37_Y, MAJ3_11_Y, XOR3_3_Y, MAJ3_36_Y, 
        XOR3_35_Y, MAJ3_25_Y, XOR2_9_Y, AND2_107_Y, XOR3_32_Y, 
        MAJ3_13_Y, XOR3_9_Y, MAJ3_19_Y, BUFF_29_Y, BUFF_9_Y, 
        BUFF_19_Y, BUFF_33_Y, BUFF_27_Y, BUFF_25_Y, BUFF_28_Y, 
        BUFF_5_Y, BUFF_38_Y, BUFF_1_Y, BUFF_46_Y, BUFF_34_Y, 
        BUFF_8_Y, BUFF_14_Y, BUFF_7_Y, BUFF_45_Y, BUFF_15_Y, 
        BUFF_18_Y, BUFF_11_Y, BUFF_37_Y, BUFF_43_Y, BUFF_10_Y, 
        BUFF_42_Y, BUFF_16_Y, BUFF_3_Y, BUFF_47_Y, BUFF_40_Y, 
        BUFF_20_Y, XOR2_55_Y, XOR2_37_Y, NOR2_11_Y, AND2_100_Y, 
        MX2_32_Y, AND2_86_Y, MX2_52_Y, AND2_85_Y, MX2_23_Y, 
        AND2_160_Y, XNOR2_1_Y, XOR2_35_Y, NOR2_0_Y, AND2_153_Y, 
        MX2_37_Y, AND2_97_Y, MX2_48_Y, AND2_87_Y, MX2_22_Y, 
        AND2_52_Y, MX2_10_Y, XNOR2_2_Y, XOR2_43_Y, NOR2_4_Y, 
        AND2_70_Y, MX2_14_Y, AND2_143_Y, MX2_63_Y, AND2_95_Y, 
        AND2_73_Y, MX2_1_Y, AND2_137_Y, MX2_58_Y, XNOR2_3_Y, 
        BUFF_23_Y, BUFF_24_Y, BUFF_17_Y, BUFF_12_Y, BUFF_39_Y, 
        XOR2_61_Y, XOR2_13_Y, NOR2_1_Y, AND2_75_Y, MX2_8_Y, 
        AND2_13_Y, MX2_3_Y, AND2_145_Y, MX2_5_Y, AND2_96_Y, 
        XNOR2_7_Y, XOR2_12_Y, NOR2_10_Y, AND2_139_Y, MX2_13_Y, 
        AND2_138_Y, MX2_29_Y, AND2_45_Y, MX2_34_Y, AND2_131_Y, 
        MX2_45_Y, XNOR2_14_Y, XOR2_38_Y, NOR2_12_Y, AND2_159_Y, 
        MX2_33_Y, AND2_148_Y, MX2_27_Y, AND2_53_Y, AND2_30_Y, 
        MX2_20_Y, AND2_51_Y, MX2_28_Y, XNOR2_11_Y, BUFF_26_Y, 
        BUFF_22_Y, BUFF_0_Y, XOR2_40_Y, AND2A_0_Y, AND2_104_Y, 
        MX2_21_Y, AND2_26_Y, MX2_9_Y, AND2_71_Y, MX2_24_Y, 
        AND2_122_Y, AND2A_2_Y, AND2_110_Y, MX2_6_Y, AND2_89_Y, 
        MX2_12_Y, AND2_61_Y, MX2_50_Y, AND2_124_Y, MX2_41_Y, 
        AND2A_1_Y, AND2_117_Y, MX2_44_Y, AND2_18_Y, MX2_49_Y, 
        AND2_12_Y, AND2_67_Y, MX2_0_Y, AND2_55_Y, MX2_19_Y, 
        BUFF_44_Y, BUFF_35_Y, BUFF_31_Y, BUFF_6_Y, XOR2_0_Y, 
        XOR2_2_Y, NOR2_9_Y, AND2_125_Y, MX2_31_Y, AND2_140_Y, 
        MX2_47_Y, AND2_115_Y, MX2_56_Y, AND2_43_Y, XNOR2_4_Y, 
        XOR2_24_Y, NOR2_8_Y, AND2_151_Y, MX2_11_Y, AND2_56_Y, 
        MX2_38_Y, AND2_8_Y, MX2_54_Y, AND2_129_Y, MX2_2_Y, 
        XNOR2_6_Y, XOR2_41_Y, NOR2_2_Y, AND2_74_Y, MX2_53_Y, 
        AND2_24_Y, MX2_7_Y, AND2_69_Y, AND2_98_Y, MX2_65_Y, 
        AND2_157_Y, MX2_46_Y, XNOR2_13_Y, BUFF_21_Y, BUFF_13_Y, 
        BUFF_4_Y, BUFF_36_Y, XOR2_33_Y, XOR2_39_Y, NOR2_14_Y, 
        AND2_77_Y, MX2_62_Y, AND2_5_Y, MX2_4_Y, AND2_90_Y, 
        MX2_42_Y, AND2_81_Y, XNOR2_12_Y, XOR2_68_Y, NOR2_6_Y, 
        AND2_113_Y, MX2_57_Y, AND2_123_Y, MX2_30_Y, AND2_94_Y, 
        MX2_51_Y, AND2_16_Y, MX2_36_Y, XNOR2_10_Y, XOR2_18_Y, 
        NOR2_3_Y, AND2_150_Y, MX2_40_Y, AND2_3_Y, MX2_64_Y, 
        AND2_91_Y, AND2_76_Y, MX2_18_Y, AND2_161_Y, MX2_17_Y, 
        XNOR2_0_Y, BUFF_41_Y, BUFF_32_Y, BUFF_30_Y, BUFF_2_Y, 
        XOR2_23_Y, XOR2_51_Y, NOR2_5_Y, AND2_99_Y, MX2_16_Y, 
        AND2_1_Y, MX2_61_Y, AND2_46_Y, MX2_55_Y, AND2_126_Y, 
        XNOR2_5_Y, XOR2_8_Y, NOR2_7_Y, AND2_20_Y, MX2_59_Y, 
        AND2_106_Y, MX2_26_Y, AND2_92_Y, MX2_43_Y, AND2_136_Y, 
        MX2_15_Y, XNOR2_8_Y, XOR2_65_Y, NOR2_13_Y, AND2_102_Y, 
        MX2_35_Y, AND2_80_Y, MX2_25_Y, AND2_14_Y, AND2_49_Y, 
        MX2_60_Y, AND2_34_Y, MX2_39_Y, XNOR2_9_Y, AND2_4_Y, 
        AND2_11_Y, AND2_6_Y, AND2_105_Y, AND2_60_Y, AND2_93_Y, 
        AND2_83_Y, AND2_114_Y, AND2_48_Y, AND2_152_Y, AND2_101_Y, 
        AND2_118_Y, AND2_79_Y, AND2_158_Y, AND2_28_Y, AND2_50_Y, 
        AND2_7_Y, AND2_33_Y, AND2_116_Y, AND2_2_Y, AND2_119_Y, 
        AND2_135_Y, XOR2_70_Y, XOR2_47_Y, XOR2_66_Y, XOR2_60_Y, 
        XOR2_56_Y, XOR2_49_Y, XOR2_45_Y, XOR2_32_Y, XOR2_22_Y, 
        XOR2_17_Y, XOR2_28_Y, XOR2_73_Y, XOR2_63_Y, XOR2_29_Y, 
        XOR2_44_Y, XOR2_16_Y, XOR2_54_Y, XOR2_31_Y, XOR2_5_Y, 
        XOR2_36_Y, XOR2_53_Y, XOR2_20_Y, XOR2_11_Y, AND2_132_Y, 
        AO1_41_Y, AND2_25_Y, AO1_45_Y, AND2_35_Y, AO1_7_Y, 
        AND2_47_Y, AO1_50_Y, AND2_41_Y, AO1_34_Y, AND2_68_Y, 
        AO1_0_Y, AND2_23_Y, AO1_10_Y, AND2_57_Y, AO1_47_Y, 
        AND2_22_Y, AO1_3_Y, AND2_141_Y, AO1_18_Y, AND2_36_Y, 
        AND2_84_Y, AND2_103_Y, AO1_19_Y, AND2_121_Y, AO1_36_Y, 
        AND2_108_Y, AO1_27_Y, AND2_149_Y, AO1_12_Y, AND2_82_Y, 
        AO1_29_Y, AND2_156_Y, AO1_52_Y, AND2_112_Y, AO1_46_Y, 
        AND2_59_Y, AO1_21_Y, AND2_130_Y, AO1_6_Y, AND2_21_Y, 
        AO1_40_Y, AND2_32_Y, AO1_23_Y, AND2_44_Y, AND2_38_Y, 
        AND2_65_Y, AND2_17_Y, AND2_154_Y, AO1_1_Y, AND2_109_Y, 
        AO1_49_Y, AND2_58_Y, AO1_11_Y, AND2_128_Y, AO1_51_Y, 
        AND2_19_Y, AO1_28_Y, AND2_31_Y, AO1_13_Y, AND2_42_Y, 
        AO1_26_Y, AND2_37_Y, AO1_20_Y, AND2_64_Y, AO1_8_Y, 
        AND2_15_Y, AND2_120_Y, AND2_63_Y, AND2_29_Y, AND2_78_Y, 
        AND2_147_Y, AND2_155_Y, AND2_10_Y, AND2_0_Y, AO1_24_Y, 
        AND2_39_Y, AND2_144_Y, AND2_54_Y, AND2_9_Y, AND2_133_Y, 
        AND2_27_Y, AND2_72_Y, AO1_37_Y, AND2_88_Y, AND2_62_Y, 
        AO1_35_Y, AO1_5_Y, AO1_38_Y, AO1_39_Y, AO1_30_Y, AO1_15_Y, 
        AO1_32_Y, AO1_22_Y, AO1_44_Y, AO1_42_Y, AO1_14_Y, AO1_2_Y, 
        AO1_33_Y, AO1_16_Y, AO1_31_Y, AO1_9_Y, AO1_25_Y, AO1_48_Y, 
        AO1_43_Y, AO1_17_Y, AO1_4_Y, XOR2_64_Y, XOR2_4_Y, 
        XOR2_26_Y, XOR2_50_Y, XOR2_6_Y, XOR2_59_Y, XOR2_71_Y, 
        XOR2_21_Y, XOR2_34_Y, XOR2_67_Y, XOR2_48_Y, XOR2_57_Y, 
        XOR2_10_Y, XOR2_69_Y, XOR2_27_Y, XOR2_7_Y, XOR2_19_Y, 
        XOR2_46_Y, XOR2_42_Y, XOR2_3_Y, XOR2_52_Y, XOR2_62_Y, 
        \VCC\ : std_logic;
    signal VCC_power_net1 : std_logic;

begin 

    \VCC\ <= VCC_power_net1;

    BUFF_8 : BUFF
      port map(A => DataA(6), Y => BUFF_8_Y);
    
    DFN1_40 : DFN1
      port map(D => \PP3[2]\, CLK => Clock, Q => DFN1_40_Q);
    
    \XOR2_Mult[8]\ : XOR2
      port map(A => XOR2_71_Y, B => AO1_15_Y, Y => Mult(8));
    
    \XOR3_SumB[16]\ : XOR3
      port map(A => MAJ3_18_Y, B => DFN1_47_Q, C => XOR3_36_Y, Y
         => \SumB[16]\);
    
    DFN1_24 : DFN1
      port map(D => MAJ3_7_Y, CLK => Clock, Q => DFN1_24_Q);
    
    AND2_12 : AND2
      port map(A => DataB(0), B => BUFF_29_Y, Y => AND2_12_Y);
    
    AO1_23 : AO1
      port map(A => XOR2_11_Y, B => AO1_18_Y, C => AND2_135_Y, Y
         => AO1_23_Y);
    
    MAJ3_9 : MAJ3
      port map(A => \PP5[4]\, B => \PP3[8]\, C => \PP1[12]\, Y
         => MAJ3_9_Y);
    
    AND2_72 : AND2
      port map(A => AND2_39_Y, B => AND2_64_Y, Y => AND2_72_Y);
    
    AND2_158 : AND2
      port map(A => \SumA[14]\, B => \SumB[14]\, Y => AND2_158_Y);
    
    MAJ3_17 : MAJ3
      port map(A => \PP6[6]\, B => \PP5[8]\, C => \PP4[10]\, Y
         => MAJ3_17_Y);
    
    XOR2_58 : XOR2
      port map(A => DFN1_72_Q, B => DFN1_32_Q, Y => XOR2_58_Y);
    
    \XOR2_Mult[13]\ : XOR2
      port map(A => XOR2_57_Y, B => AO1_14_Y, Y => Mult(13));
    
    \XOR2_Mult[2]\ : XOR2
      port map(A => XOR2_64_Y, B => AND2_62_Y, Y => Mult(2));
    
    XOR3_21 : XOR3
      port map(A => \PP3[6]\, B => \PP1[10]\, C => \PP5[2]\, Y
         => XOR3_21_Y);
    
    \XOR2_PP5[4]\ : XOR2
      port map(A => MX2_14_Y, B => BUFF_47_Y, Y => \PP5[4]\);
    
    AND2_49 : AND2
      port map(A => XOR2_65_Y, B => BUFF_27_Y, Y => AND2_49_Y);
    
    AND2_23 : AND2
      port map(A => XOR2_63_Y, B => XOR2_29_Y, Y => AND2_23_Y);
    
    XOR3_7 : XOR3
      port map(A => \PP2[8]\, B => \PP0[12]\, C => \PP4[4]\, Y
         => XOR3_7_Y);
    
    XOR3_18 : XOR3
      port map(A => DFN1_11_Q, B => DFN1_69_Q, C => DFN1_73_Q, Y
         => XOR3_18_Y);
    
    AO1_22 : AO1
      port map(A => XOR2_22_Y, B => AO1_32_Y, C => AND2_114_Y, Y
         => AO1_22_Y);
    
    XOR2_40 : XOR2
      port map(A => AND2_12_Y, B => BUFF_26_Y, Y => XOR2_40_Y);
    
    NOR2_12 : NOR2
      port map(A => XOR2_38_Y, B => XNOR2_11_Y, Y => NOR2_12_Y);
    
    AND2_91 : AND2
      port map(A => XOR2_18_Y, B => BUFF_29_Y, Y => AND2_91_Y);
    
    XOR3_31 : XOR3
      port map(A => DFN1_49_Q, B => DFN1_50_Q, C => DFN1_4_Q, Y
         => XOR3_31_Y);
    
    MAJ3_31 : MAJ3
      port map(A => \PP3[10]\, B => \PP2[12]\, C => \VCC\, Y => 
        MAJ3_31_Y);
    
    BUFF_7 : BUFF
      port map(A => DataA(7), Y => BUFF_7_Y);
    
    \DFN1_SumA[1]\ : DFN1
      port map(D => \PP0[2]\, CLK => Clock, Q => \SumA[1]\);
    
    DFN1_4 : DFN1
      port map(D => MAJ3_19_Y, CLK => Clock, Q => DFN1_4_Q);
    
    AND2_69 : AND2
      port map(A => XOR2_41_Y, B => BUFF_9_Y, Y => AND2_69_Y);
    
    MX2_37 : MX2
      port map(A => AND2_153_Y, B => BUFF_34_Y, S => NOR2_0_Y, Y
         => MX2_37_Y);
    
    MX2_54 : MX2
      port map(A => AND2_8_Y, B => BUFF_14_Y, S => NOR2_8_Y, Y
         => MX2_54_Y);
    
    AND2_55 : AND2
      port map(A => DataB(0), B => BUFF_28_Y, Y => AND2_55_Y);
    
    \XOR2_Mult[10]\ : XOR2
      port map(A => XOR2_34_Y, B => AO1_22_Y, Y => Mult(10));
    
    MX2_23 : MX2
      port map(A => AND2_85_Y, B => BUFF_10_Y, S => NOR2_11_Y, Y
         => MX2_23_Y);
    
    MAJ3_19 : MAJ3
      port map(A => MAJ3_32_Y, B => AND2_146_Y, C => \PP6[0]\, Y
         => MAJ3_19_Y);
    
    \XOR2_PP2[4]\ : XOR2
      port map(A => MX2_35_Y, B => BUFF_32_Y, Y => \PP2[4]\);
    
    MAJ3_18 : MAJ3
      port map(A => DFN1_46_Q, B => DFN1_45_Q, C => DFN1_75_Q, Y
         => MAJ3_18_Y);
    
    MX2_65 : MX2
      port map(A => AND2_98_Y, B => BUFF_33_Y, S => NOR2_2_Y, Y
         => MX2_65_Y);
    
    MX2_1 : MX2
      port map(A => AND2_73_Y, B => BUFF_33_Y, S => NOR2_4_Y, Y
         => MX2_1_Y);
    
    DFN1_73 : DFN1
      port map(D => MAJ3_36_Y, CLK => Clock, Q => DFN1_73_Q);
    
    \XOR2_PP2[11]\ : XOR2
      port map(A => MX2_55_Y, B => BUFF_2_Y, Y => \PP2[11]\);
    
    \MAJ3_SumA[17]\ : MAJ3
      port map(A => XOR3_36_Y, B => MAJ3_18_Y, C => DFN1_47_Q, Y
         => \SumA[17]\);
    
    AND2_96 : AND2
      port map(A => NOR2_1_Y, B => BUFF_42_Y, Y => AND2_96_Y);
    
    XOR2_71 : XOR2
      port map(A => \SumA[7]\, B => \SumB[7]\, Y => XOR2_71_Y);
    
    AND2_146 : AND2
      port map(A => \PP4[3]\, B => \PP3[5]\, Y => AND2_146_Y);
    
    \XOR2_Mult[12]\ : XOR2
      port map(A => XOR2_48_Y, B => AO1_42_Y, Y => Mult(12));
    
    AND2_18 : AND2
      port map(A => DataB(0), B => BUFF_19_Y, Y => AND2_18_Y);
    
    MAJ3_21 : MAJ3
      port map(A => \PP5[9]\, B => \PP4[11]\, C => \E[3]\, Y => 
        MAJ3_21_Y);
    
    BUFF_12 : BUFF
      port map(A => DataB(3), Y => BUFF_12_Y);
    
    AND2_78 : AND2
      port map(A => AND2_109_Y, B => AND2_156_Y, Y => AND2_78_Y);
    
    AO1_30 : AO1
      port map(A => AND2_35_Y, B => AO1_38_Y, C => AO1_45_Y, Y
         => AO1_30_Y);
    
    \MAJ3_SumA[19]\ : MAJ3
      port map(A => XOR3_10_Y, B => MAJ3_24_Y, C => DFN1_53_Q, Y
         => \SumA[19]\);
    
    AND2_138 : AND2
      port map(A => XOR2_12_Y, B => BUFF_46_Y, Y => AND2_138_Y);
    
    XNOR2_4 : XNOR2
      port map(A => DataB(8), B => BUFF_6_Y, Y => XNOR2_4_Y);
    
    \XOR2_PP4[7]\ : XOR2
      port map(A => MX2_54_Y, B => BUFF_31_Y, Y => \PP4[7]\);
    
    AND2_40 : AND2
      port map(A => DFN1_26_Q, B => DFN1_66_Q, Y => AND2_40_Y);
    
    BUFF_33 : BUFF
      port map(A => DataA(1), Y => BUFF_33_Y);
    
    BUFF_31 : BUFF
      port map(A => DataB(9), Y => BUFF_31_Y);
    
    XOR2_24 : XOR2
      port map(A => BUFF_44_Y, B => DataB(8), Y => XOR2_24_Y);
    
    AND2_153 : AND2
      port map(A => XOR2_35_Y, B => BUFF_14_Y, Y => AND2_153_Y);
    
    BUFF_22 : BUFF
      port map(A => DataB(1), Y => BUFF_22_Y);
    
    XOR2_34 : XOR2
      port map(A => \SumA[9]\, B => \SumB[9]\, Y => XOR2_34_Y);
    
    AND2_32 : AND2
      port map(A => AND2_22_Y, B => AND2_141_Y, Y => AND2_32_Y);
    
    \MAJ3_SumA[9]\ : MAJ3
      port map(A => XOR3_18_Y, B => MAJ3_5_Y, C => DFN1_35_Q, Y
         => \SumA[9]\);
    
    AND2_60 : AND2
      port map(A => \SumA[5]\, B => \SumB[5]\, Y => AND2_60_Y);
    
    \XOR2_PP3[0]\ : XOR2
      port map(A => XOR2_33_Y, B => DataB(7), Y => \PP3[0]\);
    
    MX2_0 : MX2
      port map(A => AND2_67_Y, B => BUFF_19_Y, S => AND2A_1_Y, Y
         => MX2_0_Y);
    
    XOR2_43 : XOR2
      port map(A => BUFF_3_Y, B => DataB(10), Y => XOR2_43_Y);
    
    DFN1_47 : DFN1
      port map(D => XOR3_16_Y, CLK => Clock, Q => DFN1_47_Q);
    
    DFN1_46 : DFN1
      port map(D => MAJ3_1_Y, CLK => Clock, Q => DFN1_46_Q);
    
    BUFF_4 : BUFF
      port map(A => DataB(7), Y => BUFF_4_Y);
    
    \XOR3_SumB[19]\ : XOR3
      port map(A => MAJ3_0_Y, B => DFN1_31_Q, C => XOR3_4_Y, Y
         => \SumB[19]\);
    
    XOR2_61 : XOR2
      port map(A => AND2_53_Y, B => BUFF_17_Y, Y => XOR2_61_Y);
    
    XNOR2_2 : XNOR2
      port map(A => DataB(10), B => BUFF_40_Y, Y => XNOR2_2_Y);
    
    XOR2_49 : XOR2
      port map(A => \SumA[5]\, B => \SumB[5]\, Y => XOR2_49_Y);
    
    DFN1_11 : DFN1
      port map(D => XOR2_15_Y, CLK => Clock, Q => DFN1_11_Q);
    
    AND2_85 : AND2
      port map(A => XOR2_37_Y, B => BUFF_16_Y, Y => AND2_85_Y);
    
    AND2_147 : AND2
      port map(A => AND2_109_Y, B => AND2_128_Y, Y => AND2_147_Y);
    
    AO1_35 : AO1
      port map(A => XOR2_47_Y, B => AND2_62_Y, C => AND2_4_Y, Y
         => AO1_35_Y);
    
    AO1_27 : AO1
      port map(A => AND2_47_Y, B => AO1_45_Y, C => AO1_7_Y, Y => 
        AO1_27_Y);
    
    MX2_21 : MX2
      port map(A => AND2_104_Y, B => BUFF_11_Y, S => AND2A_0_Y, Y
         => MX2_21_Y);
    
    AND2_53 : AND2
      port map(A => XOR2_38_Y, B => BUFF_29_Y, Y => AND2_53_Y);
    
    XOR3_22 : XOR3
      port map(A => DFN1_16_Q, B => DFN1_0_Q, C => DFN1_41_Q, Y
         => XOR3_22_Y);
    
    AO1_13 : AO1
      port map(A => AND2_130_Y, B => AO1_52_Y, C => AO1_21_Y, Y
         => AO1_13_Y);
    
    MX2_14 : MX2
      port map(A => AND2_70_Y, B => BUFF_5_Y, S => NOR2_4_Y, Y
         => MX2_14_Y);
    
    AND2_125 : AND2
      port map(A => XOR2_2_Y, B => BUFF_10_Y, Y => AND2_125_Y);
    
    DFN1_49 : DFN1
      port map(D => XOR3_27_Y, CLK => Clock, Q => DFN1_49_Q);
    
    MX2_33 : MX2
      port map(A => AND2_159_Y, B => BUFF_28_Y, S => NOR2_12_Y, Y
         => MX2_33_Y);
    
    XOR3_8 : XOR3
      port map(A => DFN1_45_Q, B => DFN1_75_Q, C => DFN1_46_Q, Y
         => XOR3_8_Y);
    
    XOR3_32 : XOR3
      port map(A => \PP4[2]\, B => \PP3[4]\, C => \PP5[0]\, Y => 
        XOR3_32_Y);
    
    \INV_E[0]\ : INV
      port map(A => DataB(1), Y => \E[0]\);
    
    MAJ3_37 : MAJ3
      port map(A => DFN1_61_Q, B => DFN1_12_Q, C => DFN1_36_Q, Y
         => MAJ3_37_Y);
    
    \XOR2_Mult[3]\ : XOR2
      port map(A => XOR2_4_Y, B => AO1_35_Y, Y => Mult(3));
    
    MX2_28 : MX2
      port map(A => AND2_51_Y, B => BUFF_27_Y, S => NOR2_12_Y, Y
         => MX2_28_Y);
    
    AND2_99 : AND2
      port map(A => XOR2_51_Y, B => BUFF_43_Y, Y => AND2_99_Y);
    
    \XOR2_PP5[1]\ : XOR2
      port map(A => MX2_63_Y, B => BUFF_47_Y, Y => \PP5[1]\);
    
    XOR2_47 : XOR2
      port map(A => \SumA[1]\, B => \SumB[1]\, Y => XOR2_47_Y);
    
    \XOR3_SumB[4]\ : XOR3
      port map(A => DFN1_22_Q, B => DFN1_71_Q, C => XOR2_58_Y, Y
         => \SumB[4]\);
    
    \MAJ3_SumA[14]\ : MAJ3
      port map(A => XOR3_22_Y, B => MAJ3_2_Y, C => DFN1_10_Q, Y
         => \SumA[14]\);
    
    \XOR2_PP4[10]\ : XOR2
      port map(A => MX2_31_Y, B => BUFF_6_Y, Y => \PP4[10]\);
    
    AO1_28 : AO1
      port map(A => AND2_59_Y, B => AO1_52_Y, C => AO1_46_Y, Y
         => AO1_28_Y);
    
    XOR2_9 : XOR2
      port map(A => \PP1[5]\, B => \PP0[7]\, Y => XOR2_9_Y);
    
    \XOR2_PP3[11]\ : XOR2
      port map(A => MX2_42_Y, B => BUFF_36_Y, Y => \PP3[11]\);
    
    AO1_12 : AO1
      port map(A => XOR2_28_Y, B => AO1_50_Y, C => AND2_152_Y, Y
         => AO1_12_Y);
    
    AND2_120 : AND2
      port map(A => AND2_154_Y, B => XOR2_22_Y, Y => AND2_120_Y);
    
    XOR2_25 : XOR2
      port map(A => DFN1_26_Q, B => DFN1_66_Q, Y => XOR2_25_Y);
    
    \XOR2_Mult[17]\ : XOR2
      port map(A => XOR2_7_Y, B => AO1_31_Y, Y => Mult(17));
    
    XOR2_35 : XOR2
      port map(A => BUFF_3_Y, B => DataB(10), Y => XOR2_35_Y);
    
    \XOR2_SumB[2]\ : XOR2
      port map(A => DFN1_9_Q, B => DFN1_64_Q, Y => \SumB[2]\);
    
    \INV_E[4]\ : INV
      port map(A => DataB(9), Y => \E[4]\);
    
    XOR3_26 : XOR3
      port map(A => \PP5[8]\, B => \PP4[10]\, C => \PP6[6]\, Y
         => XOR3_26_Y);
    
    \XOR2_PP4[0]\ : XOR2
      port map(A => XOR2_0_Y, B => DataB(9), Y => \PP4[0]\);
    
    \XOR2_PP1[1]\ : XOR2
      port map(A => MX2_27_Y, B => BUFF_17_Y, Y => \PP1[1]\);
    
    MX2_50 : MX2
      port map(A => AND2_61_Y, B => BUFF_8_Y, S => AND2A_2_Y, Y
         => MX2_50_Y);
    
    MX2_7 : MX2
      port map(A => AND2_24_Y, B => BUFF_9_Y, S => NOR2_2_Y, Y
         => MX2_7_Y);
    
    AND2_17 : AND2
      port map(A => AND2_103_Y, B => AND2_108_Y, Y => AND2_17_Y);
    
    XOR3_36 : XOR3
      port map(A => DFN1_7_Q, B => DFN1_23_Q, C => DFN1_29_Q, Y
         => XOR3_36_Y);
    
    AND2_114 : AND2
      port map(A => \SumA[8]\, B => \SumB[8]\, Y => AND2_114_Y);
    
    AND2_77 : AND2
      port map(A => XOR2_39_Y, B => BUFF_43_Y, Y => AND2_77_Y);
    
    \MAJ3_SumA[7]\ : MAJ3
      port map(A => XOR3_5_Y, B => MAJ3_37_Y, C => DFN1_57_Q, Y
         => \SumA[7]\);
    
    AO1_3 : AO1
      port map(A => XOR2_36_Y, B => AND2_33_Y, C => AND2_116_Y, Y
         => AO1_3_Y);
    
    BUFF_16 : BUFF
      port map(A => DataA(11), Y => BUFF_16_Y);
    
    AND2_133 : AND2
      port map(A => AND2_0_Y, B => AND2_32_Y, Y => AND2_133_Y);
    
    NOR2_2 : NOR2
      port map(A => XOR2_41_Y, B => XNOR2_13_Y, Y => NOR2_2_Y);
    
    AND2_38 : AND2
      port map(A => AND2_103_Y, B => XOR2_56_Y, Y => AND2_38_Y);
    
    \XOR3_SumB[20]\ : XOR3
      port map(A => MAJ3_28_Y, B => DFN1_77_Q, C => XOR3_15_Y, Y
         => \SumB[20]\);
    
    MX2_6 : MX2
      port map(A => AND2_110_Y, B => BUFF_46_Y, S => AND2A_2_Y, Y
         => MX2_6_Y);
    
    NOR2_3 : NOR2
      port map(A => XOR2_18_Y, B => XNOR2_0_Y, Y => NOR2_3_Y);
    
    XOR2_72 : XOR2
      port map(A => \PP4[12]\, B => \VCC\, Y => XOR2_72_Y);
    
    AND2_129 : AND2
      port map(A => XOR2_24_Y, B => BUFF_18_Y, Y => AND2_129_Y);
    
    DFN1_30 : DFN1
      port map(D => XOR3_19_Y, CLK => Clock, Q => DFN1_30_Q);
    
    MAJ3_27 : MAJ3
      port map(A => \PP4[5]\, B => \PP2[9]\, C => DataB(1), Y => 
        MAJ3_27_Y);
    
    MAJ3_39 : MAJ3
      port map(A => \PP5[5]\, B => \PP3[9]\, C => \E[1]\, Y => 
        MAJ3_39_Y);
    
    MAJ3_38 : MAJ3
      port map(A => \PP4[6]\, B => \PP2[10]\, C => DataB(1), Y
         => MAJ3_38_Y);
    
    AO1_0 : AO1
      port map(A => XOR2_29_Y, B => AND2_118_Y, C => AND2_79_Y, Y
         => AO1_0_Y);
    
    \XOR2_PP0[12]\ : XOR2
      port map(A => AND2_122_Y, B => BUFF_0_Y, Y => \PP0[12]\);
    
    AND2_111 : AND2
      port map(A => DFN1_72_Q, B => DFN1_32_Q, Y => AND2_111_Y);
    
    DFN1_44 : DFN1
      port map(D => AND2_107_Y, CLK => Clock, Q => DFN1_44_Q);
    
    BUFF_26 : BUFF
      port map(A => DataB(1), Y => BUFF_26_Y);
    
    \XOR2_PP0[0]\ : XOR2
      port map(A => XOR2_40_Y, B => DataB(1), Y => \PP0[0]\);
    
    AND2_83 : AND2
      port map(A => \SumA[7]\, B => \SumB[7]\, Y => AND2_83_Y);
    
    MX2_42 : MX2
      port map(A => AND2_90_Y, B => BUFF_43_Y, S => NOR2_14_Y, Y
         => MX2_42_Y);
    
    AND2_11 : AND2
      port map(A => \SumA[2]\, B => \SumB[2]\, Y => AND2_11_Y);
    
    XOR2_18 : XOR2
      port map(A => BUFF_21_Y, B => DataB(6), Y => XOR2_18_Y);
    
    AND2_90 : AND2
      port map(A => XOR2_39_Y, B => BUFF_42_Y, Y => AND2_90_Y);
    
    \MAJ3_SumA[10]\ : MAJ3
      port map(A => XOR3_13_Y, B => MAJ3_20_Y, C => DFN1_1_Q, Y
         => \SumA[10]\);
    
    \XOR2_PP5[12]\ : XOR2
      port map(A => AND2_160_Y, B => BUFF_20_Y, Y => \PP5[12]\);
    
    AND2_71 : AND2
      port map(A => DataB(0), B => BUFF_42_Y, Y => AND2_71_Y);
    
    BUFF_37 : BUFF
      port map(A => DataA(9), Y => BUFF_37_Y);
    
    XOR2_20 : XOR2
      port map(A => \SumA[21]\, B => \SumB[21]\, Y => XOR2_20_Y);
    
    MX2_31 : MX2
      port map(A => AND2_125_Y, B => BUFF_37_Y, S => NOR2_9_Y, Y
         => MX2_31_Y);
    
    XOR2_30 : XOR2
      port map(A => \PP4[3]\, B => \PP3[5]\, Y => XOR2_30_Y);
    
    MX2_56 : MX2
      port map(A => AND2_115_Y, B => BUFF_10_Y, S => NOR2_9_Y, Y
         => MX2_56_Y);
    
    MX2_38 : MX2
      port map(A => AND2_56_Y, B => BUFF_1_Y, S => NOR2_8_Y, Y
         => MX2_38_Y);
    
    \AND2_S[3]\ : AND2
      port map(A => XOR2_33_Y, B => DataB(7), Y => \S[3]\);
    
    \MAJ3_SumA[12]\ : MAJ3
      port map(A => XOR3_33_Y, B => MAJ3_22_Y, C => DFN1_21_Q, Y
         => \SumA[12]\);
    
    XOR2_62 : XOR2
      port map(A => \SumA[22]\, B => \SumB[22]\, Y => XOR2_62_Y);
    
    AND2_161 : AND2
      port map(A => XOR2_18_Y, B => BUFF_28_Y, Y => AND2_161_Y);
    
    DFN1_3 : DFN1
      port map(D => MAJ3_15_Y, CLK => Clock, Q => DFN1_3_Q);
    
    AND2_4 : AND2
      port map(A => \SumA[1]\, B => \SumB[1]\, Y => AND2_4_Y);
    
    XOR3_2 : XOR3
      port map(A => \S[5]\, B => \PP5[1]\, C => XOR2_30_Y, Y => 
        XOR3_2_Y);
    
    MAJ3_29 : MAJ3
      port map(A => MAJ3_39_Y, B => XOR2_1_Y, C => \PP6[4]\, Y
         => MAJ3_29_Y);
    
    MAJ3_28 : MAJ3
      port map(A => DFN1_15_Q, B => DFN1_33_Q, C => DFN1_59_Q, Y
         => MAJ3_28_Y);
    
    DFN1_61 : DFN1
      port map(D => \PP2[2]\, CLK => Clock, Q => DFN1_61_Q);
    
    AND2_0 : AND2
      port map(A => AND2_58_Y, B => AND2_42_Y, Y => AND2_0_Y);
    
    AND2_156 : AND2
      port map(A => AND2_41_Y, B => AND2_68_Y, Y => AND2_156_Y);
    
    AO1_34 : AO1
      port map(A => XOR2_73_Y, B => AND2_152_Y, C => AND2_101_Y, 
        Y => AO1_34_Y);
    
    XOR3_3 : XOR3
      port map(A => \PP1[6]\, B => \PP0[8]\, C => \PP2[4]\, Y => 
        XOR3_3_Y);
    
    AO1_43 : AO1
      port map(A => AND2_32_Y, B => AO1_31_Y, C => AO1_40_Y, Y
         => AO1_43_Y);
    
    DFN1_51 : DFN1
      port map(D => XOR3_6_Y, CLK => Clock, Q => DFN1_51_Q);
    
    AND2_16 : AND2
      port map(A => XOR2_68_Y, B => BUFF_15_Y, Y => AND2_16_Y);
    
    MX2_64 : MX2
      port map(A => AND2_3_Y, B => BUFF_29_Y, S => NOR2_3_Y, Y
         => MX2_64_Y);
    
    DFN1_8 : DFN1
      port map(D => XOR3_3_Y, CLK => Clock, Q => DFN1_8_Q);
    
    AND2_76 : AND2
      port map(A => XOR2_18_Y, B => BUFF_27_Y, Y => AND2_76_Y);
    
    MX2_10 : MX2
      port map(A => AND2_52_Y, B => BUFF_45_Y, S => NOR2_0_Y, Y
         => MX2_10_Y);
    
    AND2_6 : AND2
      port map(A => \SumA[3]\, B => \SumB[3]\, Y => AND2_6_Y);
    
    AO1_17 : AO1
      port map(A => AND2_37_Y, B => AO1_24_Y, C => AO1_26_Y, Y
         => AO1_17_Y);
    
    XNOR2_0 : XNOR2
      port map(A => DataB(6), B => BUFF_13_Y, Y => XNOR2_0_Y);
    
    BUFF_44 : BUFF
      port map(A => DataB(7), Y => BUFF_44_Y);
    
    MX2_49 : MX2
      port map(A => AND2_18_Y, B => BUFF_29_Y, S => AND2A_1_Y, Y
         => MX2_49_Y);
    
    XOR2_66 : XOR2
      port map(A => \SumA[2]\, B => \SumB[2]\, Y => XOR2_66_Y);
    
    \XOR2_PP0[5]\ : XOR2
      port map(A => MX2_12_Y, B => BUFF_22_Y, Y => \PP0[5]\);
    
    AO1_42 : AO1
      port map(A => AND2_82_Y, B => AO1_1_Y, C => AO1_12_Y, Y => 
        AO1_42_Y);
    
    AND2_37 : AND2
      port map(A => AND2_32_Y, B => XOR2_53_Y, Y => AND2_37_Y);
    
    AO1_18 : AO1
      port map(A => XOR2_20_Y, B => AND2_2_Y, C => AND2_119_Y, Y
         => AO1_18_Y);
    
    AO1_39 : AO1
      port map(A => XOR2_56_Y, B => AO1_38_Y, C => AND2_105_Y, Y
         => AO1_39_Y);
    
    DFN1_25 : DFN1
      port map(D => \PP6[10]\, CLK => Clock, Q => DFN1_25_Q);
    
    XOR2_41 : XOR2
      port map(A => BUFF_44_Y, B => DataB(8), Y => XOR2_41_Y);
    
    \XOR2_PP2[8]\ : XOR2
      port map(A => MX2_15_Y, B => BUFF_30_Y, Y => \PP2[8]\);
    
    AO1_21 : AO1
      port map(A => AND2_57_Y, B => AO1_0_Y, C => AO1_10_Y, Y => 
        AO1_21_Y);
    
    XOR2_7 : XOR2
      port map(A => \SumA[16]\, B => \SumB[16]\, Y => XOR2_7_Y);
    
    BUFF_6 : BUFF
      port map(A => DataB(9), Y => BUFF_6_Y);
    
    XOR2_54 : XOR2
      port map(A => \SumA[16]\, B => \SumB[16]\, Y => XOR2_54_Y);
    
    MAJ3_1 : MAJ3
      port map(A => MAJ3_38_Y, B => MAJ3_9_Y, C => \PP6[3]\, Y
         => MAJ3_1_Y);
    
    AND2_157 : AND2
      port map(A => XOR2_41_Y, B => BUFF_5_Y, Y => AND2_157_Y);
    
    AND2_44 : AND2
      port map(A => AND2_36_Y, B => XOR2_11_Y, Y => AND2_44_Y);
    
    XOR3_14 : XOR3
      port map(A => \PP2[12]\, B => \VCC\, C => \PP3[10]\, Y => 
        XOR3_14_Y);
    
    XOR2_23 : XOR2
      port map(A => AND2_14_Y, B => BUFF_32_Y, Y => XOR2_23_Y);
    
    \XOR2_PP5[2]\ : XOR2
      port map(A => MX2_1_Y, B => BUFF_47_Y, Y => \PP5[2]\);
    
    DFN1_37 : DFN1
      port map(D => \PP5[11]\, CLK => Clock, Q => DFN1_37_Q);
    
    XOR2_33 : XOR2
      port map(A => AND2_91_Y, B => BUFF_13_Y, Y => XOR2_33_Y);
    
    AND2_31 : AND2
      port map(A => AND2_112_Y, B => AND2_59_Y, Y => AND2_31_Y);
    
    DFN1_36 : DFN1
      port map(D => \PP0[6]\, CLK => Clock, Q => DFN1_36_Q);
    
    MX2_16 : MX2
      port map(A => AND2_99_Y, B => BUFF_11_Y, S => NOR2_5_Y, Y
         => MX2_16_Y);
    
    AND2_122 : AND2
      port map(A => AND2A_0_Y, B => BUFF_42_Y, Y => AND2_122_Y);
    
    XOR2_29 : XOR2
      port map(A => \SumA[13]\, B => \SumB[13]\, Y => XOR2_29_Y);
    
    AND2_64 : AND2
      port map(A => AND2_32_Y, B => AND2_36_Y, Y => AND2_64_Y);
    
    BUFF_39 : BUFF
      port map(A => DataB(3), Y => BUFF_39_Y);
    
    XOR2_39 : XOR2
      port map(A => BUFF_21_Y, B => DataB(6), Y => XOR2_39_Y);
    
    \XOR2_PP0[9]\ : XOR2
      port map(A => MX2_9_Y, B => BUFF_0_Y, Y => \PP0[9]\);
    
    \XOR2_PP3[5]\ : XOR2
      port map(A => MX2_30_Y, B => BUFF_4_Y, Y => \PP3[5]\);
    
    AND2_136 : AND2
      port map(A => XOR2_8_Y, B => BUFF_15_Y, Y => AND2_136_Y);
    
    \AND2_PP6[8]\ : AND2
      port map(A => BUFF_23_Y, B => BUFF_18_Y, Y => \PP6[8]\);
    
    \XOR2_PP2[6]\ : XOR2
      port map(A => MX2_59_Y, B => BUFF_30_Y, Y => \PP2[6]\);
    
    AND2_19 : AND2
      port map(A => AND2_112_Y, B => AND2_23_Y, Y => AND2_19_Y);
    
    AND2_79 : AND2
      port map(A => \SumA[13]\, B => \SumB[13]\, Y => AND2_79_Y);
    
    DFN1_39 : DFN1
      port map(D => \PP4[0]\, CLK => Clock, Q => DFN1_39_Q);
    
    MX2_57 : MX2
      port map(A => AND2_113_Y, B => BUFF_46_Y, S => NOR2_6_Y, Y
         => MX2_57_Y);
    
    DFN1_71 : DFN1
      port map(D => \PP2[1]\, CLK => Clock, Q => DFN1_71_Q);
    
    XOR2_27 : XOR2
      port map(A => \SumA[15]\, B => \SumB[15]\, Y => XOR2_27_Y);
    
    MX2_8 : MX2
      port map(A => AND2_75_Y, B => BUFF_11_Y, S => NOR2_1_Y, Y
         => MX2_8_Y);
    
    XOR2_6 : XOR2
      port map(A => \SumA[5]\, B => \SumB[5]\, Y => XOR2_6_Y);
    
    XOR2_37 : XOR2
      port map(A => BUFF_3_Y, B => DataB(10), Y => XOR2_37_Y);
    
    \DFN1_SumB[0]\ : DFN1
      port map(D => \S[0]\, CLK => Clock, Q => \SumB[0]\);
    
    BUFF_13 : BUFF
      port map(A => DataB(7), Y => BUFF_13_Y);
    
    BUFF_11 : BUFF
      port map(A => DataA(9), Y => BUFF_11_Y);
    
    AND2_115 : AND2
      port map(A => XOR2_2_Y, B => BUFF_16_Y, Y => AND2_115_Y);
    
    BUFF_45 : BUFF
      port map(A => DataA(7), Y => BUFF_45_Y);
    
    BUFF_40 : BUFF
      port map(A => DataB(11), Y => BUFF_40_Y);
    
    XOR2_55 : XOR2
      port map(A => AND2_95_Y, B => BUFF_47_Y, Y => XOR2_55_Y);
    
    \XOR2_Mult[15]\ : XOR2
      port map(A => XOR2_69_Y, B => AO1_33_Y, Y => Mult(15));
    
    AND2A_2 : AND2A
      port map(A => DataB(0), B => BUFF_22_Y, Y => AND2A_2_Y);
    
    AND2_104 : AND2
      port map(A => DataB(0), B => BUFF_43_Y, Y => AND2_104_Y);
    
    AND2_36 : AND2
      port map(A => XOR2_53_Y, B => XOR2_20_Y, Y => AND2_36_Y);
    
    AND2_9 : AND2
      port map(A => AND2_0_Y, B => AND2_21_Y, Y => AND2_9_Y);
    
    AND2A_1 : AND2A
      port map(A => DataB(0), B => BUFF_26_Y, Y => AND2A_1_Y);
    
    XOR3_15 : XOR3
      port map(A => DFN1_37_Q, B => DFN1_68_Q, C => DFN1_6_Q, Y
         => XOR3_15_Y);
    
    AND2_110 : AND2
      port map(A => DataB(0), B => BUFF_8_Y, Y => AND2_110_Y);
    
    \XOR3_SumB[13]\ : XOR3
      port map(A => MAJ3_2_Y, B => DFN1_10_Q, C => XOR3_22_Y, Y
         => \SumB[13]\);
    
    BUFF_23 : BUFF
      port map(A => DataB(11), Y => BUFF_23_Y);
    
    \XOR2_PP4[3]\ : XOR2
      port map(A => MX2_46_Y, B => BUFF_35_Y, Y => \PP4[3]\);
    
    BUFF_21 : BUFF
      port map(A => DataB(5), Y => BUFF_21_Y);
    
    NOR2_5 : NOR2
      port map(A => XOR2_51_Y, B => XNOR2_5_Y, Y => NOR2_5_Y);
    
    MX2_60 : MX2
      port map(A => AND2_49_Y, B => BUFF_19_Y, S => NOR2_13_Y, Y
         => MX2_60_Y);
    
    AND2_101 : AND2
      port map(A => \SumA[11]\, B => \SumB[11]\, Y => AND2_101_Y);
    
    AO1_47 : AO1
      port map(A => XOR2_31_Y, B => AND2_50_Y, C => AND2_7_Y, Y
         => AO1_47_Y);
    
    AND2_137 : AND2
      port map(A => XOR2_43_Y, B => BUFF_5_Y, Y => AND2_137_Y);
    
    DFN1_34 : DFN1
      port map(D => XOR3_12_Y, CLK => Clock, Q => DFN1_34_Q);
    
    \XOR3_SumB[17]\ : XOR3
      port map(A => MAJ3_10_Y, B => DFN1_18_Q, C => XOR3_34_Y, Y
         => \SumB[17]\);
    
    AND2_10 : AND2
      port map(A => AND2_58_Y, B => AND2_31_Y, Y => AND2_10_Y);
    
    \XOR2_PP1[2]\ : XOR2
      port map(A => MX2_20_Y, B => BUFF_17_Y, Y => \PP1[2]\);
    
    AND2_119 : AND2
      port map(A => \SumA[21]\, B => \SumB[21]\, Y => AND2_119_Y);
    
    AND2_70 : AND2
      port map(A => XOR2_43_Y, B => BUFF_1_Y, Y => AND2_70_Y);
    
    \XOR2_PP1[10]\ : XOR2
      port map(A => MX2_8_Y, B => BUFF_39_Y, Y => \PP1[10]\);
    
    DFN1_22 : DFN1
      port map(D => \S[2]\, CLK => Clock, Q => DFN1_22_Q);
    
    MAJ3_16 : MAJ3
      port map(A => \PP2[6]\, B => \PP1[8]\, C => \PP0[10]\, Y
         => MAJ3_16_Y);
    
    AO1_48 : AO1
      port map(A => AND2_21_Y, B => AO1_31_Y, C => AO1_6_Y, Y => 
        AO1_48_Y);
    
    XNOR2_7 : XNOR2
      port map(A => DataB(2), B => BUFF_39_Y, Y => XNOR2_7_Y);
    
    XOR2_42 : XOR2
      port map(A => \SumA[19]\, B => \SumB[19]\, Y => XOR2_42_Y);
    
    DFN1_10 : DFN1
      port map(D => XOR3_35_Y, CLK => Clock, Q => DFN1_10_Q);
    
    AO1_36 : AO1
      port map(A => XOR2_45_Y, B => AO1_45_Y, C => AND2_93_Y, Y
         => AO1_36_Y);
    
    \XOR2_PP5[9]\ : XOR2
      port map(A => MX2_52_Y, B => BUFF_20_Y, Y => \PP5[9]\);
    
    \XOR2_Mult[21]\ : XOR2
      port map(A => XOR2_3_Y, B => AO1_43_Y, Y => Mult(21));
    
    AND2_160 : AND2
      port map(A => NOR2_11_Y, B => BUFF_16_Y, Y => AND2_160_Y);
    
    \INV_E[5]\ : INV
      port map(A => DataB(11), Y => \E[5]\);
    
    XOR2_50 : XOR2
      port map(A => \SumA[4]\, B => \SumB[4]\, Y => XOR2_50_Y);
    
    XOR2_0 : XOR2
      port map(A => AND2_69_Y, B => BUFF_35_Y, Y => XOR2_0_Y);
    
    AO1_11 : AO1
      port map(A => XOR2_63_Y, B => AO1_29_Y, C => AND2_118_Y, Y
         => AO1_11_Y);
    
    AND2_94 : AND2
      port map(A => XOR2_68_Y, B => BUFF_7_Y, Y => AND2_94_Y);
    
    MX2_17 : MX2
      port map(A => AND2_161_Y, B => BUFF_27_Y, S => NOR2_3_Y, Y
         => MX2_17_Y);
    
    XOR3_10 : XOR3
      port map(A => DFN1_13_Q, B => DFN1_76_Q, C => DFN1_2_Q, Y
         => XOR3_10_Y);
    
    AND2_22 : AND2
      port map(A => XOR2_54_Y, B => XOR2_31_Y, Y => AND2_22_Y);
    
    MAJ3_3 : MAJ3
      port map(A => \PP5[2]\, B => \PP3[6]\, C => \PP1[10]\, Y
         => MAJ3_3_Y);
    
    MX2_53 : MX2
      port map(A => AND2_74_Y, B => BUFF_5_Y, S => NOR2_2_Y, Y
         => MX2_53_Y);
    
    AND2_39 : AND2
      port map(A => AND2_58_Y, B => AND2_42_Y, Y => AND2_39_Y);
    
    \XOR2_PP0[1]\ : XOR2
      port map(A => MX2_49_Y, B => BUFF_26_Y, Y => \PP0[1]\);
    
    \XOR2_PP4[1]\ : XOR2
      port map(A => MX2_7_Y, B => BUFF_35_Y, Y => \PP4[1]\);
    
    \XOR2_PP5[3]\ : XOR2
      port map(A => MX2_58_Y, B => BUFF_47_Y, Y => \PP5[3]\);
    
    XOR2_46 : XOR2
      port map(A => \SumA[18]\, B => \SumB[18]\, Y => XOR2_46_Y);
    
    MX2_45 : MX2
      port map(A => AND2_131_Y, B => BUFF_7_Y, S => NOR2_10_Y, Y
         => MX2_45_Y);
    
    DFN1_28 : DFN1
      port map(D => MAJ3_6_Y, CLK => Clock, Q => DFN1_28_Q);
    
    DFN1_1 : DFN1
      port map(D => XOR3_32_Y, CLK => Clock, Q => DFN1_1_Q);
    
    \XOR2_Mult[6]\ : XOR2
      port map(A => XOR2_6_Y, B => AO1_39_Y, Y => Mult(6));
    
    BUFF_17 : BUFF
      port map(A => DataB(3), Y => BUFF_17_Y);
    
    AND2_45 : AND2
      port map(A => XOR2_12_Y, B => BUFF_7_Y, Y => AND2_45_Y);
    
    MAJ3_2 : MAJ3
      port map(A => DFN1_4_Q, B => DFN1_49_Q, C => DFN1_50_Q, Y
         => MAJ3_2_Y);
    
    \XOR2_Mult[16]\ : XOR2
      port map(A => XOR2_27_Y, B => AO1_16_Y, Y => Mult(16));
    
    XOR2_21 : XOR2
      port map(A => \SumA[8]\, B => \SumB[8]\, Y => XOR2_21_Y);
    
    \AND2_PP6[9]\ : AND2
      port map(A => BUFF_23_Y, B => BUFF_37_Y, Y => \PP6[9]\);
    
    DFN1_45 : DFN1
      port map(D => XOR3_14_Y, CLK => Clock, Q => DFN1_45_Q);
    
    \XOR2_PP0[2]\ : XOR2
      port map(A => MX2_0_Y, B => BUFF_26_Y, Y => \PP0[2]\);
    
    XOR2_31 : XOR2
      port map(A => \SumA[17]\, B => \SumB[17]\, Y => XOR2_31_Y);
    
    AND2_128 : AND2
      port map(A => AND2_156_Y, B => XOR2_63_Y, Y => AND2_128_Y);
    
    \XOR2_PP0[11]\ : XOR2
      port map(A => MX2_24_Y, B => BUFF_0_Y, Y => \PP0[11]\);
    
    AND2_65 : AND2
      port map(A => AND2_103_Y, B => AND2_35_Y, Y => AND2_65_Y);
    
    XOR2_14 : XOR2
      port map(A => \PP3[12]\, B => \VCC\, Y => XOR2_14_Y);
    
    \DFN1_SumA[2]\ : DFN1
      port map(D => \S[1]\, CLK => Clock, Q => \SumA[2]\);
    
    BUFF_27 : BUFF
      port map(A => DataA(2), Y => BUFF_27_Y);
    
    BUFF_3 : BUFF
      port map(A => DataB(9), Y => BUFF_3_Y);
    
    AND2_30 : AND2
      port map(A => XOR2_38_Y, B => BUFF_27_Y, Y => AND2_30_Y);
    
    MX2_22 : MX2
      port map(A => AND2_87_Y, B => BUFF_14_Y, S => NOR2_0_Y, Y
         => MX2_22_Y);
    
    MAJ3_7 : MAJ3
      port map(A => \PP4[1]\, B => \PP3[3]\, C => \PP2[5]\, Y => 
        MAJ3_7_Y);
    
    BUFF_38 : BUFF
      port map(A => DataA(4), Y => BUFF_38_Y);
    
    AND2_28 : AND2
      port map(A => \SumA[15]\, B => \SumB[15]\, Y => AND2_28_Y);
    
    MAJ3_15 : MAJ3
      port map(A => XOR2_30_Y, B => \S[5]\, C => \PP5[1]\, Y => 
        MAJ3_15_Y);
    
    DFN1_23 : DFN1
      port map(D => MAJ3_31_Y, CLK => Clock, Q => DFN1_23_Q);
    
    XOR2_53 : XOR2
      port map(A => \SumA[20]\, B => \SumB[20]\, Y => XOR2_53_Y);
    
    MX2_51 : MX2
      port map(A => AND2_94_Y, B => BUFF_8_Y, S => NOR2_6_Y, Y
         => MX2_51_Y);
    
    XOR2_4 : XOR2
      port map(A => \SumA[2]\, B => \SumB[2]\, Y => XOR2_4_Y);
    
    \XOR2_PP5[11]\ : XOR2
      port map(A => MX2_23_Y, B => BUFF_20_Y, Y => \PP5[11]\);
    
    XOR2_59 : XOR2
      port map(A => \SumA[6]\, B => \SumB[6]\, Y => XOR2_59_Y);
    
    XNOR2_13 : XNOR2
      port map(A => DataB(8), B => BUFF_35_Y, Y => XNOR2_13_Y);
    
    XOR3_13 : XOR3
      port map(A => DFN1_30_Q, B => DFN1_56_Q, C => DFN1_24_Q, Y
         => XOR3_13_Y);
    
    \XOR2_PP1[9]\ : XOR2
      port map(A => MX2_3_Y, B => BUFF_39_Y, Y => \PP1[9]\);
    
    MX2_13 : MX2
      port map(A => AND2_139_Y, B => BUFF_46_Y, S => NOR2_10_Y, Y
         => MX2_13_Y);
    
    DFN1_60 : DFN1
      port map(D => XOR3_11_Y, CLK => Clock, Q => DFN1_60_Q);
    
    AO1_7 : AO1
      port map(A => XOR2_32_Y, B => AND2_93_Y, C => AND2_83_Y, Y
         => AO1_7_Y);
    
    MX2_58 : MX2
      port map(A => AND2_137_Y, B => BUFF_25_Y, S => NOR2_4_Y, Y
         => MX2_58_Y);
    
    XOR3_19 : XOR3
      port map(A => \PP1[8]\, B => \PP0[10]\, C => \PP2[6]\, Y
         => XOR3_19_Y);
    
    \XOR2_PP5[6]\ : XOR2
      port map(A => MX2_37_Y, B => BUFF_40_Y, Y => \PP5[6]\);
    
    AND2_112 : AND2
      port map(A => AND2_41_Y, B => AND2_68_Y, Y => AND2_112_Y);
    
    DFN1_17 : DFN1
      port map(D => \PP3[0]\, CLK => Clock, Q => DFN1_17_Q);
    
    DFN1_16 : DFN1
      port map(D => XOR3_30_Y, CLK => Clock, Q => DFN1_16_Q);
    
    DFN1_50 : DFN1
      port map(D => XOR3_23_Y, CLK => Clock, Q => DFN1_50_Q);
    
    \XOR3_SumB[18]\ : XOR3
      port map(A => MAJ3_24_Y, B => DFN1_53_Q, C => XOR3_10_Y, Y
         => \SumB[18]\);
    
    AND2_105 : AND2
      port map(A => \SumA[4]\, B => \SumB[4]\, Y => AND2_105_Y);
    
    AND2_52 : AND2
      port map(A => XOR2_35_Y, B => BUFF_18_Y, Y => AND2_52_Y);
    
    AO1_52 : AO1
      port map(A => AND2_68_Y, B => AO1_50_Y, C => AO1_34_Y, Y
         => AO1_52_Y);
    
    MAJ3_36 : MAJ3
      port map(A => \PP2[4]\, B => \PP1[6]\, C => \PP0[8]\, Y => 
        MAJ3_36_Y);
    
    \AND2_PP6[6]\ : AND2
      port map(A => BUFF_23_Y, B => BUFF_14_Y, Y => \PP6[6]\);
    
    XOR2_57 : XOR2
      port map(A => \SumA[12]\, B => \SumB[12]\, Y => XOR2_57_Y);
    
    AO1_41 : AO1
      port map(A => XOR2_60_Y, B => AND2_11_Y, C => AND2_6_Y, Y
         => AO1_41_Y);
    
    AND2_1 : AND2
      port map(A => XOR2_51_Y, B => BUFF_11_Y, Y => AND2_1_Y);
    
    \XOR2_PP4[12]\ : XOR2
      port map(A => AND2_43_Y, B => BUFF_6_Y, Y => \PP4[12]\);
    
    AND2_7 : AND2
      port map(A => \SumA[17]\, B => \SumB[17]\, Y => AND2_7_Y);
    
    MAJ3_13 : MAJ3
      port map(A => \PP5[0]\, B => \PP4[2]\, C => \PP3[4]\, Y => 
        MAJ3_13_Y);
    
    XOR3_17 : XOR3
      port map(A => DFN1_12_Q, B => DFN1_36_Q, C => DFN1_61_Q, Y
         => XOR3_17_Y);
    
    \XOR2_PP3[1]\ : XOR2
      port map(A => MX2_64_Y, B => BUFF_13_Y, Y => \PP3[1]\);
    
    \XOR2_PP0[6]\ : XOR2
      port map(A => MX2_6_Y, B => BUFF_22_Y, Y => \PP0[6]\);
    
    AND2_100 : AND2
      port map(A => XOR2_37_Y, B => BUFF_10_Y, Y => AND2_100_Y);
    
    DFN1_19 : DFN1
      port map(D => XOR3_2_Y, CLK => Clock, Q => DFN1_19_Q);
    
    XOR2_15 : XOR2
      port map(A => \PP1[7]\, B => \PP0[9]\, Y => XOR2_15_Y);
    
    AND2_43 : AND2
      port map(A => NOR2_9_Y, B => BUFF_16_Y, Y => AND2_43_Y);
    
    MAJ3_6 : MAJ3
      port map(A => AND2_66_Y, B => \PP6[5]\, C => \PP5[7]\, Y
         => MAJ3_6_Y);
    
    BUFF_5 : BUFF
      port map(A => DataA(3), Y => BUFF_5_Y);
    
    \MAJ3_SumA[21]\ : MAJ3
      port map(A => XOR3_15_Y, B => MAJ3_28_Y, C => DFN1_77_Q, Y
         => \SumA[21]\);
    
    MX2_29 : MX2
      port map(A => AND2_138_Y, B => BUFF_38_Y, S => NOR2_10_Y, Y
         => MX2_29_Y);
    
    MAJ3_5 : MAJ3
      port map(A => DFN1_44_Q, B => DFN1_39_Q, C => DFN1_40_Q, Y
         => MAJ3_5_Y);
    
    MX2_4 : MX2
      port map(A => AND2_5_Y, B => BUFF_15_Y, S => NOR2_14_Y, Y
         => MX2_4_Y);
    
    AND2_144 : AND2
      port map(A => AND2_0_Y, B => XOR2_54_Y, Y => AND2_144_Y);
    
    \XOR2_Mult[23]\ : XOR2
      port map(A => XOR2_62_Y, B => AO1_4_Y, Y => Mult(23));
    
    \XOR3_SumB[22]\ : XOR3
      port map(A => DFN1_74_Q, B => DFN1_55_Q, C => AND2_40_Y, Y
         => \SumB[22]\);
    
    DFN1_6 : DFN1
      port map(D => \PP6[9]\, CLK => Clock, Q => DFN1_6_Q);
    
    \XOR2_PP2[2]\ : XOR2
      port map(A => MX2_60_Y, B => BUFF_32_Y, Y => \PP2[2]\);
    
    AND2_63 : AND2
      port map(A => AND2_154_Y, B => AND2_41_Y, Y => AND2_63_Y);
    
    \XOR2_PP1[0]\ : XOR2
      port map(A => XOR2_61_Y, B => DataB(3), Y => \PP1[0]\);
    
    NOR2_1 : NOR2
      port map(A => XOR2_13_Y, B => XNOR2_7_Y, Y => NOR2_1_Y);
    
    BUFF_19 : BUFF
      port map(A => DataA(1), Y => BUFF_19_Y);
    
    XNOR2_8 : XNOR2
      port map(A => DataB(4), B => BUFF_30_Y, Y => XNOR2_8_Y);
    
    AND2_109 : AND2
      port map(A => AND2_121_Y, B => AND2_149_Y, Y => AND2_109_Y);
    
    MAJ3_10 : MAJ3
      port map(A => DFN1_29_Q, B => DFN1_7_Q, C => DFN1_23_Q, Y
         => MAJ3_10_Y);
    
    DFN1_5 : DFN1
      port map(D => \S[3]\, CLK => Clock, Q => DFN1_5_Q);
    
    AND2_123 : AND2
      port map(A => XOR2_68_Y, B => BUFF_46_Y, Y => AND2_123_Y);
    
    MAJ3_26 : MAJ3
      port map(A => DFN1_5_Q, B => DFN1_20_Q, C => DFN1_67_Q, Y
         => MAJ3_26_Y);
    
    NOR2_8 : NOR2
      port map(A => XOR2_24_Y, B => XNOR2_6_Y, Y => NOR2_8_Y);
    
    MX2_32 : MX2
      port map(A => AND2_100_Y, B => BUFF_37_Y, S => NOR2_11_Y, Y
         => MX2_32_Y);
    
    AND2_141 : AND2
      port map(A => XOR2_5_Y, B => XOR2_36_Y, Y => AND2_141_Y);
    
    AND2_95 : AND2
      port map(A => XOR2_43_Y, B => BUFF_9_Y, Y => AND2_95_Y);
    
    XOR2_22 : XOR2
      port map(A => \SumA[8]\, B => \SumB[8]\, Y => XOR2_22_Y);
    
    MX2_11 : MX2
      port map(A => AND2_151_Y, B => BUFF_34_Y, S => NOR2_8_Y, Y
         => MX2_11_Y);
    
    AND2_27 : AND2
      port map(A => AND2_39_Y, B => AND2_37_Y, Y => AND2_27_Y);
    
    DFN1_42 : DFN1
      port map(D => MAJ3_23_Y, CLK => Clock, Q => DFN1_42_Q);
    
    BUFF_29 : BUFF
      port map(A => DataA(0), Y => BUFF_29_Y);
    
    XOR2_32 : XOR2
      port map(A => \SumA[7]\, B => \SumB[7]\, Y => XOR2_32_Y);
    
    AND2_14 : AND2
      port map(A => XOR2_65_Y, B => BUFF_29_Y, Y => AND2_14_Y);
    
    \XOR2_Mult[20]\ : XOR2
      port map(A => XOR2_42_Y, B => AO1_48_Y, Y => Mult(20));
    
    AND2_74 : AND2
      port map(A => XOR2_41_Y, B => BUFF_1_Y, Y => AND2_74_Y);
    
    DFN1_14 : DFN1
      port map(D => XOR3_7_Y, CLK => Clock, Q => DFN1_14_Q);
    
    AND2_82 : AND2
      port map(A => AND2_41_Y, B => XOR2_28_Y, Y => AND2_82_Y);
    
    AND2_58 : AND2
      port map(A => AND2_121_Y, B => AND2_149_Y, Y => AND2_58_Y);
    
    XOR2_10 : XOR2
      port map(A => \SumA[13]\, B => \SumB[13]\, Y => XOR2_10_Y);
    
    MX2_18 : MX2
      port map(A => AND2_76_Y, B => BUFF_19_Y, S => NOR2_3_Y, Y
         => MX2_18_Y);
    
    XOR3_28 : XOR3
      port map(A => \PP3[9]\, B => \E[1]\, C => \PP5[5]\, Y => 
        XOR3_28_Y);
    
    XNOR2_9 : XNOR2
      port map(A => DataB(4), B => BUFF_32_Y, Y => XNOR2_9_Y);
    
    \XOR2_PP3[6]\ : XOR2
      port map(A => MX2_57_Y, B => BUFF_4_Y, Y => \PP3[6]\);
    
    AO1_20 : AO1
      port map(A => AND2_36_Y, B => AO1_40_Y, C => AO1_18_Y, Y
         => AO1_20_Y);
    
    DFN1_70 : DFN1
      port map(D => MAJ3_25_Y, CLK => Clock, Q => DFN1_70_Q);
    
    \AND2_PP6[0]\ : AND2
      port map(A => BUFF_23_Y, B => BUFF_9_Y, Y => \PP6[0]\);
    
    XOR3_38 : XOR3
      port map(A => \PP3[3]\, B => \PP2[5]\, C => \PP4[1]\, Y => 
        XOR3_38_Y);
    
    \XOR2_Mult[22]\ : XOR2
      port map(A => XOR2_52_Y, B => AO1_17_Y, Y => Mult(22));
    
    XNOR2_12 : XNOR2
      port map(A => DataB(6), B => BUFF_36_Y, Y => XNOR2_12_Y);
    
    \AND2_S[4]\ : AND2
      port map(A => XOR2_0_Y, B => DataB(9), Y => \S[4]\);
    
    XOR2_26 : XOR2
      port map(A => \SumA[3]\, B => \SumB[3]\, Y => XOR2_26_Y);
    
    \XOR2_PP2[1]\ : XOR2
      port map(A => MX2_25_Y, B => BUFF_32_Y, Y => \PP2[1]\);
    
    XOR2_36 : XOR2
      port map(A => \SumA[19]\, B => \SumB[19]\, Y => XOR2_36_Y);
    
    MX2_44 : MX2
      port map(A => AND2_117_Y, B => BUFF_28_Y, S => AND2A_1_Y, Y
         => MX2_44_Y);
    
    AND2_21 : AND2
      port map(A => AND2_22_Y, B => XOR2_5_Y, Y => AND2_21_Y);
    
    MAJ3_35 : MAJ3
      port map(A => \PP5[3]\, B => \PP3[7]\, C => \PP1[11]\, Y
         => MAJ3_35_Y);
    
    BUFF_34 : BUFF
      port map(A => DataA(5), Y => BUFF_34_Y);
    
    \XOR2_PP2[10]\ : XOR2
      port map(A => MX2_16_Y, B => BUFF_2_Y, Y => \PP2[10]\);
    
    MX2_63 : MX2
      port map(A => AND2_143_Y, B => BUFF_9_Y, S => NOR2_4_Y, Y
         => MX2_63_Y);
    
    MX2_39 : MX2
      port map(A => AND2_34_Y, B => BUFF_27_Y, S => NOR2_13_Y, Y
         => MX2_39_Y);
    
    DFN1_67 : DFN1
      port map(D => \PP2[3]\, CLK => Clock, Q => DFN1_67_Q);
    
    AND2_3 : AND2
      port map(A => XOR2_18_Y, B => BUFF_19_Y, Y => AND2_3_Y);
    
    \XOR2_PP1[6]\ : XOR2
      port map(A => MX2_13_Y, B => BUFF_12_Y, Y => \PP1[6]\);
    
    DFN1_66 : DFN1
      port map(D => \VCC\, CLK => Clock, Q => DFN1_66_Q);
    
    \XOR3_SumB[10]\ : XOR3
      port map(A => MAJ3_12_Y, B => DFN1_19_Q, C => XOR3_25_Y, Y
         => \SumB[10]\);
    
    DFN1_48 : DFN1
      port map(D => \PP1[2]\, CLK => Clock, Q => DFN1_48_Q);
    
    DFN1_57 : DFN1
      port map(D => XOR2_9_Y, CLK => Clock, Q => DFN1_57_Q);
    
    DFN1_56 : DFN1
      port map(D => AND2_142_Y, CLK => Clock, Q => DFN1_56_Q);
    
    \XOR2_PP3[4]\ : XOR2
      port map(A => MX2_40_Y, B => BUFF_13_Y, Y => \PP3[4]\);
    
    \AND2_PP6[2]\ : AND2
      port map(A => BUFF_23_Y, B => BUFF_25_Y, Y => \PP6[2]\);
    
    AO1_25 : AO1
      port map(A => AND2_22_Y, B => AO1_31_Y, C => AO1_47_Y, Y
         => AO1_25_Y);
    
    \MAJ3_SumA[15]\ : MAJ3
      port map(A => XOR3_1_Y, B => MAJ3_8_Y, C => DFN1_60_Q, Y
         => \SumA[15]\);
    
    DFN1_7 : DFN1
      port map(D => XOR3_29_Y, CLK => Clock, Q => DFN1_7_Q);
    
    DFN1_69 : DFN1
      port map(D => \S[4]\, CLK => Clock, Q => DFN1_69_Q);
    
    AND2_93 : AND2
      port map(A => \SumA[6]\, B => \SumB[6]\, Y => AND2_93_Y);
    
    DFN1_59 : DFN1
      port map(D => \PP5[10]\, CLK => Clock, Q => DFN1_59_Q);
    
    AND2A_0 : AND2A
      port map(A => DataB(0), B => BUFF_0_Y, Y => AND2A_0_Y);
    
    MAJ3_33 : MAJ3
      port map(A => \PP4[7]\, B => \PP2[11]\, C => \E[0]\, Y => 
        MAJ3_33_Y);
    
    AND2_26 : AND2
      port map(A => DataB(0), B => BUFF_11_Y, Y => AND2_26_Y);
    
    XOR3_9 : XOR3
      port map(A => AND2_146_Y, B => \PP6[0]\, C => MAJ3_32_Y, Y
         => XOR3_9_Y);
    
    XOR2_51 : XOR2
      port map(A => BUFF_41_Y, B => DataB(4), Y => XOR2_51_Y);
    
    DFN1_35 : DFN1
      port map(D => XOR3_38_Y, CLK => Clock, Q => DFN1_35_Q);
    
    AND2_88 : AND2
      port map(A => AND2_39_Y, B => AND2_15_Y, Y => AND2_88_Y);
    
    MAJ3_25 : MAJ3
      port map(A => MAJ3_27_Y, B => MAJ3_35_Y, C => \PP6[2]\, Y
         => MAJ3_25_Y);
    
    \XOR2_PP4[8]\ : XOR2
      port map(A => MX2_2_Y, B => BUFF_31_Y, Y => \PP4[8]\);
    
    XOR3_11 : XOR3
      port map(A => MAJ3_9_Y, B => \PP6[3]\, C => MAJ3_38_Y, Y
         => XOR3_11_Y);
    
    \AND2_S[0]\ : AND2
      port map(A => XOR2_40_Y, B => DataB(1), Y => \S[0]\);
    
    AND2_118 : AND2
      port map(A => \SumA[12]\, B => \SumB[12]\, Y => AND2_118_Y);
    
    XOR2_13 : XOR2
      port map(A => BUFF_24_Y, B => DataB(2), Y => XOR2_13_Y);
    
    DFN1_43 : DFN1
      port map(D => XOR2_14_Y, CLK => Clock, Q => DFN1_43_Q);
    
    XOR2_2 : XOR2
      port map(A => BUFF_44_Y, B => DataB(8), Y => XOR2_2_Y);
    
    BUFF_42 : BUFF
      port map(A => DataA(11), Y => BUFF_42_Y);
    
    \XOR2_Mult[19]\ : XOR2
      port map(A => XOR2_46_Y, B => AO1_25_Y, Y => Mult(19));
    
    AND2_57 : AND2
      port map(A => XOR2_44_Y, B => XOR2_16_Y, Y => AND2_57_Y);
    
    AND2_34 : AND2
      port map(A => XOR2_65_Y, B => BUFF_28_Y, Y => AND2_34_Y);
    
    XOR2_3 : XOR2
      port map(A => \SumA[20]\, B => \SumB[20]\, Y => XOR2_3_Y);
    
    XOR2_19 : XOR2
      port map(A => \SumA[17]\, B => \SumB[17]\, Y => XOR2_19_Y);
    
    AND2_102 : AND2
      port map(A => XOR2_65_Y, B => BUFF_38_Y, Y => AND2_102_Y);
    
    AO1_2 : AO1
      port map(A => AND2_128_Y, B => AO1_1_Y, C => AO1_11_Y, Y
         => AO1_2_Y);
    
    \XOR2_PP3[7]\ : XOR2
      port map(A => MX2_51_Y, B => BUFF_4_Y, Y => \PP3[7]\);
    
    MAJ3_30 : MAJ3
      port map(A => \PP4[4]\, B => \PP2[8]\, C => \PP0[12]\, Y
         => MAJ3_30_Y);
    
    XNOR2_3 : XNOR2
      port map(A => DataB(10), B => BUFF_47_Y, Y => XNOR2_3_Y);
    
    XOR2_68 : XOR2
      port map(A => BUFF_21_Y, B => DataB(6), Y => XOR2_68_Y);
    
    MX2_61 : MX2
      port map(A => AND2_1_Y, B => BUFF_15_Y, S => NOR2_5_Y, Y
         => MX2_61_Y);
    
    \XOR2_PP0[4]\ : XOR2
      port map(A => MX2_44_Y, B => BUFF_26_Y, Y => \PP0[4]\);
    
    \XOR2_PP3[10]\ : XOR2
      port map(A => MX2_62_Y, B => BUFF_36_Y, Y => \PP3[10]\);
    
    \XOR2_PP1[8]\ : XOR2
      port map(A => MX2_45_Y, B => BUFF_12_Y, Y => \PP1[8]\);
    
    \AND2_PP6[11]\ : AND2
      port map(A => BUFF_23_Y, B => BUFF_16_Y, Y => \PP6[11]\);
    
    DFN1_64 : DFN1
      port map(D => \PP0[3]\, CLK => Clock, Q => DFN1_64_Q);
    
    BUFF_9 : BUFF
      port map(A => DataA(0), Y => BUFF_9_Y);
    
    MAJ3_23 : MAJ3
      port map(A => \PP4[9]\, B => \PP3[11]\, C => \E[2]\, Y => 
        MAJ3_23_Y);
    
    AO1_33 : AO1
      port map(A => AND2_19_Y, B => AO1_1_Y, C => AO1_51_Y, Y => 
        AO1_33_Y);
    
    BUFF_35 : BUFF
      port map(A => DataB(9), Y => BUFF_35_Y);
    
    \DFN1_Mult[0]\ : DFN1
      port map(D => \PP0[0]\, CLK => Clock, Q => Mult(0));
    
    AND2_126 : AND2
      port map(A => NOR2_5_Y, B => BUFF_42_Y, Y => AND2_126_Y);
    
    \XOR2_PP3[9]\ : XOR2
      port map(A => MX2_4_Y, B => BUFF_36_Y, Y => \PP3[9]\);
    
    BUFF_30 : BUFF
      port map(A => DataB(5), Y => BUFF_30_Y);
    
    \XOR3_SumB[14]\ : XOR3
      port map(A => MAJ3_8_Y, B => DFN1_60_Q, C => XOR3_1_Y, Y
         => \SumB[14]\);
    
    MX2_25 : MX2
      port map(A => AND2_80_Y, B => BUFF_29_Y, S => NOR2_13_Y, Y
         => MX2_25_Y);
    
    DFN1_54 : DFN1
      port map(D => \PP2[0]\, CLK => Clock, Q => DFN1_54_Q);
    
    XOR2_17 : XOR2
      port map(A => \SumA[9]\, B => \SumB[9]\, Y => XOR2_17_Y);
    
    \XOR3_SumB[15]\ : XOR3
      port map(A => MAJ3_14_Y, B => DFN1_51_Q, C => XOR3_8_Y, Y
         => \SumB[15]\);
    
    AND2_154 : AND2
      port map(A => AND2_121_Y, B => AND2_149_Y, Y => AND2_154_Y);
    
    DFN1_77 : DFN1
      port map(D => AND2_127_Y, CLK => Clock, Q => DFN1_77_Q);
    
    AND2_145 : AND2
      port map(A => XOR2_13_Y, B => BUFF_42_Y, Y => AND2_145_Y);
    
    AND2_51 : AND2
      port map(A => XOR2_38_Y, B => BUFF_28_Y, Y => AND2_51_Y);
    
    DFN1_76 : DFN1
      port map(D => \PP6[7]\, CLK => Clock, Q => DFN1_76_Q);
    
    AO1_10 : AO1
      port map(A => XOR2_16_Y, B => AND2_158_Y, C => AND2_28_Y, Y
         => AO1_10_Y);
    
    DFN1_0 : DFN1
      port map(D => XOR3_39_Y, CLK => Clock, Q => DFN1_0_Q);
    
    AO1_32 : AO1
      port map(A => AND2_149_Y, B => AO1_19_Y, C => AO1_27_Y, Y
         => AO1_32_Y);
    
    \XOR2_PP5[8]\ : XOR2
      port map(A => MX2_10_Y, B => BUFF_40_Y, Y => \PP5[8]\);
    
    BUFF_1 : BUFF
      port map(A => DataA(4), Y => BUFF_1_Y);
    
    MAJ3_14 : MAJ3
      port map(A => DFN1_70_Q, B => DFN1_38_Q, C => DFN1_65_Q, Y
         => MAJ3_14_Y);
    
    \INV_E[2]\ : INV
      port map(A => DataB(5), Y => \E[2]\);
    
    AND2_29 : AND2
      port map(A => AND2_109_Y, B => AND2_82_Y, Y => AND2_29_Y);
    
    BUFF_18 : BUFF
      port map(A => DataA(8), Y => BUFF_18_Y);
    
    MX2_40 : MX2
      port map(A => AND2_150_Y, B => BUFF_28_Y, S => NOR2_3_Y, Y
         => MX2_40_Y);
    
    AND2_140 : AND2
      port map(A => XOR2_2_Y, B => BUFF_37_Y, Y => AND2_140_Y);
    
    \XOR2_PP1[5]\ : XOR2
      port map(A => MX2_29_Y, B => BUFF_12_Y, Y => \PP1[5]\);
    
    MAJ3_20 : MAJ3
      port map(A => DFN1_73_Q, B => DFN1_11_Q, C => DFN1_69_Q, Y
         => MAJ3_20_Y);
    
    AND2_151 : AND2
      port map(A => XOR2_24_Y, B => BUFF_14_Y, Y => AND2_151_Y);
    
    \DFN1_SumA[0]\ : DFN1
      port map(D => \PP0[1]\, CLK => Clock, Q => \SumA[0]\);
    
    \XOR2_PP1[3]\ : XOR2
      port map(A => MX2_28_Y, B => BUFF_17_Y, Y => \PP1[3]\);
    
    \XOR3_SumB[21]\ : XOR3
      port map(A => XOR2_25_Y, B => DFN1_25_Q, C => MAJ3_4_Y, Y
         => \SumB[21]\);
    
    \XOR2_PP2[5]\ : XOR2
      port map(A => MX2_26_Y, B => BUFF_30_Y, Y => \PP2[5]\);
    
    \XOR3_SumB[9]\ : XOR3
      port map(A => MAJ3_20_Y, B => DFN1_1_Q, C => XOR3_13_Y, Y
         => \SumB[9]\);
    
    \XOR2_PP2[7]\ : XOR2
      port map(A => MX2_43_Y, B => BUFF_30_Y, Y => \PP2[7]\);
    
    DFN1_21 : DFN1
      port map(D => XOR3_9_Y, CLK => Clock, Q => DFN1_21_Q);
    
    BUFF_2 : BUFF
      port map(A => DataB(5), Y => BUFF_2_Y);
    
    AND2_15 : AND2
      port map(A => AND2_32_Y, B => AND2_44_Y, Y => AND2_15_Y);
    
    AND2_87 : AND2
      port map(A => XOR2_35_Y, B => BUFF_45_Y, Y => AND2_87_Y);
    
    \AND2_PP6[10]\ : AND2
      port map(A => BUFF_23_Y, B => BUFF_10_Y, Y => \PP6[10]\);
    
    BUFF_28 : BUFF
      port map(A => DataA(3), Y => BUFF_28_Y);
    
    \XOR2_PP4[4]\ : XOR2
      port map(A => MX2_53_Y, B => BUFF_35_Y, Y => \PP4[4]\);
    
    AND2_75 : AND2
      port map(A => XOR2_13_Y, B => BUFF_43_Y, Y => AND2_75_Y);
    
    AND2_127 : AND2
      port map(A => \PP4[12]\, B => \VCC\, Y => AND2_127_Y);
    
    AO1_24 : AO1
      port map(A => AND2_42_Y, B => AO1_49_Y, C => AO1_13_Y, Y
         => AO1_24_Y);
    
    BUFF_0 : BUFF
      port map(A => DataB(1), Y => BUFF_0_Y);
    
    AND2_56 : AND2
      port map(A => XOR2_24_Y, B => BUFF_34_Y, Y => AND2_56_Y);
    
    \XOR2_PP2[9]\ : XOR2
      port map(A => MX2_61_Y, B => BUFF_2_Y, Y => \PP2[9]\);
    
    AND2_149 : AND2
      port map(A => AND2_35_Y, B => AND2_47_Y, Y => AND2_149_Y);
    
    \XOR2_PP1[12]\ : XOR2
      port map(A => AND2_96_Y, B => BUFF_39_Y, Y => \PP1[12]\);
    
    XOR2_52 : XOR2
      port map(A => \SumA[21]\, B => \SumB[21]\, Y => XOR2_52_Y);
    
    AND2_113 : AND2
      port map(A => XOR2_68_Y, B => BUFF_8_Y, Y => AND2_113_Y);
    
    AO1_15 : AO1
      port map(A => AND2_108_Y, B => AO1_38_Y, C => AO1_36_Y, Y
         => AO1_15_Y);
    
    XNOR2_6 : XNOR2
      port map(A => DataB(8), B => BUFF_31_Y, Y => XNOR2_6_Y);
    
    DFN1_32 : DFN1
      port map(D => \PP0[5]\, CLK => Clock, Q => DFN1_32_Q);
    
    \MAJ3_SumA[13]\ : MAJ3
      port map(A => XOR3_31_Y, B => MAJ3_34_Y, C => DFN1_58_Q, Y
         => \SumA[13]\);
    
    AO1_51 : AO1
      port map(A => AND2_23_Y, B => AO1_52_Y, C => AO1_0_Y, Y => 
        AO1_51_Y);
    
    \MAJ3_SumA[6]\ : MAJ3
      port map(A => XOR3_17_Y, B => AND2_111_Y, C => DFN1_17_Q, Y
         => \SumA[6]\);
    
    XOR3_12 : XOR3
      port map(A => \PP1[9]\, B => \PP0[11]\, C => \PP2[7]\, Y
         => XOR3_12_Y);
    
    BUFF_46 : BUFF
      port map(A => DataA(5), Y => BUFF_46_Y);
    
    XOR3_4 : XOR3
      port map(A => DFN1_33_Q, B => DFN1_59_Q, C => DFN1_15_Q, Y
         => XOR3_4_Y);
    
    XOR3_6 : XOR3
      port map(A => XOR2_1_Y, B => \PP6[4]\, C => MAJ3_39_Y, Y
         => XOR3_6_Y);
    
    AND2_81 : AND2
      port map(A => NOR2_14_Y, B => BUFF_42_Y, Y => AND2_81_Y);
    
    MX2_46 : MX2
      port map(A => AND2_157_Y, B => BUFF_25_Y, S => NOR2_2_Y, Y
         => MX2_46_Y);
    
    AND2_20 : AND2
      port map(A => XOR2_8_Y, B => BUFF_8_Y, Y => AND2_20_Y);
    
    DFN1_74 : DFN1
      port map(D => \PP6[11]\, CLK => Clock, Q => DFN1_74_Q);
    
    AND2_134 : AND2
      port map(A => \PP3[12]\, B => \VCC\, Y => AND2_134_Y);
    
    MX2_35 : MX2
      port map(A => AND2_102_Y, B => BUFF_28_Y, S => NOR2_13_Y, Y
         => MX2_35_Y);
    
    AO1_29 : AO1
      port map(A => AND2_68_Y, B => AO1_50_Y, C => AO1_34_Y, Y
         => AO1_29_Y);
    
    \INV_E[1]\ : INV
      port map(A => DataB(3), Y => \E[1]\);
    
    XOR2_56 : XOR2
      port map(A => \SumA[4]\, B => \SumB[4]\, Y => XOR2_56_Y);
    
    XNOR2_5 : XNOR2
      port map(A => DataB(4), B => BUFF_2_Y, Y => XNOR2_5_Y);
    
    \DFN1_SumB[1]\ : DFN1
      port map(D => \PP1[0]\, CLK => Clock, Q => \SumB[1]\);
    
    MAJ3_4 : MAJ3
      port map(A => DFN1_6_Q, B => DFN1_37_Q, C => DFN1_68_Q, Y
         => MAJ3_4_Y);
    
    XOR3_16 : XOR3
      port map(A => \PP6[5]\, B => \PP5[7]\, C => AND2_66_Y, Y
         => XOR3_16_Y);
    
    \XOR2_PP2[0]\ : XOR2
      port map(A => XOR2_23_Y, B => DataB(5), Y => \PP2[0]\);
    
    AO1_1 : AO1
      port map(A => AND2_149_Y, B => AO1_19_Y, C => AO1_27_Y, Y
         => AO1_1_Y);
    
    AND2_131 : AND2
      port map(A => XOR2_12_Y, B => BUFF_15_Y, Y => AND2_131_Y);
    
    \XOR2_PP4[11]\ : XOR2
      port map(A => MX2_56_Y, B => BUFF_6_Y, Y => \PP4[11]\);
    
    DFN1_38 : DFN1
      port map(D => XOR3_24_Y, CLK => Clock, Q => DFN1_38_Q);
    
    AO1_37 : AO1
      port map(A => AND2_15_Y, B => AO1_24_Y, C => AO1_8_Y, Y => 
        AO1_37_Y);
    
    MX2_2 : MX2
      port map(A => AND2_129_Y, B => BUFF_45_Y, S => NOR2_8_Y, Y
         => MX2_2_Y);
    
    \XOR2_PP4[9]\ : XOR2
      port map(A => MX2_47_Y, B => BUFF_6_Y, Y => \PP4[9]\);
    
    XNOR2_14 : XNOR2
      port map(A => DataB(2), B => BUFF_12_Y, Y => XNOR2_14_Y);
    
    AND2_13 : AND2
      port map(A => XOR2_13_Y, B => BUFF_11_Y, Y => AND2_13_Y);
    
    AND2_86 : AND2
      port map(A => XOR2_37_Y, B => BUFF_37_Y, Y => AND2_86_Y);
    
    AND2_73 : AND2
      port map(A => XOR2_43_Y, B => BUFF_25_Y, Y => AND2_73_Y);
    
    AND2_59 : AND2
      port map(A => AND2_23_Y, B => XOR2_44_Y, Y => AND2_59_Y);
    
    AO1_40 : AO1
      port map(A => AND2_141_Y, B => AO1_47_Y, C => AO1_3_Y, Y
         => AO1_40_Y);
    
    AO1_38 : AO1
      port map(A => AND2_25_Y, B => AO1_35_Y, C => AO1_41_Y, Y
         => AO1_38_Y);
    
    AO1_9 : AO1
      port map(A => XOR2_54_Y, B => AO1_31_Y, C => AND2_50_Y, Y
         => AO1_9_Y);
    
    XOR2_11 : XOR2
      port map(A => \SumA[22]\, B => \SumB[22]\, Y => XOR2_11_Y);
    
    MX2_52 : MX2
      port map(A => AND2_86_Y, B => BUFF_18_Y, S => NOR2_11_Y, Y
         => MX2_52_Y);
    
    AND2_35 : AND2
      port map(A => XOR2_56_Y, B => XOR2_49_Y, Y => AND2_35_Y);
    
    AND2_108 : AND2
      port map(A => AND2_35_Y, B => XOR2_45_Y, Y => AND2_108_Y);
    
    XOR2_48 : XOR2
      port map(A => \SumA[11]\, B => \SumB[11]\, Y => XOR2_48_Y);
    
    \XOR2_PP3[3]\ : XOR2
      port map(A => MX2_17_Y, B => BUFF_13_Y, Y => \PP3[3]\);
    
    MAJ3_34 : MAJ3
      port map(A => DFN1_3_Q, B => DFN1_14_Q, C => DFN1_27_Q, Y
         => MAJ3_34_Y);
    
    \XOR2_PP3[8]\ : XOR2
      port map(A => MX2_36_Y, B => BUFF_4_Y, Y => \PP3[8]\);
    
    NOR2_9 : NOR2
      port map(A => XOR2_2_Y, B => XNOR2_4_Y, Y => NOR2_9_Y);
    
    \XOR2_PP0[3]\ : XOR2
      port map(A => MX2_19_Y, B => BUFF_26_Y, Y => \PP0[3]\);
    
    BUFF_14 : BUFF
      port map(A => DataA(6), Y => BUFF_14_Y);
    
    \MAJ3_SumA[16]\ : MAJ3
      port map(A => XOR3_8_Y, B => MAJ3_14_Y, C => DFN1_51_Q, Y
         => \SumA[16]\);
    
    XOR3_24 : XOR3
      port map(A => \PP2[11]\, B => \E[0]\, C => \PP4[7]\, Y => 
        XOR3_24_Y);
    
    DFN1_15 : DFN1
      port map(D => XOR2_72_Y, CLK => Clock, Q => DFN1_15_Q);
    
    DFN1_33 : DFN1
      port map(D => \PP6[8]\, CLK => Clock, Q => DFN1_33_Q);
    
    XOR2_5 : XOR2
      port map(A => \SumA[18]\, B => \SumB[18]\, Y => XOR2_5_Y);
    
    MAJ3_8 : MAJ3
      port map(A => DFN1_41_Q, B => DFN1_16_Q, C => DFN1_0_Q, Y
         => MAJ3_8_Y);
    
    XOR3_34 : XOR3
      port map(A => DFN1_42_Q, B => DFN1_43_Q, C => DFN1_28_Q, Y
         => XOR3_34_Y);
    
    \XOR2_PP4[6]\ : XOR2
      port map(A => MX2_11_Y, B => BUFF_31_Y, Y => \PP4[6]\);
    
    \XOR2_PP0[8]\ : XOR2
      port map(A => MX2_41_Y, B => BUFF_22_Y, Y => \PP0[8]\);
    
    XOR3_1 : XOR3
      port map(A => DFN1_38_Q, B => DFN1_65_Q, C => DFN1_70_Q, Y
         => XOR3_1_Y);
    
    AO1_14 : AO1
      port map(A => AND2_156_Y, B => AO1_1_Y, C => AO1_29_Y, Y
         => AO1_14_Y);
    
    AO1_45 : AO1
      port map(A => XOR2_49_Y, B => AND2_105_Y, C => AND2_60_Y, Y
         => AO1_45_Y);
    
    \AND2_PP6[3]\ : AND2
      port map(A => BUFF_23_Y, B => BUFF_5_Y, Y => \PP6[3]\);
    
    AND2_155 : AND2
      port map(A => AND2_109_Y, B => AND2_19_Y, Y => AND2_155_Y);
    
    BUFF_24 : BUFF
      port map(A => DataB(1), Y => BUFF_24_Y);
    
    AND2_142 : AND2
      port map(A => \PP1[7]\, B => \PP0[9]\, Y => AND2_142_Y);
    
    \XOR2_PP0[7]\ : XOR2
      port map(A => MX2_50_Y, B => BUFF_22_Y, Y => \PP0[7]\);
    
    MX2_47 : MX2
      port map(A => AND2_140_Y, B => BUFF_18_Y, S => NOR2_9_Y, Y
         => MX2_47_Y);
    
    AND2_50 : AND2
      port map(A => \SumA[16]\, B => \SumB[16]\, Y => AND2_50_Y);
    
    \XOR2_Mult[1]\ : XOR2
      port map(A => \SumA[0]\, B => \SumB[0]\, Y => Mult(1));
    
    MX2_24 : MX2
      port map(A => AND2_71_Y, B => BUFF_43_Y, S => AND2A_0_Y, Y
         => MX2_24_Y);
    
    \MAJ3_SumA[8]\ : MAJ3
      port map(A => XOR3_0_Y, B => MAJ3_26_Y, C => DFN1_8_Q, Y
         => \SumA[8]\);
    
    AND2_150 : AND2
      port map(A => XOR2_18_Y, B => BUFF_38_Y, Y => AND2_150_Y);
    
    MX2_59 : MX2
      port map(A => AND2_20_Y, B => BUFF_46_Y, S => NOR2_7_Y, Y
         => MX2_59_Y);
    
    MAJ3_24 : MAJ3
      port map(A => DFN1_28_Q, B => DFN1_42_Q, C => DFN1_43_Q, Y
         => MAJ3_24_Y);
    
    AND2_89 : AND2
      port map(A => DataB(0), B => BUFF_46_Y, Y => AND2_89_Y);
    
    AND2_116 : AND2
      port map(A => \SumA[19]\, B => \SumB[19]\, Y => AND2_116_Y);
    
    MX2_3 : MX2
      port map(A => AND2_13_Y, B => BUFF_15_Y, S => NOR2_1_Y, Y
         => MX2_3_Y);
    
    AO1_26 : AO1
      port map(A => XOR2_53_Y, B => AO1_40_Y, C => AND2_2_Y, Y
         => AO1_26_Y);
    
    NOR2_11 : NOR2
      port map(A => XOR2_37_Y, B => XNOR2_1_Y, Y => NOR2_11_Y);
    
    AO1_19 : AO1
      port map(A => AND2_25_Y, B => AO1_35_Y, C => AO1_41_Y, Y
         => AO1_19_Y);
    
    XOR3_25 : XOR3
      port map(A => DFN1_34_Q, B => DFN1_63_Q, C => DFN1_62_Q, Y
         => XOR3_25_Y);
    
    AND2_42 : AND2
      port map(A => AND2_112_Y, B => AND2_130_Y, Y => AND2_42_Y);
    
    AND2_33 : AND2
      port map(A => \SumA[18]\, B => \SumB[18]\, Y => AND2_33_Y);
    
    XOR3_35 : XOR3
      port map(A => MAJ3_35_Y, B => \PP6[2]\, C => MAJ3_27_Y, Y
         => XOR3_35_Y);
    
    AO1_4 : AO1
      port map(A => AND2_64_Y, B => AO1_24_Y, C => AO1_20_Y, Y
         => AO1_4_Y);
    
    AND2_159 : AND2
      port map(A => XOR2_38_Y, B => BUFF_38_Y, Y => AND2_159_Y);
    
    NOR2_10 : NOR2
      port map(A => XOR2_12_Y, B => XNOR2_14_Y, Y => NOR2_10_Y);
    
    MX2_12 : MX2
      port map(A => AND2_89_Y, B => BUFF_38_Y, S => AND2A_2_Y, Y
         => MX2_12_Y);
    
    AND2_2 : AND2
      port map(A => \SumA[20]\, B => \SumB[20]\, Y => AND2_2_Y);
    
    \XOR3_SumB[6]\ : XOR3
      port map(A => MAJ3_37_Y, B => DFN1_57_Q, C => XOR3_5_Y, Y
         => \SumB[6]\);
    
    DFN1_41 : DFN1
      port map(D => MAJ3_11_Y, CLK => Clock, Q => DFN1_41_Q);
    
    BUFF_43 : BUFF
      port map(A => DataA(10), Y => BUFF_43_Y);
    
    AND2_62 : AND2
      port map(A => \SumA[0]\, B => \SumB[0]\, Y => AND2_62_Y);
    
    BUFF_41 : BUFF
      port map(A => DataB(3), Y => BUFF_41_Y);
    
    AND2_103 : AND2
      port map(A => AND2_132_Y, B => AND2_25_Y, Y => AND2_103_Y);
    
    \XOR2_PP5[0]\ : XOR2
      port map(A => XOR2_55_Y, B => DataB(11), Y => \PP5[0]\);
    
    XNOR2_1 : XNOR2
      port map(A => DataB(10), B => BUFF_20_Y, Y => XNOR2_1_Y);
    
    \MAJ3_SumA[11]\ : MAJ3
      port map(A => XOR3_25_Y, B => MAJ3_12_Y, C => DFN1_19_Q, Y
         => \SumA[11]\);
    
    BUFF_15 : BUFF
      port map(A => DataA(8), Y => BUFF_15_Y);
    
    BUFF_10 : BUFF
      port map(A => DataA(10), Y => BUFF_10_Y);
    
    \AND2_PP6[1]\ : AND2
      port map(A => BUFF_23_Y, B => BUFF_33_Y, Y => \PP6[1]\);
    
    XOR2_12 : XOR2
      port map(A => BUFF_24_Y, B => DataB(2), Y => XOR2_12_Y);
    
    NOR2_13 : NOR2
      port map(A => XOR2_65_Y, B => XNOR2_9_Y, Y => NOR2_13_Y);
    
    AND2_117 : AND2
      port map(A => DataB(0), B => BUFF_38_Y, Y => AND2_117_Y);
    
    AND2_135 : AND2
      port map(A => \SumA[22]\, B => \SumB[22]\, Y => AND2_135_Y);
    
    XOR2_64 : XOR2
      port map(A => \SumA[1]\, B => \SumB[1]\, Y => XOR2_64_Y);
    
    AND2_80 : AND2
      port map(A => XOR2_65_Y, B => BUFF_19_Y, Y => AND2_80_Y);
    
    \XOR2_Mult[5]\ : XOR2
      port map(A => XOR2_50_Y, B => AO1_38_Y, Y => Mult(5));
    
    BUFF_25 : BUFF
      port map(A => DataA(2), Y => BUFF_25_Y);
    
    DFN1_12 : DFN1
      port map(D => \PP1[4]\, CLK => Clock, Q => DFN1_12_Q);
    
    BUFF_20 : BUFF
      port map(A => DataB(11), Y => BUFF_20_Y);
    
    XOR3_20 : XOR3
      port map(A => \PP4[11]\, B => \E[3]\, C => \PP5[9]\, Y => 
        XOR3_20_Y);
    
    MAJ3_12 : MAJ3
      port map(A => DFN1_24_Q, B => DFN1_30_Q, C => DFN1_56_Q, Y
         => MAJ3_12_Y);
    
    DFN1_65 : DFN1
      port map(D => XOR3_28_Y, CLK => Clock, Q => DFN1_65_Q);
    
    AND2_130 : AND2
      port map(A => AND2_23_Y, B => AND2_57_Y, Y => AND2_130_Y);
    
    MX2_34 : MX2
      port map(A => AND2_45_Y, B => BUFF_8_Y, S => NOR2_10_Y, Y
         => MX2_34_Y);
    
    AO1_31 : AO1
      port map(A => AND2_42_Y, B => AO1_49_Y, C => AO1_13_Y, Y
         => AO1_31_Y);
    
    \XOR2_Mult[7]\ : XOR2
      port map(A => XOR2_59_Y, B => AO1_30_Y, Y => Mult(7));
    
    \AND2_SumA[3]\ : AND2
      port map(A => DFN1_9_Q, B => DFN1_64_Q, Y => \SumA[3]\);
    
    MX2_19 : MX2
      port map(A => AND2_55_Y, B => BUFF_27_Y, S => AND2A_1_Y, Y
         => MX2_19_Y);
    
    MX2_43 : MX2
      port map(A => AND2_92_Y, B => BUFF_8_Y, S => NOR2_7_Y, Y
         => MX2_43_Y);
    
    XOR3_30 : XOR3
      port map(A => \PP2[10]\, B => DataB(1), C => \PP4[6]\, Y
         => XOR3_30_Y);
    
    XOR2_16 : XOR2
      port map(A => \SumA[15]\, B => \SumB[15]\, Y => XOR2_16_Y);
    
    DFN1_55 : DFN1
      port map(D => \E[5]\, CLK => Clock, Q => DFN1_55_Q);
    
    NOR2_7 : NOR2
      port map(A => XOR2_8_Y, B => XNOR2_8_Y, Y => NOR2_7_Y);
    
    \XOR2_PP4[2]\ : XOR2
      port map(A => MX2_65_Y, B => BUFF_35_Y, Y => \PP4[2]\);
    
    AND2_24 : AND2
      port map(A => XOR2_41_Y, B => BUFF_33_Y, Y => AND2_24_Y);
    
    \XOR2_PP2[12]\ : XOR2
      port map(A => AND2_126_Y, B => BUFF_2_Y, Y => \PP2[12]\);
    
    AND2_48 : AND2
      port map(A => \SumA[9]\, B => \SumB[9]\, Y => AND2_48_Y);
    
    AO1_44 : AO1
      port map(A => AND2_41_Y, B => AO1_32_Y, C => AO1_50_Y, Y
         => AO1_44_Y);
    
    \AND2_PP6[5]\ : AND2
      port map(A => BUFF_23_Y, B => BUFF_34_Y, Y => \PP6[5]\);
    
    \XOR3_SumB[12]\ : XOR3
      port map(A => MAJ3_34_Y, B => DFN1_58_Q, C => XOR3_31_Y, Y
         => \SumB[12]\);
    
    \XOR2_Mult[18]\ : XOR2
      port map(A => XOR2_19_Y, B => AO1_9_Y, Y => Mult(18));
    
    \XOR3_SumB[3]\ : XOR3
      port map(A => DFN1_48_Q, B => DFN1_52_Q, C => DFN1_54_Q, Y
         => \SumB[3]\);
    
    AND2_139 : AND2
      port map(A => XOR2_12_Y, B => BUFF_8_Y, Y => AND2_139_Y);
    
    \MAJ3_SumA[20]\ : MAJ3
      port map(A => XOR3_4_Y, B => MAJ3_0_Y, C => DFN1_31_Q, Y
         => \SumA[20]\);
    
    MX2_20 : MX2
      port map(A => AND2_30_Y, B => BUFF_19_Y, S => NOR2_12_Y, Y
         => MX2_20_Y);
    
    AND2_68 : AND2
      port map(A => XOR2_28_Y, B => XOR2_73_Y, Y => AND2_68_Y);
    
    DFN1_20 : DFN1
      port map(D => \PP3[1]\, CLK => Clock, Q => DFN1_20_Q);
    
    XOR2_65 : XOR2
      port map(A => BUFF_41_Y, B => DataB(4), Y => XOR2_65_Y);
    
    \XOR2_PP0[10]\ : XOR2
      port map(A => MX2_21_Y, B => BUFF_0_Y, Y => \PP0[10]\);
    
    DFN1_18 : DFN1
      port map(D => XOR3_26_Y, CLK => Clock, Q => DFN1_18_Q);
    
    \XOR3_SumB[8]\ : XOR3
      port map(A => MAJ3_5_Y, B => DFN1_35_Q, C => XOR3_18_Y, Y
         => \SumB[8]\);
    
    \INV_E[3]\ : INV
      port map(A => DataB(7), Y => \E[3]\);
    
    XOR2_70 : XOR2
      port map(A => \SumA[0]\, B => \SumB[0]\, Y => XOR2_70_Y);
    
    \MAJ3_SumA[22]\ : MAJ3
      port map(A => MAJ3_4_Y, B => XOR2_25_Y, C => DFN1_25_Q, Y
         => \SumA[22]\);
    
    AO1_49 : AO1
      port map(A => AND2_149_Y, B => AO1_19_Y, C => AO1_27_Y, Y
         => AO1_49_Y);
    
    AO1_16 : AO1
      port map(A => AND2_31_Y, B => AO1_49_Y, C => AO1_28_Y, Y
         => AO1_16_Y);
    
    AND2_5 : AND2
      port map(A => XOR2_39_Y, B => BUFF_11_Y, Y => AND2_5_Y);
    
    AND2_92 : AND2
      port map(A => XOR2_8_Y, B => BUFF_7_Y, Y => AND2_92_Y);
    
    XOR2_28 : XOR2
      port map(A => \SumA[10]\, B => \SumB[10]\, Y => XOR2_28_Y);
    
    \XOR2_PP5[10]\ : XOR2
      port map(A => MX2_32_Y, B => BUFF_20_Y, Y => \PP5[10]\);
    
    NOR2_6 : NOR2
      port map(A => XOR2_68_Y, B => XNOR2_10_Y, Y => NOR2_6_Y);
    
    XOR2_38 : XOR2
      port map(A => BUFF_24_Y, B => DataB(2), Y => XOR2_38_Y);
    
    BUFF_32 : BUFF
      port map(A => DataB(5), Y => BUFF_32_Y);
    
    MX2_62 : MX2
      port map(A => AND2_77_Y, B => BUFF_11_Y, S => NOR2_14_Y, Y
         => MX2_62_Y);
    
    \XOR2_PP1[11]\ : XOR2
      port map(A => MX2_5_Y, B => BUFF_39_Y, Y => \PP1[11]\);
    
    AND2_148 : AND2
      port map(A => XOR2_38_Y, B => BUFF_19_Y, Y => AND2_148_Y);
    
    AND2_152 : AND2
      port map(A => \SumA[10]\, B => \SumB[10]\, Y => AND2_152_Y);
    
    XOR2_1 : XOR2
      port map(A => \PP5[6]\, B => \PP4[8]\, Y => XOR2_1_Y);
    
    MX2_41 : MX2
      port map(A => AND2_124_Y, B => BUFF_7_Y, S => AND2A_2_Y, Y
         => MX2_41_Y);
    
    BUFF_47 : BUFF
      port map(A => DataB(11), Y => BUFF_47_Y);
    
    \XOR3_SumB[7]\ : XOR3
      port map(A => MAJ3_26_Y, B => DFN1_8_Q, C => XOR3_0_Y, Y
         => \SumB[7]\);
    
    \MAJ3_SumA[18]\ : MAJ3
      port map(A => XOR3_34_Y, B => MAJ3_10_Y, C => DFN1_18_Q, Y
         => \SumA[18]\);
    
    XOR3_23 : XOR3
      port map(A => \PP3[7]\, B => \PP1[11]\, C => \PP5[3]\, Y
         => XOR3_23_Y);
    
    DFN1_2 : DFN1
      port map(D => MAJ3_17_Y, CLK => Clock, Q => DFN1_2_Q);
    
    \XOR2_PP1[7]\ : XOR2
      port map(A => MX2_34_Y, B => BUFF_12_Y, Y => \PP1[7]\);
    
    \MAJ3_SumA[5]\ : MAJ3
      port map(A => XOR2_58_Y, B => DFN1_22_Q, C => DFN1_71_Q, Y
         => \SumA[5]\);
    
    XOR2_8 : XOR2
      port map(A => BUFF_41_Y, B => DataB(4), Y => XOR2_8_Y);
    
    MX2_26 : MX2
      port map(A => AND2_106_Y, B => BUFF_38_Y, S => NOR2_7_Y, Y
         => MX2_26_Y);
    
    DFN1_75 : DFN1
      port map(D => MAJ3_33_Y, CLK => Clock, Q => DFN1_75_Q);
    
    XOR3_29 : XOR3
      port map(A => \PP3[11]\, B => \E[2]\, C => \PP4[9]\, Y => 
        XOR3_29_Y);
    
    MX2_55 : MX2
      port map(A => AND2_46_Y, B => BUFF_43_Y, S => NOR2_5_Y, Y
         => MX2_55_Y);
    
    MX2_48 : MX2
      port map(A => AND2_97_Y, B => BUFF_1_Y, S => NOR2_0_Y, Y
         => MX2_48_Y);
    
    XOR3_33 : XOR3
      port map(A => DFN1_14_Q, B => DFN1_27_Q, C => DFN1_3_Q, Y
         => XOR3_33_Y);
    
    \XOR2_PP3[12]\ : XOR2
      port map(A => AND2_81_Y, B => BUFF_36_Y, Y => \PP3[12]\);
    
    DFN1_13 : DFN1
      port map(D => AND2_134_Y, CLK => Clock, Q => DFN1_13_Q);
    
    \XOR2_Mult[11]\ : XOR2
      port map(A => XOR2_67_Y, B => AO1_44_Y, Y => Mult(11));
    
    XOR2_60 : XOR2
      port map(A => \SumA[3]\, B => \SumB[3]\, Y => XOR2_60_Y);
    
    XOR3_39 : XOR3
      port map(A => \PP3[8]\, B => \PP1[12]\, C => \PP5[4]\, Y
         => XOR3_39_Y);
    
    AND2_106 : AND2
      port map(A => XOR2_8_Y, B => BUFF_46_Y, Y => AND2_106_Y);
    
    \XOR2_PP5[5]\ : XOR2
      port map(A => MX2_48_Y, B => BUFF_40_Y, Y => \PP5[5]\);
    
    AO1_50 : AO1
      port map(A => XOR2_17_Y, B => AND2_114_Y, C => AND2_48_Y, Y
         => AO1_50_Y);
    
    DFN1_9 : DFN1
      port map(D => \PP1[1]\, CLK => Clock, Q => DFN1_9_Q);
    
    DFN1_62 : DFN1
      port map(D => MAJ3_13_Y, CLK => Clock, Q => DFN1_62_Q);
    
    AND2_47 : AND2
      port map(A => XOR2_45_Y, B => XOR2_32_Y, Y => AND2_47_Y);
    
    \XOR2_Mult[9]\ : XOR2
      port map(A => XOR2_21_Y, B => AO1_32_Y, Y => Mult(9));
    
    \MAJ3_SumA[4]\ : MAJ3
      port map(A => DFN1_54_Q, B => DFN1_48_Q, C => DFN1_52_Q, Y
         => \SumA[4]\);
    
    MX2_30 : MX2
      port map(A => AND2_123_Y, B => BUFF_38_Y, S => NOR2_6_Y, Y
         => MX2_30_Y);
    
    XOR3_27 : XOR3
      port map(A => \PP2[9]\, B => DataB(1), C => \PP4[5]\, Y => 
        XOR3_27_Y);
    
    AND2_54 : AND2
      port map(A => AND2_0_Y, B => AND2_22_Y, Y => AND2_54_Y);
    
    XNOR2_10 : XNOR2
      port map(A => DataB(6), B => BUFF_4_Y, Y => XNOR2_10_Y);
    
    DFN1_52 : DFN1
      port map(D => \PP0[4]\, CLK => Clock, Q => DFN1_52_Q);
    
    AO1_6 : AO1
      port map(A => XOR2_5_Y, B => AO1_47_Y, C => AND2_33_Y, Y
         => AO1_6_Y);
    
    \AND2_S[5]\ : AND2
      port map(A => XOR2_55_Y, B => DataB(11), Y => \S[5]\);
    
    \XOR2_PP4[5]\ : XOR2
      port map(A => MX2_38_Y, B => BUFF_31_Y, Y => \PP4[5]\);
    
    \XOR2_PP3[2]\ : XOR2
      port map(A => MX2_18_Y, B => BUFF_13_Y, Y => \PP3[2]\);
    
    XOR3_37 : XOR3
      port map(A => MAJ3_3_Y, B => \PP6[1]\, C => MAJ3_30_Y, Y
         => XOR3_37_Y);
    
    AND2_67 : AND2
      port map(A => DataB(0), B => BUFF_27_Y, Y => AND2_67_Y);
    
    MAJ3_32 : MAJ3
      port map(A => \PP2[7]\, B => \PP1[9]\, C => \PP0[11]\, Y
         => MAJ3_32_Y);
    
    \XOR2_Mult[14]\ : XOR2
      port map(A => XOR2_10_Y, B => AO1_2_Y, Y => Mult(14));
    
    \XOR2_PP5[7]\ : XOR2
      port map(A => MX2_22_Y, B => BUFF_40_Y, Y => \PP5[7]\);
    
    AND2_8 : AND2
      port map(A => XOR2_24_Y, B => BUFF_45_Y, Y => AND2_8_Y);
    
    MAJ3_0 : MAJ3
      port map(A => DFN1_2_Q, B => DFN1_13_Q, C => DFN1_76_Q, Y
         => MAJ3_0_Y);
    
    XNOR2_11 : XNOR2
      port map(A => DataB(2), B => BUFF_17_Y, Y => XNOR2_11_Y);
    
    AND2_98 : AND2
      port map(A => XOR2_41_Y, B => BUFF_25_Y, Y => AND2_98_Y);
    
    NOR2_0 : NOR2
      port map(A => XOR2_35_Y, B => XNOR2_2_Y, Y => NOR2_0_Y);
    
    MAJ3_11 : MAJ3
      port map(A => MAJ3_30_Y, B => MAJ3_3_Y, C => \PP6[1]\, Y
         => MAJ3_11_Y);
    
    XOR2_73 : XOR2
      port map(A => \SumA[11]\, B => \SumB[11]\, Y => XOR2_73_Y);
    
    AND2_41 : AND2
      port map(A => XOR2_22_Y, B => XOR2_17_Y, Y => AND2_41_Y);
    
    XOR2_44 : XOR2
      port map(A => \SumA[14]\, B => \SumB[14]\, Y => XOR2_44_Y);
    
    DFN1_31 : DFN1
      port map(D => MAJ3_21_Y, CLK => Clock, Q => DFN1_31_Q);
    
    \AND2_S[1]\ : AND2
      port map(A => XOR2_61_Y, B => DataB(3), Y => \S[1]\);
    
    AND2_132 : AND2
      port map(A => XOR2_70_Y, B => XOR2_47_Y, Y => AND2_132_Y);
    
    AND2_107 : AND2
      port map(A => \PP1[5]\, B => \PP0[7]\, Y => AND2_107_Y);
    
    \XOR2_PP1[4]\ : XOR2
      port map(A => MX2_33_Y, B => BUFF_17_Y, Y => \PP1[4]\);
    
    DFN1_27 : DFN1
      port map(D => XOR3_21_Y, CLK => Clock, Q => DFN1_27_Q);
    
    DFN1_68 : DFN1
      port map(D => \E[4]\, CLK => Clock, Q => DFN1_68_Q);
    
    BUFF_36 : BUFF
      port map(A => DataB(7), Y => BUFF_36_Y);
    
    DFN1_26 : DFN1
      port map(D => \PP5[12]\, CLK => Clock, Q => DFN1_26_Q);
    
    AND2_61 : AND2
      port map(A => DataB(0), B => BUFF_7_Y, Y => AND2_61_Y);
    
    AND2_143 : AND2
      port map(A => XOR2_43_Y, B => BUFF_33_Y, Y => AND2_143_Y);
    
    DFN1_58 : DFN1
      port map(D => XOR3_37_Y, CLK => Clock, Q => DFN1_58_Q);
    
    AO1_46 : AO1
      port map(A => XOR2_44_Y, B => AO1_0_Y, C => AND2_158_Y, Y
         => AO1_46_Y);
    
    MAJ3_22 : MAJ3
      port map(A => DFN1_62_Q, B => DFN1_34_Q, C => DFN1_63_Q, Y
         => MAJ3_22_Y);
    
    MX2_36 : MX2
      port map(A => AND2_16_Y, B => BUFF_7_Y, S => NOR2_6_Y, Y
         => MX2_36_Y);
    
    MX2_15 : MX2
      port map(A => AND2_136_Y, B => BUFF_7_Y, S => NOR2_7_Y, Y
         => MX2_15_Y);
    
    DFN1_29 : DFN1
      port map(D => MAJ3_29_Y, CLK => Clock, Q => DFN1_29_Q);
    
    \AND2_PP6[7]\ : AND2
      port map(A => BUFF_23_Y, B => BUFF_45_Y, Y => \PP6[7]\);
    
    AND2_25 : AND2
      port map(A => XOR2_66_Y, B => XOR2_60_Y, Y => AND2_25_Y);
    
    \AND2_S[2]\ : AND2
      port map(A => XOR2_23_Y, B => DataB(5), Y => \S[2]\);
    
    XOR2_63 : XOR2
      port map(A => \SumA[12]\, B => \SumB[12]\, Y => XOR2_63_Y);
    
    AND2_46 : AND2
      port map(A => XOR2_51_Y, B => BUFF_42_Y, Y => AND2_46_Y);
    
    AND2_84 : AND2
      port map(A => AND2_132_Y, B => XOR2_66_Y, Y => AND2_84_Y);
    
    NOR2_14 : NOR2
      port map(A => XOR2_39_Y, B => XNOR2_12_Y, Y => NOR2_14_Y);
    
    XOR2_69 : XOR2
      port map(A => \SumA[14]\, B => \SumB[14]\, Y => XOR2_69_Y);
    
    MX2_27 : MX2
      port map(A => AND2_148_Y, B => BUFF_29_Y, S => NOR2_12_Y, Y
         => MX2_27_Y);
    
    \AND2_PP6[4]\ : AND2
      port map(A => BUFF_23_Y, B => BUFF_1_Y, Y => \PP6[4]\);
    
    AO1_5 : AO1
      port map(A => XOR2_66_Y, B => AO1_35_Y, C => AND2_11_Y, Y
         => AO1_5_Y);
    
    DFN1_72 : DFN1
      port map(D => \PP1[3]\, CLK => Clock, Q => DFN1_72_Q);
    
    AND2_124 : AND2
      port map(A => DataB(0), B => BUFF_15_Y, Y => AND2_124_Y);
    
    XOR2_45 : XOR2
      port map(A => \SumA[6]\, B => \SumB[6]\, Y => XOR2_45_Y);
    
    AND2_66 : AND2
      port map(A => \PP5[6]\, B => \PP4[8]\, Y => AND2_66_Y);
    
    AO1_8 : AO1
      port map(A => AND2_44_Y, B => AO1_40_Y, C => AO1_23_Y, Y
         => AO1_8_Y);
    
    DFN1_63 : DFN1
      port map(D => MAJ3_16_Y, CLK => Clock, Q => DFN1_63_Q);
    
    \XOR2_PP2[3]\ : XOR2
      port map(A => MX2_39_Y, B => BUFF_32_Y, Y => \PP2[3]\);
    
    MX2_5 : MX2
      port map(A => AND2_145_Y, B => BUFF_43_Y, S => NOR2_1_Y, Y
         => MX2_5_Y);
    
    \XOR3_SumB[11]\ : XOR3
      port map(A => MAJ3_22_Y, B => DFN1_21_Q, C => XOR3_33_Y, Y
         => \SumB[11]\);
    
    XOR2_67 : XOR2
      port map(A => \SumA[10]\, B => \SumB[10]\, Y => XOR2_67_Y);
    
    DFN1_53 : DFN1
      port map(D => XOR3_20_Y, CLK => Clock, Q => DFN1_53_Q);
    
    XOR3_0 : XOR3
      port map(A => DFN1_39_Q, B => DFN1_40_Q, C => DFN1_44_Q, Y
         => XOR3_0_Y);
    
    AND2_121 : AND2
      port map(A => AND2_132_Y, B => AND2_25_Y, Y => AND2_121_Y);
    
    MX2_9 : MX2
      port map(A => AND2_26_Y, B => BUFF_15_Y, S => AND2A_0_Y, Y
         => MX2_9_Y);
    
    \XOR2_Mult[4]\ : XOR2
      port map(A => XOR2_26_Y, B => AO1_5_Y, Y => Mult(4));
    
    NOR2_4 : NOR2
      port map(A => XOR2_43_Y, B => XNOR2_3_Y, Y => NOR2_4_Y);
    
    AND2_97 : AND2
      port map(A => XOR2_35_Y, B => BUFF_34_Y, Y => AND2_97_Y);
    
    XOR3_5 : XOR3
      port map(A => DFN1_20_Q, B => DFN1_67_Q, C => DFN1_5_Q, Y
         => XOR3_5_Y);
    
    \XOR3_SumB[5]\ : XOR3
      port map(A => AND2_111_Y, B => DFN1_17_Q, C => XOR3_17_Y, Y
         => \SumB[5]\);
    
    VCC_power_inst1 : VCC
      port map( Y => VCC_power_net1);


end DEF_ARCH; 

-- _Disclaimer: Please leave the following comments in the file, they are for internal purposes only._


-- _GEN_File_Contents_

-- Version:11.8.3.6
-- ACTGENU_CALL:1
-- BATCH:T
-- FAM:PA3LDP
-- OUTFORMAT:VHDL
-- LPMTYPE:LPM_MULT
-- LPM_HINT:XBOOTHMULT
-- INSERT_PAD:NO
-- INSERT_IOREG:NO
-- GEN_BHV_VHDL_VAL:F
-- GEN_BHV_VERILOG_VAL:F
-- MGNTIMER:F
-- MGNCMPL:T
-- DESDIR:G:/ACTELL/EKB/EKB/Libero/smartgen\mult_x_x
-- GEN_BEHV_MODULE:F
-- SMARTGEN_DIE:IT14X14M4LDP
-- SMARTGEN_PACKAGE:fg484
-- AGENIII_IS_SUBPROJECT_LIBERO:T
-- WIDTHA:12
-- WIDTHB:12
-- REPRESENTATION:UNSIGNED
-- CLK_EDGE:RISE
-- MAXPGEN:0
-- PIPES:1
-- INST_FA:1
-- HYBRID:0
-- DEBUG:0

-- _End_Comments_

