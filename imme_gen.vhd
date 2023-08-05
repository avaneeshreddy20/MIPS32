library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity imme_gen is
  Port (instr:in std_logic_vector(31 downto 0);
        imme:out std_logic_vector(31 downto 0) );
end imme_gen;

architecture Behavioral of imme_gen is

begin
process(instr) begin
    --sign extending to 32 bit
    if(instr(31 downto 26)="000010") then   --jump
        if(instr(25)='1') then
            imme <= X"f" & "11" & instr(25 downto 0);
        else
            imme <= X"0" & "00" & instr(25 downto 0);
        end if;
    elsif(instr(31 downto 26)="001000" or instr(31 downto 26)="000100" or instr(31 downto 26)="100001" or instr(31 downto 26)="101011") then       --addi,beq,lw,sw  
        if(instr(15)='1') then
            imme <= X"ffff"  & instr(15 downto 0);
        else
            imme <= X"0000" & instr(15 downto 0);
        end if;
    else 
        imme <= X"0000" & instr(15 downto 0);
    end if;    
    
end process;

end Behavioral;
