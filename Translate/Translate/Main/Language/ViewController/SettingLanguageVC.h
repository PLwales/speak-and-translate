//
//  SettingLanguageVC.h
//  Translate
//
//  Created by sihao99 on 2019/5/29.
//  Copyright © 2019 SiHan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SettingLanguageVC : UIViewController
@property (nonatomic,strong)UIColor  *bgcolor;
@property (nonatomic,strong)NSString *currentLanguage;
@property (nonatomic,strong)NSString *idf;
@property (nonatomic,copy) void (^updataLanguage)(NSString * idef);
@end

NS_ASSUME_NONNULL_END
