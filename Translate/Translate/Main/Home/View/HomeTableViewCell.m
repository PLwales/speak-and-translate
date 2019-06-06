//
//  HomeTableViewCell.m
//  Translate
//
//  Created by sihao99 on 2019/5/30.
//  Copyright © 2019 SiHan. All rights reserved.
//

#import "HomeTableViewCell.h"
#import "TranslateDB.h"
#import "SoundPlayer.h"

#define kIconSizeWidth  35*FITScreenWidth
#define kIconMarginWidth  31*FITScreenWidth
#define kiconToLabelMarginHeight  5*FITScreenHeight

@interface HomeTableViewCell ()
@property (nonatomic,strong)UILabel     *toLanguageLab;
@property (nonatomic,strong)UILabel     *frmoLanguageLab;
@property (nonatomic,strong)UIView      *bgToolView;
@property (nonatomic,strong)UIButton   *collectBtn;
@property (nonatomic,strong)UILabel     *collectLab;
@property (nonatomic,strong)UIButton   *soundBtn;
@property (nonatomic,strong)UILabel      *soundLab;

@property (nonatomic,strong)UIButton    *editBtn;
@property (nonatomic,strong)UILabel     *editLab;

@property (nonatomic,strong)UIButton    *shareBtn;
@property (nonatomic,strong)UILabel      *shareLab;

@property (nonatomic,strong)UIButton    *deleteBtn;
@property (nonatomic,strong)UILabel     *deleteLab;

@property (nonatomic,strong)TranslateModel *model;

@property (nonatomic,assign)BOOL   isCollect;
@end

@implementation HomeTableViewCell


-(void)setHistoryContentTranslateModel:(TranslateModel *)model showTool:(BOOL)isShow
{
    self.isCollect = NO;
    CGAffineTransform transform =CGAffineTransformMakeRotation(M_PI);
    [self.contentView setTransform:transform];
    self.model = model;
    self.toLanguageLab.text = model.translate;
    self.frmoLanguageLab.text = model.content;
    [ self isShowUI:!isShow];
    self.collectBtn.selected =model.isCollect;
    [self.soundBtn setBackgroundImage:GET_IMAGE(@"sound") forState:UIControlStateNormal];
    [self.soundBtn setBackgroundImage:GET_IMAGE(@"sounded") forState:UIControlStateSelected];
    self.soundLab.text = @"播放语音";
    self.editLab.text   =   @"重新编辑";
    self.collectLab.text = @"收藏";
    self.shareLab.text = @"分享";
    self.deleteLab.text = @"删除";
}

