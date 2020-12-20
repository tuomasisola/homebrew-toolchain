# Z80 Homebrew Toolchain

This package is a collection of tools used to develop software for homebrew computer boards in C or Assembly. The toolchain has been designed to work with the hex loader included in the [Small Computer Monitor](https://smallcomputercentral.wordpress.com/small-computer-monitor/) developed by Stephen C Cousins.

The toolchain includes a Python terminal application for direct input and output with the serial connection, and a set of scripts controlled by a Makefile for compiling, interacting with the hex loader etc. The idea is to include all the tools required to get started with Z80 development.

The toolchain has been tested only with the [SC114](https://smallcomputercentral.wordpress.com/sc114-documentation/) motherboard using the included bit-bang serial port, FTDI232 based USB to serial adapter and macOS Catalina.

## Quick start

1. `make build`
2. Connect the board to the usb port of the computer with the serial adapter.
3. Set correct `$TTY_DEV` and `$BAUDRATE` in `./configs`
4. `make run` to start the terminal application
5. `make asm && make asm-send` to assemble and load the hex file to the target computer

NOTE: `./tools/send.c` is used to add delay between characters when loading the hex files to the serial interface as at least for me this seems to be needed for successful upload.


## Videoterminal

This toolchain includes a simple terminal application based on the Miniterm module included in [PySerial](https://pyserial.readthedocs.io/en/latest/tools.html#miniterm). The module has been extended with minor changes like auto execution of code after it's uploaded to the RAM using the hex loader of the SMC.

The terminal can be activated with `make run`. See `./configs` for settings.

## Assembly development
The assembler used is [Asm80](https://manual.asm80.com). Set the source file in `./configs`.

* `make asm` to assemble
* `make asm-send` to send to the hex loader

## C development
The C compiler used is [z88dk](https://github.com/z88dk/z88dk). Set the source file in `./configs`.

* `make c` to compile
* `make c-send` to send to the hex loader


## Configurations

Default configurations:

```
TTY_DEV=/dev/tty.usbserial-A50285BI
BAUDRATE=9600
INPUT_DELAY=0.01

CODE_ORG = 0x8000

ASM_SOURCE = asm/example.asm
C_SRC = c/example.c
```

The code origin is automatically carried over to the c compilation, and the auto execution in the videoterminal.py. The origin still needs to be defined in the assembly files.