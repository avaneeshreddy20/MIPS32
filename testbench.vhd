library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity testbench is
--  Port ( );
end testbench;

architecture Behavioral of testbench is

component Top_module is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC);
end component;

signal clk :std_logic;
signal rst :std_logic;

begin
    UUT:Top_module port map(clk=>clk, rst=>rst);

clock_p : process
    variable clk_tmp : std_logic :='0';
    begin
      clk_tmp := not clk_tmp;
      clk <= clk_tmp;
      wait for 50 ns;
  end process;

reset : process
  begin
    rst <= '1';
    wait for 1 ns;
    
    rst <= '0';
    wait;
end process;



end Behavioral;

