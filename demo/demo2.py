import sys
import random
import numpy as np
import tensorflow as tf
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Dense

# Import the kernel.
sys.path.append("../kernel")
from kernel import Kernel

# Generate random data.
X = [ [random.randint(-20, 20), random.randint(-20, 20)] for i in range(0, 100) ]

# Tensorflow model.
model = Sequential(
    [
        tf.keras.Input(shape=(2,)),
        Dense(3, activation='relu', name = 'layer1'),
        Dense(1, activation='relu', name = 'layer2')
     ]
)

print("Model to train:")
model.summary()
model.compile(
    loss = tf.keras.losses.BinaryCrossentropy(),
    optimizer = tf.keras.optimizers.Adam(learning_rate=0.01),
)

# Examine the weights.
W1, b1 = model.get_layer("layer1").get_weights()
W2, b2 = model.get_layer("layer2").get_weights()
print("\nModel Weights (untrained):")
print("W1:\n", W1, "\nb1:", b1)
print("W2:\n", W2, "\nb2:", b2)

# Normalize weights.
W1_q = W1*100
W1_q = [ [int(x), int(y), int(z)] for [x,y,z] in W1_q ]
W2_q = W2*100
W2_q = [ [int(x)] for [x] in W2_q ]
print("Normalized weights:")
print("W1:\n", W1_q, "\nb1:", b1)
print("W2:\n", W2_q, "\nb2:", b2)

# Kernel inference
def kern_infer(x, W1, W2, b1, b2):
    kern = Kernel()
    kern.RST()

    # Layer 1.
    kern.LOAD(W1[0][0], W1[1][0], b1[0], 0, 0)
    kern.EXEC(x[0], x[1], 1, 0, 0)
    n_0_0 = kern.RPRT() if kern.RPRT() > 0 else 0

    kern.LOAD(W1[0][1], W1[1][1], b1[1], 0, 0)
    kern.EXEC(x[0], x[1], 1, 0, 0)
    n_0_1 = kern.RPRT() if kern.RPRT() > 0 else 0

    kern.LOAD(W1[0][2], W1[1][2], b1[2], 0, 0)
    kern.EXEC(x[0], x[1], 1, 0, 0)
    n_0_2 = kern.RPRT() if kern.RPRT() > 0 else 0

    # Layer 2
    kern.LOAD(W2[0][0], W2[1][0], W2[2][0], b2[0], 0)
    kern.EXEC(n_0_0, n_0_1, n_0_2, 1, 0)
    out = kern.RPRT() if kern.RPRT() > 0 else 0
    return out

# Compare CPU vs kernel.
kernel = [ kern_infer([x1, x2], W1_q, W2_q, b1, b2)/10000.0 for [x1, x2] in X]
cpu = model.predict(np.array(X))

avg_error = 0
for ([c], k) in zip(cpu, kernel):
    if c == 0:
        continue
    avg_error += abs(c-k)/c

avg_error = avg_error / len(kernel)
print("Average % error:", avg_error * 100)
