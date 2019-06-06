//
//  SpectrumView.h
//  GYSpectrum
//
//  Created by sh on 16/8/19.
//  Copyright © 2016年 sh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpectrumView : UIView

@property (nonatomic, copy) void (^itemLevelCallback)();

//

@property (nonatomic) NSUInteger numberOfItems;

@property (nonatomic) UIColor * itemColor;

@property (nonatomic) CGFloat level;

@property (nonatomic) UILabel *timeLabel;

@property (nonatomic) NSString *text;

@property (nonatomic) CGFloat middleInterval;

- (void)start;
- (void)stop;

@end