-(void)setCollectContentTranslateModel:(TranslateModel *)model showTool:(BOOL)isShow
{
    self.isCollect = YES;
    self.model = model;
    self.toLanguageLab.text = model.translate;
    self.frmoLanguageLab.text = model.content;
    self.collectBtn.selected = NO;
    [self isShowUI:!isShow];
    [self.soundBtn setBackgroundImage:GET_IMAGE(@"sound") forState:UIControlStateNormal];
    [self.soundBtn setBackgroundImage:GET_IMAGE(@"sounded") forState:UIControlStateSelected];
    [self.editBtn setBackgroundImage:GET_IMAGE(@"sounded_left") forState:UIControlStateNormal];
    [self.editBtn setBackgroundImage:GET_IMAGE(@"soundeded_left") forState:UIControlStateSelected];
    [self.collectBtn setBackgroundImage:GET_IMAGE(@"copy_ original") forState:UIControlStateNormal];
    [self.collectBtn setBackgroundImage:GET_IMAGE(@"copyed_ original") forState:UIControlStateSelected];
    [self.shareBtn setBackgroundImage:GET_IMAGE(@"copy_ translation") forState:UIControlStateNormal];
    [self.shareBtn setBackgroundImage:GET_IMAGE(@"copyed_ translation") forState:UIControlStateSelected];
    self.soundLab.text = @"播放原文";
    self.editLab.text   =   @"重新译文";
    self.collectLab.text = @"复制原文";
    self.shareLab.text = @"复制译文";
    self.deleteLab.text = @"删除";
    self.lineView.hidden =NO;

}
-(void)isShowUI:(BOOL)isshow
{
    [self.bgToolView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(isshow ?0 :70*FITScreenHeight);
    }];
    self.soundBtn.hidden = isshow;
    self.editBtn.hidden = isshow;
    self.collectBtn.hidden = isshow;
    self.shareBtn.hidden = isshow;
    self.deleteBtn.hidden = isshow;
    
    self.soundLab.hidden = isshow;
    self.editLab.hidden = isshow;
    self.collectLab.hidden = isshow;
    self.shareLab.hidden = isshow;
    self.deleteLab.hidden = isshow;
}
#pragma mark   action
-(void)collectBtnAction:(UIButton *)sender
{
    if (self.isCollect) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = self.model.translate;
        [MBProgressHUDCustom showSuccess:NSLocalizedString(@"Text content has been copied", nil) toView:self.superview];

    }else{
        if (sender.selected) {
            self.model.isCollect = NO;
        }else{
            self.model.isCollect = YES;
        }
        TranslateDB  *DB = [TranslateDB new];
        [DB _updateStatusWithTranslate:self.model];
        sender.selected  = !sender.selected;
        self.upDataDBblock();
    }
}
-(void)soundBtnAction
{
    SoundPlayer *playS = [SoundPlayer SoundPlayerInit];
    if (playS.isSpeaking) {
        [playS stopPlaer];
        return;
    }
    [playS setDefaultWithVolume:1.0 rate:0.4 pitchMultiplier:-1.0];
    playS.soundPlayStatus = ^(BOOL status) {
        self.soundBtn.selected = status;
    };
    //数据库里获取到的是s语言缩写。  先把语言转成对应国家。再把g对应国家转换成缩写
    NSInteger  integer = [[Comn gb]_getCurrentSystemLanguageWithString:self.model.fromLanguage];
    NSString *languageStr = [[Comn gb]_getLanguageArray][integer];
    [playS play:self.model.content language:[[Comn gb]_getTranslateLanguegeABWithTranslateType:TypeTranslateUseBaidu lanuageString:languageStr]];
    self.soundBtn.selected =   [SoundPlayer SoundPlayerInit].isSpeaking;

}
-(void)updateSoundStatue:(BOOL)statue
{
    self.soundBtn.selected = statue;
}
-(void)editBtnAction
{
    if (self.isCollect) {
        SoundPlayer *playS = [SoundPlayer SoundPlayerInit];
        if (playS.isSpeaking) {
            [playS stopPlaer];
            return;
        }
        [playS setDefaultWithVolume:1.0 rate:0.4 pitchMultiplier:-1.0];
        playS.soundPlayStatus = ^(BOOL status) {
            self.editBtn.selected = status;
        };
        
        NSInteger  integer = [[Comn gb]_getCurrentSystemLanguageWithString:self.model.toLanguage];
        NSString *languageStr = [[Comn gb]_getLanguageArray][integer];
        [playS play:self.model.translate language:[[Comn gb]_getTranslateLanguegeABWithTranslateType:TypeTranslateUseBaidu lanuageString:languageStr]];
        self.editBtn.selected =   [SoundPlayer SoundPlayerInit].isSpeaking;
    }else{
        self.againEditblock(self.model.content, self.model.UUID);
    }
}
-(void)shareBtnAction
{
    if (self.isCollect) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = self.model.translate;
        [MBProgressHUDCustom showSuccess:NSLocalizedString(@"Text content has been copied", nil) toView:self.superview];

    }else{
        [[Comn gb]_shareWithTitle:self.model.translate image:@""];
    }
}
-(void)deleteBtnAction
{
    TranslateDB  *DB = [TranslateDB new];
    if (self.isCollect) {
        self.model.isCollect  = NO;
        [DB  _updateStatusWithTranslate:self.model];
    }else{
        [DB _delTranslateWithUUID:self.model.UUID];
    }
    
    self.upDataDBblock();
}
#pragma   mark   setter   getter
-(UILabel *)toLanguageLab
{
    if (!_toLanguageLab) {
        _toLanguageLab = [[UILabel alloc]init];
        _toLanguageLab.font = LWUIFONT(18);;
        _toLanguageLab.textColor = LWRGB16Color(0xffffff, 1);
        _toLanguageLab.textAlignment = NSTextAlignmentLeft;
        _toLanguageLab.numberOfLines =0;
        [self.contentView addSubview:_toLanguageLab];
        [_toLanguageLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(15);
            make.left.mas_equalTo(40*FITScreenWidth);
            make.right.mas_equalTo(-40*FITScreenWidth);
            make.bottom.mas_equalTo(self.frmoLanguageLab.mas_top).mas_equalTo(-15*FITScreenHeight);
        }];
    }
    return _toLanguageLab;
}
-(UILabel *)frmoLanguageLab
{
    if (!_frmoLanguageLab) {
        _frmoLanguageLab = [[UILabel alloc]init];
        _frmoLanguageLab.font = LWUIFONT(12);;
        _frmoLanguageLab.textColor = LWRGB16Color(0xffffff, 1);
        _frmoLanguageLab.textAlignment = NSTextAlignmentLeft;
        _frmoLanguageLab.numberOfLines =0;
        [self.contentView addSubview:_frmoLanguageLab];
        [_frmoLanguageLab mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(self.toLanguageLab.mas_bottom).mas_equalTo(15*FITScreenHeight);
            make.left.mas_equalTo(40*FITScreenWidth);
            make.right.mas_equalTo(-40*FITScreenWidth);
            make.bottom.mas_equalTo(self.bgToolView.mas_top).mas_equalTo(-15*FITScreenHeight);
        }];
    }
    return _frmoLanguageLab;
}
-(UIView *)bgToolView
{
    if (!_bgToolView) {
        _bgToolView  = [[UIView alloc]init];
        [self.contentView addSubview:_bgToolView];
        [_bgToolView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(self.frmoLanguageLab.mas_bottom);
            make.left.mas_equalTo(self.frmoLanguageLab.mas_left);
            make.right.mas_equalTo(self.frmoLanguageLab.mas_right);
//            make.height.mas_equalTo(1);
            make.bottom.mas_equalTo(self.lineView.mas_top);
        }];
    }
    return _bgToolView;
}

