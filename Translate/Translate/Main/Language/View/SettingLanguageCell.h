//
//  SettingLanguageCell.h
//  Translate
//
//  Created by sihao99 on 2019/5/29.
//  Copyright © 2019 SiHan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SettingLanguageCell : UITableViewCell
-(void)setContentCellicon:(NSString *)icon Language:(NSString *)language;
@property (nonatomic,strong)UIButton *currentBtn;
@end

NS_ASSUME_NONNULL_END
