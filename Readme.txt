# MIPS-processor

The purpose of this project is to develop a pipelined mini-MIPS processor capable for the following instruction set.
NORI, SRL, XOR, NANDI, SUBU, ADDI, BEQ, LH, SW, JR and J. 

## Usage 

Load the project in modelsim tool -> compile all files -> simulate the testbench
The instructions for executing the above variant are in the imem.vhd file. These instructions can be changed to test different scenarios.
Furthermore, values can be changed in registers(regfile.vhd) and data memory(dmem.vhd) for new results.


The modules used in MIPS pipelined design are as follows:

Top_module: Has all the required below modules.

PC_register: This block computes the PC value.

Inst_mem: Used to fetch the instruction of 32 bit.

Mux_IF_ID: This block is used to multiplex the original instrunction from inst_mem and nop instruction used for stalling when branch taken using the select signal IF_flush.

Control: This block decodes the control signals required for the instruction.

Imme_gen: This block computes the immediate value.

Register_file: Has set of 32 32-bit registers.

Stall_unit: This block computes the select signal for mux_IF_ID(IF_flush), control(cen) depending on the dependencies between the instructions and PCsrc.

ALU: Performs basic required given operations.

Forwarding: used to forward the data between the instructions to prevent the data hazards in pipeline.

Data_mem: Stores 32 32bit data.

WB_stage: It provides the data to be written to the register file and the corresponding write address and rwr.