-(UIButton *)soundBtn
{
    if (!_soundBtn) {
        _soundBtn = [UIButton buttonWithType:UIButtonTypeCustom];

        [_soundBtn addTarget:self action:@selector(soundBtnAction) forControlEvents:UIControlEventTouchUpInside];
 
        [self.bgToolView addSubview:_soundBtn];
        [_soundBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.centerY.mas_equalTo(self.bgToolView.mas_centerY).mas_equalTo(-10);
            make.size.mas_equalTo(CGSizeMake(kIconSizeWidth, kIconSizeWidth));
        }];
    }
    return _soundBtn;
}
-(UILabel *)soundLab
{
    if (!_soundLab) {
        _soundLab = [[UILabel alloc]init];
        _soundLab.font = LWUIFONT(10);
        _soundLab.textColor = [UIColor whiteColor];
        [self.bgToolView addSubview:_soundLab];
        [_soundLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.soundBtn.mas_bottom).mas_equalTo(kiconToLabelMarginHeight);
            make.centerX.mas_equalTo(self.soundBtn.mas_centerX);
        }];
    }
    return _soundLab;
}
-(UIButton *)editBtn
{
    if (!_editBtn) {
        _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_editBtn setBackgroundImage:GET_IMAGE(@"edit") forState:UIControlStateNormal];
        [_editBtn addTarget:self action:@selector(editBtnAction) forControlEvents:UIControlEventTouchUpInside];
        
        [self.bgToolView addSubview:_editBtn];
        [_editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.soundBtn.mas_right).mas_equalTo(kIconMarginWidth);
            make.centerY.mas_equalTo(self.soundBtn.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(kIconSizeWidth, kIconSizeWidth));
        }];
    }
    return _editBtn;
}

