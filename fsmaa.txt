LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
ENTITY controller IS

	PORT (
		reset : IN STD_LOGIC;
		clk : IN STD_LOGIC;
		ALUz : IN STD_LOGIC;
		INSTR : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		RFs : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		RFwa : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		RFwe : OUT STD_LOGIC;
		OPr1a : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		OPr1e : OUT STD_LOGIC;
		OPr2a : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		OPr2e : OUT STD_LOGIC;
		ALUs : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		IRld : OUT STD_LOGIC;
		PCincr : OUT STD_LOGIC;
		PCclr : OUT STD_LOGIC;
		PCld : OUT STD_LOGIC;
		Ms : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		Mre : OUT STD_LOGIC;
		Mwe : OUT STD_LOGIC 
	);
END controller;

ARCHITECTURE controller OF controller IS
	TYPE state_type IS (NRESET, FETCH, LOADIR, INCPC, DECODE, MOV1, MOV1_1, MOV1_2, MOV2, MOV2_1, MOV2_2, 
	MOV3, MOV3_1, MOV3_2, MOV4, MOV4_1, ADD, ADD_1, SUB, SUB_1, SUB_2, 
	OR_0, OR_1, AND_0, AND_1, JZ, JZ_1, JMP, JMP_1);
	SIGNAL state : state_type;
	SIGNAL rn, rm, OPCODE : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL dir, imm, rel : STD_LOGIC_VECTOR(7 DOWNTO 0);
    
BEGIN
	rn <= INSTR(11 DOWNTO 8);
	rm <= INSTR(7 DOWNTO 4);
    dir <= INSTR(7 DOWNTO 0);
    imm <= INSTR(7 DOWNTO 0);
    rel <= INSTR(7 DOWNTO 0);
    
	OPCODE <= INSTR(15 DOWNTO 12);
	PROCESS (clk, reset, OPCODE)
	BEGIN
		IF reset = '1' THEN
			state <= NRESET;
		ELSIF clk'EVENT AND clk = '1' THEN
			CASE state IS
				WHEN NRESET => 
					state <= FETCH;
				WHEN FETCH => 
 
					state <= LOADIR;
				WHEN LOADIR => 
					state <= INCPC;
				WHEN INCPC => 
					state <= DECODE;
				WHEN DECODE => 
					CASE OPCODE IS
						WHEN "0000" => state <= MOV1;
						WHEN "0001" => state <= MOV2;
						WHEN "0010" => state <= MOV3;
						WHEN "0011" => state <= MOV4;
						WHEN "0100" => state <= ADD;
						WHEN "0101" => state <= SUB;
						WHEN "0110" => state <= JZ;
						WHEN "0111" => state <= OR_0;
						WHEN "1000" => state <= AND_0;
						WHEN OTHERS => state <= JMP;
				END CASE;
				WHEN MOV1 => 
 
					state <= MOV1_1;
				WHEN MOV1_1 => 

					state <= FETCH;
				WHEN MOV2 => 

					state <= MOV2_1;
				WHEN MOV2_1 => 

					state <= FETCH;
				WHEN MOV3 => 

					state <= MOV3_1;
				WHEN MOV3_1 => 
					state <= FETCH;
				WHEN MOV4 => 

					state <= FETCH;
				WHEN ADD => 

					state <= ADD_1;
				WHEN ADD_1 => 

					state <= FETCH;
			
				WHEN SUB => 
 
					state <= SUB_1;
				WHEN SUB_1 => 
					state <= FETCH;

				WHEN JZ => 
					state <= JZ_1;
				WHEN JZ_1 => 
					state <= FETCH;
				WHEN OR_0 => 
					state <= OR_1;
				WHEN OR_1 => 
					state <= FETCH;
				WHEN AND_0 => 
					state <= AND_1;
				WHEN AND_1 => 
					state <= FETCH;
				WHEN JMP => 
					state <= JMP_1;
				WHEN JMP_1 => 
					state <= FETCH;
				WHEN OTHERS => State <= FETCH;
			END CASE;
		END IF;
	END PROCESS;
	PCClr <= '1' WHEN (State = NRESET) ELSE '0';
	PCincr <= '1' WHEN (State = INCPC) ELSE '0';
	WITH State SELECT PCld <= ALUz WHEN JZ_1, 
	                          '1' WHEN JMP_1, 
	                          '0' WHEN OTHERS;

	IRld <= '1' WHEN (state = LOADIR) ELSE '0';

	WITH State SELECT Ms <= "10" WHEN Fetch, 
	                        "01" WHEN MOV1 | MOV2_1, 
	                        "00" WHEN MOV3_1, 
	                        "11" WHEN OTHERS;
	WITH State SELECT Mre <= '1' WHEN Fetch | MOV1, 
	                         '0' WHEN OTHERS;
	WITH State SELECT Mwe <= '1' WHEN MOV2_1 | MOV3_1, 
	                         '0' WHEN OTHERS;

	WITH State SELECT RFs <= "10" WHEN MOV1_1, 
	                         "01" WHEN MOv4, 
	                         "00" WHEN ADD_1 | SUB_1 | OR_1 | AND_1, 
	                         "11" WHEN OTHERS;
	WITH State SELECT RFwe <= '1' WHEN MOV1_1 | MOv4 | ADD_1 | SUB_1 | OR_1 | AND_1, 
	                          '0' WHEN OTHERS;
	WITH State SELECT RFwa <= rn WHEN MOV1_1 | MOv4 | ADD_1 | SUB_1 | OR_1 | AND_1, 
	                          "0000" WHEN OTHERS;
	WITH State SELECT OPr1e <= '1' WHEN MOV2 | MOV3 | ADD | SUB | JZ | JMP | OR_0 | AND_0, 
	                           '0' WHEN OTHERS;
	WITH State SELECT OPr1a <= rn WHEN MOV2 | MOV3 | ADD | SUB | JZ | JMP | OR_0 | AND_0, 
	                           "0000" WHEN OTHERS;
	WITH State SELECT OPr2e <= '1' WHEN MOV3 | ADD | SUB | OR_0 | AND_0, 
	                           '0' WHEN OTHERS;
	WITH State SELECT OPr2a <= rm WHEN MOV3 | ADD | SUB | OR_0 | AND_0, 
	                           "0000" WHEN OTHERS;
	WITH State SELECT ALUs <= "00" WHEN ADD, 
	                          "01" WHEN SUB, 
	                          "10" WHEN OR_0, 
	                          "11" WHEN OTHERS;

END controller;