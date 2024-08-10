# RISC-V Processor Core

This project implements a RISC-V processor core capable of executing instructions through a pipelined architecture. The processor initially uses 4 pipeline stages and is extended to 7 stages using a Finite State Machine (FSM).

### Pipeline Stages

Here's a refined version of that sentence:

The project expands on 4-stage pipeline of Fetch, Decode, Execute, and Write-Back by dividing it into more specific substages for more modularity

### 7-Stage Pipeline (FSM)
1. **Instruction Fetch**
2. **Instruction Decode**
3. **Read Register**
4. **Execute**
5. **Read Memory**
6. **Write Memory**
7. **Write Register**


### Submodules

The execution of pipeline stages is facilitated by several submodules, each responsible for specific operations:

- **Program Counter (PC)**
- **Instruction Fetch Unit (IFU)**
- **Instruction Decode Unit (IDU)**
- **Arithmetic Logic Unit (ALU)**
- **Register File (RF)**
- **Memory Access Unit (MAU)**

## Supported Instruction Types

The processor supports the following RISC-V instruction types, which are defined within the ALU:

- **R-Type**: Register-to-Register
- **I-Type**: Immediate Instructions (constant values)
- **U-Type**: Upper Immediate Instructions
- **B-Type**: Branching Operations
- **S-Type**: Memory Store
- **J-Type**: Jumping Operations
- **L-Type**: Memory Load 

