import memory
import numpy as np
import arithmetic

class Kernel:
    """ Kernel maintains state and emulates opcode execution """

    def __init__(self):
        self.ddrmem = memory.DDRMEM()
        self.vmem = memory.VMEM()
        self.output = np.int8(0)

    def LOAD(self, w0, w1, w2, w3, w4):
        """Load model weights into register"""
        self.ddrmem.set_low(w0, w1)
        self.ddrmem.set_high(w2, w3, w4)
        self.output = np.int8(0)

    def EXEC(self, v0, v1, v2, v3, v4):
        """Executes GEMV using pre-loaded weights and v0, v1,
        v2, v3, v4 operands """

        # Redundant, but values are written to memory for
        # the sake of preserving the physical architecture's
        # logic.
        self.vmem.write(v0, v1)
        v = self.vmem.read()

        # Perform GEMV step.
        w = self.ddrmem.read()
        self.output = arithmetic._gemv(w[0], w[1], w[2], w[3], w[4],
                                       v[0], v[1], v2, v3, v4)

    def RPRT(self):
        """Virtual instruction: reports the last kernel output """
        return self.output

    def RST(self):
        """Resets all internal memory"""
        self.ddrmem.reset()
        self.vmem.reset()
