import numpy as np

def _gemv(a0, a1, a2, a3, a4, m0, m1, m2, m3, m4):
    """Emulates the GEMV0 (General Matrix-Vector Multiplication)
    unit, which performs a single step of row-column
    sum of products."""
    a0 = np.int32(a0); m0 = np.int32(m0)
    a1 = np.int32(a1); m1 = np.int32(m1)
    a2 = np.int32(a2); m2 = np.int32(m2)
    a3 = np.int32(a3); m3 = np.int32(m3)
    a4 = np.int32(a4); m4 = np.int32(m4)

    return a0*m0 + a1*m1 + a2*m2 + a3*m3 + a4*m4
