# -*- coding: utf-8 -*-
"""
Created on Fri Mar 10 17:18:25 2017

@author: sdp
"""

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


#enframe
nx = np.size(waveData)
fn = int((nx - frameSize + frameSize/2) /(frameSize/2))  # number of frames
f = np.mat(np.zeros((fn, frameSize)))
tempWaveData = np.mat(waveData)
for index in range(0, fn):
    f[index, 0:frameSize] = tempWaveData[0, index * (frameSize/2):index * (frameSize/2) + frameSize]
i_temp = np.arange(0,fn)
#end enframe

# Short Time Average Energy - amp
amp = tools.STA_E(f,fn)

# Short Time Average zero-crossing rate




#pl.subplot(311)
pl.plot(time, waveData)
pl.xlabel('time/second')
pl.ylabel('amplitude')

pl.show()
