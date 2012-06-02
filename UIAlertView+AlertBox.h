//
//  UIAlertView+AlertBox.h
//  testFace
//
//  Created by Yuan Mingyi on 12-6-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface UIAlertView (AlertBox)
+ (void)alertWithTitle:(NSString *)title 
               message:(NSString *)message 
              delegate:(id <UIAlertViewDelegate>)delegate
     cancelButtonTitle:(NSString*)cancelButtonTitle
    conformButtonTitle:(NSString*)conformButtonTitle;
+ (void)alertWithTitle:(NSString*)title message:(NSString*)message;
+ (void)alertWithMessage:(NSString*)message;
@end
