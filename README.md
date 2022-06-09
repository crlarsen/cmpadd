# Verilog IEEE 754 Addition

## Description

Test harness which compares the output of the fp_add_extract and fp_add modules. The test runs over all combinations of normal and subnormal numbers. The test harness runs on the Digilent BASYS 3 board which uses a Xilinx Artix-7 FPGA. The DIP switches are used to control which rounding attribute is used.

Only one DIP switch is allowed in the ON position at a time. All other DIP switches must be in the OFF position.

| DIP Switch   | Rounding Attribute  |
|--------------|---------------------|
| DIP Switch 0 | roundTiesToEven     |
| DIP Switch 1 | roundTowardZero     |
| DIP Switch 2 | roundTowardPositive |
| DIP Switch 2 | roundTowardNegative |

The code is explained in the video series [Building an FPU in Verilog](https://www.youtube.com/watch?v=rYkVdJnVJFQ&list=PLlO9sSrh8HrwcDHAtwec1ycV-m50nfUVs).
See the video *Building an FPU in Verilog: Adding Floating Point Numbers, Part 2*.

The BASYS 3 board can be purchased at [digilent.com](https://store.digilentinc.com/basys-3-artix-7-fpga-beginner-board-recommended-for-introductory-users/)

## Manifest

|   Filename        |                        Description                           |
|-------------------|--------------------------------------------------------------|
| README.md         | This file.                                                   |
| cmpadd.v          | Test harness for fp_add_exact and fp_add.                    |
| debounce.v        | Module to debounce signals from the push buttons on the Digilent BASYS 3 board. |
| fp_add.sv         | Addition circuit for the IEEE 754 binary16 data type using inexact intermediate results. |
| fp_add_exact.sv   | Addition circuit for the IEEE 754 binary16 data type.        |
| fp_class.sv       | Utility module to identify the type of the IEEE 754 value passed in, and extract the exponent & significand fields for use by other modules. |
| hex2_7seg.v       | Utility module to output 4 digit hexadecimal value on 7-segment display. |
| ieee-754-flags.vh | Verilog header file to define constants for datum type (NaN, Infinity, Zero, Subnormal, and Normal), rounding attributes, and IEEE exceptions. |
| padder11.v        | Prefix adder used by round module.                           |
| padder26.v        | Prefix adder used by fp_add module.                          |
| padder42.v        | Prefix adder used by fp_add_exact module.                    |
| PijGij.v          | Utility routines needed by the various prefix adder modules. |
| round.v           | Parameterized rounding module.                               |
| x7seg.v           | Miscellaneous utility routines for formatting data for output to the 7-segment display. |

## Copyright

:copyright: Chris Larsen, 2019-2022
