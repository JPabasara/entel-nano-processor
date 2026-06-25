<!--
  📸 IMAGE PLACEHOLDER — banner.png (optional)
  Add an optional title/banner graphic for the project here.
  Place the file at: docs/images/banner.png
-->
<!-- ![E-ntel Nano Processor](docs/images/banner.png) -->

# E-ntel Nano Processor

A **4-bit nano processor** designed in VHDL and implemented on the **Digilent Basys 3 (Xilinx Artix-7)** FPGA board. The project is a structural, bottom-up CPU built from individual logic blocks (half/full adders, ripple-carry adders, multiplexers, decoders, registers) all the way up to a working processor that fetches, decodes and executes instructions from an on-chip program ROM.

The repository ships **two variants** of the design:

| Variant | Folder | Highlights |
| ------- | ------ | ---------- |
| **Base E-ntel Processor** | [`base-processor/`](base-processor/) | Implements exactly the lab specification. Shows register **R7** in two's-complement on the **leftmost 7-segment digit** and on **LEDs U16–V19**. |
| **E-ntel Processor Pro** | [`pro-processor/`](pro-processor/) | Adds **time-multiplexed 4-digit display** and creative enhancements (absolute value + minus sign, live ROM address tracking, output/register toggle switch). |

> [!NOTE]
> The single most important difference between the two versions is that **Pro introduces digital (time) multiplexing to drive all four seven-segment digits**, whereas Base statically drives a single digit.

---

## Table of Contents

