library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;
use IEEE.numeric_std.all;

entity ALU is
  Port (FA,FB,imme: in std_logic_vector(31 downto 0);
        rt,rd: in std_logic_vector(4 downto 0);
        PC: in std_logic_vector(11 downto 0);
        ALUcontrol: in std_logic_vector(2 downto 0);
        ALUsrc,regdst,branch,jump: in std_logic;
        ALUresult: out std_logic_vector(31 downto 0);
        PCBranch: out std_logic_vector(31 downto 0);
        writereg: out std_logic_vector(4 downto 0);
        PCsrc: out std_logic );
end ALU;

architecture Behavioral of ALU is
signal zero: std_logic;
signal srcA,srcB,ALUresult1: std_logic_vector(31 downto 0);
begin
    -- setting PCbranch value adding PC with sign extended and left shifted by 2 immediate value for BEQ
    -- setting PCbranch value as left shifted by 2 immediate value
    -- setting PCbranch value as sourceRegister1 value for Jump Register 
    PCBranch <= FA when (branch ='1' and  jump ='1') else (X"00000" & PC) + (imme(29 downto 0) & "00") when branch='1' else (imme(29 downto 0) & "00") when jump='1' else (others=>'0');
    srcA <= FA;
    -- for Immediate instructions instead of FB imme value is taken
    srcB <= FB when ALUsrc='0' else imme;
    -- for Register instructions rd is considered as destination register, for Immediate instructions rt
    writereg <= rd when regdst='1' else rt;
    ALUresult <= ALUresult1;
    -- setting PCsrc value for jump and branch instructions
    PCsrc <= jump or (zero and branch);
    -- Setting zero flag 1 to indicate both inputs are same for BEQ and branch is taken 
    zero <= '1' when ALUresult1=X"00000000" else '0';
    process(srcA,srcB,ALUcontrol(2 downto 0))
    begin
        case(ALUcontrol(2 downto 0)) is 
            when "000" => ALUresult1 <= srcA + srcB;
            when "001" => ALUresult1 <= srcA - srcB;
            when "010" => ALUresult1 <= srcA xor srcB;--xor
            when "011" => ALUresult1 <= std_logic_vector(shift_right(unsigned(srcA),to_integer(unsigned(srcB(10 downto 6)))));--srl
            when "100" => ALUresult1 <= srcA nand srcB;
            when "101" => ALUresult1 <= srcA nor srcB;
            when others => ALUresult1 <= (others=>'0');        
        end case;    
    end process;    

end Behavioral;
