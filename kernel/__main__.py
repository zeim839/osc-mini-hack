import sys
from lex import lex
from assembler import assemble
from parse import parse
from execute import execute

def compile(path):
    """Compile source file at path"""
    assemble(parse(lex(path)))

def exec(path):
    """Execute binary file at path"""
    execute(path)

def usage():
    """Print usage instructions"""
    print("Usage: python asm [ compile | exec ] [ file ]\n")

if __name__ == "__main__":
    if len(sys.argv) <= 1:
        print("error: not enough arguments")
        usage()
        exit()

    # --- Compile ---

    if sys.argv[1] == "compile" and len(sys.argv) == 3:
        compile(sys.argv[2])
        exit()

    if sys.argv[1] == "compile" and len(sys.argv) < 3:
        print("error: expected source file")
        usage()
        exit()

    # --- Execute ---

    if sys.argv[1] == "exec" and len(sys.argv) == 3:
        exec(sys.argv[2])
        exit()

    if sys.argv[1] == "exec" and len(sys.argv) < 3:
        print("error: expected compiled binary file")
        usage()
        exit()

    # Unknown.
    print("Error: unrecognized keyword")
    usage()
