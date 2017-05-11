#from numpy import *
import numpy as np

'''
x = np.mat(np.ones((1,100)))

for index in range(0,100):
    x[0,index] = index

win = np.mat(np.ones((1,20)))
inc = 10
'''

######

import wave
import numpy as np
import pylab as pl
import tools

fw = wave.open('../test2.wav','rb')
params = fw.getparams()
print(params)
nchannels, sampwidth, framerate, nframes = params[:4]
strData = fw.readframes(nframes)
waveData = np.fromstring(strData, dtype = np.int16)
waveData = waveData*1.0/max(abs(waveData))#nomolization

fw.close()

time = np.arange(0,len(waveData))*(1.0/framerate)

frameSize = 512

######

x = np.mat(waveData)
win = frameSize
inc = win/2


nx = np.size(x)
nwin = np.size(win)

if nwin == 1 :
    wlen = win
else:
    wlen = nwin

nf = int((nx-wlen+inc)/inc)#number of frames

f = np.mat(np.zeros((nf, wlen)))

for index in range(0,nf):
    f[index,0:wlen] = x[0,index*inc:index*inc+wlen]

#####

'''
x = np.mat(np.ones((1,10)))

for index in range(0,10):
    x[0,index] = index
y = x.T
temp = y*x
#amp = np.mat(np.zeros((10,1)))
amp = np.zeros((1,10))

for index in range(0,10) :
    amp[0,index] = np.sum(np.square(temp[index]))
'''
fn = nf
wlen = np.size(x)
zcr = np.zeros(1,fn)
delta = 0.01
for index in range(0,fn):
    #n =



print("1")