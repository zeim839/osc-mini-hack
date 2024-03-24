# Project Demonstration
This folder contains two demonstrations. The first is contained in `demo1.asm` and demonstrates the assembler 
and emulator. The second, implemented in `demo2.py`, constructs a simple neural network and executes it using 
the emulator. 

## Demo 1 - Assembling Source Files
The file `demo1.asm` contains assembly instructions that can be executed on the emulator. The contents of the
file are reproduced below:
```asm
RST;
LOAD 0 0 0 0 0;
EXEC 0 0 0 0 0;
RPRT;

LOAD 1 1 1 1 1;
EXEC 1 1 1 1 1;
RPRT;
RST;

LOAD -5 -3 13 2 -28;
EXEC 12 -3 4 -7 -28;
RPRT;
```

The first block instructs the chip to reset its memory contents (`RST`), load an array of zeros (`LOAD 0 0 0 0 0`), 
and then multiply the array by five additional numbers (`EXEC 0 0 0 0 0`). Finally, the `RPRT` operation is a 
virtual instruction that prints the chip's output. In summary, this is equivalent to performing the following
calculation:
```
RPRT = 0*0 + 0*0 + 0*0 + 0*0 + 0*0
```

Naturally, the output is `0`. The following two blocks demonstrate the same principles using positive and negative
integers.

The code can be compiled by running the following command in the project root directory:
```bash
python kernel compile demo/demo1.asm
```

This produces the file `program.bin`, which contains the compiled binary. This compiled binary may be used by a
microprocessor to interface with the chip. Alternatively, it can be executed directly on the emulator using the
following command (again, ran from the root directory):
```bash
python kernel exec program.bin
```

The output will look like this:
```
[RPRT OUTPUT]: 0
[RPRT OUTPUT]: 5
[RPRT OUTPUT]: 771
Finished executing file.
```

The integer outputs correspond to the matrix-vector sum of products specified in the source program

## Demo 2 - Implementing a Neural Network

This example implements a simple neural network, executes it on both the computer CPU and the emulator, and then 
compares both outputs. The neural network implemented is shown below:
```python
model = Sequential(
    [
        tf.keras.Input(shape=(2,)),
        Dense(3, activation='relu', name = 'layer1'),
        Dense(1, activation='relu', name = 'layer2')
     ]
)
```
It consists of two inputs, 3 hidden layer neurons, and a single output. The activation function was chosen to be `relu`
for the sake of simplification. All inputs and weights to the model are random, the model only serves a demonstration
of the kernel emulator.

Since the chip can only operate on integers, the model's weights are normalized prior to being fed to the kernel:
```python
# Model weights.
W1, b1 = model.get_layer("layer1").get_weights()
W2, b2 = model.get_layer("layer2").get_weights()
print("\nModel Weights (untrained):")
print("W1:\n", W1, "\nb1:", b1)
print("W2:\n", W2, "\nb2:", b2)

# Normalized weights.
W1_q = W1*100
W1_q = [ [int(x), int(y), int(z)] for [x,y,z] in W1_q ]
W2_q = W2*100
W2_q = [ [int(x)] for [x] in W2_q ]
print("Normalized weights:")
print("W1:\n", W1_q, "\nb1:", b1)
print("W2:\n", W2_q, "\nb2:", b2)
```

For more advanced networks, quantization may also be used. A random series of 100 inputs is then used to compare
the kernel and TensorFlows inference engine (i.e. `model.predict()`). The error between the two is compared:
```bash
python demo2.py
```

```
Average % error: 1.5542110248999554
```

This is an optimistic estimate. In reality, overflows are much more likely to occur on the chip as weights and
multiplicands are transferred to/from memory.
