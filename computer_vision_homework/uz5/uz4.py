#!/usr/bin/env python3

import numpy as np
import cv2
from PIL import Image
import matplotlib.pyplot as plt
import math
import os
import random
from a4_utils import *

swap = lambda x,y: (y,x)
imread = lambda path: np.asarray(Image.open(path).convert('RGB')).astype(np.float64)/255
gray=lambda I: (lambda x,y,z: (x+y+z)/3)(I[:,:,0],I[:,:,1],I[:,:,2])

l2 = lambda I,J: np.sqrt(np.sum((I-J)**2))
chi = lambda e0: lambda I,J: 0.5*np.sum((I-J)**2/(I+J+e0))
inter = lambda I,J: 1-np.sum(np.min(np.array([I,J]),axis=0))
hell = lambda I,J: np.sqrt(np.sum((np.sqrt(I)-np.sqrt(J))**2)/2)

#gaussf = lambda s: lambda x: np.exp(-x**2/(2*s**2))/(np.sqrt(2*np.pi)*s)
# Gaussian kernel
#def gauss(sigma):
#    N = 2*np.ceil(3*sigma)+1
#    x = np.arange(-N,N+1)
#    return gaussf(sigma)(x).reshape(1,-1)

#gaussd = lambda s: lambda x: -1/(s**3*np.sqrt(2*np.pi))*x*np.exp(-x**2/(2*s**2))
# Gaussian derivative kernel
#def gaussdx(sigma):
#    N = 2*np.ceil(3*sigma)+1
#    x = np.arange(-N,N+1)
#    return ((lambda g: g/np.abs(g).sum())(gaussd(sigma)(x))).reshape(1,-1)

def ds_mag(D,G):
    conv2 = lambda k1,k2: lambda I: cv2.filter2D(cv2.filter2D(I,-1,np.flip(k1)),-1,np.flip(k2))
    dx, dy = conv2(D,G.T), conv2(G,D.T)
    mag = lambda I: np.sqrt(dx(I)**2+dy(I)**2)
    return dx,dy,mag

def gradient_magnitude(I,sigma=2):
    G,D = gauss(sigma),gaussdx(sigma)
    dx,dy,mag = ds_mag(D,G)
    return dx(I),dy(I),mag(I)

def nonmaxima_suppression_box(I,w=3):
    my,mx = I.shape
    R = np.zeros(I.shape)
    b2i = lambda x: 1 if x else 0
    for y,x in zip(*np.nonzero(I)):
        R[y,x]=I[y,x]*b2i(np.all(I[y,x] >= I[max(0,y-1):min(my,y+2), max(0,x-1):min(mx,x+2)]))
    return R

def hessian_points(I,t=0,sigma=2,w=3):
    G,D = gauss(sigma),gaussdx(sigma)
    dx,dy,mag = ds_mag(D,G)
    det = dx(dx(I))*dy(dy(I))-dx(dy(I))**2
    ps = np.where(nonmaxima_suppression_box(det,w)>t)
    return det,ps

def e1a():
    I = gray(imread('data/graf/graf_a.jpg'))
    plt.clf()
    l = 3
    for i in range(l):
        sigma=(i+1)*3
        det,ps = hessian_points(I,sigma=sigma,t=0.004)
        plt.subplot(2,l,i+1,title='sigma = '+str(sigma))
        plt.imshow(det)
        plt.subplot(2,l,(i+1)+l)
        plt.imshow(I,cmap='gray')
        plt.scatter(*swap(*ps),s=3,c='r')
    plt.show()

# Question: What kind of structures in the image are detected by the algorithm?
# How does the parameter σ affect the result?

def harris(I,sigma=2,thr=0):
    sigmal,alpha = 1.6,0.06
    G,D = gauss(sigma*sigmal),gaussdx(sigma*sigmal)
    dx,dy,mag = ds_mag(D,G)
    conv2 = lambda k1,k2: lambda I: cv2.filter2D(cv2.filter2D(I,-1,np.flip(k1)),-1,np.flip(k2))
    dx,dy,mag = dx(I),dy(I),mag(I)
    C11 = conv2(G,G.T)(dx*dx)
    C12 = conv2(G,G.T)(dx*dy)
    C21 = conv2(G,G.T)(dy*dx)
    C22 = conv2(G,G.T)(dy*dy)
    Cdet = C11*C22-C12*C21
    Ctr = C11+C22
    r = Cdet - alpha*Ctr*Ctr
    ps = np.argwhere(nonmaxima_suppression_box(r,3)>thr).T
    return r,ps

