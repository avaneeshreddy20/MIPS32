library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Top_module is
  Port (clk,rst:in std_logic
            );
end Top_module;

architecture Behavioral of Top_module is

component PCreg
  Port (clk,rst,PCsrc,PC_CE:in std_logic;
        PCBranch:in std_logic_vector(11 downto 0);
        PC:out std_logic_vector(11 downto 0) );
end component;

component imem
port (
    PC  :  in std_logic_vector (11 downto 0); 
    instruction :  out std_logic_vector (31 downto 0)
  );
end component;

component mux_IF_ID
  Port (instr1: in std_logic_vector(31 downto 0);
        IF_flush: in std_logic;
        instr_mux: out std_logic_vector(31 downto 0) );
end component;

component Controller
    port(op, funct: in STD_LOGIC_VECTOR(5 downto 0);
        cen:in STD_LOGIC;
        memtoreg, memread, memwrite: out STD_LOGIC;
        alusrc: out STD_LOGIC;
        regdst, regwrite: out STD_LOGIC;
        jump,branch : out STD_LOGIC;
        alucontrol: out STD_LOGIC_VECTOR(2 downto 0));
end component;

component imme_gen
  Port (instr:in std_logic_vector(31 downto 0);
        imme:out std_logic_vector(31 downto 0) );
end component;

component regfile
  Port (clk,registerwrite:in std_logic;
        rd1,rd2,wr: in std_logic_vector(4 downto 0);
        wr_dt:in std_logic_vector(31 downto 0);
        dt1,dt2:out std_logic_vector(31 downto 0)
         );
end component;

component Stall_unit
  Port (ID_EX_dmr,PCsrc: in std_logic;
        ID_EX_wr,IF_ID_rd1,IF_ID_rd2: in std_logic_vector(4 downto 0);
        IF_ID_CE,PC_CE,cen,IF_flush: out std_logic );
end component;

component Forwarding
  Port (EX_MEM_rwr,MEM_WB_rwr,WB_FIN_rwr: in std_logic;
        EX_MEM_wr,MEM_WB_wr,WB_FIN_wr,ID_EX_rd1,ID_EX_rd2: in std_logic_vector(4 downto 0);
        ID_EX_d1,ID_EX_d2,EX_MEM_d,MEM_WB_d,WB_FIN_d: in std_logic_vector(31 downto 0);
        FA,FB: out std_logic_vector(31 downto 0) );
end component;

component ALU
  Port (FA,FB,imme: in std_logic_vector(31 downto 0);
        rt,rd: in std_logic_vector(4 downto 0);
        PC: in std_logic_vector(11 downto 0);
        ALUcontrol: in std_logic_vector(2 downto 0);
        ALUsrc,regdst,branch,jump: in std_logic;
        ALUresult: out std_logic_vector(31 downto 0);
        PCBranch: out std_logic_vector(31 downto 0);
        writereg: out std_logic_vector(4 downto 0);
        PCsrc: out std_logic );
end component;


component dmem
  port(
    memWrite,clk  : in std_logic;
    memRead       : in std_logic;
    address       : in std_logic_vector(9 downto 0);
    writeData     : in std_logic_vector(31 downto 0);
    readData      : out std_logic_vector(31 downto 0)
  );
end component;
  
component WB_stage
  Port (readdata:in std_logic_vector(31 downto 0);
        ALUresult: in std_logic_vector(31 downto 0); 
        memreg: in std_logic;
        wr_dt: out std_logic_vector(31 downto 0));
end component;


