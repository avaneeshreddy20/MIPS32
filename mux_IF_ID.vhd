library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux_IF_ID is
  Port (instr1: in std_logic_vector(31 downto 0);
        IF_flush: in std_logic;
        instr_mux: out std_logic_vector(31 downto 0) );
end mux_IF_ID;

architecture Behavioral of mux_IF_ID is

begin

--when the branch is taken the instruction is set to zero, i.e, no operation  

instr_mux <= x"00000000" when IF_flush='1' else instr1; 

end Behavioral;
