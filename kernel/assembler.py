import numpy as np

def assemble(stmts):
    with open("program.bin", "wb+") as out:
        for stmt in stmts:
            children = stmt.children()
            if stmt.type() == "LOAD":
                out.write(np.int8(2))
                for i in range(0, len(children)-1):
                    out.write(np.int8(children[i].attrib()))
                continue

            if stmt.type() == "EXEC":
                out.write(np.int8(3))
                for i in range(0, len(children)-1):
                    out.write(np.int8(children[i].attrib()))
                continue

            if stmt.type() == "RST":
                out.write(np.int8(0))
                continue

            if stmt.type() == "RPRT":
                out.write(np.int8(4))
                continue

    print("Successfully compiled program.")
    print("See ./program.bin for output.")
