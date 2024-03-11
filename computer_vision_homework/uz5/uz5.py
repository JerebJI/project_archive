import numpy as np
from matplotlib import pyplot as plt
import cv2
from PIL import Image
from a5_utils import *
from uz4 import hessian_points,harris,find_matches,display_matches
import random

swap = lambda x,y: (y,x)
imread = lambda path: np.asarray(Image.open(path).convert('RGB')).astype(np.float64)/255
gray=lambda I: (lambda x,y,z: (x+y+z)/3)(I[:,:,0],I[:,:,1],I[:,:,2])

def e1b(pz=np.linspace(0.01,1,100)):
    f,T = 2.5e-3, 0.12
    d = f*T/pz
    plt.clf()
    plt.plot(d)
    plt.xlabel('$p_z$ (m)')
    plt.ylabel('d (m)')
    plt.show()

def e1c():
    f,T,px = 2.5e-3, 0.12, 7.4e-6
    width = 648*px
    for l,r in [(550,300),(550,540)]:
        xl,xr = l*px-width/2, r*px-width/2
        disp = xl-xr
        dist = f*T/disp
        print('disparity:',disp,'distance:',dist)

def ncc(x,y):
    x,y=x.flatten(),y.flatten()
    avgx,avgy = np.mean(x),np.mean(y)
    if len(x)<len(y):
        y = y[:len(x)]
    if len(x)>len(y):
        x = x[:len(y)]
    return np.sum((x-avgx)*(y-avgy))/(1e10+np.sqrt(np.sum((x-avgx)**2)*np.sum((y-avgy)**2)))

