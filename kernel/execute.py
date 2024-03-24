import numpy as np
from kernel import Kernel

def execute(path):
    with open(path, "rb") as prg:
        data = np.fromfile(prg, dtype=np.int8)
        kern = Kernel()
        i = 0

        while i < len(data):
            if data[i] == 2:
                if i+5 >= len(data):
                    print("error at byte", i, ": instruction LOAD (0x2) expects 5 (bytes) arguments")
                    return

                kern.LOAD(data[i+1], data[i+2], data[i+3], data[i+4], data[i+5])
                i = i + 6
                continue

            if data[i] == 3:
                if i + 5 >= len(data):
                    print("error at byte", i, ": instruction EXEC (0x3) expects 5 (bytes) arguments")
                    return

                kern.EXEC(data[i+1], data[i+2], data[i+3], data[i+4], data[i+5])
                i = i + 6
                continue

            if data[i] == 0:
                kern.RST()
                i = i + 1
                continue

            if data[i] == 4:
                print("[RPRT OUTPUT]:", kern.RPRT())
                i = i + 1
                continue

            print("error at byte", i,": unrecognized opcode",
                  "0x" + str(np.base_repr(data[i], base=16)))

            return

    print("Finished executing file.")