-(UILabel *)editLab
{
    if (!_editLab) {
        _editLab = [[UILabel alloc]init];
        _editLab.font = LWUIFONT(10);
        _editLab.textColor = [UIColor whiteColor];
        [self.bgToolView addSubview:_editLab];
        [_editLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.editBtn.mas_bottom).mas_equalTo(kiconToLabelMarginHeight);
            make.centerX.mas_equalTo(self.editBtn.mas_centerX);
        }];
    }
    return _editLab;
}
-(UIButton *)collectBtn
{
    if (!_collectBtn) {
        _collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_collectBtn setBackgroundImage:GET_IMAGE(@"collect") forState:UIControlStateNormal];
        [_collectBtn setBackgroundImage:GET_IMAGE(@"collected") forState:UIControlStateSelected];
        [_collectBtn addTarget:self action:@selector(collectBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.bgToolView addSubview:_collectBtn];
        [_collectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.editBtn.mas_right).mas_equalTo(kIconMarginWidth);
            make.centerY.mas_equalTo(self.soundBtn.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(kIconSizeWidth, kIconSizeWidth));
        }];
    }
    return _collectBtn;
}

-(UILabel *)collectLab
{
    if (!_collectLab) {
        _collectLab = [[UILabel alloc]init];
        _collectLab.font = LWUIFONT(10);
        _collectLab.textColor = [UIColor whiteColor];
        [self.bgToolView addSubview:_collectLab];
        [_collectLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.collectBtn.mas_bottom).mas_equalTo(kiconToLabelMarginHeight);
            make.centerX.mas_equalTo(self.collectBtn.mas_centerX);
        }];
    }
    return _collectLab;
}
-(UIButton *)shareBtn
{
    if (!_shareBtn) {
        _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareBtn setBackgroundImage:GET_IMAGE(@"share") forState:UIControlStateNormal];
        [_shareBtn addTarget:self action:@selector(shareBtnAction) forControlEvents:UIControlEventTouchUpInside];

        [self.bgToolView addSubview:_shareBtn];
        [_shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.collectBtn.mas_right).mas_equalTo(kIconMarginWidth);
            make.centerY.mas_equalTo(self.soundBtn.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(kIconSizeWidth, kIconSizeWidth));
        }];
    }
    return _shareBtn;
}


-(UILabel *)shareLab
{
    if (!_shareLab) {
        _shareLab = [[UILabel alloc]init];
        _shareLab.font = LWUIFONT(10);
        _shareLab.textColor = [UIColor whiteColor];
        [self.bgToolView addSubview:_shareLab];
        [_shareLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.shareBtn.mas_bottom).mas_equalTo(kiconToLabelMarginHeight);
            make.centerX.mas_equalTo(self.shareBtn.mas_centerX);
        }];
    }
    return _shareLab;
}
-(UIButton *)deleteBtn
{
    if (!_deleteBtn) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteBtn setBackgroundImage:GET_IMAGE(@"delete") forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(deleteBtnAction) forControlEvents:UIControlEventTouchUpInside];

        [self.bgToolView addSubview:_deleteBtn];
        [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.shareBtn.mas_right).mas_equalTo(kIconMarginWidth);
            make.centerY.mas_equalTo(self.soundBtn.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(kIconSizeWidth, kIconSizeWidth));
        }];
    }
    return _deleteBtn;
}
-(UILabel *)deleteLab
{
    if (!_deleteLab) {
        _deleteLab = [[UILabel alloc]init];
        _deleteLab.font = LWUIFONT(10);
        _deleteLab.textColor = [UIColor whiteColor];
        [self.bgToolView addSubview:_deleteLab];
        [_deleteLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.deleteBtn.mas_bottom).mas_equalTo(kiconToLabelMarginHeight);
            make.centerX.mas_equalTo(self.deleteBtn.mas_centerX);
        }];
    }
    return _deleteLab;
}
-(UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.alpha = 0.4;
        _lineView.backgroundColor = [UIColor whiteColor];

        [self.contentView addSubview:_lineView];
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(40*FITScreenWidth);
            make.right.mas_equalTo(-40*FITScreenWidth);
            make.height.mas_equalTo(1);
            make.bottom.mas_equalTo(self.contentView.mas_bottom);
        }];
    }
    return _lineView;
}
@end
