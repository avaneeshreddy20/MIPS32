library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;


entity regfile is
  Port (clk,registerwrite:in std_logic;
        rd1,rd2,wr: in std_logic_vector(4 downto 0);
        wr_dt:in std_logic_vector(31 downto 0);
        dt1,dt2:out std_logic_vector(31 downto 0)
         );
end regfile;

architecture Behavioral of regfile is

type vector_of_mem is array(0 to 31) of std_logic_vector (31 downto 0); --Define the memory of the registers (5 bit for readRegister : 128 byte register memory)
signal registersMem: vector_of_mem := (                                 --Initialize the value in the registers 
        "00000000000000000000000000000010", --0 
        "00000000000000000000000000000001", 
        "00000000000000000000000000000011", 
        "00000000000000000000000000000011", 
        "00000000000000000000000000000000", 
        "00000000000000000000000000011111", --5
        "00000000000000000000000000001010",
        "00000000000000000000000000000000",
        "00000000000000000000000000011010",
        "00000000000000000000000000001101",
        "00000000000000000000000000000000", --10
        "00000000000000000000000000001101",
        "00000000000000000000000000011100",
        "00000000000000000000000000000000",
        "00000000000000000000000000000001",
        "00000000000000000000000000000010", --15
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000001100", --20
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000", --25
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000", --30
        "00000000000000000000000000000000"
    );
signal zero: std_logic;
begin    
    dt1 <= registersMem(to_integer(unsigned(rd1)));
    dt2 <= registersMem(to_integer(unsigned(rd2)));
    process(clk,registerwrite,wr_dt)
    begin
        if(clk'event and clk='1') then
            if(registerwrite='1' and wr/="00000") then
                registersMem(to_integer(unsigned(wr)))<=wr_dt;   
            end if; 
        end if;    
    end process;


end Behavioral;
