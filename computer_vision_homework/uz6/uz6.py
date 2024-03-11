#!/usr/bin/env python3

import numpy as np
from matplotlib import pyplot as plt
from a6_utils import *
import cv2
from pathlib import Path
from PIL import Image
import random

def swap(x,y): return (y,x)
imread = lambda path: np.asarray(Image.open(path).convert('RGB')).astype(np.float64)/255
gray=lambda I: (lambda x,y,z: (x+y+z)/3)(I[:,:,0],I[:,:,1],I[:,:,2])

def e1a():
    ps = [[3,3,7,6],
          [4,6,6,4]]
    U,S,Vt = np.linalg.svd(ps)
    plt.clf()
    plt.scatter(ps[0],ps[1])
    mu = np.mean(ps,axis=1,keepdims=True)
    vs = U*np.sqrt(S)
    for i in [0,1]:
        plt.plot([mu[0],mu[0]+vs[0,i]], [mu[1],mu[1]+vs[1,i]],c=['r','g'][i])
    plt.show()

def pca(X):
    m,N = X.shape
    # calculate the mean value of the data
    mu = np.mean(X,axis=1,keepdims=True)
    # center the data
    X_d = X-mu
    # compute the covariance matrix
    C = (1/(N-1))*X_d@X_d.T
    # compute SVD of the covariance matrix
    U,S,Vt = np.linalg.svd(C)
    return U,S,Vt,mu,C

def e1bcd():
    ps = np.loadtxt('data/points.txt').T
    print(ps)
    U,S,Vt,mu,C = pca(ps)
    mu = mu.reshape(-1)
    plt.clf()
    plt.subplot(1,2,1)
    drawEllipse(mu,C)
    plt.scatter(*ps)
    vs = U*np.sqrt(S)
    plt.plot([mu[0],mu[0]+vs[0,0]], [mu[1],mu[1]+vs[1,0]],c='r')
    plt.plot([mu[0],mu[0]+vs[0,1]], [mu[1],mu[1]+vs[1,1]],c='g')
    plt.subplot(1,2,2)
    cums = np.cumsum(S)
    plt.bar(range(len(cums)),cums/cums[-1])
    print(cums[0]/cums[1],'of variance is explained by just the first vector.')
    plt.show()

def e1e():
    ps = np.loadtxt('data/points.txt').T
    U,S,Vt,mu,C = pca(ps)
    # transform data to PCA space
    pspca = U.T@(ps-mu)
    # set 0 to the components corresponding to the "lowest variance"
    pspca[np.argmin(S),:]=0
    # project back to Cartesian space
    pscar = U@pspca+mu
    plt.clf()
    drawEllipse(mu,C)
    plt.scatter(*ps)
    plt.scatter(*pscar)
    vs = U*np.sqrt(S)
    plt.plot([mu[0],mu[0]+vs[0,0]], [mu[1],mu[1]+vs[1,0]],c='r')
    plt.plot([mu[0],mu[0]+vs[0,1]], [mu[1],mu[1]+vs[1,1]],c='g')
    plt.show()

def e1f():
    ps = np.loadtxt('data/points.txt').T
    U,S,Vt,mu,C = pca(ps)
    q = np.array([6.,6.])
    cp = ps.T[np.argmin(np.linalg.norm(q-ps.T,axis=1))]
    print('Closest point to',q,'is',cp)
    pspca = U.T@(ps-mu)
    pspca[1,:]=0
    pscar = U@pspca+mu
    qpca = U.T@(q[:,np.newaxis]-mu)
    qpca[1,:]=0
    qpca=qpca.reshape(-1)
    qcar=U@qpca[:,np.newaxis]+mu
    cppca = ps.T[np.argmin(np.linalg.norm(qpca-pspca.T,axis=1))]
    print('Closest point to',q,'in PCA subspace is',cppca)
    plt.clf()
    drawEllipse(mu,C)
    plt.scatter(*ps)
    plt.scatter(*pscar)
    plt.scatter(*qcar)
    plt.scatter(*q)
    plt.arrow(*q,*(qcar.reshape(-1)-q),width=0.03,length_includes_head=True)
    for od,do in zip(ps.T,pscar.T):
        plt.arrow(*od,*(do.reshape(-1)-od),width=0.03,length_includes_head=True)
    plt.annotate('$q$',q)
    plt.annotate('$q_{pca}$',qcar)
    plt.annotate('closest',cp)
    plt.annotate('closest(pca)',cppca)
    vs = U*np.sqrt(S)
    plt.plot([mu[0],mu[0]+vs[0,0]], [mu[1],mu[1]+vs[1,0]],c='r')
    plt.plot([mu[0],mu[0]+vs[0,1]], [mu[1],mu[1]+vs[1,1]],c='g')
    plt.show()

