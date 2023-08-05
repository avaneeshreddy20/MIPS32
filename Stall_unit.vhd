library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Stall_unit is
  Port (ID_EX_dmr,PCsrc: in std_logic;
        ID_EX_wr,IF_ID_rd1,IF_ID_rd2: in std_logic_vector(4 downto 0);
        IF_ID_CE,PC_CE,cen,IF_flush: out std_logic );
end Stall_unit;

architecture Behavioral of Stall_unit is
begin
process(ID_EX_dmr,ID_EX_wr,IF_ID_rd1,IF_ID_rd2,PCsrc)
begin
--load stall
    if(ID_EX_dmr='1' and (ID_EX_wr=IF_ID_rd1 or ID_EX_wr=IF_ID_rd2) ) then
        IF_ID_CE <= '1';    --clock enable signal for IF_ID_reg
        PC_CE <= '1';       --enable signal PC
    else
        IF_ID_CE <= '0';
        PC_CE <= '0';
    end if;
    
 --branch/jump stall
    if(PCsrc='1') then
        IF_flush <= '1';    --flush signal when branch is taken
    else 
        IF_flush <= '0';
    end if;  
    
 --load and branch stall    
    if((ID_EX_dmr='1' and (ID_EX_wr=IF_ID_rd1 or ID_EX_wr=IF_ID_rd2)) or PCsrc='1') then
        cen <= '1'; --control mux signal - controls set to zero so that no operation is performed
    else
        cen <= '0';
    end if;

end process;
end Behavioral;
