#!/usr/bin/env python3

import numpy as np
import cv2
from PIL import Image
import matplotlib.pyplot as plt
import math
import os
from a3_utils import *

imread = lambda path: np.asarray(Image.open(path).convert('RGB')).astype(np.float64)/255
gray=lambda I: (lambda x,y,z: (x+y+z)/3)(I[:,:,0],I[:,:,1],I[:,:,2])

gaussf = lambda s: lambda x: np.exp(-x**2/(2*s**2))/(np.sqrt(2*np.pi)*s)
# Gaussian kernel
def gauss(sigma):
    N = 2*np.ceil(3*sigma)+1
    x = np.arange(-N,N+1)
    return gaussf(sigma)(x).reshape(1,-1)

gaussd = lambda s: lambda x: -1/(s**3*np.sqrt(2*np.pi))*x*np.exp(-x**2/(2*s**2))
# Gaussian derivative kernel
def gaussdx(sigma):
    N = 2*np.ceil(3*sigma)+1
    x = np.arange(-N,N+1)
    return ((lambda g: g/np.abs(g).sum())(gaussd(sigma)(x))).reshape(1,-1)

def e1b(sigma=2):
    N = 2*np.ceil(3*sigma)+1
    x = np.arange(-N,N+1)
    plt.clf()
    plt.plot(x,gaussdx(sigma).reshape(-1))
    plt.plot(x,gauss(sigma).reshape(-1))
    plt.show()

def e1c(sigma=3):
    impulse = np.zeros((50,50))
    impulse[25, 25] = 1
    G,D = gauss(sigma),gaussdx(sigma)
    titles = ['$G,D^T$','$D,G^T$','$G,G^T$','$G^T,D$','$D^T,G$']
    convs = [(G,D.T),(D,G.T),(G,G.T),(G.T,D),(D.T,G)]
    plt.clf()
    plt.subplot(2,3,1,title='Impulse'); plt.imshow(impulse,cmap='gray')
    for i,c in enumerate(convs):
        plt.subplot(2,3,i+2,title=titles[i])
        plt.imshow(cv2.filter2D(cv2.filter2D(impulse,-1,np.flip(c[0])),-1,np.flip(c[1])),cmap='gray')
    plt.tight_layout()
    plt.show()
    # Is the order of operations important?
    # No.

def ds_mag(D,G):
    conv2 = lambda k1,k2: lambda I: cv2.filter2D(cv2.filter2D(I,-1,np.flip(k1)),-1,np.flip(k2))
    dx, dy = conv2(D,G.T), conv2(G,D.T)
    mag = lambda I: np.sqrt(dx(I)**2+dy(I)**2)
    return dx,dy,mag

def gradient_magnitude(I,sigma=2):
    G,D = gauss(sigma),gaussdx(sigma)
    dx,dy,mag = ds_mag(D,G)
    return dx(I),dy(I),mag(I)

def e1d(sigma=2):
    mus = gray(imread('images/museum.jpg'))
    G,D = gauss(sigma),gaussdx(sigma)
    titles = ['$I_x$','$I_y$','$I_{mag}$','$I_{xx}$','$I_{xy}$','$I_{yy}$','$I_{dir}$']
    dx, dy, mag = ds_mag(D,G)
    ims = [dx(mus),dy(mus),mag(mus),dx(dx(mus)),dx(dy(mus)),dy(dy(mus)),np.arctan2(dy(mus),dx(mus))]
    plt.subplot(2,4,1,title='I'); plt.imshow(mus,cmap='gray')
    for i,I in enumerate(ims):
        plt.subplot(2,4,i+2,title=titles[i])
        plt.imshow(I,cmap='gray')
    plt.tight_layout()
    plt.show()

l2 = lambda I,J: np.sqrt(np.sum((I-J)**2))
chi = lambda e0: lambda I,J: 0.5*np.sum((I-J)**2/(I+J+e0))
inter = lambda I,J: 1-np.sum(np.min(np.array([I,J]),axis=0))
hell = lambda I,J: np.sqrt(np.sum((np.sqrt(I)-np.sqrt(J))**2)/2)