signal instr, instr1,readdata1,FA,FB,dt2,ALUresult,wr_dt,Address: std_logic_vector(31 downto 0);
signal PC: std_logic_vector(11 downto 0);
signal PCsrc,memreg,registerwrite,ALUsrc,regdst,datamemread,IF_ID_CE,PC_CE,cen,IF_flush,jmp: std_logic;
signal datamemwrite,branch: std_logic;
signal writereg: std_logic_vector(4 downto 0);
signal ALUcontrol: std_logic_vector(2 downto 0);
signal IF_ID_reg : std_logic_vector(43 downto 0); --Pipeline Buffer 1
signal ID_EX_reg : std_logic_vector(133 downto 0); --Pipeline Buffer 2
signal EX_MEM_reg : std_logic_vector(118 downto 0); --Pipeline Buffer 3
signal MEM_WB_reg : std_logic_vector(148 downto 0); --Pipeline Buffer 4
signal WB_FIN_reg : std_logic_vector(37 downto 0); --Pipeline Buffer 5

signal dt1,imme: std_logic_vector(31 downto 0);
signal PCBranch: std_logic_vector(31 downto 0);


begin



--PC
program_counter:PCreg port map(clk=>clk, rst=>rst, PCsrc=>PCsrc, PC=>PC, PC_CE=>PC_CE, PCBranch=>PCBranch(11 downto 0));

--instr mem
instruction_memory: imem port map(PC=>PC, instruction=>instr1);

--muxIF_ID
mux_no_op: mux_IF_ID port map(instr1=>instr1, IF_flush=>IF_flush, instr_mux=>instr);

--controller
control_unit:controller port map(op=>IF_ID_reg(31 downto 26), funct=>IF_ID_reg(5 downto 0), memwrite=>datamemwrite, regwrite=>registerwrite, ALUsrc=>ALUsrc, memread=>datamemread, regdst=>regdst,
     memtoreg=>memreg, ALUcontrol=>ALUcontrol, branch=>branch, cen=>cen, jump=>jmp);
    
--imme_gen
immediate_value_generator:imme_gen port map(instr=>IF_ID_reg(31 downto 0), imme=>imme);

--stall
stall_block:Stall_unit port map(ID_EX_dmr=>ID_EX_reg(128), PCsrc=>PCsrc, ID_EX_wr=>ID_EX_reg(4 downto 0), IF_ID_rd1=>IF_ID_reg(25 downto 21),
 IF_ID_rd2=>IF_ID_reg(20 downto 16), IF_ID_CE=>IF_ID_CE, PC_CE=>PC_CE, cen=>cen, IF_flush=>IF_flush);

--regfile
instruction_decode_reg:regfile port map(clk=>clk, registerwrite=>MEM_WB_reg(147), rd1=>IF_ID_reg(25 downto 21), rd2=>IF_ID_reg(20 downto 16),
 wr=>MEM_WB_reg(4 downto 0), wr_dt=>wr_dt, dt1=>dt1, dt2=>dt2);
       
--Forwarding
forwading_block:Forwarding port map(EX_MEM_rwr=>EX_MEM_reg(117), MEM_WB_rwr=>MEM_WB_reg(147), WB_FIN_rwr=>WB_FIN_reg(37), EX_MEM_wr=>EX_MEM_reg(4 downto 0),
 MEM_WB_wr=>MEM_WB_reg(4 downto 0), WB_FIN_wr=>WB_FIN_reg(4 downto 0), ID_EX_rd1=>ID_EX_reg(14 downto 10), ID_EX_rd2=>ID_EX_reg(9 downto 5),
ID_EX_d1=>ID_EX_reg(110 downto 79), ID_EX_d2=>ID_EX_reg(78 downto 47), EX_MEM_d=>EX_MEM_reg(100 downto 69), MEM_WB_d=>wr_dt, WB_FIN_d=>WB_FIN_reg(36 downto 5),
FA=>FA,FB=>FB);
    
--ALU
alu_unit:ALU port map(FA=>FA, FB=>FB, PC=>ID_EX_reg(122 downto 111), imme=>ID_EX_reg(46 downto 15), ALUcontrol=>ID_EX_reg(125 downto 123), 
ALUsrc=>ID_EX_reg(126), ALUresult=>ALUresult, branch=>ID_EX_reg(127), PCsrc=>PCsrc, PCBranch=>PCBranch, 
 jump=>ID_EX_reg(133), regdst=>ID_EX_reg(130), rt=>ID_EX_reg(9 downto 5) ,rd=>ID_EX_reg(4 downto 0), writereg=>writereg);

