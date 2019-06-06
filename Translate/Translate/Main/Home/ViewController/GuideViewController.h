//
//  GuideViewController.h
//  FoxCard
//
//  Created by sihan on 2017/11/29.
//  Copyright © 2017年 Xiamen Worldscan Information Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol GuideViewControllerDelegate <NSObject>
- (void)_GuideViewControllerDelegate_cancel;
- (void)_GuideViewControllerDelegate_buyAction;
@end
@interface GuideViewController : UIViewController
@property (nonatomic, assign) id<GuideViewControllerDelegate>delegate;
@end