def myhist3(I,bins):
  H = np.zeros((bins,bins,bins))
  rI = I.reshape((I.shape[0]*I.shape[1],3))
  wbin = np.floor(rI*bins).astype(int)
  wbin[wbin==bins]=bins-1
  vals,counts = np.unique(wbin,return_counts=True,axis=0)
  H[vals[:,0],vals[:,1],vals[:,2]]=counts
  return H/I.size*3

def fb_show_similar(file,dir,lamb=0.1,bins=8,l=l2):
  imgs = [dir+f for f in next(os.walk(dir))[2]]
  Is = [imread(I) for I in imgs]
  hs = [myhist3(i,bins).reshape(-1) for i in Is]
  h = myhist3(imread(file),bins).reshape(-1)
  ls = [l(I,h) for I in hs]
  si = list(zip(imgs,ls))
  si.sort(key=lambda x: x[1])
  return [i[0] for i in si],si,ls

def hist(mag,ang):
    wbin = np.digitize(ang%(2*np.pi),np.linspace(0,2*np.pi,8))
    wbin[wbin==8]-=1
    r = np.zeros(8)
    for (y,x),_ in np.ndenumerate(wbin):
        r[wbin[y,x]]+=mag[y,x]
    return r

def chist(mag,ang):
    r = np.zeros((8,8,8))
    for i in range(8):
        for j in range(8):
            x1, x2 = i*round(mag.shape[1]/8), (i+1)*round(mag.shape[1]/8)
            y1, y2 = j*round(mag.shape[0]/8), (j+1)*round(mag.shape[0]/8)
            r[i,j]=hist(mag[y1:y2,x1:x2],ang[y1:y2,x1:x2])
    return r.reshape(-1)

def show_similar(file,dir,l=l2,sigma=2):
    G,D = gauss(sigma),gaussdx(sigma)
    dx, dy, mag = ds_mag(D,G)
    imgs = [dir+f for f in next(os.walk(dir))[2]]
    Is = [gray(imread(I)) for I in imgs]
    ds = [(dx(I),dy(I)) for I in Is]
    mags = [mag(I) for I in Is]
    angs = [np.arctan2(dy,dx) for dx,dy in ds]
    hs = [chist(m,a) for m,a in zip(mags,angs)]
    I = gray(imread(file))
    h = chist(mag(I),np.arctan2(dy(I),dx(I)))
    ls = [l(I,h) for I in hs]
    si = list(zip(imgs,ls))
    si.sort(key=lambda x: x[1])
    return [i[0] for i in si],si,ls

def e1e(img='05_3',bins=8):
    num=6
    plt.clf()
    d=hell
    ss, si, _ =fb_show_similar("dataset/object_"+img+".png","dataset/",bins=bins,l=d)
    for i,s in enumerate(ss[:num]):
        plt.subplot(2,num,i+1)
        plt.imshow(imread(s))
    ss, si, _ =show_similar("dataset/object_"+img+".png","dataset/",l=d)
    for i,s in enumerate(ss[:num]):
        plt.subplot(2,num,i+1+num)
        plt.imshow(imread(s))
    plt.show()

def findedges(I,sigma,theta):
    G,D = gauss(sigma),gaussdx(sigma)
    _, _, mag = ds_mag(D,G)
    return np.where(mag(I)>=theta,1,0)

def e2a(N=9,sigma=1):
    mus = gray(imread('images/museum.jpg'))
    plt.clf()
    for i,th in enumerate(np.linspace(0,0.1,N)):
        plt.subplot(int(np.ceil(np.sqrt(N))),int(np.ceil(np.sqrt(N))),i+1,title='$\\vartheta=$'+str(th))
        plt.imshow(findedges(mus,sigma,th),cmap='gray')
    plt.tight_layout()
    plt.show()
    # Can you set the parameter so that all the edges in the image are clearly visible?
    # Yes (?).

