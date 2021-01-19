import sys, os, math
import numpy as np

scale = 1

objFilePath = './dodecahedron2.obj'

with open(objFilePath) as file:
    objLines = file.readlines()
    file.close()

# to make the index match, i.e. start from 1
vertex = [None]
for line in objLines:
    string = line.split(" ")
    if string[0] == "v":
        vertex.append([string[1], string[2], string[3][:-1]])
# for i in vertex:
#     print(i)
surface = []
for line in objLines:
    string = line.split(" ")
    if string[0] == "f":
        index1 = int(string[1].split("/")[0]) 
        index2 = int(string[2].split("/")[0]) 
        index3 = int(string[3].split("/")[0]) 
        subList = []
        for i in vertex[index1]:
            subList.append(i)
        for i in vertex[index2]:
            subList.append(i)
        for i in vertex[index3]:
            subList.append(i)
        surface.append(subList)

def fxpDivisor(number):
    sol = []
    num = number
    for i in range(1, 9):
        partialRes = int(num // (16**(-1*i)))
        sol.append(hex(partialRes)[-1])
        num -= partialRes * 16**(-1*i)
    return sol

def fixedPointConverter(number):
    if number >= 0:
        zs = math.floor(number)
        partA = "0x%02x" % zs
        partB = fxpDivisor(number-zs)[0:2]
        assert(len(partA[-2:]+partB[0]+partB[1])==4)
        return partA[-2:]+partB[0]+partB[1]
    else:
        partialRes = fixedPointConverter(-1*number)
        rawBinary = bin(int(partialRes, 16))[2:]
        if len(rawBinary) > 16:
            raise ValueError
        if len(rawBinary) < 16:
            rawBinary = "0"*(16-len(rawBinary))+rawBinary
        res = [0]*len(rawBinary)
        for i in range(len(rawBinary)):
            if rawBinary[i] == "1":
                res[i] = "0"
            else:
                res[i] = "1"
        inverse = ''.join(res)
        if len(hex(int(inverse, 2)+0b1)[2:]) != 4:
            print(number/scale)
            print(partialRes, "\n")
            return hex(int(inverse, 2)+0b1)[3:]
        else:
            return hex(int(inverse, 2)+0b1)[2:]
#print(fixedPointConverter(-2.1754370e-002))

# print(fixedPointConverter(-6.836))
sol = []
for i in surface:
    tmp = []
    for j in i:
        #if float(j)*scale >= 100:
            #print(float(j)*scale)
            #print(j)
            #print(scale, "\n")
        res = fixedPointConverter(float(j)*scale)
        tmp.append(str(res))
    sol.append(''.join(tmp))

# for i in sol:
#     print(i)

with open("./out.txt", "w") as out:
    out.write("@1\n")
    for i in sol:
        out.write(i)
        out.write("\n")