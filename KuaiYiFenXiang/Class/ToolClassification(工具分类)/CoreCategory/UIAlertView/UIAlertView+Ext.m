//
//  UIAlertView+Ext.m
//  E_Stuff_Platform
//
//  Created by even on 15/12/4.
//  Copyright © 2015年 even. All rights reserved.
//

#import "UIAlertView+Ext.h"

#define kOkButtonDefaultTitle     @"确定"
#define kCancelButtonDefaultTitle @"取消"

@implementation UIAlertView (Ext)

+ (UIAlertView *)showWithMessage:(NSString *)message {
  return [self showWithTitle:nil message:message];
}

+ (UIAlertView *)showWithTitle:(NSString *)title message:(NSString *)message {
  return [self showWithTitle:title message:message delegate:nil];
}

+ (UIAlertView *)showWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate {
  return [self showWithTitle:title
                     message:message
                    okButton:kOkButtonDefaultTitle
                cancelButton:kCancelButtonDefaultTitle];
}

+ (UIAlertView *)showWithTitle:(NSString *)title
                       message:(NSString *)message
                      okButton:(NSString *)okButtonTitle
                  cancelButton:(NSString *)cancelButtonTitle {
  return [self showWithTitle:title
                     message:message
                    delegate:nil
                    okButton:okButtonTitle
                cancelButton:cancelButtonTitle];
}

+ (UIAlertView *)showWithTitle:(NSString *)title
                       message:(NSString *)message
                      delegate:(id)delegate
                      okButton:(NSString *)okButtonTitle
                  cancelButton:(NSString *)cancelButtonTitle {
  __block UIAlertView *alertView = nil;
  
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    alertView =  [[UIAlertView alloc] initWithTitle:title
                                            message:message
                                           delegate:delegate
                                  cancelButtonTitle:cancelButtonTitle
                                  otherButtonTitles:okButtonTitle, nil];
    dispatch_async(dispatch_get_main_queue(), ^{
      [alertView show];
    });
  });
  return alertView;
}

@end
