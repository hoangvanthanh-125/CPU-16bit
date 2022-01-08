LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_arith.ALL;

ENTITY datapath IS
 
	PORT (
		nReset : IN STD_LOGIC;
		clk : IN STD_LOGIC;
		Data_in_1 : IN std_logic_vector(15 DOWNTO 0);
		Data_in_2 : IN std_logic_vector(15 DOWNTO 0);
		RFs : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		RFwa, OPr1a, OPr2a : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
 
		RFwe, OPr1e, OPr2e : IN STD_LOGIC;
		ALUs : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		Data_out_opr1 : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
		Data_out_opr2 : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
		ALUz : OUT STD_LOGIC;
                ALUr: OUT  STD_LOGIC_VECTOR (15 DOWNTO 0)
	);
END datapath;

ARCHITECTURE struct OF datapath IS
	COMPONENT ALU IS
		PORT (
			OPr1 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			OPr2 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			ALUs : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
			ALUr : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			ALUz : OUT STD_LOGIC
		);
	END COMPONENT;
	COMPONENT MUX3to1 IS
		PORT (
			data_in0, data_in1 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			data_in2 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			RFs : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
			data_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
		);
	END COMPONENT;
 
	COMPONENT RF IS
		PORT (
			reset : IN STD_LOGIC;
			clk : IN STD_LOGIC;
			RFin : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
			RFwa : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
			RFwe : IN STD_LOGIC;
			OPr1a : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
			OPr1e : IN STD_LOGIC;
			OPr2a : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
			OPr2e : IN STD_LOGIC;
			OPr1 : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
			OPr2 : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
		);
	END COMPONENT;
 
	SIGNAL OPr1, OPr2 : 
	STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL RFin : 
	STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL Data_in0 : STD_LOGIC_VECTOR(15 DOWNTO 0);
BEGIN
	-- write your code here

	--ALU_U: alu port map (?);
	ALU_U : ALU
	PORT MAP(
		OPr1 => OPr1, 
		OPr2 => OPr2, 
		ALUs => ALUs, 
		ALUr => ALUr, 
		ALUz => ALUz
	);
	-- MUX_U: MUX3to1 port map(?);
 
	MUX_U : MUX3to1
	PORT MAP(
		data_in1 => Data_in_1, 
		data_in2 => Data_in_2, 
		data_in0 =>ALUr, 
		RFs => RFs, 
		data_out => RFin
	);
	Data_out_opr1 <= Opr1;
	Data_out_opr2 <= Opr2;
 
	--RF_U: REG_FILE port map (?);
	RF_U : RF
	PORT MAP(
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
	);

END struct;