def dpca(X,corr=0):
    m,N = X.shape
    # calculate the mean value of the data
    mu = np.mean(X,axis=1,keepdims=True)
    # center the data
    X_d = X-mu
    # compute the dual covariance matrix
    C = (1/(N-1))*(X_d.T@X_d)
    # compute SVD of the covariance matrix
    U,S,Vt = np.linalg.svd(C)
    # compute the basis of the eigenvector space
    U = X_d @ (U @ np.diag(np.sqrt(1/(S*(N-1))))+corr)
    return U,S,Vt,mu,C

def e2ab():
    ps = np.loadtxt('data/points.txt').T
    U,S,Vt,mu,C = pca(ps)
    dU,dS,dVt,dmu,dC = dpca(ps)
    print('Eigenvectors from PCA:')
    print(U*np.sqrt(S))
    print('Eigenvectors from dual PCA:')
    print(dU*np.sqrt(dS))
    print('U from dual PCA:')
    print(dU)
    mu = mu.reshape(-1)
    plt.clf()
    drawEllipse(mu,C)
    plt.scatter(*ps)
    vs = U*np.sqrt(S)
    plt.plot([mu[0],mu[0]+vs[0,0]], [mu[1],mu[1]+vs[1,0]],c='r')
    plt.plot([mu[0],mu[0]+vs[0,1]], [mu[1],mu[1]+vs[1,1]],c='g')
    dvs = dU*np.sqrt(dS)
    plt.plot([dmu[0],dmu[0]+dvs[0,0]], [dmu[1],dmu[1]+dvs[1,0]],'r--')
    plt.plot([dmu[0],dmu[0]+dvs[0,1]], [dmu[1],dmu[1]+dvs[1,1]],'--',c='lime')
    pspca = dU.T@(ps-dmu)
    pscar = dU@pspca+dmu
    plt.scatter(*pscar,marker='x')
    plt.show()

def e3a():
    return np.array([[gray(imread(p)).flatten()
                      for p in Path(f'data/faces/{i}').iterdir()]
            for i in range(1,4)])

def e3b1():
    ps = e3a()[0]
    sh=gray(imread('data/faces/1/001.png')).shape
    U,S,Vt,mu,C = dpca(ps.T,1e-15)
    plt.clf()
    for i in range(5):
        plt.subplot(1,5,i+1)
        plt.imshow(-U[:,i].reshape(96,84),cmap='gray')
    plt.show()

def e3b2():
    ps = e3a()[0]
    sh=gray(imread('data/faces/1/001.png')).shape
    U,S,Vt,mu,C = dpca(ps.T,1e-15)
    r,c=3,3
    i=1
    plt.clf()
    plt.subplot(r,c,1,title='original')
    plt.imshow((ps[i]).reshape(*sh),cmap='gray')
    plt.subplot(r,c,4,title='reprojected')
    pspca = U.T@(ps[i].reshape(-1,1)-mu)
    pscar = U @ pspca + mu
    plt.imshow(pscar.reshape(*sh),cmap='gray')
    plt.subplot(r,c,7,title='difference')
    plt.imshow((ps[i]-pscar.reshape(-1)).reshape(*sh))
    plt.subplot(r,c,2,title='pca component 0 removed')
    pspca[0] = 0
    pscar = U @ pspca + mu
    plt.imshow(pscar.reshape(*sh),cmap='gray')
    plt.subplot(r,c,5,title='difference')
    plt.imshow((pscar.reshape(-1)-ps[i]).reshape(*sh))
    plt.subplot(r,c,3,title='component 4047 removed')
    ps[i][4047] = 0
    plt.imshow(ps[i].reshape(*sh),cmap='gray')
    plt.subplot(r,c,6,title='reprojected')
    pspca = U.T@(ps[i].reshape(-1,1)-mu)
    pscar = U @ pspca + mu
    plt.imshow(pscar.reshape(*sh),cmap='gray')
    plt.show()

def e3c():
    ps = e3a()[1]
    U,S,Vt,mu,C = dpca(ps.T,1e-15)
    c = 1
    num = 6
    plt.clf()
    plt.subplot(1,num+1,1,title='original')
    plt.imshow(ps[c].reshape(96,84),cmap='gray')
    for i in range(num):
        exr = ps[c].copy()
        exrpca = U.T@(exr.reshape(-1,1)-mu)
        exrpca[2**(num-i-1):] = 0
        exr = U@exrpca+mu
        plt.subplot(1,num+1,i+2,title=f'{2**(num-i-1)} retained')
        plt.imshow(exr.reshape(96,84),cmap='gray')
    plt.show()

e3c()
