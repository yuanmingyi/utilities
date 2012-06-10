//
//  UIImage+TransformCVMat.m
//  opencvTestFace
//
//  Created by Yuan Mingyi on 12-6-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIImage+TransformCVMat.h"

# pragma mark --
# pragma mark objective-C implementation
void fillImageBuffer(CGImageRef cgImage, UIImageOrientation imageOrientation, int *_rows, int *_cols, void *data);

@implementation UIImage (TransformCVMat)

# pragma mark -- instance methods 
// return a cv::Mat object with copied data and in the same format (RGBA)
- (cv::Mat)mat {
    CGImage *cgImage = self.CGImage;
    int cols = CGImageGetWidth(cgImage);
    int rows = CGImageGetHeight(cgImage);
    
    cv::Mat mat(rows, cols, CV_8UC4);
    fillImageBuffer(cgImage, self.imageOrientation, &rows, &cols, mat.data);
    
    mat = mat.reshape(0, rows);
    return mat;
}

// return a cv::Mat image in BGR color format with copied data
- (cv::Mat)matBGR {
    cv::Mat mat = [self mat];
    cv::Mat matBGR;
    cv::cvtColor(mat, matBGR, CV_RGBA2BGR);
    return matBGR;
}

// return a cv::Mat gray (8bit, 1channel) image with copied data
- (cv::Mat)matGray {
    cv::Mat mat = [self mat];
    cv::Mat matGray;
    cv::cvtColor(mat, matGray, CV_RGBA2GRAY);
    return matGray;
}