- [Features](#features)
- [Repository Structure](#repository-structure)
- [Architecture](#architecture)
- [Instruction Set Architecture (ISA)](#instruction-set-architecture-isa)
- [Base vs. Pro](#base-vs-pro)
- [Board I/O & Pin Mapping](#board-io--pin-mapping)
- [Getting Started](#getting-started)
- [Simulation & Testbenches](#simulation--testbenches)
- [Screenshots](#screenshots)
- [Team](#team)
- [License](#license)

---

## Features

- Fully **structural VHDL** design — every block (HA, FA, RCA, mux, decoder, register) is built up by hand and composed hierarchically.
- **8 × 4-bit register bank** with a hard-wired zero register (`R0`).
- **4-bit ripple-carry Adder/Subtractor ALU** with `Zero` and signed `Overflow` flags.
- **8 × 12-bit Program ROM** holding the instruction sequence.
- **Program Counter + increment unit** with conditional **jump-if-zero** support.
- **Clock divider** (`Slow_Clk`) so execution is slow enough to observe on the board.
- Seven-segment value display in **two's-complement** with status **LEDs** for `Jump`, `Zero`, `Overflow`.
- **Pro extras:** absolute-value display, dedicated minus-sign digit, current/next ROM address digits, and a switch to toggle between the final output and `R7`.

---

## Repository Structure

```
entel-nano-processor/
├── README.md                  ← you are here
├── LICENSE                    ← MIT
├── .gitignore                 ← ignores all Vivado-generated artifacts
│
├── docs/
│   ├── E-ntel-Lab-Report.pdf  ← full lab report
│   ├── Instructions.txt       ← summary of the two designs' behaviour
│   └── images/                ← screenshots / diagrams (see images/README.md)
│
├── base-processor/            ← Base E-ntel Processor
│   ├── src/                   ← VHDL design sources
│   ├── sim/                   ← VHDL testbenches
│   └── constraints/           ← Basys 3 .xdc pin constraints
│
└── pro-processor/             ← E-ntel Processor Pro
    ├── src/                   ← VHDL design sources (incl. Display.vhd, Nano_Processor.vhd)
    ├── sim/                   ← VHDL testbenches
    └── constraints/           ← Basys 3 .xdc pin constraints
```

> Only **source files** (`.vhd`, `.xdc`) are tracked. The Vivado project (`.xpr`), caches,
> runs, simulation binaries, bitstreams and logs are intentionally **not** committed — they are
> fully regenerated from these sources (see [Getting Started](#getting-started)).

---

## Architecture

<!--
  📸 IMAGE PLACEHOLDER — block-diagram.png
  Add the top-level datapath block diagram here.
  Place the file at: docs/images/block-diagram.png
  It should show the flow: Slow_Clk → PC Increment Unit → Program ROM →
  Instruction Decoder → Register Bank → ALU → Data Mux → Display.
-->
![Top-level block diagram](docs/images/block-diagram.png)

The processor follows a classic fetch → decode → execute datapath:

1. **`Slow_Clk`** divides the 100 MHz board clock down to a human-observable rate.
2. **`PC_Increment_Unit`** holds the Program Counter and computes the next address (PC + 1, or a jump target when `Jump_Flag` is asserted).
3. **`Program_ROM`** outputs the 12-bit instruction at the current address.
4. **`Instruction_Decoder`** breaks the instruction into control signals (register selects, write enables, immediate, add/sub select, jump address/flag).
5. **`Reg_Bank`** (8 × 4-bit) provides operands and stores write-back results; `R0` is a read-only zero register.
6. **`Arithmetic_Unit`** selects two registers via 8-way muxes and feeds them to the **`Add_Sub_Unit`**, producing the result plus `Zero` and `Overflow` flags.
7. A **2-way mux** chooses the write-back source: ALU result *or* immediate value.
8. The selected value is rendered on the seven-segment display via the **`LUT_16_7`** decoder (Base) / **`Display`** multiplexer (Pro).

### Module overview

| Module | Role |
| ------ | ---- |
| `HA`, `FA` | Half adder / full adder primitives |
| `RCA_3`, `RCA_4` | 3-bit / 4-bit ripple-carry adders |
| `Add_Sub_Unit` | 4-bit two's-complement adder/subtractor (`Sum = B + (A⊕Cin) + Cin`) with Zero & Overflow |
| `Mux_2_way_3_bit`, `Mux_2_way_4_bit`, `Mux_8_way_4_bit` | Datapath multiplexers |
| `Decoder_2_to_4`, `Decoder_3_to_8` | Address/select decoders |
| `Register`, `Reg_Zero`, `Reg_Bank` | 4-bit register, hard-wired zero register, 8-register bank |
| `Program_Counter`, `PC_Increment_Unit` | PC storage and next-address logic with jump support |
| `Program_ROM` | 8 × 12-bit instruction memory |
| `Instruction_Decoder` | Instruction → control-signal mapping |
| `Arithmetic_Unit` | Operand muxing + ALU |
| `Slow_Clk` | Clock divider |
| `LUT_16_7` | 4-bit value → 7-segment pattern decoder |
| `Seven_Seg` *(Base)* | Single-digit seven-segment driver |
| `Display` *(Pro)* | **4-digit time-multiplexed** seven-segment driver |
| `Nano_Processor` *(Pro)* | Core CPU wrapper exposing ALU output, R7, and current/next address |
| `Base_E-ntel_Processor` / `E-ntel_Processor_Pro` | Top-level entities |

---

## Instruction Set Architecture (ISA)

Each instruction is **12 bits** wide. The top two bits select the operation; the remaining bits encode register selects, an immediate, or a jump address.

```
 11 10 | 9  8  7 | 6  5  4 | 3  2  1  0
 ------+---------+---------+------------
 op    |  Rd     |  Rb     |  immediate
       | (RegA)  | (RegB)  |  / jump addr (bits 2..0)
```

- `Instruction(11)` doubles as the **write-back source select** (`0` = ALU result, `1` = immediate).
- `Rd` (`RegSelA`, bits 9–7) is both the first ALU operand and the **destination** register (write-back is gated off during a jump).
- `Rb` (`RegSelB`, bits 6–4) is the second ALU operand.
- For `MOVI`, the 4-bit immediate is bits 3–0. For `JZR`, the jump target is bits 2–0.

| Opcode `[11:10]` | Mnemonic | Operation | Notes |
| ---------------- | -------- | --------- | ----- |
| `00` | `ADD Rd, Rb` | `Rd ← Rb + Rd` | `Cin = 0` (add) |
| `01` | `NEG Rd` | `Rd ← 0 − Rd` | `Cin = 1` (subtract), `Rb` defaults to `R0 = 0` → two's-complement negate |
| `10` | `MOVI Rd, imm` | `Rd ← imm` | 4-bit signed immediate loaded directly |
| `11` | `JZR addr` | `if (Zero) PC ← addr` else `PC ← PC + 1` | conditional jump-if-zero; no register write-back |

### Example program (default `Program_ROM`)

The ROM ships with a short demo that loops using the zero flag and finally displays `6` in `R7`:

```asm
0: MOVI R1, 1     ; R1 = 1
1: MOVI R2, 2     ; R2 = 2
2: ADD  R7, R1    ; R7 += R1
3: ADD  R1, R1    ; R1 += R1
4: NEG  R2        ; R2 = -R2
5: ADD  R2, R1    ; R2 += R1   (loop control toward 0)
6: JZR  2         ; if Zero, jump back to address 2
7: MOVI R7, 6     ; show R7 = 6
```

> Edit `src/Program_ROM.vhd` (in either variant) to run your own program.

---

## Base vs. Pro

| Aspect | Base E-ntel Processor | E-ntel Processor Pro |
| ------ | --------------------- | -------------------- |
| Seven-segment display | **Single** (leftmost) digit, statically driven (`AN = "1110"`) | **All four** digits, **time-multiplexed** (`Display.vhd`) |
| Displayed value | `R7` in two's-complement | Digit 1: **absolute value** of the selected value |
| Sign indication | (sign via LEDs only) | Digit 2: shows a **minus sign** when the value is negative |
| Address visibility | — | Digit 3: **current** ROM address; Digit 4: **next** ROM address |
| Output selection | Always `R7` | **V17 switch** toggles between final output (all-out) and `R7` |
| LEDs U16–V19 | `R7` (two's-complement) | Selected value (two's-complement) |
| Flags (LEDs) | `Jump` = P1, `Zero` = N3, `Overflow` = L1 | same |
| Reset | **U18** button | **U18** button |

The Pro core (`Nano_Processor`) additionally exposes the ALU output and the current/next program-counter values so the `Display` unit can show live address information.

---

## Board I/O & Pin Mapping

Target board: **Digilent Basys 3** — Xilinx Artix-7 `xc7a35tcpg236-1`, 100 MHz onboard clock (`W5`).

| Signal | Direction | Basys 3 pins | Description |
| ------ | --------- | ------------ | ----------- |
| `Clk` | in | `W5` | 100 MHz system clock |
| `Reset` | in | `U18` (BTNC) | Synchronous reset |
| `SW` *(Pro only)* | in | `V17` (SW0) | Toggle: final output ⇄ `R7` |
| `Value_Out[3:0]` | out | `U16`, `E19`, `U19`, `V19` (LD0–LD3) | Displayed value in two's-complement |
| `Jump` | out | `P1` (LD13) | Jump flag |
| `Zero` | out | `N3` (LD14) | Zero flag |
| `OverFlow` | out | `L1` (LD15) | Signed overflow flag |
| `SEG[6:0]` | out | `W7 W6 U8 V8 U5 V5 U7` | Seven-segment cathodes |
| `AN[3:0]` | out | `U2 U4 V4 W4` | Seven-segment anodes (Pro multiplexes these) |

Constraints live in each variant's `constraints/Basys3Labs.xdc`.

---

## Getting Started

### Prerequisites

- **Xilinx Vivado** (2019.x or newer recommended — the design uses only standard VHDL, no IP).
- A **Digilent Basys 3** board (for hardware deployment).

### Build the project in Vivado (GUI)

Because only sources are tracked, create a fresh project and import them:

1. **Create Project** → RTL Project (do *not* specify sources yet) → choose part **`xc7a35tcpg236-1`** (or select the Basys 3 board file).
2. **Add Sources → Add or create design sources** → add every `.vhd` from the variant's `src/` folder.
3. **Add Sources → Add or create simulation sources** → add the `.vhd` files from `sim/`.
4. **Add Sources → Add or create constraints** → add `constraints/Basys3Labs.xdc`.
5. Set the **top module**:
   - Base → `Base_Entel_Processor`
   - Pro → `E_ntel_Processor_Pro`
6. **Run Synthesis → Run Implementation → Generate Bitstream**.
7. **Open Hardware Manager → Program Device** with the generated `.bit`.

### Build via Tcl (optional)

You can script the same steps, e.g. for the Pro variant:

```tcl
create_project entel_pro ./entel_pro -part xc7a35tcpg236-1
add_files [glob pro-processor/src/*.vhd]
add_files -fileset sim_1 [glob pro-processor/sim/*.vhd]
add_files -fileset constrs_1 pro-processor/constraints/Basys3Labs.xdc
set_property top E_ntel_Processor_Pro [current_fileset]
launch_runs impl_1 -to_step write_bitstream -jobs 4
```

---

## Simulation & Testbenches

Behavioral testbenches are provided under each variant's `sim/` folder.

**Base** (`base-processor/sim/`): `Arithmetic_Unit_TB`, `Instruction_Decoder_TB`

**Pro** (`pro-processor/sim/`): `Arithmetic_Unit_TB`, `Display_TB`, `E_ntel_Processor_Pro_TB`, `Instruction_Decoder_TB`, `Mux_2_Way_4_bit_TB`, `Nano_Processor_TB`, `PC_Increment_Unit_TB`, `Program_ROM_TB`, `Reg_Bank_TB`, `Slow_Clk_TB`

To simulate: set the desired `*_TB` as the simulation top in Vivado and **Run Behavioral Simulation**.

---

## Screenshots

<!--
  📸 IMAGE PLACEHOLDERS — add the following files to docs/images/.
  See docs/images/README.md for the full list and capture tips.
-->

**Base processor on the board**
<!-- docs/images/base-board.jpg — photo of the leftmost 7-seg digit + LEDs U16–V19 showing R7 -->
![Base processor running on Basys 3](docs/images/base-board.jpg)

**Pro 4-digit multiplexed display**
<!-- docs/images/pro-display.jpg — |value| | minus sign | current addr | next addr -->
![Pro multiplexed display](docs/images/pro-display.jpg)

**Pro processor on the board**
<!-- docs/images/pro-board.jpg — full board with V17 switch and U18 reset visible -->
![Pro processor running on Basys 3](docs/images/pro-board.jpg)

**Elaborated schematic**
<!-- docs/images/elaborated-schematic.png — Vivado RTL/elaborated schematic of the top entity -->
![Elaborated schematic](docs/images/elaborated-schematic.png)

**Simulation waveform**
<!-- docs/images/sim-waveform.png — behavioral simulation waveform from a testbench -->
![Simulation waveform](docs/images/sim-waveform.png)

> The complete project write-up is available in [`docs/E-ntel-Lab-Report.pdf`](docs/E-ntel-Lab-Report.pdf).

---

## Team

- **Pabasara H.H.J.**
- **Jayathissa W.M.V.K.**
- **Bandara L.H.M.M.D.**
- **Herath H.M.S.B.B.**

---

## License

Released under the **MIT License** — see [LICENSE](LICENSE) for details.