def e1d(l='data/disparity/office_left.png',r='data/disparity/office_right.png'):
    Il,Ir = gray(imread(l)),gray(imread(r))
    Il = cv2.resize(Il,dsize=(Il.shape[1]//2,Il.shape[0]//2))
    Ir = cv2.resize(Ir,dsize=(Ir.shape[1]//2,Ir.shape[0]//2))
    plt.subplot(1,3,1)
    plt.imshow(Il,cmap='gray')
    plt.subplot(1,3,2)
    plt.imshow(Ir,cmap='gray')
    plt.subplot(1,3,3)
    disp = np.zeros(Il.shape)
    ws = 11
    def patch(I,y,x,s=ws):
        return I[max(0,y-s):min(y+s+1,I.shape[0]), max(0,x-s):min(x+s+1,I.shape[1])]
    mxx = Ir.shape[1]
    mxd = 35
    n=0
    for (y,x),_ in np.ndenumerate(Il[ws:-ws,ws:-ws]):
        x,y = x+ws,y+ws
        L = patch(Il,y,x)
        it = np.arange(max(0,x-mxd),min(mxx,x+mxd))
        comp_ncc = np.vectorize(lambda d: ncc(L,patch(Ir,y,d)))
        mxncc = np.argmax(comp_ncc(it))
        disp[y,x] = abs(it[mxncc]-x)
    plt.imshow(disp,cmap='gray')
    print(np.unique(disp))
    plt.show()

def e2a():
    F = np.array([[1, 0,   0],
                  [0, 0.5, 0],
                  [0, 0,  -1]])
    for p in np.array([[0,2,1],[1,0,1]]):
        r = F.dot(np.array(p).T)
        print(r[0],'x +',r[1],'y +',r[2],'= 0')
    print('[1,0,0]')

def fundamental_matrix(ps):
    p1s,T1 = normalize_points(ps[:,0:2])
    p2s,T2 = normalize_points(ps[:,2:4])
    up,vp,u,v = p1s[:,0],p1s[:,1],p2s[:,0],p2s[:,1]
    # Construct the matrix A as in equation
    A = np.stack([u*up,u*vp,u,v*up,v*vp,v,up,vp,np.ones(u.shape)]).T
    # Decompose the matrix using SVD A = U D V.T
    U,D,VT = np.linalg.svd(A)
    # and transform the last eigenvector v9 in a 3x3 fundamental matrix F
    Ft = VT.T[:,-1].reshape((3,3))
    # Decompose F = U D V.T
    U,D,VT = np.linalg.svd(Ft)
    # and set the lowest eigenvalue to 0,
    D[-1] = 0
    # reconstruct F = U D V.T
    F = (U*D)@VT
    # compute both epipoles following the equation
    F = T2.T @ F @ T1
    return F

def e2b():
    ps = np.loadtxt('data/epipolar/house_points.txt')
    F = fundamental_matrix(ps)
    print('fundamental matrix errors:')
    print(F-np.loadtxt('data/epipolar/house_fundamental.txt'))
    h1,h2 = gray(imread('data/epipolar/house1.jpg')),gray(imread('data/epipolar/house2.jpg'))
    plt.clf()
    plt.subplot(1,2,1)
    plt.imshow(h1,cmap='gray')
    for p in ps[:,2:4]:
        draw_epiline(F.T@[p[0],p[1],1], *h1.shape)
    plt.scatter(*ps[:,0:2].T,c='r')
    plt.subplot(1,2,2)
    plt.imshow(h2,cmap='gray')
    for p in ps[:,0:2]:
        draw_epiline(F@[p[0],p[1],1], *h2.shape)
    plt.scatter(*ps[:,2:4].T,c='r')
    plt.show()

def reprojection_error(x1,x2,F):
    ph1,ph2 = np.array([x1[0],x1[1],1]),np.array([x2[0],x2[1],1])
    l1,l2 = F.T@ph2,F@ph1
    d1,d2 = np.abs(l1.dot(ph1)/np.linalg.norm(l1[:2])),np.abs(l2.dot(ph2)/np.linalg.norm(l2[:2]))
    return (d1+d2)/2

def e2c():
    ps = np.loadtxt('data/epipolar/house_points.txt')
    F = fundamental_matrix(ps)
    print('(1)',reprojection_error(np.array([85,233]),np.array([67,219]),F))
    print('(2)',np.mean([reprojection_error(p1,p2,F) for p1,p2 in zip(ps[:,0:2],ps[:,2:4])]))

def e2d(k=2000,thr=2,perc=0,nf=300):
    h1 = cv2.imread('data/desk/DSC02638.JPG',cv2.IMREAD_GRAYSCALE)
    h2 = cv2.imread('data/desk/DSC02639.JPG',cv2.IMREAD_GRAYSCALE)
    orb = cv2.ORB_create(nfeatures=nf)
    kp1,des1 = orb.detectAndCompute(h1,None)
    kp2,des2 = orb.detectAndCompute(h2,None)
    ps1,ps2 = np.array([p.pt for p in kp1]),np.array([p.pt for p in kp2])
    bf = cv2.BFMatcher(cv2.NORM_HAMMING,crossCheck=True)
    mat = (bf.knnMatch(des1,des2,k=1))
    mat = sorted(mat,key=lambda x:10e5 if len(x)==0 else x[0].distance)
    mat = np.array([(m[0].queryIdx,m[0].trainIdx) for m in mat if len(m)!=0])
    ps = mat.T
    #display_matches(h1,ps1[ps[0]],h2,ps2[ps[1]])
    print('#All matches:',len(mat))
    mat1,mat2 = ps[0],ps[1]
    binl = []
    bmat = []
    berr = float('inf')
    best = None
    mt = np.array([np.hstack([kp1[m[0]].pt,kp2[m[1]].pt]) for m in mat])
    for i in range(k):
        # Randomly select a minimal set of matches that are required to estimate a model.
        ss = np.array(random.sample(range(len(mat1)),8),dtype='uint')
        # Estimate the homography matrix.
        est = fundamental_matrix(mt[ss])
        # Determine the inliers for the estimate (i.e. matched pairs with the reprojection error below a given threshold).
        inl=[]
        for i,(sl,sr) in enumerate(zip(mat1,mat2)):
            if abs(reprojection_error(ps1[sl],ps2[sr],est))<thr:
                inl+=[i]
        # If the percentage of inliers if large enough, use the entire inlier subset to estimate a new homography matrix.
        if len(inl)>8 and len(inl)/len(mat1)>perc:
            est = fundamental_matrix(mt[inl])
            inl1=[]
            for i,(sl,sr) in enumerate(zip(mat1,mat2)):
                if reprojection_error(ps1[sl],ps2[sr],est)<thr:
                    inl1+=[i]
            # If the error of the newly computed estimate is lower than any before, save the inlier set and the corresponding matrix.
            err = abs(reprojection_error(mat1[inl],mat2[inl],est))
            if err<berr:
                binl = inl1
                best = est
                berr = err
    print('Inliers:',binl)
    if best is None:
        raise ValueError('No suitable estimation found.')
    print('Reprojection error:',berr)
    display_matches(h1,ps1[mat1[binl]],h2,ps2[mat2[binl]])
    plt.clf()
    plt.subplot(1,2,1)
    plt.imshow(h1,cmap='gray')
    for p in mt[binl][:,2:4]:
        draw_epiline(best.T@[p[0],p[1],1], *h1.shape)
    plt.scatter(*mt[binl][:,0:2].T,c='r')
    plt.subplot(1,2,2)
    plt.imshow(h2,cmap='gray')
    for p in mt[binl][:,0:2]:
        draw_epiline(best@[p[0],p[1],1], *h2.shape)
    plt.scatter(*mt[binl][:,2:4].T,c='r')
    plt.show()
e2d()

def triangulate(corr,P1,P2):
    ps3d=[]
    for p1x,p1y,p2x,p2y in corr:
        p1s=np.array([[0,-1,p1y],[1,0,-p1x],[-p1y,p1x,0]])
        p2s=np.array([[0,-1,p2y],[1,0,-p2x],[-p2y,p2x,0]])
        A1,A2 = p1s@P1, p2s@P2
        _,_,VT = np.linalg.svd([A1[0],A1[1],A2[0],A2[1]])
        ps3d+=[(VT[-1]/VT[-1][-1])[:3]]
    return ps3d

def e3a():
    c1 = np.loadtxt('data/epipolar/house1_camera.txt')
    c2 = np.loadtxt('data/epipolar/house2_camera.txt')
    ps = np.loadtxt('data/epipolar/house_points.txt')
    plt.clf()
    fig,ax = plt.subplots(1,3)
    ax[0].imshow(gray(imread('data/epipolar/house1.jpg')),cmap='gray')
    ax[0].scatter(*ps[:,0:2].T,c='r')
    for i,p in enumerate(ps[:,0:2]):
        ax[0].text(*p,i)
    ax[1].imshow(gray(imread('data/epipolar/house2.jpg')),cmap='gray')
    ax[1].scatter(*ps[:,2:4].T,c='r')
    for i,p in enumerate(ps[:,2:4]):
        ax[1].text(*p,i)
    T = np.array([[-1,0,0],[0,0,1],[0,-1,0]])
    ax[2].remove()
    ax2 = fig.add_subplot(133,projection='3d')
    p3d = np.dot(triangulate(ps,c1,c2),T)
    ax2.scatter(*p3d.T,c='r')
    for i, p in enumerate(p3d):
        ax2.text(*p,i)
    fig.show(),input('')
