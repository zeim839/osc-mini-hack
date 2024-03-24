class Token:
    def __init__(self, _type, lpos, cpos, attrib=""):
        self._type = _type
        self._attrib = attrib
        self._lpos = lpos
        self._cpos = cpos

    def type(self):
        return self._type

    def attrib(self):
        return self._attrib

    def pos(self):
        return [self._lpos, self._cpos]

def is_legal(c):
    if c.isalnum() or c.isspace() or c == '-' or c == ';':
        return True

    return False

def prefix(lineNum, cNum):
    return "(lex) {0}:{1}".format(lineNum, cNum)

def lex(path):
    """Reads a source file and generates language tokens"""
    tokens = []
    with open(path, 'r', encoding='utf-8') as src:
        currentToken = ""
        for lineNum, line in enumerate(src):
            for cNum, c in enumerate(line):

                if not is_legal(c):
                    print(prefix(lineNum, cNum), "error: illegal character", c)
                    return []

                # Extract integers.
                if (len(currentToken) == 0 and c == '-') or c.isnumeric():
                    currentToken += c
                    continue

                if (len(currentToken) > 0) and c == '-':
                    print(prefix(lineNum, cNum),
                          "error: unexpected minus operator (-)")
                    return []

                if (not c.isnumeric()) and len(currentToken) > 0 and (
                        currentToken[-1].isnumeric()):
                    tokens.append(Token("INT", lineNum, cNum, int(currentToken)))
                    currentToken = ""

                # Skip whitespace characters.
                if c.isspace() and len(currentToken) == 0:
                    continue

                if c.isspace():
                    print(prefix(lineNum, cNum),
                          "error: unrecognized keyword", currentToken)
                    return []

                currentToken += c

                if currentToken == "LOAD" or currentToken == "load":
                    tokens.append(Token("LOAD", lineNum, cNum))
                    currentToken = ""
                    continue

                if currentToken == "EXEC" or currentToken == "exec":
                    tokens.append(Token("EXEC", lineNum, cNum))
                    currentToken = ""
                    continue

                if currentToken == "RPRT" or currentToken == "rprt":
                    tokens.append(Token("RPRT", lineNum, cNum))
                    currentToken = ""
                    continue

                if currentToken == "RST" or currentToken == "rst":
                    tokens.append(Token("RST", lineNum, cNum))
                    currentToken = ""
                    continue

                if currentToken == ";":
                    tokens.append(Token("STOP", lineNum, cNum))
                    currentToken = ""
                    continue

            if len(currentToken) > 0 and (currentToken.isnumeric() or (
                    currentToken[1:].isnumeric())):
                tokens.append(Token("INT", lineNum, cNum, int(currentToken)))
                currentToken = ""

            if len(currentToken) > 0:
                print(prefix(lineNum, cNum),
                      "error: unrecognized token", currentToken)
                return []

    return tokens
