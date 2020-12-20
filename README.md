# Z80 Development Enviroment

See `./configs` for device settings

Default configs:

```
TTY_DEV=/dev/tty.usbserial-A50285BI
BAUDRATE=9600
INPUT_DELAY=0.01
CODE_ORG = 0x8000
```

The code origin is automatically carried over to the c compilation, and the auto execution in the Videoterminal. The origin still needs to be defined in the assembly files.