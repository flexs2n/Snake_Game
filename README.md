# Snake Game (Verilog) — Xilinx Artix‑7 (Digilent) FPGA

A hardware implementation of the classic Snake game written in Verilog and targeted for Xilinx Artix‑7 based Digilent boards (for example, Nexys A7 or Arty A7). The game runs on the FPGA, driving a VGA display and taking user input from board buttons/switches (or other input peripherals you wire up). This repository contains the Verilog sources, build constraints, and instructions to synthesize and program the design onto the board.

Project overview
----------------
This project implements a playable Snake game in synthesizable Verilog. The FPGA produces video output (VGA) and implements game logic, rendering, collision detection, scoring, and user controls in hardware. The design is intended to be simple to synthesize and easy to extend.

Features
--------
- Snake movement and growth on apple consumption
- Collision detection (self and border)
- Score counter / basic on‑screen display
- VGA video output (standard resolutions supported; adjust as needed)
- Configurable controls (buttons, switches, PS/2 keyboard, or UART input)
- Modular Verilog code to simplify learning and modification

Hardware & tools
---------------
- Target FPGA family: Xilinx Artix‑7
- Example Digilent boards: Nexys A7, Arty A7 (verify your exact board model and pinout)
- Xilinx Vivado Design Suite (Recommended versions: 2018.3 — 2023.x; use a version that supports your board)
- USB cable to program the board (USB‑JTAG)
- VGA monitor and VGA cable (or HDMI adapter if using a bridge)

Repository layout
-----------------
MSM.v — likely a module (MSM)
NSM.v — likely a module (NSM)
NSM_Constraints.xdc — XDC constraints file (empty in the repo)
NSM_TB.v — testbench for NSM (simulation)
README.md — project README
VGA_interface.v — VGA interface/timing or wrapper logic
VGA_wrapper.v — wrapper around VGA interface or pixel pipeline
decoder_2.v — decoder module
generic_counter.v — generic counter module
score_counter.v — score counter module
snakeXDC.xdc — constraints / pin assignment XDC (large file)
snake_control.v — snake game control logic
snake_game_1.xpr — Xilinx project file
target_gen.v — target/food generation module
top.v — top-level module

Build & flash (Vivado)
----------------------
The steps below assume you have Vivado installed and the project files are ready.

1. Prepare constraints
   - Open constraints/board_top.xdc and update pin names to match your board and revision.
   - Ensure VGA pins (HS, VS, R[2:0], G[2:0], B[2:0] or whatever bit depth used) are assigned.
   - Assign your user buttons, switches, and LEDs pins.

2. Using the Vivado GUI
   - Open Vivado and create a new project.
   - Choose RTL project -> Add sources -> select all Verilog files in src/.
   - Add the .xdc constraints file.
   - Set the top module (e.g., top or whatever the repo uses).
   - Run Synthesis → Implementation → Generate Bitstream.
   - Open Hardware Manager → Connect to target → Program device with the generated .bit.

3. Using a Vivado TCL script (example)
   - Create a file run_build.tcl with contents similar to:
     ```tcl
     create_project snake_game -part xc7a35ticsg324-1L -force
     add_files ./src/*.v
     set_property top top [current_fileset]
     add_files -fileset constrs_1 ./constraints/board_top.xdc
     update_compile_order -fileset sources_1
     launch_runs synth_1 -jobs 4
     wait_on_run synth_1
     launch_runs impl_1 -to_step write_bitstream
     wait_on_run impl_1
     write_bitstream -force ./snake_game_top.bit
     ```
   - Adjust the part number to the exact part for your board (check board docs).
   - Run: vivado -mode batch -source run_build.tcl

Pin / constraints (.xdc)
------------------------
- You must adapt the .xdc to the exact board pinout. Typical signals:
  - VGA: VGA_HS, VGA_VS, VGA_R[2:0], VGA_G[2:0], VGA_B[2:0]
  - Buttons: BTN_UP, BTN_DOWN, BTN_LEFT, BTN_RIGHT, BTN_RESET
  - Switches: optional difficulty / start
  - LEDs: score or status
- Example mapping (this is an example — DO NOT copy blindly; check board XDC):
  ```xdc
  set_property PACKAGE_PIN J15 [get_ports {VGA_R[2]}]  # example pin
  set_property IOSTANDARD LVCMOS33 [get_ports {VGA_R[*] VGA_G[*] VGA_B[*] VGA_HS VGA_VS}]
  set_property PACKAGE_PIN G14 [get_ports BTN_UP]
  ```
- If the design uses a pixel clock (25.175 MHz for 640×480@60), instantiate a clocking wizard or a divider from the board 100 MHz input. Using an MMCM is recommended for accurate timing.

Controls & gameplay
-------------------
- Movement: use four directional inputs (buttons, switches, or keyboard).
- Reset / Start: dedicated button or switch to reset the game.
- If keyboard (PS/2) support is included, plug in a PS/2 keyboard and use arrow keys.
- Scoring: the score can be shown on VGA or LED indicators.
- Goals: direct the snake to collect food (apple). Each food increases the snake length and score. Hitting walls or self results in game over.

How to play
-----------
1. Power up the board and program the bitstream.
2. Connect the VGA monitor.
3. Press the Start button (if available) or toggle the Start switch.
4. Use the movement controls to steer the snake.
5. Eat food to grow and increase score. Avoid collisions.

Testing & debugging tips
------------------------
- First verify VGA output with a simple test module that outputs a color bar or grid to confirm timing and pin mappings.
- If the screen is black:
  - Confirm the VGA HS/VS signals toggle.
  - Verify pixel clock generation and timing parameters.
  - Check the monitor supports the chosen mode.
- Use onboard LEDs to output internal state (e.g., game running, collision detected).
- Simulate critical modules (snake logic, renderer) with a simple testbench before synthesizing.
- Use Vivado logic analyzer (ILA) for on-target signal inspection if needed.

Contact
-------
Repository owner: flexs2n
For questions or help adapting this to your board, open an issue on the repository.

Notes
-----
- Replace placeholder filenames, top‑module name, pin mappings, and Vivado part number with the actual values in this repository before building.
- If you want, tell me which Digilent board you are using (Nexys A7, Arty A7, etc.) and which files in this repo correspond to the top module and constraints; I can update this README with exact build commands and a ready‑to‑use .tcl script.
