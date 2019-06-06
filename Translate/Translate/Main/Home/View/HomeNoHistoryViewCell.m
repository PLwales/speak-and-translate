//
//  HomeNoHistoryViewCell.m
//  Translate
//
//  Created by sihao99 on 2019/5/31.
//  Copyright © 2019 SiHan. All rights reserved.
//

#import "HomeNoHistoryViewCell.h"

@interface HomeNoHistoryViewCell ()
@property (nonatomic,strong)UILabel *contentLab;

@end
@implementation HomeNoHistoryViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setContent
{
    
    CGAffineTransform transform =CGAffineTransformMakeRotation(M_PI);
    [self.contentView setTransform:transform];
    self.contentLab.text = @"点击[语言按钮]可输入语音\n点击[文本框]可输入文字";
    NSString *labelText = self.contentLab.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:10];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    self.contentLab.attributedText = attributedString;
    self.contentLab.textAlignment = NSTextAlignmentCenter;
    [self.contentLab sizeToFit];
}

-(UILabel *)contentLab
{
    if (!_contentLab) {
        _contentLab = [[UILabel alloc]init];
        _contentLab.textColor = [UIColor whiteColor];
        _contentLab.textAlignment = NSTextAlignmentCenter;
        _contentLab.numberOfLines = 0;
        _contentLab.font = LWUIFONT(24);
      
       
  
        [self.contentView addSubview:_contentLab];
        [_contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0);
        }];
    }
    
    return _contentLab;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
