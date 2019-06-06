//
//  ChangeLanguageView.h
//  Translate
//
//  Created by sihao99 on 2019/5/29.
//  Copyright © 2019 SiHan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ChangeLanguageViewDelegate <NSObject>

-(void)ChangeLanguageViewPresentSetting:(NSString *)language color:(UIColor *)color   ident:(NSString *)ident;

@end
@interface ChangeLanguageView : UIView
- (instancetype)initWithFrame:(CGRect)frame  LanguageKey:(NSString *)language;
-(void)reloadData:(NSString *)language;
@property(nonatomic,weak)id<ChangeLanguageViewDelegate>delegete;
@end

NS_ASSUME_NONNULL_END
