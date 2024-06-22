# PPM Encoder and Decoder for Visible Light Communication

This project implements a Pulse Position Modulation (PPM) encoder and decoder designed for Visible Light Communication (VLC) systems. The encoder converts serial data to parallel data, encodes it using PPM, and transmits it. The decoder receives the PPM signal, decodes it, and converts it back to parallel data.

## Table of Contents
- [Introduction](#introduction)
- [Features](#features)
- [Modules](#modules)
  - [Shift Register](#shift-register)
  - [PPM Memory](#ppm-memory)
  - [PPM Encoder and Transmitter](#ppm-encoder-and-transmitter)
  - [PPM Encoder Top Module](#ppm-encoder-top-module)
  - [PPM Decoder](#ppm-decoder)
- [Usage](#usage)
- [Simulation](#simulation)
- [Dependencies](#dependencies)
- [License](#license)

## Introduction

This project aims to facilitate real-time data collection in marine environments using VLC technology. The PPM encoder and decoder are essential components in achieving reliable data transmission under varying water conditions. 

## Features
- **PPM Encoder**: Converts serial data to parallel data, encodes it using PPM, and transmits it.
- **PPM Decoder**: Receives the PPM signal, decodes it, and converts it back to parallel data.
- **Wavelength Adaptation**: Adjusts the LED wavelength to optimize data transmission in different water conditions.

## Modules

### Shift Register
Converts the serial input data to parallel output data.

```verilog
module shift_register (
    input wire clk,
    input wire rst,
    input wire serial_in,
    input wire data_ready_rst,
    output reg [7:0] parallel_out,
    output reg data_ready
);
```

### PPM Memory
Stores the PPM data temporarily for encoding and transmission.

```verilog
module ppm_memory(
    input wire clk,
    input wire rst,
    input wire [7:0] M_in,
    input wire control, //0: read; 1: write
    input wire [3:0] address,
    output reg [7:0] M_out 
);
```

### PPM Encoder and Transmitter
Encodes the data using PPM and transmits it.

```verilog
module ppm_encoder_tx(
    input wire clk,
    input wire rst,
    input wire [7:0] in_ppm,
    input wire [1:0] order, // 00: null; 01: SOF; 10: data; 11: EOF
    input wire [9:0] clk_count_ppm,
    input wire [1:0] bit_count_ppm,
    output reg Dout
);
```

### PPM Encoder Top Module
Integrates the shift register, PPM memory, and PPM encoder for the complete encoding process.

```verilog
module ppm_encoder(
    input wire clk,
    input wire rst,
    input wire Din,
    output wire Dout
);
```

### PPM Decoder
Decodes the received PPM signal and converts it back to parallel data.

```verilog
module ppm_decoder(
    input wire clk,
    input wire rst,
    input wire Din,
    output reg [7:0] Dout,
    output reg D_en, // data enable
    output reg F_en // frame enable
);
```

## Usage
1. **Compile and load the Verilog files into your simulation tool or FPGA development environment.**
2. **Instantiate the `ppm_encoder` and `ppm_decoder` modules in your top-level design.**
3. **Provide the necessary input signals to the `ppm_encoder` and connect the `ppm_decoder` to the output of the `ppm_encoder`.**

## Simulation
Use your preferred Verilog simulation tool (e.g., ModelSim, XSIM) to simulate the functionality of the PPM encoder and decoder. Ensure to provide test benches that simulate various input conditions to validate the design.

## Dependencies
- **Verilog 2001**: Ensure your environment supports Verilog 2001 syntax and constructs.
- **FPGA Development Tool**: Tools like Vivado, Quartus, or similar for synthesis and implementation.

## License
This project is licensed under the MIT License - see the LICENSE file for details.
