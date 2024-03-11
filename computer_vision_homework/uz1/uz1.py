# -*- coding: utf-8 -*-
import numpy as np
import cv2
from matplotlib import pyplot as plt
from UZ_utils import *
import math

gray=lambda I: (lambda x,y,z: (x+y+z)/3)(I[:,:,0],I[:,:,1],I[:,:,2])
def otsu(img):
  # compute class sizes
  w0=lambda t: np.count_nonzero(img<t)
  w1=lambda t: np.count_nonzero(img>=t)
  # compute class means
  nu0=lambda t: np.average(img[img<t]) if w0(t)>0 else 0
  nu1=lambda t: np.average(img[img>=t]) if w1(t)>0 else 0
  # inter-class variance
  criteria=np.vectorize(lambda t: w0(t)*w1(t)*(nu0(t)-nu1(t))**2)
  # all relevant thresholds
  thresholds=np.unique(img)
  # select threshold that maximizes Otsu's criteria (inter-class variance)
  return thresholds[np.argmax(criteria(thresholds))]


def exercise1():
  # 1.(a) #
  # read image
  I = imread('images/umbrellas.jpg')
  # display image
  imshow(I)

  # 1.(b) #
  # convert image to grayscale
  gI=(lambda x,y,z: (x+y+z)/3)(I[:,:,0],I[:,:,1],I[:,:,2])
  # show converted image
  imshow(gI)

  # 1.(c) #
  # Question: Why would you use different color maps?
  # Answer: for presentation or to see specific info about image

  plt.clf()
  plt.subplot(1,2,1)
  plt.imshow(I)
  plt.subplot(1,2,2)
  cutout=I[100:200, 200:400, 0]
  plt.imshow(cutout)
  plt.tight_layout()
  plt.show()

  # 1.(d) #
  # Question: How is inverting a grayscale value defined?
  # Answer: By invert(x)=1-x for x in [0,1]

  # draw original image
  plt.clf()
  plt.subplot(1,2,1)
  plt.imshow(I)
  # invert a part of the image
  I[100:200,200:400]=1-I[100:200,200:400]
  # draw partially inverted image
  plt.subplot(1,2,2)
  plt.imshow(I)
  plt.tight_layout()
  plt.show()

  # 1.(e) #
  # reduce the grayscale levels
  grI = 0.3*gI
  # draw original grayscale image
  plt.subplot(1,2,1)
  plt.imshow(gI)
  # draw image with reduced grayscale levels
  plt.subplot(1,2,2)
  plt.imshow(grI,vmin=0,vmax=1)
  plt.tight_layout()
  plt.show()

