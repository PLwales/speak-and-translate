//
//  SettingTableViewHeadView.m
//  Translate
//
//  Created by sihao99 on 2019/5/31.
//  Copyright © 2019 SiHan. All rights reserved.
//

#import "SettingTableViewHeadView.h"


@interface SettingTableViewHeadView ()
@property (nonatomic,strong) UIImageView *bgimgV;
@property (nonatomic,strong) UIButton *blackBtn;
@property (nonatomic,strong) UILabel *nameLab_cn;
@property (nonatomic,strong) UILabel *nameLab_en;
@end

@implementation SettingTableViewHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.bgimgV.image = GET_IMAGE(@"setting_top");
        [self.blackBtn setImage:GET_IMAGE(@"setting_black") forState:UIControlStateNormal];
        self.nameLab_cn.text = @"讲话和翻译";
        self.nameLab_en.text = @"Translate";
    }
    return self;
}

-(void)dismissViewC
{
    if ([self.delegate respondsToSelector:@selector(blackAction)]) {
        [self.delegate blackAction];
    }
}

-(UIImageView *)bgimgV
{
    if (!_bgimgV) {
        _bgimgV =[[UIImageView alloc]init];
        _bgimgV.contentMode = UIViewContentModeCenter;
        [self addSubview:_bgimgV];
        [_bgimgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0);
        }];
    }
    return _bgimgV;
}

-(UIButton *)blackBtn
{
    if (!_blackBtn) {
        _blackBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [_blackBtn addTarget:self action:@selector(dismissViewC) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_blackBtn];
        [_blackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(20);
            make.size.mas_equalTo(CGSizeMake(GET_IMAGE(@"setting_black").size.width*2, GET_IMAGE(@"setting_black").size.height*2));
        }];
    }
    return _blackBtn;
}
-(UILabel *)nameLab_cn
{
    if (!_nameLab_cn) {
        _nameLab_cn =[[UILabel alloc]init];
//        PingFang-SC-Heavy
//        _nameLab_cn.font =  [UIFont fontWithName:@"PingFang-SC-Heavy" size:10];
        _nameLab_cn.font = [UIFont systemFontOfSize:44];
        _nameLab_cn.textColor = LWRGB16Color(0xffffff, 1);
        [self addSubview:_nameLab_cn];
        [_nameLab_cn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(30);
            make.centerX.mas_equalTo(self.mas_centerX);
//            make.height.mas_equalTo(42);
        }];
    }
    return _nameLab_cn;
}
-(UILabel *)nameLab_en
{
    if (!_nameLab_en) {
        _nameLab_en =[[UILabel alloc]init];
        _nameLab_en.font = LWUIFONT(44);
        _nameLab_en.textColor = LWRGB16Color(0xffffff, 1);
        [self addSubview:_nameLab_en];
        [_nameLab_en mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.nameLab_cn.mas_bottom).mas_equalTo(6);
            make.centerX.mas_equalTo(self.mas_centerX);
        }];
    }
    return _nameLab_en;
}
@end
