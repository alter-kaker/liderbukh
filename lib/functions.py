import sys

def runerror(exception):
    if exception.stderr:
        print ( exception.stderr.decode() )
    else:
        print ( exception.stdout.decode() )
    sys.exit() 
