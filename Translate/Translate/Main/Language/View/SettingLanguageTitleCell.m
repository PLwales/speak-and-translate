//
//  SettingLanguageTitleCell.m
//  Translate
//
//  Created by sihao99 on 2019/5/29.
//  Copyright © 2019 SiHan. All rights reserved.
//

#import "SettingLanguageTitleCell.h"
#define kIconMarginWidth  15*FITScreenWidth

@interface SettingLanguageTitleCell ()
@property (nonatomic,strong)UILabel *titleLab;

@end

@implementation SettingLanguageTitleCell

-(void)setTitleContent:(NSString *)str
{
    self.titleLab.text = str;

}
-(UILabel *)titleLab
{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc]init];
        _titleLab.textColor = LWRGB16Color(0x999999, 1);
        _titleLab.font = LWUIFONT(15);
        [self.contentView addSubview:_titleLab];
        [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kIconMarginWidth);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }];
    }
    return _titleLab;
}
@end