--data mem
data_memory:dmem port map(clk=>clk, memWrite=>EX_MEM_reg(114), memread=>EX_MEM_reg(113), address=>EX_MEM_reg(80 downto 71), writeData=>EX_MEM_reg(68 downto 37), readData=>readdata1);

--write back
writeback_block:WB_stage port map(readdata=>MEM_WB_reg(132 downto 101), ALUresult=>MEM_WB_reg(68 downto 37), memreg=>MEM_WB_reg(146), wr_dt=>wr_dt); 
-- storing values in buffer at each stage
process(clk, rst)
begin
    if(clk = '1' and clk'event) then
        if(rst = '1') then
            ID_EX_reg <= (others=>'0'); --rd,rs1,rs2,8control,4alu and rd1,rd2(15+8+4+64=91)
            EX_MEM_reg <= (others=>'0'); --alu result,data2,rd,registerwrite,lui,memreg,datamemwrite,datamemread(64+5+5=74)
            MEM_WB_reg <= (others=>'0'); --data,alurssult,rd, registerwrite,memreg,lui(64+5+3=72)
            WB_FIN_reg <= (others=>'0');
        else 
            ID_EX_reg <= jmp & registerwrite & memreg & regdst & datamemwrite & datamemread & branch & ALUsrc & ALUcontrol & IF_ID_reg(43 downto 32) & dt1 & dt2 & imme & IF_ID_reg(25 downto 21) & IF_ID_reg(20 downto 16) & IF_ID_reg(15 downto 11);
            --jmp(133) & registerwrite(132)+memreg(131)+regdst(130)+datamemwrite(129)+datamemread(128)+branch(127)+ALUsrc(126)+ALUcontrol(125:123)+PC(122:111)+dt1(110:79)+dt2(78:47)+imme(46:15)+rd1(14:10)+rd2(9:5)+wr(4:0)            
            EX_MEM_reg <= ID_EX_reg(133) & ID_EX_reg(132) & ID_EX_reg(131) & ID_EX_reg(130) & ID_EX_reg(129) & ID_EX_reg(128) & ID_EX_reg(122 downto 111) & ALUresult & FB & ID_EX_reg(46 downto 15) & writereg ;
            --  jmp(118) & registerwrite(117) & memreg(116) & regdst(115) & datamemwrite(114) & datamemread(113) & PC(112:101) &  ALUresult(100:69) & data2(68:37) & imme(36:5) & wr(4:0);
            MEM_WB_reg <= EX_MEM_reg(118) &  EX_MEM_reg(117) & EX_MEM_reg(116) & EX_MEM_reg(115) & EX_MEM_reg(112 downto 101) & readdata1 & EX_MEM_reg(36 downto 5) &  EX_MEM_reg(100 downto 69) & EX_MEM_reg(36 downto 5) & EX_MEM_reg(4 downto 0) ;
            --jmp(148) & registerwrite(147) & memreg(146) & lui(145) & PC(144:133) & readdata1(132:101)+imme(100:69) & ALUresult(68:37) & imme(36:5) & wr(4:0);
            WB_FIN_reg <= MEM_WB_reg(147) & wr_dt & MEM_WB_reg(4 downto 0);
            -- registerwrite(37) & wr_dt(36:5) &  wr(4:0);
        end if;

        
        if(rst = '1') then
            IF_ID_reg <= (others=>'0'); --PC & instr(32bit)
        elsif(IF_ID_CE = '0') then
            IF_ID_reg <= PC & instr;  
            --PC(43:32)+instr(31:0)  
        end if;    
    end if;
end process;
end Behavioral;