def ang2nei(a):
    bin = np.digitize((a+np.pi/8)%(2*np.pi),np.arange(1,9)*(2*np.pi)/8)
    bins = [(0,1),(1,1),(1,0),(1,-1),(0,-1),(-1,-1),(-1,0),(-1,1),(0,1)]
    r = bins[bin]
    return [r,(-r[0],-r[1])]

def nonmaxima_suppression(mag,dire):
    r = mag.copy()
    my,mx = mag.shape
    for (y,x),_ in np.ndenumerate(mag):
        for ds in ang2nei(dire[y,x]%(2*np.pi)):
            if r[y,x] < mag[np.clip(y+ds[0],0,my-1),np.clip(x+ds[1],0,mx-1)]:
                r[y,x] = 0
                break
    return r

def e2b(sigma=2):
    mus = gray(imread('images/museum.jpg'))
    G,D = gauss(sigma),gaussdx(sigma)
    dx,dy,mag = ds_mag(D,G)
    dire = np.arctan2(dy(mus),dx(mus))
    return nonmaxima_suppression(mag(mus),dire)

def e2c(sigma=2):
    musns = e2b(sigma)
    musl,mush = np.where(musns>0.04,1,0),np.where(musns>0.1,1,0)
    plt.clf()
    plt.subplot(1,3,1,title='low threshold')
    plt.imshow(musl)
    plt.subplot(1,3,2,title='high threshold')
    plt.imshow(mush)
    plt.subplot(1,3,3,title='original')
    plt.imshow(musns)
    plt.show()
    n, labels, stats, centroids = cv2.connectedComponentsWithStats(musl.astype('uint8'), connectivity=8)
    r = np.zeros_like(musl)
    for i in range(1,n):
        if np.max(mush[labels==i])>0:
            r[labels==i] = 1
    plt.imshow(r,cmap='gray')
    plt.show()

# Question: Analytically solve the problem by using Hough transform: In 2D space
# you are given four points (0, 0), (1, 1), (1, 0), (2, 2). Define the equations of the lines that
# run through at least two of these points.

def acc(r,x,y):
    rhon, thetan = r.shape
    ths = np.linspace(-np.pi/2,np.pi,thetan)
    rhos = np.linspace(-rhon/2,rhon/2,rhon)
    ys = x*np.cos(ths)+y*np.sin(ths)
    ys = (lambda y:np.digitize(y,rhos))(ys)
    r[ys, np.arange(thetan)] += 1
    return r

def e3a():
    plt.clf()
    for i,c in enumerate([(10,10),(30,60),(50,20),(80,90)]):
        plt.subplot(2,2,i+1)
        plt.imshow(acc(np.zeros((300,300)),c[0],c[1]))
    plt.show()

def hough_find_lines(I,rhon,thetan):
    r = np.zeros((rhon+1,thetan))
    D = np.sqrt(I.shape[0]**2+I.shape[1]**2)
    ths = np.linspace(-np.pi/2,np.pi/2,thetan)
    rhos = np.linspace(-D,D,rhon)
    for y,x in zip(*np.nonzero(I)):
        ys = x*np.cos(ths)+y*np.sin(ths)
        ys = [np.digitize(y,rhos) for y in ys]
        r[ys, np.arange(thetan)] += 1
    return r[:-1,:]

def e3b():
   plt.clf()
   S = np.zeros((100,100))
   S[[10,10],[10,20]]=1
   Is = [S]
   Is += [gray(imread(I)) for I in ['images/oneline.png','images/rectangle.png']]
   for i,I in enumerate(Is):
       plt.subplot(2,3,i+1)
       plt.imshow(I)
       plt.subplot(2,3,4+i)
       if i!=0:
           plt.imshow(hough_find_lines(findedges(I,2,0.04),200,200))
       else:
           plt.imshow(hough_find_lines(I,300,300))
   plt.tight_layout()
   plt.show()

