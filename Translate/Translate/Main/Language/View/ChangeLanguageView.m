//
//  ChangeLanguageView.m
//  Translate
//
//  Created by sihao99 on 2019/5/29.
//  Copyright © 2019 SiHan. All rights reserved.
//

#import "ChangeLanguageView.h"

@interface ChangeLanguageView ()
@property (nonatomic,strong)UIButton *languageBtn;
@property (nonatomic,strong)UIImageView *languageimage;
@property (nonatomic,strong)UILabel *languageLab;
@property (nonatomic,strong)NSString *idf;
@end
@implementation ChangeLanguageView

- (instancetype)initWithFrame:(CGRect)frame  LanguageKey:(nonnull NSString *)language
{
    self = [super initWithFrame:frame];
    if (self) {
        self.languageBtn.hidden = NO;
        _idf = language;
        if ([language isEqualToString:ISKeyTanslateDictionaryLanguageFrom]) {
                    self.languageimage.image =GET_IMAGE([[Comn gb]_frmoTranslateDictionaryLanguageImage]);
                    self.languageLab.text = NSLocalizedString([[Comn gb]_fromTranslateDictionaryLanguageTitle], nil);
        }else{
                self.languageimage.image =GET_IMAGE([[Comn gb]_toTranslateDictionaryLanguageImage]);
                self.languageLab.text = NSLocalizedString([[Comn gb]_toTranslateDictionaryLanguageTitle], nil);
        }

    }
    return self;
}
-(void)reloadData:(NSString *)language
{
    if ([language isEqualToString:ISKeyTanslateDictionaryLanguageFrom]) {
        self.languageimage.image =GET_IMAGE([[Comn gb]_frmoTranslateDictionaryLanguageImage]);
        self.languageLab.text = NSLocalizedString([[Comn gb]_fromTranslateDictionaryLanguageTitle], nil);
    }else{
        self.languageimage.image =GET_IMAGE([[Comn gb]_toTranslateDictionaryLanguageImage]);
        self.languageLab.text = NSLocalizedString([[Comn gb]_toTranslateDictionaryLanguageTitle], nil);
    }
}
-(void)presentSettingLangauge:(UIButton *)sender
{
    UIColor *color = self.backgroundColor;
    if ([self.delegete  respondsToSelector:@selector(ChangeLanguageViewPresentSetting:color:ident:)]) {
        [self.delegete ChangeLanguageViewPresentSetting:self.languageLab.text color:color ident:_idf];
    }
}

-(UIButton *)languageBtn
{
    if (!_languageBtn) {
        _languageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_languageBtn addTarget:self action:@selector(presentSettingLangauge:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_languageBtn];
        
        [_languageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0);
        }];
    }
    return _languageBtn;
}
-(UIImageView *)languageimage
{
    if (!_languageimage) {
        _languageimage = [[UIImageView alloc]init];
        [self addSubview:_languageimage];
        [_languageimage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.mas_equalTo(143*FITScreenHeight);
            make.size.mas_equalTo(CGSizeMake(53*FITScreenWidth, 53*FITScreenWidth));
        }];
    }
    return _languageimage;
}
-(UILabel *)languageLab
{
    if (!_languageLab) {
        _languageLab  = [[UILabel alloc]init];
        _languageLab.font = LWUIFONT(30);
        _languageLab.textColor = LWRGB16Color(0x004A3D, 1);
        [self addSubview:_languageLab];
        [_languageLab  mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.languageimage.mas_bottom).mas_equalTo(10*FITScreenHeight);
            make.centerX.mas_equalTo(self.mas_centerX);
        }];
    }
    return _languageLab;
}
@end
