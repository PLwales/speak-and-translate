//
//  BaseNavigationVC.h
//  ScanPlant
//
//  Created by sihan on 2018/7/6.
//  Copyright © 2018年 sihan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseNavigationVC : UIViewController
@property (nonatomic, retain) UIView * viewNavigation;
@property (nonatomic, retain) UILabel * labelTitle;
@property (nonatomic, retain) UIButton * buttonLeft;
@property (nonatomic, retain) UIButton * buttonRight;

- (void)_showMBProgressHUD:(NSString *)stringTitle;
- (void)_showWaitView;
- (void)_hideWaitView;
@end
