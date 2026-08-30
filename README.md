# RV32I Processor in Verilog
 
A from-scratch RV32I RISC-V CPU built in Verilog, implemented in three progressively more complex versions: **single-cycle**, **multi-cycle**, and **5-stage pipelined**.
 
## What's implemented
 
### Single-cycle
Every instruction fetches, decodes, executes, accesses memory, and writes back in one clock cycle.
 
**Modules:** fetch_stage (PC register, PC adders, instruction memory), decoder, control_unit, register (register file), ALU, data_mem
 
### Multi-cycle
Each instruction takes a variable number of clock cycles (3–5) depending on its type, sequenced by an explicit finite state machine. Branches complete in 3 cycles, most instructions in 4, loads in 5. A single physical ALU, register file, and memory are reused across states rather than duplicated.
 
**Modules:** state_reg (FSM), instr_reg, ab_reg, alu_reg, mdr, pc_ctrl, pc_snapshot_reg, reg_control_logic (state-gated control unit), plus the shared decoder, register, ALU, data_mem
 
### Pipelined (5-stage)
Instructions flow through Fetch, Decode, Execute, Memory, and Writeback stages simultaneously — multiple instructions in flight at once, one entering the pipeline every cycle. Includes hazard handling to keep results correct despite the overlap:
 
- **Data hazard forwarding** — routes results from the EX/MEM or MEM/WB pipeline stage directly into the ALU, avoiding stale register reads
- **Load-use hazard stalling** — inserts a one-cycle stall when an instruction needs a value from a load that hasn't finished yet
- **Control hazard flushing** — discards incorrectly fetched instructions when a branch or jump is resolved as taken
**Modules:** if_id_reg, id_ex_reg, ex_mem_reg, mem_wb_reg (pipeline registers), load_hazard_ctrl, forward_unit, flush_logic, plus the shared decoder, register (with a write-first same-cycle bypass), ALU, data_mem
 
## Instruction coverage (all three versions)
 
| Category | Instructions |
|---|---|
| R-type | ADD, SUB, XOR, OR, AND, SLL, SRL, SRA, SLT, SLTU |
| I-type ALU | ADDI, SLTI, SLTIU, XORI, ORI, ANDI, SLLI, SRLI, SRAI |
| Memory | LW, SW |
| Branch | BEQ, BNE, BLT, BGE, BLTU, BGEU |
| Jump | JAL, JALR |
| Upper immediate | LUI, AUIPC |
 
## Verification
 
Each version was tested against hand-assembled RISC-V programs using Xilinx Vivado, with testbenches checking final register values against expected results. The pipelined version was additionally tested against adversarial instruction sequences targeting each hazard type specifically (back-to-back dependent instructions, load-immediately-followed-by-use, and taken branches with instructions that must never execute).
