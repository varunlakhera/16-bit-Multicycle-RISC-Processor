| **ORA** | `0101 RA RB RC 000` | $RC = RA \text{ OR } RB$ |
| **IMP** | `0110 RA RB RC 000` | $RC = \text{NOT}(RA) \text{ OR } RB$ |
| **LHI** | `1000 RA 0+Imm8` | $RA[15:8] = Imm8$, $RA[7:0] = 0$ |
| **LLI** | `1001 RA 0+Imm8` | $RA[7:0] = Imm8$, $RA[15:8] = 0$ |
| **LW** | `1010 RA RB Imm6` | $RA = \text{Memory}[RB + Imm6]$ |
| **SW** | `1011 RA RB Imm6` | $\text{Memory}[RB + Imm6] = RA$ |
| **BEQ** | `1100 RA RB Imm6` | If $RA == RB$, branch to $PC + Imm6 \times 2$ |
| **JAL** | `1101 RA Imm9` | $RA = PC$, jump to $PC + Imm9 \times 2$ |
| **JLR** | `1111 RA RB 000_000` | $RA = PC$, jump to address in RB |
| **J** | `1110 RA Imm9` | Jump unconditionally to $PC + Imm9 \times 2$ |

## 4 Control Module (FSM)
The Controller has a 5 state multicycle FSM (FETCH, DECODE, EXECUTE, MEM ACCESS, WRITEBACK) to prevent structural hardware hazards:
1.  **FETCH**: Asserts `pc_write`, `ir_load`, and `mem_read` to retrieve the instruction from memory at the address held in the Program Counter. Under normal non-branching conditions, the PC simply increases.
2.  **DECODE**: Purely combinational logic that splits the 16-bit instruction to extract opcodes, register addresses, and immediates.
3.  **EXECUTE**: The ALU does basic arithmetic and logic operations and asserts flags if conditions are met. For BEQ instructions, it compares the `zero_out` flag and asserts `pc_write` to execute a branch if the equality condition holds true.
4.  **MEM ACCESS**: Dedicated exclusively for Load (LW) and Store (SW) execution. Asserts the `mem_read` or `mem_write` flags and uses the ALU's output as the target memory address.
5.  **WRITEBACK**: Operates multiplexers (`wb_src`, `reg_write_sel`) to safely store computed values from the ALU, the Memory, or immediate values into the Register File.

## 5 Datapath Modules
The `datapath.v` handles the physical logic pathways. It instantiates the following hardware components:
* **ALU (`alu.v`)**: It accepts two 16-bit operands and processes data based on a 3-bit `alu_op` code. It calculates results and independently pushes out a carry out signal and a zero out signal.
* **Register File (`register_file.v`)**: Has the eight general-purpose memory registers. It allows for two simultaneous combinational reads and one sequential write.
* **PC and IR Counters**: Separate modules designed to update the PC Counter and obtain Instruction from the Memory.
* **Sign Extend (`sign_extend.v`)**: Extends the truncated 6-bit or 9-bit immediate from instructions into full 16-bit lengths based on `sign_ext_mode`.
* **Condition Code Register (`cc_register.v`)**: Traps the carry flag and `zero_flag` evaluated by the ALU when the `cc_update` is high.
