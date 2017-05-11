#from numpy import *
import numpy as np

#   x   -   data
#   win -   length or window func
#   inc -   frame offset
def enframe(x, win, inc):

    nx = np.size(x)

    nf = int((nx - win + inc) / inc)  # number of frames

    f = np.mat(np.zeros((nf, win)))

    for index in range(0, nf):
        f[index, 0:win] = x[0, index * inc:index * inc + win]

    return f

#   Short Time Average Energy
#   x   -   data
#   fn  -   frame number
def STA_E(x, fn):
    amp = np.zeros((1, fn))
    for index in range(0, fn):
        amp[0, index] = np.sum(np.square(x[index]))

    return amp

## Short Time Average zero-crossing rate
#   x   -   data
#   fn  -   frame number
def STA_ZCR(x,fn):
    wlen = np.size(x,0)


    return