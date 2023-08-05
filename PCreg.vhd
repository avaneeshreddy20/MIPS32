library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;

entity PCreg is
  Port (clk,rst,PCsrc,PC_CE:in std_logic;
        PCBranch:in std_logic_vector(11 downto 0);
        PC:out std_logic_vector(11 downto 0) );
end PCreg;

architecture Behavioral of PCreg is

signal PCPlus4, PC_reg, PC_mux:std_logic_vector(11 downto 0);

begin 
    PC <= PC_reg;
    PCPlus4 <= PC_reg+4;
    -- PC Mux for selecting Branch address for conditional instructions
    PC_mux <= PCBranch when PCsrc='1' else PCPlus4;  
    process(clk,rst)
    begin
        if(clk'event and clk='1') then
            if(rst='1') then
                PC_reg <= (others=>'0');
            elsif(PC_CE = '0') then
                PC_reg <= PC_mux;  
            end if;   
        end if;    
    end process;


end Behavioral;
