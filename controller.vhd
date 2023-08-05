library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity controller is
    port(op, funct: in STD_LOGIC_VECTOR(5 downto 0);
        cen: in STD_LOGIC;
        memtoreg, memread, memwrite: out STD_LOGIC;
        alusrc: out STD_LOGIC;
        regdst, regwrite: out STD_LOGIC;
        jump,branch : out STD_LOGIC;
        alucontrol: out STD_LOGIC_VECTOR(2 downto 0));
end controller;

architecture Behavioral of controller is

signal controls: STD_LOGIC_VECTOR(10 downto 0);
begin
process(op,funct,cen) begin
    -- setting controls to zero to flush instructions fetched while branch taken
    if(cen='1') then
        controls <= (others=>'0');
    else 
        case op is
            when "000000" => controls(10 downto 4) <= "1100000"; -- RTYPE
                case funct is
                    when "100011" => controls(3 downto 0) <= "0001"; --subu
                    when "100110" => controls(3 downto 0) <= "0010"; --xor
                    when "000010" => controls(3 downto 0) <= "1011"; --srl
                    when others => controls(3 downto 0) <= "----";
                end case;    
            when "100001" => controls <= "10010101000"; -- LH
            when "101011" => controls <= "00001101000"; -- SW
            when "000100" => controls <= "00100100001"; -- BEQ
            when "001000" => controls <= "10000001000"; -- ADDI
            when "000010" => controls <= "00000010---"; -- J
            when "100010" => controls <= "00100010---"; -- JR
            when "101100" => controls <= "10000001100"; --nandi
            when "101101" => controls <= "10000001101"; --nori
            when others =>   controls <= "-----------"; -- illegal op
        end case;
    end if;
end process;

(regwrite, regdst, branch, memread, memwrite,memtoreg, jump, alusrc, alucontrol(2), alucontrol(1), alucontrol(0)) <= controls;

end Behavioral;
