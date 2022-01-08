
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use work.sys_definition.all;

entity datapath is
  Generic (
    DATA_WIDTH : integer   := 16;     -- Data Width
    ADDR_WIDTH : integer   := 16      -- Address width
    );
   port (
            nReset     : in STD_LOGIC;
            clk     : in STD_LOGIC;
	        imm     : in std_logic_vector(7 downto 0);
	        Data_in_1 : in std_logic_vector(DATA_WIDTH - 1 downto 0);
            Data_in_2 : in std_logic_vector(DATA_WIDTH - 1 downto 0);
            RFs : in STD_LOGIC_VECTOR(1 downto 0);
            RFwa, OPr1a, OPr2a : in STD_LOGIC_VECTOR(ADDR_WIDTH – 1 downto 0);
            RFwe, OPr1e, OPr2e : in STD_LOGIC;
            ALUs : in STD_LOGIC_VECTOR(1 downto 0);
            Data_out_opr1: out STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0);
            Data_out_opr2: out STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0);
            ALUz : out STD_LOGIC
        );
end datapath;

architecture struct of datapath is
  signal OPr1, OPr2 :
STD_LOGIC_VECTOR(15 downto 0);
    signal RFin :
STD_LOGIC_VECTOR(15 downto 0);
    Signal Data_in0 :  STD_LOGIC_VECTOR(DATA_WIDTH – 1 downto 0);
begin
-- write your code here

	--ALU_U: alu port map (?);
    ALU_U: ALU port map(
            OPr1 => OPr1,
            OPr2 => OPr2,
            ALUs => ALUs,
            ALUr => Data_in0,
            ALUz => ALUz
            );
  -- MUX_U: MUX3to1 port map(?);
  MUX_U : MUX3to1 port map(
        data_in1 => Data_in1,
        data_in2 => Data_in2,
        data_in0 => Data_in0,
        RFs => RFs,
        data_out => RFin);
        Data_out_opr1 <= Opr1;
        Data_out_opr2 <= Opr2;


           
  --RF_U: REG_FILE port map (?);
  RF_U:RF port map(
        clk => clk,
        reset => nReset,
        RFin => RFin,
        RFwa => RFwa,
        RFwe => RFwe,
        OPr1a => OPr1a,
        OPr1e => OPr1e,
        OPr2a => OPr2a,
        OPr2e => OPr2e,
        OPr1 => OPr1,
        OPr2 => OPr2
  )
 
end struct;


