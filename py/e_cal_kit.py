#!/usr/bin/python3
import serial

class CalkitController:
    def __init__(self, port):
        self.serial=serial.Serial(port=port, baudrate=115200)
        self.waitForData(b'READY\r\n')

    def waitForData(self, data):
        d =  b''
        while True:
            g=self.serial.read()
            d+=g
            if data in d:
                return d;

    def selectStandard(self, standard):
        if standard not in ['S', 'O', 'L', 'T', 'A', 'B', 'N']:
            raise ValueError("Standard must be one of the chars S, O, L, T, A, B or N.")

        sb = standard.encode('ascii')
        self.serial.write(sb)
        self.waitForData(sb+b'\r\n')

if __name__ == "__main__":
    import argparse
    parser=argparse.ArgumentParser(description='Measure calkit standards')
    parser.add_argument('port', help='Serial port device file, ie. /dev/ttyUSB0')

    standards = parser.add_argument_group("Select a standard to use")
    standards.add_argument('-s', '--short', action='store_true', help='Switch to short')
    standards.add_argument('-o', '--open', action='store_true', help='Switch to open')
    standards.add_argument('-l', '--load', action='store_true', help='Switch to load')
    standards.add_argument('-t', '--through', action='store_true', help='Switch to through')
    standards.add_argument('-a', '--a-port', action='store_true', help='Switch to a port')
    standards.add_argument('-b', '--b-port', action='store_true', help='Switch to b port')
    standards.add_argument('-n', '--none', action='store_true', help='Switch to none')
    args=parser.parse_args()

    if args.short:
        c = CalkitController(args.port)
        c.selectStandard('S')
        input("S selected press enter to continue")
    if args.open:
        c = CalkitController(args.port)
        c.selectStandard('O')
        input("O selected press enter to continue")
    if args.load:
        c = CalkitController(args.port)
        c.selectStandard('L')
        input("L selected press enter to continue")
    if args.through:
        c = CalkitController(args.port)
        c.selectStandard('T')
        input("T selected press enter to continue")
    if args.a_port:
        c = CalkitController(args.port)
        c.selectStandard('A')
        input("A port selected press enter to continue")
    if args.b_port:
        c = CalkitController(args.port)
        c.selectStandard('B')
        input("B port selected press enter to continue")
    if args.none:
        c = CalkitController(args.port)
        c.selectStandard('N')
        input("None selected press enter to continue")

