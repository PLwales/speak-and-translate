//
//  UIColor+Hex.h
//  HandEarn
//
//  Created by sihan02 on 2017/4/18.
//  Copyright © 2017年 sihan02. All rights reserved.
//

#import <UIKit/UIKit.h>
#define COLOR_HEX(_HEX_) [UIColor colorWithHexString:_HEX_]
#define COLOR_HEX_A(_HEX_,_A_) [UIColor colorWithHexString:_HEX_ alpha:_A_]
@interface UIColor (Hex)
+ (UIColor *)colorWithHexString:(NSString *)color;

//从十六进制字符串获取颜色，
//color:支持@“#123456”、 @“0X123456”、 @“123456”三种格式
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

@end
