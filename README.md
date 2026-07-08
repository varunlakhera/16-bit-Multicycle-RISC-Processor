# IITB-RISC CPU: Design and Implementation

## 1. Introduction
The IITB-RISC CPU is a custom 16-bit computing system designed primarily for teaching and educational purposes, based on the Little Computer Architecture. 
- **Datapath & Registers:** Features a 16-bit datapath and an 8-register general-purpose register file (`R0` to `R7`).
- **Flags:** Uses a Condition Code register to maintain Carry (C) and Zero (Z) flags.
- **Execution Model:** Implemented using a multicycle execution model (3 to 5 discrete clock cycles) managed by a centralized 5-state finite state machine (FSM).
- **Instruction Set:** Utilizes three primary instruction formats (R, I, and J types) across 14 instructions to solve complex logical and arithmetic workloads.

## 2. Top-Level Architecture
At the system level, the processor functions as a standalone unit comprising three primary modules instantiated within `cpu_top.v`:
- **Datapath (`datapath.v`)**: The computational core containing the Arithmetic Logic Unit (ALU), Register File, Program Counter, Instruction Counter, and routing multiplexers.
- **Controller (`controller.v`)**: The centralized 5-state FSM responsible for decoding instructions, resolving branches, and asserting control signals to route data through the datapath.
- **Memory (`memory.v`)**: A 64KB (65,536 addressable 16-bit words) storage module. It acts as a unified memory space, handling sequential writes and combinational reads for both program instructions and runtime data.

## 3. Instruction Set Architecture (ISA)
The CPU operates purely on a 16-bit instruction format. Upon power-up (reset), the Program Counter (PC) is initialized to `0000H`.

### 3.1 Instruction Formats
Instructions are divided into three architectural formats:
- **R-Type:** `Opcode [15:12] | RA [11:9] | RB [8:6] | RC [5:3] | Unused [2:0]`
- **I-Type:** `Opcode [15:12] | RA [11:9] | RB [8:6] | Immediate [5:0]`
- **J-Type:** `Opcode [15:12] | RA [11:9] | Immediate [8:0]`

### 3.2 Instruction Summary
*Note: `Imm6` represents a 6-bit immediate, `Imm8` an 8-bit immediate, and `Imm9` a 9-bit immediate.*

| Mnemonic | Encoding | Semantics |
| :--- | :--- | :--- |
| **ADD** | `0000 RA RB RC 000` | $RC = RA + RB$ |
| **SUB** | `0010 RA RB RC 000` | $RC = RA - RB$ |
| **MUL** | `0011 RA RB RC 000` | $RC = RA[3:0] \times RB[3:0]$ (Uses 4 LSBs) |
| **ADI** | `0001 RA RB Imm6` | $RB = RA + \text{sign\_extend}(Imm6)$ |
| **AND** | `0100 RA RB RC 000` | $RC = RA \text{ AND } RB$ |
| **ORA** | `0101 RA RB RC 000` | $RC = RA \text{ OR } RB$ |
| **IMP** | `0110 RA RB RC 000` | $RC = \text{NOT}(RA) \text{ OR } RB$ |
| **LHI** | `1000 RA 0+Imm8` | $RA[15:8] = Imm8$, $RA[7:0] = 0$ |
| **LLI** | `1001 RA 0+Imm8` | $RA[7:0] = Imm8$, $RA[15:8] = 0$ |
| **LW** | `1010 RA RB Imm6` | $RA = \text{Memory}[RB + Imm6]$ |
| **SW** | `1011 RA RB Imm6` | $\text{Memory}[RB + Imm6] = RA$ |
| **BEQ** | `1100 RA RB Imm6` | If $RA == RB$, branch to $PC + Imm6 \times 2$ |
| **JAL** | `1101 RA Imm9` | $RA = PC$, jump to $PC + Imm9 \times 2$ |
| **JLR** | `1111 RA RB 000_000`| $RA = PC$, jump to address in $RB$ |
| **J** | `1110 RA Imm9` | Jump unconditionally to $PC + Imm9 \times 2$ |

## 4. Control Module (FSM)
The Controller utilizes a rigid 5-state multicycle FSM (`FETCH`, `DECODE`, `EXECUTE`, `MEM_ACCESS`, `WRITEBACK`) to prevent structural hardware hazards:
1. **FETCH:** Asserts `pc_write`, `ir_load`, and `mem_read` to retrieve the instruction from memory at the address held in the Program Counter. Under normal non-branching conditions, the PC simply increases.
2. **DECODE:** Purely combinational logic that splits the 16-bit instruction to extract opcodes, register addresses, and immediates.
3. **EXECUTE:** The ALU crunches basic arithmetic and logic, asserting flags if conditions are met. For `BEQ` instructions, it compares the `zero_out` flag and asserts `pc_write` to execute a branch if the equality condition holds true.
4. **MEM_ACCESS:** Dedicated exclusively for Load (`LW`) and Store (`SW`) execution. Asserts the `mem_read` or `mem_write` flags, utilizing the ALU's output as the target memory address.
5. **WRITEBACK:** Operates multiplexers (`wb_src`, `reg_write_sel`) to safely push computed values—whether from the ALU, the Memory buffer, or immediate extensions—back into the Register File.

## 5. Datapath Modules
`datapath.v` handles the physical logic pathways. It instantiates the following hardware components:
- **ALU (`alu.v`):** The primary math engine. It accepts two 16-bit operands and processes data based on a 3-bit `alu_op` code. It calculates results and independently pushes out a `carry_out` signal and a `zero_out` signal.
- **Register File (`register_file.v`):** Houses the eight general-purpose memory registers. It allows for two simultaneous combinational reads on channels A and B, alongside a synchronous sequential write on the rising edge of the clock.
- **PC and IR Counters:** Separate modules (`pc_counter.v`, `instruction_counter.v`) designed to synchronously capture and hold the Program Counter and current Instruction word to keep the CPU stable across multicycle ticks.
- **Sign Extend (`sign_extend.v`):** Dynamically extends the truncated 6-bit or 9-bit immediate encodings from instructions into full 16-bit lengths based on the controller's `sign_ext_mode`.
- **Condition Code Register (`cc_register.v`):** Traps the `carry_flag` and `zero_flag` evaluated by the ALU. These states are strictly preserved and updated only when the controller explicitly asserts the `cc_update` flag during an active mathematical operation.

## 6. Simulation and Testing
This project is fully synthesizable and can be simulated using **Icarus Verilog (iverilog)** and visualized with **GTKWave**.

### 1. Compilation
To compile the CPU and its testbench, run your compiler command. Ensure `tb_cpu_top.v` explicitly includes or compiles alongside all sub-modules.

### 2. Execution
Run the compiled simulation to generate the VCD waveform file.

### 3. Waveform Visualization
Open the generated dump file in GTKWave:
> **Note:** In your testbench (`tb_cpu_top.v`), ensure you have `$dumpfile("cpu_waveform.vcd");` and `$dumpvars(0, tb_cpu_top);` included in the `initial` block.

## 7. Future Work: Pipelining
The current architecture has been extensively verified under a multicycle paradigm. Work is actively underway to transition the datapath to a **5-stage pipeline**.

**Phase 1 of this optimization includes:**
- Splitting unified memory into `instruction_memory.v` and `data_memory.v` to resolve structural hazards.
- Introducing pipeline registers (IF/ID, ID/EX, EX/MEM, MEM/WB).
- Optimizing throughput towards an ideal 1 Instruction-Per-Clock (IPC).
