=begin

	MakeAVR v0.0.1
	Copyright (C) 2022 Isaac W. Budde
	This software is released under the provisions of the MIT License.

	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all
	copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
	SOFTWARE.
	
	https://github.com/buddeiw/makeAVR-ruby

=end

# Enable immediate buffer flush to system console
$stdin.sync = true

# Required for user confirmation prompt

require 'highline/import'

# MakeAVR intialization details

puts
puts "Welcome to the MakeAVR Make Tool"
puts "Copyright (C) 2022 Isaac W. Budde"
puts
puts "MakeAVR is designed to automate the compilation of C code for AVR microcontrollers, creation of memory hex files, and processor flashing."
puts
puts "MakeAVR was developed specifically for the ATMega2560 and ATMega328p microcontrollers and is provided \"as-is\", without warranty of any kind, express or implied."
puts
puts "MakeAVR accepts a single input file of type ANSI-C with filename syntax [NAME].c."
puts "Confirmation of execution will create the following files in the present working directory:"
puts
puts "    [NAME].o    is the initial compiled version of the C file."
puts "    [NAME]      is the compiled version of the C file with system libraries imported."
puts "    [NAME].hex  is the flash memory hex file (Intel hex format) to be written to the microcontroller."
puts
puts "MakeAVR must be run inside the directory containing [NAME].c."
puts


# Begin acquiring required user input

print "Enter the input file name in format [NAME].c: "
cfile = gets.chomp!

print "Enter the COM programming port: "
comport = gets.chomp!

print "Enter the Microcontroller type (atmega2560/atmega328p): "
mmcu = gets.chomp!


cfile_path = cfile
ofile_path = cfile[/\A.{#{cfile.size-2}}/] + ".o"
libfile_path = cfile[/\A.{#{cfile.size-2}}/]
hexfile_path = cfile[/\A.{#{cfile.size-2}}/] + ".hex"

# Determine shell execution commands based on microcontroller type selection
if mmcu == "atmega328p"
	exec_compile = "avr-gcc -v -Os -DF_CPU=16000000UL -mmcu=atmega328p -c -o #{ofile_path} #{cfile_path}"
	exec_libimport = "avr-gcc -mmcu=atmega328p #{ofile_path} -o #{libfile_path}"
	exec_makehex = "avr-objcopy -v -O ihex #{libfile_path} #{hexfile_path}"
	exec_write = "avrdude -v -patmega328p -carduino -P#{comport} -b115200 -D -Uflash:w:#{hexfile_path}:i"
elsif mmcu == "atmega2560"
	exec_compile = "avr-gcc -v -Os -DF_CPU=16000000UL -mmcu=atmega2560 -c -o #{ofile_path} #{cfile_path}"
	exec_libimport = "avr-gcc -mmcu=atmega2560 #{ofile_path} -o #{libfile_path}"
	exec_makehex = "avr-objcopy -v -O ihex #{libfile_path} #{hexfile_path}"
	exec_write = "avrdude -v -patmega2560 -cwiring -P#{comport} -b115200 -D -Uflash:w:#{hexfile_path}:i"
else
	puts
	puts "Invalid microcontroller type selection! Exiting."
	puts
	exit
end


# Inform user of execution and request confirmation
puts
puts "The following shell execution calls will occur upon acceptance. Please review them carefully."
puts
puts exec_compile
puts exec_libimport
puts exec_makehex
puts exec_write
puts
exit unless HighLine.agree('Continue? [y/N]: ')
puts

# Execute commands as accepted including version info for debugging.
system("avr-gcc --version")
puts
system(exec_compile)
puts
system(exec_libimport)
puts
system("avr-objcopy --version")
puts
system(exec_makehex)
puts
system(exec_write)


# Confirm successful execution upon completion of all system calls
puts("All required executions completed.")