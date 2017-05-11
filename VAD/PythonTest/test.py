# -*- coding: utf-8 -*-
"""
Created on Fri Mar 10 17:18:25 2017

@author: sdp
"""

import wave
import numpy as np
import pylab as pl

fw = wave.open('test.wav','rb')
params = fw.getparams()
print(params)
nchannels, sampwidth, framerate, nframes = params[:4]
strData = fw.readframes(nframes)
waveData = np.fromstring(strData, dtype = np.int16)
waveData = waveData*1.0/max(abs(waveData))#nomolization

fw.close()

time = np.arange(0,len(waveData))*(1.0/framerate)

frameSize = 512
idx1 = 10000
idx2 = idx1+frameSize
index1 = idx1*1.0/framerate
index2 = idx2*1.0/framerate

#suanfa

#pl.subplot(311)
pl.plot(time, waveData)
pl.plot([index1,index1],[-1,1],'r')
pl.plot([index2,index2],[-1,1],'r')
pl.xlabel('time/second')
pl.ylabel('amplitude')
