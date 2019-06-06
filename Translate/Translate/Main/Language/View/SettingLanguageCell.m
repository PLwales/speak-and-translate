//
//  SettingLanguageCell.m
//  Translate
//
//  Created by sihao99 on 2019/5/29.
//  Copyright © 2019 SiHan. All rights reserved.
//

#import "SettingLanguageCell.h"


#define kIconMarginWidth  15*FITScreenWidth
#define kLanguageMarginWidth  52*FITScreenWidth
#define kIconMarginSzie  23*FITScreenWidth


@interface SettingLanguageCell ()
@property (nonatomic,strong)UIImageView *iconView;
@property (nonatomic,strong)UILabel *languageLab;
@property (nonatomic,strong)UIButton *playbtn;
@property (nonatomic,strong)UIButton *voicebtn;
@end
@implementation SettingLanguageCell



-(void)setContentCellicon:(NSString *)icon Language:(NSString *)language
{
    self.iconView.image = GET_IMAGE(icon);
    self.languageLab.text = NSLocalizedString(language, nil);
//    self.voicebtn.hidden = YES;
//    self.playbtn.hidden =YES;
}

-(UIImageView *)iconView
{
    if (!_iconView ) {
        _iconView = [[UIImageView alloc]init];
        [self.contentView addSubview:_iconView];
        [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kIconMarginWidth);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(kIconMarginSzie, kIconMarginSzie));
        }];
    }
    return _iconView;
}
-(UILabel *)languageLab
{
    if (!_languageLab) {
        _languageLab =  [[UILabel alloc]init];
        _languageLab.textColor = LWRGB16Color(0x333333, 1);
        _languageLab.font = LWUIFONT(18);
        [self.contentView addSubview:_languageLab];
        [_languageLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kLanguageMarginWidth);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }];
    }
    return _languageLab;
}
-(UIButton *)currentBtn
{
    if (!_currentBtn) {
        _currentBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
        [_currentBtn setBackgroundImage:GET_IMAGE(@"ok") forState:UIControlStateNormal];
        [self.contentView addSubview:_currentBtn];
        [_currentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-kIconMarginWidth);
//            make.size.mas_equalTo(CGSizeMake(kIconMarginSzie, kIconMarginSzie));
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }];
    }
    return _currentBtn;
}

//-(UIButton *)playbtn
//{
//    if (!_playbtn) {
//        _playbtn  = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_playbtn setBackgroundImage:GET_IMAGE(@"语音(1)-1") forState:UIControlStateNormal];
//
//        [self.contentView addSubview:_playbtn];
//        [_playbtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.mas_equalTo(self.voicebtn.mas_left).mas_equalTo(-kIconMarginWidth);
//            make.size.mas_equalTo(CGSizeMake(kIconMarginSzie, kIconMarginSzie));
//            make.centerY.mas_equalTo(self.contentView.mas_centerY);
//        }];
//    }
//    return _playbtn;
//}

@end
