//
//  CustomTabBar.h
//  IScanner
//
//  Created by sihan on 2018/9/19.
//  Copyright © 2018年 sihan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTabBar : UITabBar
@property (nonatomic, strong) RACSubject *buttonActionSubject;
@end
