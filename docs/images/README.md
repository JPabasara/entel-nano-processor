# Images

This folder holds the images referenced by the root [`README.md`](../../README.md).
Add the files below using the **exact file names** so the README renders them
automatically. (Recommended: PNG for diagrams/screenshots, JPG for board photos,
~1200 px wide.)

| File name                   | What it should show                                                                                  |
| --------------------------- | ---------------------------------------------------------------------------------------------------- |
| `banner.png`                | Optional project banner / title graphic shown at the top of the README.                              |
| `block-diagram.png`         | Top-level datapath block diagram (Slow_Clk → PC Increment Unit → Program ROM → Instruction Decoder → Register Bank → ALU → Mux → Display). |
| `base-board.jpg`            | Photo of the Basys 3 board running the **Base** processor — leftmost 7-seg digit + LEDs U16–V19 showing R7. |
| `pro-display.jpg`           | Close-up photo of the **Pro** 4-digit display: digit 1 = |value|, digit 2 = minus sign, digit 3 = current address, digit 4 = next address. |
| `pro-board.jpg`             | Full photo of the Basys 3 board running the **Pro** processor (with the V17 toggle switch and U18 reset visible). |
| `elaborated-schematic.png`  | Vivado RTL/elaborated schematic of the top-level entity.                                              |
| `sim-waveform.png`          | Behavioral simulation waveform from one of the testbenches (e.g. `Nano_Processor_TB` or `Arithmetic_Unit_TB`). |
| `utilization.png`           | Vivado post-implementation resource utilization summary (optional, useful for the report).           |

> Tip: in Vivado, schematics can be exported via **File → Export → Export Schematic**,
> and waveforms via the simulator's **File → Export → Export Waveform / screenshot**.