// create a UIImage object with normalized orientation
- (UIImage*)normalizedOrientationImage {
    CGAffineTransform transform = CGAffineTransformIdentity;
    int cols = CGImageGetWidth(self.CGImage);
    int rows = CGImageGetHeight(self.CGImage);
    CGSize size;
    
    switch (self.imageOrientation) {
        case UIImageOrientationUp:      // default orientation
            return self;
            break;
        case UIImageOrientationDown:    // 180 deg rotation            
            transform = CGAffineTransformMake(-1, 0, 0, -1, cols, rows);
            size = CGSizeMake(cols, rows);
            break;
        case UIImageOrientationLeft:          // 90 deg CCW
            transform = CGAffineTransformMake(0, 1, -1, 0, rows, 0);
            size = CGSizeMake(rows, cols);
            break;
        case UIImageOrientationRight:         // 90 deg CW
            transform = CGAffineTransformMake(0, -1, 1, 0, 0, cols);
            size = CGSizeMake(rows, cols);
            break;
        case UIImageOrientationUpMirrored:    // as above but image mirrored along other axis. horizontal flip
            transform = CGAffineTransformMake(-1.0, 0, 0, 1.0, cols, 0);
            size = CGSizeMake(cols, rows);
            break;
        case UIImageOrientationDownMirrored:  // horizontal flip
            transform = CGAffineTransformMake(1.0, 0, 0, -1.0, 0, rows);
            size = CGSizeMake(cols, rows);
            break;
        case UIImageOrientationLeftMirrored:  // vertical flip
            transform = CGAffineTransformMake(0, 1.0, 1.0, 0, 0, 0);
            size = CGSizeMake(rows, cols);
            break;
        case UIImageOrientationRightMirrored: // vertical flip
            transform = CGAffineTransformMake(0, -1.0, -1.0, 0, rows, cols);
            size = CGSizeMake(rows, cols);
            break;
        default:
            break;
    }
    
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextConcatCTM(context, transform);
    CGContextDrawImage(context, CGRectMake(0, 0, cols, rows), self.CGImage);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

# pragma mark -- class methods
// create a UIImage object with copied data from a cv::Mat object
+ (id)imageWithMat:(const cv::Mat&)mat {
    cv::Mat matRGBA;
    switch (mat.type()) {
        case CV_8UC1:
            cv::cvtColor(mat, matRGBA, CV_GRAY2RGBA);
            break;
        case CV_8UC3:
            cv::cvtColor(mat, matRGBA, CV_BGR2RGBA);
            break;
        case CV_8UC4:
            matRGBA = mat.clone();
            break;
        default:
            return nil;
            break;
    }
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(matRGBA.data, matRGBA.cols, matRGBA.rows, 8, matRGBA.step, space, kCGImageAlphaPremultipliedLast);
    CGImageRef cgImage = CGBitmapContextCreateImage(context);
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    
    CGColorSpaceRelease(space);
    CGImageRelease(cgImage);
    CGContextRelease(context);
    
    return image;
}

// create a UIImage object with copied data from an IplImage structure
+ (id)imageWithIplImage:(const IplImageRef)iplImage {
    cv::Mat mat = iplImage;
    return [UIImage imageWithMat:mat];
}

// create a UIImage object with normalized orientation
+ (id)normalizedOrientationImage:(UIImage*)image {
    return [image normalizedOrientationImage];
}

@end

# pragma mark --
# pragma mark C++ implementation
inline void swap(int &a, int &b) {
    a ^= b;
    b ^= a;
    a ^= b;
}
void fillImageBuffer(CGImageRef cgImage, UIImageOrientation imageOrientation, int *_rows, int *_cols, void *data) {
    CGAffineTransform transform = CGAffineTransformIdentity;
    int cols = *_cols;
    int rows = *_rows;
    // transform the image according to the orientation of UIImage
    switch (imageOrientation) {
        case UIImageOrientationUp:      // default orientation
            break;
        case UIImageOrientationDown:    // 180 deg rotation
            transform = CGAffineTransformMake(-1, 0, 0, -1, cols, rows);
            break;
        case UIImageOrientationLeft:          // 90 deg CCW
            transform = CGAffineTransformMake(0, 1, -1, 0, rows, 0);
            swap(cols,rows);
            break;
        case UIImageOrientationRight:         // 90 deg CW
            transform = CGAffineTransformMake(0, -1, 1, 0, 0, cols);
            swap(cols,rows);
            break;
        case UIImageOrientationUpMirrored:    // as above but image mirrored along other axis. horizontal flip
            transform = CGAffineTransformMake(-1.0, 0, 0, 1.0, cols, 0);
            break;
        case UIImageOrientationDownMirrored:  // horizontal flip
            transform = CGAffineTransformMake(1.0, 0, 0, -1.0, 0, rows);
            break;
        case UIImageOrientationLeftMirrored:  // vertical flip
            transform = CGAffineTransformMake(0, 1.0, 1.0, 0, 0, 0);
            swap(cols,rows);
            break;
        case UIImageOrientationRightMirrored: // vertical flip
            transform = CGAffineTransformMake(0, -1.0, -1.0, 0, rows, cols);
            swap(cols,rows);
            break;
        default:
            break;
    }
    
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(data, cols, rows, 8, cols*4, space, kCGImageAlphaPremultipliedLast);
    CGContextConcatCTM(context, transform);
    CGContextDrawImage(context, CGRectMake(0, 0, *_cols, *_rows), cgImage);
    CGColorSpaceRelease(space);
    CGContextRelease(context);    
    *_cols = cols;
    *_rows = rows;
}

IplImageRef iplImageCreateWithUIImage(UIImage *image, IplImageType type) {
    CGImage *cgImage = image.CGImage;
    int cols = CGImageGetWidth(cgImage);
    int rows = CGImageGetHeight(cgImage);
    
    void *imageData = malloc(cols*rows*4);
    fillImageBuffer(cgImage, image.imageOrientation, &rows, &cols, imageData);
    IplImage *iplImage = cvCreateImageHeader(cvSize(cols, rows), IPL_DEPTH_8U, 4);
    cvSetData(iplImage, imageData, CV_AUTOSTEP);
    
    IplImage *retImage = iplImage;
    switch (type) {
        case IplImageTypeBGR:
            retImage = cvCreateImage(cvSize(cols,rows), IPL_DEPTH_8U, 3);
            cvCvtColor(iplImage, retImage, CV_RGBA2BGR);
            cvReleaseImage(&iplImage);
            break;
        case IplImageTypeGray:
            retImage = cvCreateImage(cvSize(cols,rows), IPL_DEPTH_8U, 1);
            cvCvtColor(iplImage, retImage, CV_RGBA2GRAY);
            cvReleaseImage(&iplImage);
            break;
        case IplImageTypeRGBA:
        default:
            break;
    }
    return retImage;
}

void iplImageRelease(IplImageRef image) {
    cvReleaseImage(&image);
}
