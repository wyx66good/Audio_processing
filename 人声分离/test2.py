# import os, sys
# import numpy as np
# from scipy import signal
# import librosa.display
# import soundfile as sf
# import matplotlib.pyplot as plt  # 导入绘图工作的函数集合
# import binascii

# file = open('a.txt', 'rb')

# data = file.read()

# hex_data = binascii.hexlify(data)

# a=1




# # 十六进制字符串转换为有符号十进制数
# def f_hexToSignedInt(hexStr, numBits=16):
#     """
#     function:  十六进制字符串转换为有符号十进制数
#           in:  hexStr：十六进制字符串；
#                numBits：十六进制数在内存中的表示方式（例如，它是否是 16 位、32 位还是 64 位等），默认为16位；
#          out:  signedInt：有符号十进制数int类型；
#       return:  int
#       others:  Convert Hexadecimal String To Signed Decimal Number
#     """
#     # 将十六进制数转换为无符号整数
#     unsignedInt = int(hexStr, 16)
#     # 检查最高位
#     if (unsignedInt >> (numBits - 1)) & 1:
#         # 如果最高位是 1，执行二进制补码转换
#         signedInt = unsignedInt - (1 << numBits)
#     else:
#         # 如果最高位是 0，则无需转换
#         signedInt = unsignedInt
#     # 返回int类型的有符号十进制数
#     return signedInt

# if __name__ == '__main__':
#     # 使用函数
#     # num = -700
#     # 假设是 16 位数
#     num_bits = 16
#     hex_str=np.zeros(1024)
#     i=0
#     with open( 'a.txt', 'r') as f:
#     #渎取文件内容，并辩每行的十六进制滋转换为十进制滋
#         for line in f:
# #渎取文件内容，并辩每行的十六进制滋转换为十进制滋for line in f:
#             num = line.strip()#去除行末的换行符
#             # dec_num = int(hex_str,16)#将十六进制数转换为十进制数print(dec_num)
#         # print(dec_num)
#             a= f_hexToSignedInt(num)
#             hex_str[i]=a
#             i=i+1
#     # print(hex_str)
#     b=np.fft.fft(hex_str,1024)
#     print(b)

import pyttsx3

engine = pyttsx3.init()
engine.setProperty('rate', 150)
engine.setProperty('volume', 0.7)

text = "你好，欢迎使用 pyttsx3 中文语音合成！"
engine.say(text)
engine.runAndWait()

engine.save_to_file(text, 'output.wav')
engine.runAndWait()