def nonmaxima_suppression_box(I,w=3):
    my,mx = I.shape
    R = np.zeros(I.shape)
    b2i = lambda x: 1 if x else 0
    for y,x in zip(*np.nonzero(I)):
        R[y,x]=I[y,x]*b2i(np.all(I[y,x] >= I[max(0,y-1):min(my,y+2), max(0,x-1):min(mx,x+2)]))
    return R

def e3c():
    Ie = findedges(gray(imread('images/rectangle.png')),2,0.3)
    I = hough_find_lines(Ie,300,300)
    plt.clf()
    plt.subplot(1,3,1)
    plt.imshow(Ie)
    plt.subplot(1,3,2)
    plt.imshow(I)
    plt.subplot(1,3,3)
    plt.imshow(nonmaxima_suppression_box(I))
    plt.show()

def e3d():
    S = np.zeros((100,100))
    S[[10,10],[10,20]]=1
    Is = [S]
    Is += [gray(imread(I)) for I in ['images/oneline.png','images/rectangle.png']]
    Ies = [findedges(I,2,0.3) for I in Is]
    Ies[0]=Is[0]
    Ihs = [hough_find_lines(Ie,300,300) for Ie in Ies]
    Imsbs = [nonmaxima_suppression_box(Ih) for Ih in Ihs]
    Ifs = [np.where(Imsb>340,1,0) for Imsb in Imsbs]
    Ifs[0] = np.where(Imsbs[0]>1,1,0)
    plt.clf()
    n = len(Is)
    for i in range(n):
        plt.subplot(n,5,1+i*5)
        plt.imshow(Ies[i])
        plt.subplot(n,5,2+i*5)
        plt.imshow(Ihs[i])
        plt.subplot(n,5,3+i*5)
        plt.imshow(Imsbs[i])
        plt.subplot(n,5,4+i*5)
        plt.imshow(Ifs[i])
        plt.subplot(n,5,5+i*5)
        plt.imshow(Is[i])
        thetan,rhon=300,300
        D = np.sqrt(Is[i].shape[0]**2+Is[i].shape[1]**2)
        ths = np.linspace(-np.pi/2,np.pi/2,thetan)
        rhos = np.linspace(-D,D,rhon)
        for y,x in zip(*np.nonzero(Ifs[i])):
            draw_line(rhos[y],ths[x],*Is[i].shape)
    plt.show()

def swap(x,y):
    return (y,x)

def e3e(thetan=400,rhon=400):
    ethr,fthr = [0.15,0.1],[950,850]
    Ims = ['images/bricks.jpg','images/pier.jpg']
    Is = [gray(imread(I)) for I in Ims]
    Ies = [findedges(I,2,ethr[i]) for i,I in enumerate(Is)]
    Ihs = [hough_find_lines(Ie,thetan,rhon) for Ie in Ies]
    Imsbs = [nonmaxima_suppression_box(Ih) for Ih in Ihs]
    Ifs = [np.where(Imsb>fthr[i],1,0) for i,Imsb in enumerate(Imsbs)]
    plt.clf()
    n = len(Is)
    for i in range(n):
        plt.subplot(n,3,1+i*3)
        plt.imshow(Ihs[i])
        plt.scatter(*swap(*np.nonzero(Ifs[i])))
        plt.subplot(n,3,2+i*3)
        plt.imshow(Ies[i])
        plt.subplot(n,3,3+i*3)
        plt.imshow(imread(Ims[i]))
        D = np.sqrt(Is[i].shape[0]**2+Is[i].shape[1]**2)
        ths = np.linspace(-np.pi/2,np.pi/2,thetan)
        rhos = np.linspace(-D,D,rhon)
        for y,x in zip(*np.nonzero(Ifs[i])):
            draw_line(rhos[y],ths[x],*Is[i].shape)
    plt.show()
