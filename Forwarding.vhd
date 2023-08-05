library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Forwarding is
  Port (EX_MEM_rwr,MEM_WB_rwr,WB_FIN_rwr: in std_logic;
        EX_MEM_wr,MEM_WB_wr,WB_FIN_wr,ID_EX_rd1,ID_EX_rd2: in std_logic_vector(4 downto 0);
        ID_EX_d1,ID_EX_d2,EX_MEM_d,MEM_WB_d,WB_FIN_d: in std_logic_vector(31 downto 0);
        FA,FB: out std_logic_vector(31 downto 0) );
end Forwarding;

architecture Behavioral of Forwarding is
begin
process(EX_MEM_rwr,MEM_WB_rwr,EX_MEM_wr,MEM_WB_wr,ID_EX_rd1,ID_EX_rd2,ID_EX_d1,ID_EX_d2,EX_MEM_d,MEM_WB_d,WB_FIN_rwr,WB_FIN_wr,WB_FIN_d)
begin
    if(EX_MEM_rwr='1' and EX_MEM_wr/="00000" and EX_MEM_wr=ID_EX_rd1) then -- Forwading for next instruction
        FA <= EX_MEM_d;
    elsif(MEM_WB_rwr='1' and MEM_WB_wr/="00000" and MEM_WB_wr=ID_EX_rd1) then -- Forwading for next instruction+1
        FA <= MEM_WB_d;
    elsif(WB_FIN_rwr='1' and WB_FIN_wr/="00000" and WB_FIN_wr=ID_EX_rd1) then -- Forwading for next instruction+2
        FA <= WB_FIN_d;
    else
        FA <= ID_EX_d1;    
    end if;  
    
    if(EX_MEM_rwr='1' and EX_MEM_wr/="00000" and EX_MEM_wr=ID_EX_rd2) then -- Forwading for next instruction
        FB <= EX_MEM_d;
    elsif(MEM_WB_rwr='1' and MEM_WB_wr/="00000" and MEM_WB_wr=ID_EX_rd2) then -- Forwading for next instruction+1
        FB <= MEM_WB_d;
    elsif(WB_FIN_rwr='1' and WB_FIN_wr/="00000" and WB_FIN_wr=ID_EX_rd2) then -- Forwading for next instruction+2
        FB <= WB_FIN_d;
    else
        FB <= ID_EX_d2;    
    end if;        
end process;

end Behavioral;
