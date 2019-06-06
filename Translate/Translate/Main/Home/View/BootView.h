//
//  BootView.h
//  Translate
//
//  Created by sihao99 on 2019/6/5.
//  Copyright © 2019 SiHan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BootView : UIView
//显示历史记录的引导页
- (void)setHistoryBootView:(CGRect)frame;
//显示输入文字时的引导页
- (void)setTextTranslationBootView:(CGRect)frame;

@end

NS_ASSUME_NONNULL_END
