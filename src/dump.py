import os, sys

INSTALL_PATH = os.path.dirname(sys.argv[0])

class Dump:
    def __init__(self, fileName, raw):
        directory = os.path.join(INSTALL_PATH, 'dump')
        if not os.path.exists(directory):
            os.makedirs(directory)
        path = os.path.join(directory, 'fileName')
        print(F'dump path : {path}')
        file = open(path,'w', encoding='utf8')
        file.write(raw)
        file.close()