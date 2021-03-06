
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_arith.ALL;

ENTITY cpu IS
	GENERIC (
		DATA_WIDTH : INTEGER := 16; -- Data Width
		ADDR_WIDTH : INTEGER := 16 -- Address width
	);
	PORT (
		nReset : IN STD_LOGIC; -- high active reset signal
		-- start : in STD_LOGIC; -- high active Start: enable cpu
		clk : IN STD_LOGIC; -- Clock
		Addr_out : OUT STD_LOGIC_VECTOR (ADDR_WIDTH - 1 DOWNTO 0);
		IR_in : IN STD_LOGIC_VECTOR (DATA_WIDTH - 1 DOWNTO 0);
		ALU_out : OUT STD_LOGIC_VECTOR (DATA_WIDTH - 1 DOWNTO 0);
		Mre, Mwe : OUT std_logic
	);
END cpu;
ARCHITECTURE struc OF cpu IS

	COMPONENT control_unit IS
		GENERIC (
			DATA_WIDTH : INTEGER := 16; -- Data Width
			ADDR_WIDTH : INTEGER := 16 -- Address width
		);
		PORT (-- you will need to add more ports here as design grows
			nReset : IN STD_LOGIC; -- high active reset signal
			-- start : IN STD_LOGIC; -- high active Start: enable cpu
			clk : IN STD_LOGIC; -- Clock
			IR_in : IN STD_LOGIC_VECTOR (DATA_WIDTH - 1 DOWNTO 0);
			data_in0 : IN STD_LOGIC_VECTOR (DATA_WIDTH - 1 DOWNTO 0);
			ALUz : IN STD_LOGIC;

			Addr_out : OUT STD_LOGIC_VECTOR (ADDR_WIDTH - 1 DOWNTO 0);
			RFs : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
			RFwa : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			RFwe : OUT STD_LOGIC;
			OPr1a : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			OPr1e : OUT STD_LOGIC;
			OPr2a : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			OPr2e : OUT STD_LOGIC;
			ALUs : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
			Mre : OUT STD_LOGIC;
			Mwe : OUT STD_LOGIC
		);

	END COMPONENT;

	COMPONENT dpmem IS
		GENERIC (
			DATA_WIDTH : INTEGER := 16; -- Word Width
			ADDR_WIDTH : INTEGER := 16 -- Address width
		);

		PORT (
			-- Writing
			Clk : IN std_logic; -- clock
			nReset : IN std_logic; -- Reset input
			addr : IN std_logic_vector(ADDR_WIDTH - 1 DOWNTO 0); -- Address
			-- Writing Port
			Wen : IN std_logic; -- Write Enable
			Datain : IN std_logic_vector(DATA_WIDTH - 1 DOWNTO 0) := (OTHERS => '0'); -- Input Data
			-- Reading Port
 
			Ren : IN std_logic; -- Read Enable
			Dataout : OUT std_logic_vector(DATA_WIDTH - 1 DOWNTO 0) -- Output data
 
			);
		END COMPONENT;

		COMPONENT datapath IS
			GENERIC (
				DATA_WIDTH : INTEGER := 16; -- Data Width
				ADDR_WIDTH : INTEGER := 16 -- Address width
			);
			PORT (
				nReset : IN STD_LOGIC;
				clk : IN STD_LOGIC;
				Data_in_1 : IN std_logic_vector(15 DOWNTO 0);
				Data_in_2 : IN std_logic_vector(DATA_WIDTH - 1 DOWNTO 0);
				RFs : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
				RFwa, OPr1a, OPr2a : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
				RFwe, OPr1e, OPr2e : IN STD_LOGIC;
				ALUs : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
				Data_out_opr1 : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
				Data_out_opr2 : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
				ALUz : OUT STD_LOGIC;
                ALUr: OUT  STD_LOGIC_VECTOR (15 DOWNTO 0)
			);
		END COMPONENT;
		SIGNAL RFs : STD_LOGIC_VECTOR(1 DOWNTO 0);
		SIGNAL RFwa : STD_LOGIC_VECTOR(3 DOWNTO 0);
		SIGNAL RFwe : STD_LOGIC;
		SIGNAL OPr1a : STD_LOGIC_VECTOR(3 DOWNTO 0);
		SIGNAL OPr1e : STD_LOGIC;
		SIGNAL OPr2a : STD_LOGIC_VECTOR(3 DOWNTO 0);
		SIGNAL OPr2e : STD_LOGIC;
		SIGNAL ALUs : STD_LOGIC_VECTOR(1 DOWNTO 0);
		SIGNAL IR_out : STD_LOGIC_VECTOR (15 DOWNTO 0);
		SIGNAL Data_out_opr1 : STD_LOGIC_VECTOR (15 DOWNTO 0);
		SIGNAL Data_out_opr2 : STD_LOGIC_VECTOR (15 DOWNTO 0);
		SIGNAL ALUz : STD_LOGIC;
        SIGNAL dataMemOut : STD_LOGIC_VECTOR (DATA_WIDTH - 1 DOWNTO 0);
	BEGIN
		--ctrl_U: controller port map(?);
		CONTROL_U :
		control_unit PORT MAP(
			nReset => nReset, 
			-- start : IN STD_LOGIC; -- high active Start: enable cpu
			clk => clk, 
			IR_in => IR_in, 
			data_in0 =>  Data_out_opr2, 
			ALUz => ALUz, 
			Addr_out => Addr_out, 
			RFs => RFs, 
			RFwa => RFwa, 
			RFwe => RFwe, 
			OPr1a => OPr1a, 
			OPr1e => OPr1e, 
			OPr2a => OPr2a, 
			OPr2e => OPr2e, 
			ALUs => ALUs, 
			Mre => Mre, 
			Mwe => Mwe
			);
            
			--Dp_U: datapath port map(?);
			DP_U : datapath PORT MAP(
			nReset => nReset, 
			clk => clk, 
			Data_in_1 => (x"00" & IR_out(7 DOWNTO 0)), 
			Data_in_2 => IR_in, 
			RFs => RFs, 
			RFwa => RFwa, 
			OPr1a => OPr1a, 
			OPr2a => OPr2a, 
			RFwe => RFwe, 
			OPr1e => OPr1e, 
			OPr2e => OPr2e, 
			ALUs => ALUs,
            Data_out_opr1 => Data_out_opr1, 
			Data_out_opr2 => Data_out_opr2, 
			ALUz => ALUz,
            ALUr => ALU_out
		);
		--Mem_U: dpmem port map (?);
		Mem_U : dpmem
		PORT MAP(
			Clk => clk, 
			nReset => nReset, 
			addr => Addr_out,
			Wen => Mwe, 
			Datain => Data_out_opr1, 
			Ren => Mre, 
			Dataout => dataMemOut
		);
      

 

END struc;