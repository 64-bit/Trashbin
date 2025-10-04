import sys
import os

def main():
    if(len(sys.argv) == 1):
        print("No input file specified")
        return

    file = sys.argv[1]
    deleteOldBin(file)

    from riscv_assembler.convert import AssemblyConverter
    cnv = AssemblyConverter()
    cnv.convert(file)

    in_file = open(f"{file.split('.')[0]}\\bin\\{file.split('.')[0]}.bin", "rb") # opening for [r]eading as [b]inary
    data = in_file.read() # if you only wanted to read 512 bytes, do .read(512)
    in_file.close()


    outFile = open(f"{file.split('.')[0]}.hex", 'w')
    writeNewBinary(file, data, outFile)

def deleteOldBin(filename):
    split = filename.split('.')[0]
    os.system(f'rd /s /q {split}')


def writeNewBinary(name, bytes, targetFile):
    memoryWordSize = 4

    print(bytes)

    for i in range(int(len(bytes) / 4)):
        line = bytesToLine(bytes, i*4)
        targetFile.write(line)
    targetFile.write(":00000001FF\r\n")
    targetFile.close()


def bytesToLine(array, startIndex):
    sum = 0
    dataString = ""

    for i in range(4):
        sum += int(array[startIndex+i])
        dataString += formatAsHex(int(array[startIndex+i]))

    resultLine = f":{4:02X}{int(startIndex/4):04X}00{dataString}{int(calc_checksum(int(sum), 4, int(startIndex/4))):02X}\n"

    return resultLine


def formatAsHex(byte):
    return f"{byte:02X}"


def calc_checksum(base_sum, byteCount, addressStart):

    base_sum +=  byteCount
    base_sum += addressStart & 0xFF
    base_sum += (addressStart >> 8) & 0xFF


    base_sum = base_sum & 0xFF
    base_sum = ~base_sum
    base_sum += 1
    return base_sum & 0xFF

if __name__ == "__main__":
    # execute only if run as a script
    main()