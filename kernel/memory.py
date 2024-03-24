class Register:
    """Emulates a register. The physical register is synchronous,
    but this implementation ignores clock state."""

    def __init__(self):
        self.value = 0

    def write(self, data: int):
        """Set the register value. Numbers outside the
        [-128, 127] range will overflow"""
        self.value = data

    def read(self):
        """Return the register value"""
        return self.value

    def reset(self):
        """Set the register's value to 0"""
        self.value = 0

class SRLatch:
    """Emulates an SR-Latch. The physical latch is synchronous,
    but this implementation ignores clock state."""

    def __init__(self):
        self.bit = False

    def set(self):
        """Set the latch's value to 1"""
        self.bit = True

    def reset(self):
        """Set latch's value to 0"""
        self.bit = False

    def read(self):
        """Return the stored value"""
        return self.bit

    def complement(self):
        """Return the complement of the stored value"""
        return not self.bit

class DDRMEM:
    """Emulates the DDR memory unit, which stores the matrix weight
    values (matrix rows)"""

    def __init__(self):
        self.reg0 = Register()
        self.reg1 = Register()
        self.reg2 = Register()
        self.reg3 = Register()
        self.reg4 = Register()

    def set_low(self, x0: int, x1: int):
        """Set the data that will be written on the rising
        clock edge"""
        self.reg0.write(x0)
        self.reg1.write(x1)

    def set_high(self, x0: int, x1: int, x2: int):
        """Set the data that will be written on the falling
        clock edge"""
        self.reg2.write(x0)
        self.reg3.write(x1)
        self.reg4.write(x2)

    def reset(self):
        """Set all underlying register values to 0"""
        self.reg0.reset()
        self.reg1.reset()
        self.reg2.reset()
        self.reg3.reset()
        self.reg4.reset()

    def read(self):
        """Return a list of all the register values"""
        return [
            self.reg0.read(),
            self.reg1.read(),
            self.reg2.read(),
            self.reg3.read(),
            self.reg4.read(),
        ]

class VMEM:
    """Emulates the VMEM memory unit, which stores the first two
    operand values of the EXEC operation"""

    def __init__(self):
        self.reg0 = Register()
        self.reg1 = Register()

    def write(self, x0: int, x1: int):
        """Write the memory data values"""
        self.reg0.write(x0)
        self.reg1.write(x1)

    def reset(self):
        """Set all underlying memory register values to 0"""
        self.reg0.reset()
        self.reg1.reset()

    def read(self):
        """Return a list of the stored memory values"""
        return [
            self.reg0.read(),
            self.reg1.read(),
        ]