def exercise2():
  # 2.(a) #
  # read image
  I = imread('images/bird.jpg')

  # 2.(b) #
  # convert to grayscale
  gray=lambda I: (lambda x,y,z: (x+y+z)/3)(I[:,:,0],I[:,:,1],I[:,:,2])
  I=gray(I)
  # set threshold (by trial-and-error)
  threshold = 0.19608
  # draw original image
  plt.clf()
  plt.subplot(1,2,1)
  plt.imshow(imread('images/bird.jpg'))
  # binarize and display image
  plt.subplot(1,2,2)
  plt.imshow(np.where(I<threshold, 0, 1), cmap='gray')
  plt.tight_layout()
  plt.show()

  # alternative binarization
  # read image and convert to grayscale
  Ia = gray(imread('images/bird.jpg'))
  # binarize
  Ia[Ia<threshold], Ia[Ia>=threshold] = 0, 1
  imshow(Ia)

  # 2.(b) #
  # Question: The histograms are usually normalized by dividing the result by the sum of all cells. Why is that?
  # Answer: Usually it is not important how many pixels of each color are in an image but their proportion.
  #         (it also makes images of different sizes "comparable")
  def myhist(img,bins):
    # assign bin
    wbin=np.floor(img*bins).astype(int)
    # correct edge (1)
    wbin[wbin==bins]=bins-1
    # count
    vals, counts=np.unique(wbin,return_counts=True)
    # store in histogram
    r=np.zeros(bins)
    r[vals]=counts
    return r/img.size

  # show
  plt.clf()
  plt.subplot(1,3,1)
  plt.imshow(I,cmap='gray')
  plt.subplot(1,3,2)
  plt.bar(range(100),myhist(I,100))
  plt.subplot(1,3,3)
  plt.bar(range(10),myhist(I,10))
  plt.tight_layout()
  plt.show()

  # 2.(c) #
  def myhist1(img,bins):
    min, max = np.min(img), np.max(img)
    # assign bin
    wbin=np.floor((img-min)*bins/(max-min)).astype(int)
    # correct edge (1)
    wbin[wbin==bins]=bins-1
    # count
    vals, counts=np.unique(wbin,return_counts=True)
    # store in histogram
    r=np.zeros(bins)
    r[vals]=counts
    return r/img.size

  plt.clf()
  plt.subplot(1,3,1)
  rng = np.random.default_rng()
  timg = rng.uniform(low=0.3, high=0.7, size=(500,500))
  plt.imshow(timg, cmap='gray')
  plt.subplot(1,3,2)
  plt.bar(range(100),myhist(timg,100))
  plt.subplot(1,3,3)
  plt.bar(range(100),myhist1(timg,100))
  plt.tight_layout()
  plt.show()

  # 1.(d) #
  plt.clf()
  nimgs = ['1.jpg','2.jpg','3.jpg','4.jpg']
  imgs = [gray(imread(i)) for i in nimgs]

  plt.subplot(3,4,1)
  plt.imshow(imgs[0],cmap='gray')
  plt.subplot(3,4,2)
  plt.imshow(imgs[1],cmap='gray')
  plt.subplot(3,4,3)
  plt.imshow(imgs[2],cmap='gray')
  plt.subplot(3,4,4)
  plt.imshow(imgs[3],cmap="gray")
  plt.subplot(3,4,5)
  #plt.hist(imgs[0].reshape(-1),bins=50)
  plt.bar(range(50),myhist(imgs[0],50))
  plt.subplot(3,4,6)
  #plt.hist(imgs[1].reshape(-1),bins=50)
  plt.bar(range(50),myhist(imgs[1],50))
  plt.subplot(3,4,7)
  #plt.hist(imgs[2].reshape(-1),bins=50)
  plt.bar(range(50),myhist(imgs[2],50))
  plt.subplot(3,4,8)
  #plt.hist(imgs[3].reshape(-1),bins=50)
  plt.bar(range(50),myhist(imgs[3],50))
  plt.subplot(3,4,9)
  #plt.hist(imgs[0].reshape(-1),bins=50)
  plt.bar(range(10),myhist(imgs[0],10))
  plt.subplot(3,4,10)
  #plt.hist(imgs[1].reshape(-1),bins=50)
  plt.bar(range(10),myhist(imgs[1],10))
  plt.subplot(3,4,11)
  #plt.hist(imgs[2].reshape(-1),bins=50)
  plt.bar(range(10),myhist(imgs[2],10))
  plt.subplot(3,4,12)
  #plt.hist(imgs[3].reshape(-1),bins=50)
  plt.bar(range(10),myhist(imgs[3],10))
  plt.tight_layout()
  plt.show()

  # Interpretation: less values on the right side of the graph indicate lower lighting
  #                 and vice-versa, "strange" abnormalities indicate "abnormal" lighting

  # 1.(e) #
  def otsu(img):
    # compute class sizes
    w0=lambda t: np.count_nonzero(img<t)
    w1=lambda t: np.count_nonzero(img>=t)
    # compute class means
    nu0=lambda t: np.average(img[img<t]) if w0(t)>0 else 0
    nu1=lambda t: np.average(img[img>=t]) if w1(t)>0 else 0
    # inter-class variance
    criteria=np.vectorize(lambda t: w0(t)*w1(t)*(nu0(t)-nu1(t))**2)
    # all relevant thresholds
    thresholds=np.unique(img)
    # select threshold that maximizes Otsu's criteria (inter-class variance)
    return thresholds[np.argmax(criteria(thresholds))]

  plt.clf()
  plt.subplot(1,3,1)
  plt.imshow(np.where(I<otsu(I),0,1),cmap='gray')
  plt.subplot(1,3,2)
  plt.imshow(np.where((lambda I:I<otsu(I))(gray(imread('images/umbrellas.jpg'))),0,1),cmap='gray')
  plt.subplot(1,3,3)
  plt.imshow(np.where((lambda I:I<otsu(I))(gray(imread('images/coins.jpg'))),0,1),cmap='gray')
  plt.tight_layout()
  plt.show()

