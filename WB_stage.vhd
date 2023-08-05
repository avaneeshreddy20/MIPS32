library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;

entity WB_stage is
  Port (readdata:in std_logic_vector(31 downto 0);
        ALUresult: in std_logic_vector(31 downto 0); 
        --PC: in std_logic_vector(11 downto 0);
        memreg: in std_logic;
        wr_dt: out std_logic_vector(31 downto 0));
end WB_stage;

architecture Behavioral of WB_stage is


begin

    wr_dt <= ((31 downto 16=>readdata(15)) & readdata(15 downto 0)) when memreg='1' else ALUresult; --load HW scenario

end Behavioral;