def e1b(sigma=2):
    I = gray(imread('data/graf/graf_a.jpg'))
    plt.clf()
    l = 3
    for i in range(l):
        r,ps = harris(I,sigma,thr=4e-6)
        sigma=(i+1)*3
        plt.subplot(2,l,i+1,title='sigma = '+str(sigma))
        plt.imshow(r)
        plt.subplot(2,l,(i+1)+l)
        plt.imshow(I,cmap='gray')
        #print(ps)
        plt.scatter(*swap(*ps),s=3,c='r')
    plt.show()

# Do the feature points of both detectors appear on the same structures in the image?

def find_correspondences(l1,l2,dist=hell):
    return [(i,np.array([dist(l,m) for m in l2]).argmin())
            for i,l in enumerate(l1)]

def unzip(l):
    return [x[0] for x in l],[x[1] for x in l]

def e2a():
    I1 = gray(imread('data/graf/graf_a_small.jpg'))
    I2 = gray(imread('data/graf/graf_b_small.jpg'))
    _,hess1 = hessian_points(I1,0.007)
    _,hess2 = hessian_points(I2,0.003)
    desc1 = (simple_descriptors(I1,*(hess1)))
    desc2 = (simple_descriptors(I2,*(hess2)))
    corr = unzip(find_correspondences(desc1,desc2))
    display_matches(I1,np.flip(np.array(hess1).T[corr[0]]),I2,np.flip(np.array(hess2).T[corr[1]]))

def find_matches(I1,I2,t,descript=simple_descriptors,dist=hell,f_points=hessian_points):
    _,hess1 = f_points(I1,t)
    _,hess2 = f_points(I2,t)
    """
    plt.clf()
    plt.subplot(1,2,1)
    plt.imshow(I1,cmap='gray')
    plt.scatter(*swap(*hess1))
    plt.subplot(1,2,2)
    plt.imshow(I2,cmap='gray')
    plt.scatter(*swap(*hess2))
    plt.show()
    """
    desc1 = (descript(I1,*(hess1)))
    desc2 = (descript(I2,*(hess2)))
    plt.clf()
    corr1 = (find_correspondences(desc1,desc2,dist=dist))
    corr2 = (find_correspondences(desc2,desc1,dist=dist))
    corr = unzip(list(set(corr1).intersection(map(lambda x:swap(*x),corr2))))
    d1s=(descript(I1,*np.array(hess1).T[corr[0]].T))
    return (np.array(hess1)).T,(np.array(hess2)).T,corr

def e2b():
    I1 = gray(imread('data/graf/graf_a_small.jpg'))
    I2 = gray(imread('data/graf/graf_b_small.jpg'))
    lh1,lh2,corr = find_matches(I1,I2,0.005)
    display_matches(I1,np.flip(lh1[corr[0]]),I2,np.flip(lh2[corr[1]]))

#Question: What do you notice when visualizing the correspondences? How accurate are the matches?

def hamming(l1,l2):
    return np.count_nonzero(np.array(l1)!=np.array(l2))

