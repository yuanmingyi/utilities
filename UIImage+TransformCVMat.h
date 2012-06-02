//
//  UIImage+TransformCVMat.h
//  opencvTestFace
//
//  Created by Yuan Mingyi on 12-6-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#include <opencv2/opencv.hpp>

# pragma mark constants
typedef IplImage* IplImageRef;

typedef enum {
    IplImageTypeRGBA = 0,
    IplImageTypeBGR = 1,
    IplImageTypeGray = 2
} IplImageType;

# pragma mark --
# pragma mark UIImage interface category
@interface UIImage (TransformCVMat)

// return a cv::Mat object with copied data and in the same format (usually RGBA)
- (cv::Mat)mat;

// return a cv::Mat image in BGR color format with copied data
- (cv::Mat)matBGR;

// return a cv::Mat gray (8bit, 1channel) image with copied data
- (cv::Mat)matGray;

// create a UIImage object with copied data from a cv::Mat object
+ (id)imageWithMat:(const cv::Mat&)mat;

// create a UIImage object with copied data from an IplImage structure
+ (id)imageWithIplImage:(const IplImageRef)iplImage;

@end

# pragma mark --
# pragma mark C++ functions
// create an IplImageRef object with data in UIImage and indicated image type
IplImageRef iplImageWithUIImage(UIImage *image, IplImageType type);

// release an IplImageRef object
void iplImageRelease(IplImageRef iplImage);
