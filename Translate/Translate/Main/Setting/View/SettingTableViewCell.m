//
//  SettingTableViewCell.m
//  Translate
//
//  Created by sihao99 on 2019/5/31.
//  Copyright © 2019 SiHan. All rights reserved.
//

#import "SettingTableViewCell.h"

@interface SettingTableViewCell ()
@property (nonatomic,strong) UIImageView *icon;
@property (nonatomic,strong) UILabel *setTitleLab;
@property (nonatomic,strong) UIView  *lineView;
@end

@implementation SettingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
-(void)setContentIcon:(NSString *)icon  Title:(NSString *)title
{
    self.icon.image = GET_IMAGE(icon);
    self.setTitleLab.text= title;
    self.lineView.hidden = NO;
}

-(UIImageView *)icon
{
    if (!_icon) {
        _icon = [[UIImageView alloc]init];
        [self.contentView addSubview:_icon];
        [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(36*FITScreenWidth);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }];
    }
    return _icon;
}

-(UILabel *)setTitleLab
{
    if (!_setTitleLab) {
        _setTitleLab = [[UILabel alloc]init];
        _setTitleLab.font = LWUIFONT(24);
        _setTitleLab.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_setTitleLab];
        [_setTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.icon.mas_right).mas_equalTo(13*FITScreenWidth);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }];
    }
    return _setTitleLab;
}

-(UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = [UIColor whiteColor];
        _lineView.alpha = 0.4;
        [self.contentView addSubview:_lineView];
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.left.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
    }
    return _lineView;
}
@end