def genBRIEF(sampling='uniform',s=20,nd=128*6,sigma=2,vis=False):
    def pol2xy(ls,ans):
        return np.array([ls*np.cos(ans),ls*np.sin(ans)])
    rng = np.random.default_rng()
    match sampling:
        case 'uniform':
            p=np.array([rng.integers(low=-s//2,high=s//2,size=nd),
                        rng.integers(low=-s//2,high=s//2,size=nd)])
            q=np.array([rng.integers(low=-s//2,high=s//2,size=nd),
                        rng.integers(low=-s//2,high=s//2,size=nd)])
        case 'normal':
            p=np.array([np.digitize(rng.normal(0,1/25*s**2/4,size=nd),np.arange(-s//2,s//2)),
                        np.digitize(rng.normal(0,1/25*s**2/4,size=nd),np.arange(-s//2,s//2))])-s//2
            q=np.array([np.digitize(rng.normal(0,1/25*s**2/4,size=nd),np.arange(-s//2,s//2)),
                        np.digitize(rng.normal(0,1/25*s**2/4,size=nd),np.arange(-s//2,s//2))])-s//2
        case 'gauss2':
            p=np.array([np.digitize(rng.normal(0,1/25*s**2/4,size=nd),np.arange(-s//2,s//2)),
                        np.digitize(rng.normal(0,1/25*s**2/4,size=nd),np.arange(-s//2,s//2))])-s//2
            q=np.array([np.digitize(rng.normal(0,1/100*s**2/2,size=nd),np.arange(-s//2,s//2)),
                        np.digitize(rng.normal(0,1/100*s**2/2,size=nd),np.arange(-s//2,s//2))])-s//2
            q = np.clip(p+q,-s//2,s//2)
        case 'polar':
            rou = 2*np.pi/32
            p=pol2xy(rng.integers(low=0,high=s//2,size=nd),
                     np.round(rng.uniform(0,2*np.pi,size=nd)/rou)*rou)
            q=pol2xy(rng.integers(low=0,high=s//2,size=nd),
                     np.round(rng.uniform(0,2*np.pi,size=nd)/rou)*rou)
            p = np.digitize(p,np.arange(-s//2,s//2))-s//2
            q = np.digitize(q,np.arange(-s//2,s//2))-s//2
        case 'polar2':
            nang= nd//(s//2)
            rou = 2*np.pi/nang
            p=np.zeros((2,nd))
            q=pol2xy(np.hstack([np.tile(np.arange(0,s//2),nang),np.arange(0,nd%(s//2))]),
                     np.round(rng.uniform(0,2*np.pi,size=nd)/rou)*rou)
            q = np.digitize(q,np.arange(-s//2,s//2))-s//2
    if vis:
        plt.clf()
        plt.scatter(q[0],q[1])
        plt.scatter(p[0],p[1])
        plt.show()
    def brief(I,ys,xs):
        r = []
        G = gauss(sigma)
        conv2 = lambda k1,k2: lambda I: cv2.filter2D(cv2.filter2D(I,-1,np.flip(k1)),-1,np.flip(k2))
        I = conv2(G,G.T)(I)
        I = np.pad(I,(s,s),'edge')
        for y,x in zip(ys,xs):
            gI = lambda k: I[k[0],k[1]]
            poi = lambda i: gI(p.T[i]+[y,x]+s) < gI(q.T[i]+[y,x]+s)
            r += [[1 if poi(i) else 0 for i in range(nd)]]
        return np.array(r)
    return brief

def e2d():
    for d in ['uniform','normal','gauss2','polar','polar2']:
        genBRIEF(d,vis=True)
    I1 = gray(imread('data/sud_a.tiff'))
    I2 = gray(imread('data/sud_b.png'))
    lh1,lh2,corr = find_matches(I1,I2,0.003,descript=genBRIEF('normal'),dist=hamming)
    display_matches(I1,np.flip(lh1[corr[0]]),I2,np.flip(lh2[corr[1]]))
    lh1,lh2,corr = find_matches(I1,I2,0.003)
    display_matches(I1,np.flip(lh1[corr[0]]),I2,np.flip(lh2[corr[1]]))
    plt.show()
    I1 = gray(imread('data/graf/graf_a_small.jpg'))
    I2 = gray(imread('data/graf/graf_b_small.jpg'))
    lh1,lh2,corr = find_matches(I1,I2,0.008,descript=genBRIEF('uniform'),dist=hamming)
    display_matches(I1,np.flip(lh1[corr[0]]),I2,np.flip(lh2[corr[1]]))
    plt.show()

def estimate_homography(ps1,ps2):
    A = []
    for p1,p2 in zip(ps1,ps2):
        A += [[p1[0],p1[1],1,0,0,0,-p2[0]*p1[0],-p2[0]*p1[1],-p2[0]]]
        A += [[0,0,0,p1[0],p1[1],1,-p2[1]*p1[0],-p2[1]*p1[1],-p2[1]]]
    _,_,V = np.linalg.svd(np.array(A))
    return (V[-1]/V[-1,-1]).reshape((3,3))

def e3a():
    I1 = gray(imread('data/newyork/newyork_a.jpg'))
    I2 = gray(imread('data/newyork/newyork_b.jpg'))
    ps = np.loadtxt('data/newyork/newyork.txt')
    h = np.loadtxt('data/newyork/H.txt')
    ps1,ps2 = ps[:,0:2],ps[:,2:4]
    #display_matches(I1,ps1,I2,ps2)
    est = estimate_homography(ps1,ps2)
    plt.clf()
    plt.subplot(2,3,1)
    plt.imshow(I1,cmap='gray')
    plt.subplot(2,3,2)
    plt.imshow(I2,cmap='gray')
    plt.subplot(2,3,3)
    plt.imshow(cv2.warpPerspective(I1,est,I1.shape),cmap='gray')
    I1 = gray(imread('data/graf/graf_a.jpg'))
    I2 = gray(imread('data/graf/graf_b.jpg'))
    ps = np.loadtxt('data/graf/graf.txt')
    ps1,ps2 = ps[:,0:2],ps[:,2:4]
    #display_matches(I1,ps1,I2,ps2)
    est = estimate_homography(ps1,ps2)
    plt.subplot(2,3,4)
    plt.imshow(I1,cmap='gray')
    plt.subplot(2,3,5)
    plt.imshow(I2,cmap='gray')
    plt.subplot(2,3,6)
    plt.imshow(cv2.warpPerspective(I1,est,I1.T.shape),cmap='gray')
    plt.show()

def e3b(k=100,thr=3,perc=0):
    I1 = gray(imread('data/newyork/newyork_a.jpg'))
    I2 = gray(imread('data/newyork/newyork_b.jpg'))
    lh1,lh2,corr = find_matches(I1,I2,0.004)
    #display_matches(I1,np.flip(lh1[corr[0]]),I2,np.flip(lh2[corr[1]]))
    mat1,mat2 = np.flip(lh1[corr[0]]),np.flip(lh2[corr[1]])
    binl = []
    bmat = []
    berr = float('inf')
    best = None
    for i in range(k):
        # Randomly select a minimal set of matches that are required to estimate a model (that is 4 matches for homography).
        ss = np.array(random.sample(range(len(mat1)),4),dtype='uint')
        # Estimate the homography matrix.
        est = estimate_homography(mat1[ss],mat2[ss])
        # Determine the inliers for the estimated homography (i.e. matched pairs with the reprojection error below a given threshold).
        inl=[]
        for s in range(len(mat1)):
            x = np.hstack([mat1[s],1]).reshape(3,1)
            y = np.hstack([mat2[s],1]).reshape(3,1)
            if l2(est.dot(x),y)<thr:
                inl+=[s]
        # If the percentage of inliers if large enough, use the entire inlier subset to estimate a new homography matrix.
        if len(inl)>3 and len(inl)/len(mat1)>perc:
            est = estimate_homography(mat1[inl],mat2[inl])
            inl1=[]
            err = []
            for s in range(len(mat1)):
                x = np.hstack([mat1[s],1]).reshape(3,1)
                y = np.hstack([mat2[s],1]).reshape(3,1)
                err += [l2(est.dot(x),y)]
                if err[-1]<thr:
                    inl1+=[s]
            err = np.mean(err)
            # If the error of the newly computed homography is lower than any before, save the inlier set and the corresponding homography matrix.
            if berr>err:
                binl = inl1
                best = est
                berr = err
    print(binl)
    if best is None:
        raise ValueError('No suitable estimation found.')
    display_matches(I1,mat1[binl],I2,mat2[binl])
    plt.clf()
    plt.subplot(1,3,1)
    plt.imshow(I1,cmap='gray')
    plt.subplot(1,3,2)
    plt.imshow(I2,cmap='gray')
    plt.subplot(1,3,3)
    print(best)
    plt.imshow(cv2.warpPerspective(I1,(best),I1.T.shape),cmap='gray')
    plt.show()

# Question: How many iterations on average did you need to find a good solution?
# How does the parameter choice for both the keypoint detector and RANSAC itself influence the performance (both quality and speed)?
def warpPerspective(I,H):
    Is = I.shape
    # initialize final picture
    r = np.zeros(Is)
    # iterate over array coordinates
    for x,y in np.ndindex(*Is):
        # calculate from where copy pixel
        # (if calculated in the reverse direction there are holes)
        t = np.linalg.inv(H).dot([x,y,1])
        # round coordinates
        xt,yt,_ = np.round(t/t[-1]).astype('int')
        # only include pixels from valid locations
        if 0<=xt<Is[1] and 0<=yt<Is[0]:
            r[y,x]=I[yt,xt]
    return r

def e3d():
    I1 = gray(imread('data/newyork/newyork_a.jpg'))
    ps = np.loadtxt('data/newyork/newyork.txt')
    h = np.loadtxt('data/newyork/H.txt')
    ps1,ps2 = ps[:,0:2],ps[:,2:4]
    plt.clf()
    plt.subplot(2,2,1)
    plt.imshow(I1,cmap='gray')
    plt.subplot(2,2,2)
    plt.imshow(cv2.warpPerspective(I1,h,I1.T.shape),cmap='gray')
    plt.subplot(2,2,4)
    plt.imshow(warpPerspective(I1,h),cmap='gray')
    plt.show()
