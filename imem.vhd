library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity imem is
  port(
    PC     : in std_logic_vector(11 downto 0);
    instruction      : out std_logic_vector(31 downto 0)
  );
end imem;
--instruction memory
architecture behavioral of imem is
  signal instruction1      : std_logic_vector(31 downto 0);
  type vector_of_mem is array(0 to 10) of std_logic_vector (31 downto 0);
  signal memory : vector_of_mem := ( 
        "10110100000000010000000000000001",--nori r1,r0,1    
        "00000000001000100001100001000010",--srl r3,r1,1     
        "00000000011001010010000000100110",--xor r4,r3,r5    
        "10110000100001110000000000000010",--nandi r7,r4,2   
        "00000001010001110100100000100011",--subu r9,r10,r7  
        "00100000111011000000000000000010",--addi r12,r7,3   
        "00010001110011110000000000000001",--beq r14,r15,1   
        "10000110001100000000000000000101",--lh r16,r17,5    
        "10101110010100110000000000000110",--sw r19,r20,6    
        "00001000000000000000000000001010",--j 10            
        "10001010100000000000000000001000"--jr r20           

        );
  begin
  process(PC) begin
  if(to_integer(unsigned(PC)) <44) then
    instruction <= memory(to_integer(unsigned(PC(11 downto 2))));
  else
    instruction <= (others=>'0');
  end if;
  end process;

end behavioral;
