//
//  MBProgressHUDCustom.h
//  HandEarn
//
//  Created by sihan02 on 2017/4/26.
//  Copyright © 2017年 sihan02. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUDCustom : MBProgressHUD
+ (void)showSuccess:(NSString *)success;
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;

+ (void)showError:(NSString *)error;
+ (void)showError:(NSString *)error toView:(UIView *)view;

+ (void)hideHUD;
+ (void)hideHUDForView:(UIView *)view;
+ (MBProgressHUD *)showMessage:(NSString *)message;
@end
