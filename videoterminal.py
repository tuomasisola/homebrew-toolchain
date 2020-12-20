import sys
import subprocess
import time

import serial

from serial.tools import miniterm


try:
    INPUT_DELAY = float(sys.argv[3]) # seconds
    ORG = f"${sys.argv[4].split('x')[1]}"
    sys.argv.pop(3) # remove argument so it is not carried out as Miniterm argument
    sys.argv.pop(3)
except IndexError:
    sys.stderr.write("Using default code org and delay\n")
    ORG = '$8000'
    INPUT_DELAY = 0.01

# Small Computer Monitor
UPLOAD_READY = 'eady\r\n\r\n*'
GOTO_UPLOAD_START = f'g {ORG}\r\n'

# Stderr coloring
GREEN = '\033[92m'
ENDC = '\033[0m'


""" Delay in writer enables auto goto as well as copy-paste """
class NewSerial(serial.serialposix.Serial):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
    
    def write(self, data):
        serial.serialposix.Serial.write(self, data)
        time.sleep(INPUT_DELAY)


# Add auto goto after file upload
class NewMiniterm(miniterm.Miniterm):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)

    def write_console(self, data):
        text = self.rx_decoder.decode(data)
        for transformation in self.rx_transformations:
            text = transformation.rx(text)
        self.console.write(text)
        return text

    def write_serial(self, text):
        for char in text:
            self.serial.write(str.encode(char))

    def reader(self):
        """
        Modified from the original read-method from pySerial Miniterm
        loop and copy serial->console
        """
        try:
            while self.alive and self._reader_alive:
                # read all that is there or wait for one byte
                data = self.serial.read(self.serial.in_waiting or 1)
                if data:
                    text = self.write_console(data)
                    if text == UPLOAD_READY:
                        self.write_serial(GOTO_UPLOAD_START)
                        
        except serial.SerialException:
            self.alive = False
            self.console.cancel()
            raise


""" Add coloring to sderr so miniterm output is different from serial output """
class NewStderr(object):
    def __init__(self, target):
        self.target = target

    def write(self, s):
        s = f'{GREEN}{s}{ENDC}'
        self.target.write(s)


def main():
    miniterm.Miniterm = NewMiniterm
    serial.Serial = NewSerial
    sys.stderr = NewStderr(sys.stdout)

    try:
        miniterm.main()
    except BaseException:
        sys.stderr.write(f"\nUnable to connect\nMake sure the device is attached to the usb port.\n")


if __name__ == "__main__":
    main()

