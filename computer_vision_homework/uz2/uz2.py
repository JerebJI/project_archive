#!/usr/bin/env python3

import numpy as np
import cv2
from PIL import Image
import matplotlib.pyplot as plt
import math
import os
from a2_utils import *

imread = lambda path: np.asarray(Image.open(path).convert('RGB')).astype(np.float64)/255
gray=lambda I: (lambda x,y,z: (x+y+z)/3)(I[:,:,0],I[:,:,1],I[:,:,2])

# 1.(a) # ON PAPER!

# 1.(b) #
def simple_convolution(I,k):
  conv = lambda x: np.sum(np.pad(k,(x,len(I)-len(k)-x))*I)
  return [conv(i) for i in np.arange(len(I)-len(k),dtype=int)]

def pad_convolution(I,k,p):
  return simple_convolution(np.pad(I,(len(k)//2,len(k)//2+len(k)%2),p),k)

def e1b():
    # read data
    k=read_data("kernel.txt")
    S=read_data("signal.txt")
    # on the same plot show simple and padded convolution
    plt.clf()
    plt.plot(range(len(k)),k)
    plt.plot(range(len(S)),S)
    sc = simple_convolution(S,k)
    plt.plot(range(len(sc)),sc)
    sc = pad_convolution(S,k,'edge')
    plt.plot(range(len(sc)),sc)
    plt.show()
    print('Kernel sum:',np.sum(k))
    # Can you recognize the shape of the kernel? Looks like Gaussian kernel.
    # What is the sum of the elements in the kernel? 1 (almost).
    # How does the kernel affect the signal? It smooths the signal.

def e1c():
    # implemented in e1b
    e1b()

# helper function (g)
gaussf = lambda s: lambda x: np.exp(-x**2/(2*s**2))/(np.sqrt(2*math.pi)*s)
# Gaussian kernel
def gauss(sigma):
    N = 2*np.ceil(3*sigma)+1
    return gaussf(sigma)(np.arange(-N//2+1,N//2-(1-N%2)+1))

def e1d():
    # show gauss on different sigma's
    plt.clf()
    for s in [0.5,1,2,3,4]:
        g = gauss(s)
        plt.plot(np.arange(-len(g)//2+1,len(g)//2-(1-len(g)%2)+1),g)
    plt.show()

    # Sketch # ON PAPER!

def e1e():
    k=read_data("kernel.txt")
    S=read_data("signal.txt")
    # visualize
    k1=gauss(2)
    k2=np.array([0.1,0.6,0.4])
    plt.clf()
    plt.subplot(1,4,1)
    plt.title('s')
    plt.plot(range(len(S)),S)
    plt.subplot(1,4,2)
    plt.title('(s*k1)*k2')
    R = pad_convolution(pad_convolution(S,k1,'edge'),k2,'edge')
    plt.plot(range(len(R)),R)
    plt.subplot(1,4,3)
    plt.title('(s*k2)*k1')
    R = pad_convolution(pad_convolution(S,k2,'edge'),k1,'edge')
    plt.plot(range(len(R)),R)
    plt.subplot(1,4,4)
    plt.title('s*(k1*k2)')
    R = pad_convolution(S,pad_convolution(k1,k2,'edge'),'edge')
    plt.plot(range(len(R)),R)
    plt.tight_layout()
    plt.show()

# implement 2d gaussfilter
def gaussfilter(I,s):
    gk = gauss(s)
    f1 = cv2.filter2D(src=I,ddepth=-1,kernel=gk)
    return cv2.filter2D(src=f1.T,ddepth=-1,kernel=gk).T

def e2a(m=1.3):
    # visualize gaussian filter on various images
    I = gray(imread('images/lena.png'))
    plt.clf()
    plt.subplot(2,3,1)
    plt.imshow(I,cmap='gray',vmin=0,vmax=1)
    plt.subplot(2,3,2)
    gI = gauss_noise(I)
    plt.imshow(gI,cmap='gray',vmin=0,vmax=1)
    plt.subplot(2,3,3)
    spI = sp_noise(I)
    plt.imshow(spI,cmap='gray',vmin=0,vmax=1)
    plt.subplot(2,3,5)
    plt.imshow(gaussfilter(gI,m),cmap='gray',vmin=0,vmax=1)
    plt.subplot(2,3,6)
    plt.imshow(gaussfilter(spI,m),cmap='gray',vmin=0,vmax=1)
    plt.tight_layout()
    plt.show()
    # Question: Which noise is better removed using the Gaussian filter?
    # Gaussian noise.

def e2b():
    # read image
    mus = gray(imread('images/museum.jpg'))
    plt.clf()
    plt.subplot(1,2,1)
    plt.imshow(mus,cmap='gray')
    plt.subplot(1,2,2)
    # create "sharpening" kernel
    k=np.array([[0,0,0],[0,2,0],[0,0,0]])-1/9*np.ones((3,3))
    # use it
    plt.imshow(cv2.filter2D(src=mus,ddepth=-1,kernel=k),cmap='gray',vmin=0,vmax=1)
    plt.tight_layout()
    plt.show()

def simple_median(I,w):
    return np.median(np.lib.stride_tricks.sliding_window_view(I,w),axis=1)

def pad_median(I,k,p):
    return simple_median(np.pad(I,(k//2,k//2),p),k)

def e2c():
    # visualize noise
    # generate signal
    sig = np.zeros(50)
    sig[13:25]=0.5*np.ones(25-13)
    osig=np.copy(sig)
    rng = np.random.default_rng()
    # salt and pepper noise
    sig[rng.integers(50,size=5)],sig[rng.integers(50,size=5)]=0,1

    plt.clf()
    plt.subplot(1,4,1)
    plt.ylim([0,1.2])
    plt.plot(range(len(osig)),osig)
    plt.subplot(1,4,2)
    plt.ylim([0,1.2])
    plt.plot(range(len(sig)),sig)
    plt.subplot(1,4,3)
    plt.ylim([0,1.2])
    plt.plot(range(len(sig)),pad_convolution(sig,gauss(1),'edge'))
    plt.subplot(1,4,4)
    plt.ylim([0,1.2])
    plt.plot(range(len(sig)),pad_median(sig,5,'edge'))
    plt.tight_layout()
    plt.show()
    # Question: Which filter performs better at this specific task?
    # In comparison to Gaussian filter that can be applied multiple times in any order, does the order
    # matter in case of median filter?
    # What is the name of filters like this?
    # Median. Yes. Non-commutative.

def median2d(I,w):
    sw = np.lib.stride_tricks.sliding_window_view(I,(w,w))
    r = np.zeros((I.shape[0]-w+1)*(I.shape[1]-w+1))
    sw = sw.reshape((I.shape[0]-w+1)*(I.shape[1]-w+1),w*w)
    return np.median(sw,axis=1).reshape((I.shape[0]-w+1,I.shape[1]-w+1))

def e2d():
    I = gray(imread('images/lena.png'))
    gI = gauss_noise(I)
    spI = sp_noise(I)
    # visualize
    plt.clf()
    plt.subplot(2,4,1)
    plt.imshow(I,cmap='gray',vmin=0,vmax=1)
    plt.subplot(2,4,2)
    plt.imshow(gI,cmap='gray',vmin=0,vmax=1)
    plt.subplot(2,4,3)
    plt.imshow(gaussfilter(gI,2),cmap='gray',vmin=0,vmax=1)
    plt.subplot(2,4,4)
    plt.imshow(median2d(gI,5),cmap='gray',vmin=0,vmax=1)
    plt.subplot(2,4,6)
    plt.imshow(spI,cmap='gray',vmin=0,vmax=1)
    plt.subplot(2,4,7)
    plt.imshow(gaussfilter(spI,2),cmap='gray',vmin=0,vmax=1)
    plt.subplot(2,4,8)
    m2d = median2d(spI,5)
    plt.imshow(median2d(spI,5),cmap='gray',vmin=0,vmax=1)
    plt.tight_layout()
    plt.show()
    # Question: What is the computational complexity of the Gaussian filter operation?
    # How about the median filter? What does it depend on? Describe the computational
    # complexity using the O(·) notation (you can assume n log n complexity for sorting).
    # Gauss(k*n^2), Median(n^2*k^2*log k^2)

def e2e():
    lin=gray(imread('images/lincoln.jpg'))
    oba=gray(imread('images/obama.jpg'))
    plt.clf()
    plt.subplot(2,3,1)
    plt.imshow(lin,cmap='gray')
    plt.subplot(2,3,2)
    plt.imshow(oba,cmap='gray')
    plt.subplot(2,3,4)
    ling = gaussfilter(lin,3)
    plt.imshow(ling,cmap='gray')
    plt.subplot(2,3,5)
    obal = oba-gaussfilter(oba,12)
    plt.imshow(obal,cmap='gray')
    plt.subplot(2,3,3)
    avg = np.average(np.array([ling,obal]),weights=[1,2],axis=0)
    plt.imshow(avg,cmap='gray')
    plt.tight_layout()
    plt.show()

def myhist3(I,bins):
  H = np.zeros((bins,bins,bins))
  rI = I.reshape((I.shape[0]*I.shape[1],3))
  wbin = np.floor(rI*bins).astype(int)
  wbin[wbin==bins]=bins-1
  vals,counts = np.unique(wbin,return_counts=True,axis=0)
  H[vals[:,0],vals[:,1],vals[:,2]]=counts
  return H/I.size*3

def e3a():
    I = imread("dataset/object_03_1.png")
    test = myhist3(I,8).reshape(-1)
    plt.clf()
    plt.bar(range(len(test)),test,width=4)
    plt.show()

l2 = lambda I,J: np.sqrt(np.sum((I-J)**2))
chi = lambda e0: lambda I,J: 0.5*np.sum((I-J)**2/(I+J+e0))
inter = lambda I,J: 1-np.sum(np.min(np.array([I,J]),axis=0))
hell = lambda I,J: np.sqrt(np.sum((np.sqrt(I)-np.sqrt(J))**2)/2)
dist = [l2,chi(0.1**10),inter,hell]
dist_name = ['l2','chi','inter','hell']
def compare_histograms(I,J,h):
    return dist[dist_name.index(h)](I,J)

def e3b():
    print('ABOVE')

def e3c():
    bins=8
    fs = ["dataset/object_01_1.png","dataset/object_02_1.png","dataset/object_03_1.png"]
    Is = [imread(f) for f in fs]
    hs = [myhist3(i,bins).reshape(-1) for i in Is]
    plt.clf()
    for i,I in enumerate(Is):
        plt.subplot(2,len(Is),i+1)
        plt.imshow(I)
        plt.subplot(2,len(Is),i+1+len(Is))
        plt.bar(range(len(hs[i])),hs[i],width=4)
        out = '\n'
        for d in dist_name:
            out+=d+'(h1, h'+str(i+1)+') = '+str(round(compare_histograms(hs[0],hs[i],d),3))+'\n'
        plt.title(out)
    plt.tight_layout()
    plt.show()
    # Question: Which image (object_02_1.png or object_03_1.png) is more similar
    # to image object_01_1.png considering the L2 distance? How about the other three
    # distances? We can see that all three histograms contain a strongly expressed com-
    # ponent (one bin has a much higher value than the others). Which color does this
    # bin represent?
    # The third. Also. Black.

def show_similar(file,dir,bins=8,l=l2):
  imgs = [dir+f for f in next(os.walk(dir))[2]]
  Is = [imread(I) for I in imgs]
  hs = [myhist3(i,bins).reshape(-1) for i in Is]
  h = myhist3(imread(file),bins).reshape(-1)
  ls = [l(I,h) for I in hs]
  si = list(zip(imgs,ls))
  si.sort(key=lambda x: x[1])
  #print(si)
  return [i[0] for i in si],si,ls

def e3d(img='17_3',bins=8):
    num=6
    ld = len(dist)
    plt.clf()
    for di,d in enumerate(dist):
        ss, si, _ =show_similar("dataset/object_"+img+".png","dataset/",bins=bins,l=d)
        for i,s in enumerate(ss[:num]):
            plt.subplot(2*ld,num,num*2*di+i+1)
            plt.imshow(imread(s))
            plt.subplot(2*ld,num,num*2*di+i+1+num)
            plt.title(dist_name[dist.index(d)]+': '+str(round(si[di][1],3)))
            h = myhist3(imread(si[i][0]),8).reshape(-1)
            plt.plot(range(len(h)),h)
    plt.show()
# Question: Which distance is in your opinion best suited for image retrieval?
# How does the retrieved sequence change if you use a different number of bins?
# Is the execution time affected by the number of bins?
# Chi, Hell. It is more accurate. It is greater.

def e3e(d=l2):
    ss, si, ls = show_similar("dataset/object_03_1.png","dataset/",l=d)
    plt.clf()
    plt.subplot(1,2,1)
    plt.plot(range(len(ls)),ls)
    for s in si[:6]:
        plt.scatter(ls.index(s[1]),s[1])
    plt.subplot(1,2,2)
    plt.plot(range(len(ss)),[i[1] for i in si])
    for i,s in enumerate(si[:6]):
        plt.scatter(i,s[1])
    plt.show()

def fb_show_similar(file,dir,lamb=0.1,bins=8,l=l2):
  imgs = [dir+f for f in next(os.walk(dir))[2]]
  Is = [imread(I) for I in imgs]
  hs = [myhist3(i,bins).reshape(-1) for i in Is]
  h = myhist3(imread(file),bins).reshape(-1)
  w = np.exp(-lamb*np.sum(np.array(hs),axis=0))
  ls = [l(w*I,w*h) for I in hs]
  si = list(zip(imgs,ls))
  si.sort(key=lambda x: x[1])
  return [i[0] for i in si],si,ls

def e3f(img='17_3',bins=8):
    dir = 'dataset/'
    imgs = [dir+f for f in next(os.walk(dir))[2]]
    Is = [imread(I) for I in imgs]
    hs = [myhist3(i,bins).reshape(-1) for i in Is]
    plt.clf()
    plt.bar(range(len(hs[0])),np.sum(np.array(hs),axis=0))
    plt.show()
    # Which bins dominate this histogram?
    # Dark.
    num=6
    ld = len(dist)
    plt.clf()
    for di,d in enumerate(dist):
        ss, si, _ =fb_show_similar("dataset/object_"+img+".png","dataset/",bins=bins,l=d)
        for i,s in enumerate(ss[:num]):
            plt.subplot(2*ld,num,num*2*di+i+1)
            plt.imshow(imread(s))
            plt.subplot(2*ld,num,num*2*di+i+1+num)
            plt.title(dist_name[dist.index(d)]+': '+str(round(si[di][1],3)))
            h = myhist3(imread(si[i][0]),8).reshape(-1)
            plt.plot(range(len(h)),h)
    plt.show()
    # Did the weighting help with retrieving relevant results?
    # Yes (somewhat).
