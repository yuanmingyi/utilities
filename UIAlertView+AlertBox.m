//
//  UIAlertView+AlertBox.m
//  testFace
//
//  Created by Yuan Mingyi on 12-6-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIAlertView+AlertBox.h"

@implementation UIAlertView (AlertBox)
+ (void)alertWithTitle:(NSString *)title 
               message:(NSString *)message 
              delegate:(id <UIAlertViewDelegate>)delegate
     cancelButtonTitle:(NSString*)cancelButtonTitle
    conformButtonTitle:(NSString*)conformButtonTitle {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                message:message
                                               delegate:delegate
                                      cancelButtonTitle:cancelButtonTitle
                                      otherButtonTitles:conformButtonTitle,nil];
    [alert show];    
}
+ (void)alertWithTitle:(NSString*)title message:(NSString*)message {
    [UIAlertView alertWithTitle:title 
                        message:message
                       delegate:nil
              cancelButtonTitle:@"OK" 
             conformButtonTitle:nil];
}
+ (void)alertWithMessage:(NSString*)message {
    [UIAlertView alertWithTitle:@"Alert" message:message];
}
                             
@end
