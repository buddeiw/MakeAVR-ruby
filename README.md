# MakeAVR-ruby
MakeAVR is a simple Ruby script designed to automate the compilation and programming of ANSI-C source code files for AVR microcontrollers including the ATMega328P and ATMega2560.

## Dependencies
MakeAVR requires the following dependencies:
- Ruby
- HighLine (gem)
- avr-gcc
- avr-binutils
- avrdude

## Development
MakeAVR was developed on Arch Linux with the following versions:
- Linux Kernel: `5.16.4`
- Ruby: `3.0.3`
- HighLine: `2.0.3`
- avr-gcc: `11.2.0`
- avr-binutils: `2.37`
- avrdude: `6.4`

## Use
- Ensure that all required dependencies have been installed. 
- Connect your ATMega development board and identify the COM port to which it is connected.
- Create a file `[NAME].c` containing the ANSI-C code to be programmed to the board. 
- Copy `MakeAVR.rb` to the working directory.
- Open a shell session in the working directory and execute: `ruby MakeAVR.rb`
- Follow the prompts provided by MakeAVR.