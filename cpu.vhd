-- Nguyen Kiem Hung
-- cpu : the top level entity

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use work.sys_definition.all;

-- 
entity cpu is
   Generic (
    DATA_WIDTH : integer   := 16;     -- Data Width
    ADDR_WIDTH : integer   := 16      -- Address width
    );
   port ( nReset   : in STD_LOGIC; -- low active reset signal
    	  start : in STD_LOGIC;    -- high active Start: enable cpu
          clk   : in STD_LOGIC;    -- Clock
	       Addr_out : out STD_LOGIC_VECTOR (ADDR_WIDTH-1 downto 0);
	       IR_in : in STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
	       ALU_out : out STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
     	   
     	   -- control signals for accessing to memory
     	   Mre, Mwe : out std_logic
     	    -- add ports as required here
        );
end cpu;


architecture struc of cpu is

-- declare internal signals here



begin

-- write your code here

  --ctrl_U: controller port map(?);
  --Dp_U: datapath port map(?);
  --Mem_U: dpmem port map (?);

							

end struc;