def exercise3():
  # 3.(a) #
  # opening: erode, dilate
  # closing: dilate, erode

  I = imread('images/mask.png')
  n = 5
  SE = np.ones((n,n)) # create a square structuring element
  I_eroded = cv2.erode(I, SE)
  I_dilated = cv2.dilate(I, SE)
  # display images
  plt.clf()
  plt.subplot(2,3,1)
  plt.imshow(I)
  plt.subplot(2,3,2)
  plt.imshow(I_eroded)
  plt.subplot(2,3,3)
  plt.imshow(I_dilated)
  plt.subplot(2,3,5)
  plt.imshow(cv2.dilate(I_eroded, SE))
  plt.subplot(2,3,6)
  plt.imshow(cv2.erode(I_dilated, SE))
  plt.tight_layout()
  plt.show()

  # 3.(b) #
  # load image
  I = imread('images/bird.jpg')
  # convert to grayscale
  gI=(lambda x,y,z: (x+y+z)/3)(I[:,:,0],I[:,:,1],I[:,:,2])
  # binarize
  tI = np.where(gI<0.19608, 0, 1)
  # close
  n = 13
  SE = cv2.getStructuringElement(cv2.MORPH_ELLIPSE, (n,n))
  tI = cv2.dilate(tI.astype('uint8'), SE)
  tI = cv2.erode(tI.astype('uint8'), SE)
  plt.clf()
  imshow(tI)

  # 3.(c) #
  def immask(img,m):
    # copy image
    r = np.copy(img)
    # remove colors
    r[m==0]=0
    return r
  imshow(immask(I,tI))

  # 3.(d) #
  # Question: Why is the background included in the mask and not the object? How would you fix that in general? (just inverting the mask if necessary doesn’t count)
  # Answer: by always choosing the bigger partition as the background or more homogenous partition or more homogenous partition
  I = imread('images/eagle.jpg')
  gI = gray(I)
  imshow(immask(I,np.where(gI<otsu(gI),1,0)))

  # 3.(e) #
  # read image
  I = imread('images/coins.jpg')
  # create grayscale version
  cgI=gray(I)
  # binarize "by hand"
  ctI=np.where(cgI<0.89,1,0).astype('uint8')
  # open
  n = 5
  SE = cv2.getStructuringElement(cv2.MORPH_ELLIPSE, (n,n))
  ctI=cv2.erode(ctI,SE)
  ctI=cv2.dilate(ctI,SE)
  # get components
  out=cv2.connectedComponentsWithStats(ctI,4,cv2.CV_32S)
  # remove each component (with centroids)
  for c in out[2][out[2][:,cv2.CC_STAT_AREA]>700][1:]:
    ctI[c[cv2.CC_STAT_TOP]:c[cv2.CC_STAT_TOP]+c[cv2.CC_STAT_HEIGHT],
        c[cv2.CC_STAT_LEFT]:c[cv2.CC_STAT_LEFT]+c[cv2.CC_STAT_WIDTH]]=0

  # display result
  plt.clf()
  plt.subplot(1,2,1)
  plt.imshow(I)
  plt.subplot(1,2,2)
  plt.imshow(ctI)
  plt.tight_layout()
  plt.show()

exercise1()
