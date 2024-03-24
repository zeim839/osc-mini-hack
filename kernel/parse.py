import numpy as np

class Statement:
    def __init__(self, _type):
        self._children = []
        self._type = _type

    def type(self):
        return self._type

    def insert(self, child):
        self._children.append(child)

    def children(self):
        return self._children

def predict(tokens, i, _type, err):
    if i+1 >= len(tokens):
        print("(parse)", tokens[i].pos(), err)
        return False

    if tokens[i+1].type() != _type:
        print("(parse)", tokens[i].pos(), err)
        return False

    return True

def parse(tokens):
    stmts = []
    i = 0
    while i < len(tokens):
        token = tokens[i]
        if token.type() == "LOAD":
            stmt = Statement("LOAD")

            # Expect 5 integers.
            for j in range(0, 5):
                if not predict(tokens, i, "INT", "error: expected integer"):
                    return []

                stmt.insert(tokens[i+1])
                i = i + 1

            if not predict(tokens, i, "STOP", "error: expected semicolon (;)"):
                return []

            stmt.insert(tokens[i+1])
            stmts.append(stmt)
            i = i + 2

            continue

        if token.type() == "EXEC":
            stmt = Statement("EXEC")

            # Expect 5 integers.
            for j in range(0, 5):
                if not predict(tokens, i, "INT", "error: expected integer"):
                    return []

                stmt.insert(tokens[i+1])
                i = i + 1

            if not predict(tokens, i, "STOP", "error: expected semicolon (;)"):
                return []

            stmt.insert(tokens[i+1])
            stmts.append(stmt)
            i = i + 2

            continue

        if token.type() == "RPRT":
            stmt = Statement("RPRT")
            if not predict(tokens, i, "STOP", "error: expected semicolon (;)"):
                return []

            stmt.insert(tokens[i+1])
            stmts.append(stmt)
            i = i + 2

            continue

        if token.type() == "RST":
            stmt = Statement("RST")
            if not predict(tokens, i, "STOP", "error: expected semicolon (;)"):
                return []

            stmt.insert(tokens[i+1])
            stmts.append(stmt)
            i = i + 2

            continue

        print("(parse)", token.pos(), "error: invalid statement (unexpected",
              token.type(), "token)")

        return []

    return stmts
