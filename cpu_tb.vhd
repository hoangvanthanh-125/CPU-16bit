LIBRARY ieee;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_1164.ALL;
USE ieee.STD_LOGIC_UNSIGNED.ALL;

USE std.textio.ALL;

ENTITY cpu_tb IS

END cpu_tb;

ARCHITECTURE behavior OF cpu_tb IS
	COMPONENT cpu IS
 
		PORT (
			nReset : IN STD_LOGIC; -- high active reset signal
			-- start : in STD_LOGIC; -- high active Start: enable cpu
			clk : IN STD_LOGIC; -- Clock
			Addr_out : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
			IR_in : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
			ALU_out : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
			Mre, Mwe : OUT std_logic
		);
	END component;
	CONSTANT CLKTIME : TIME := 20 ns;
	SIGNAL clk : std_logic := '0';
	SIGNAL nReset : std_logic := '0';
	SIGNAL Addr_out : STD_LOGIC_VECTOR (15 DOWNTO 0);
	SIGNAL IR_in : STD_LOGIC_VECTOR (15 DOWNTO 0);
	SIGNAL ALU_out : STD_LOGIC_VECTOR (15 DOWNTO 0);
	SIGNAL Mre, Mwe : std_logic;
BEGIN
	-- write your code here
	clk <= NOT clk AFTER CLKTIME/2;
	CPU_U : cpu
	PORT MAP(
		nReset => nReset, 
		clk => clk, 
		Addr_out => Addr_out, 
		ALU_out => ALU_out, 
		Mre => Mre, 
		Mwe => Mwe, 
		IR_in => IR_in
	);
 
	-- X"0003", -- Mov R0,3 => RF0 = M(3)
	-- X"1007" -- Mov 7,R0 => M(7) = RF0
	-- X"2230", -- M[ RF[2] ] = RF[3]
	-- X"3415", -- RF[4] = 21 -- mov4
	-- X"4450", -- add RF[4] = RF[4] + RF[5]
	-- X"5780", -- SUB RF[7] = RF[7] - RF[8]
	-- X"6812", -- jump 18 if RF[8] = 0
	-- X"7670", -- OR RF[6] = RF[6] OR RF[6] -- or
	-- X"8700", -- AND RF[7] = RF[7] AND RF[0] :AND
	-- X"9511" -- jum to 17
 
	stimuli_proc : PROCESS
	BEGIN
		-- Reset generation
 
		nReset <= '0';
		IR_in <= (OTHERS => '0');
		WAIT FOR 50 ns; 
		IR_in <= X"0003";
		WAIT FOR 20 ns;
		IR_in <= X"1007";
		WAIT FOR 40 ns;
		nReset <= '1';
		WAIT FOR 10 ns;
 
		IR_in <= X"0003";
		WAIT FOR 20 ns;
		IR_in <= X"1007";
		WAIT FOR 20 ns;
		IR_in <= X"2230";
		WAIT FOR 20 ns;
		IR_in <= X"3415";
		WAIT FOR 20 ns;
		IR_in <= X"4450";
		WAIT FOR 20 ns;
		IR_in <= X"5780";
		WAIT FOR 20 ns;
		IR_in <= X"6812";
		WAIT FOR 20 ns;
		IR_in <= X"7670";
		WAIT FOR 20 ns;
		IR_in <= X"8700";
		WAIT FOR 20 ns;
		IR_in <= X"9511";
		WAIT FOR 20 ns;
 end process stimuli_proc; 
END behavior;