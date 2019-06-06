//
//  HomeView.m
//  Translate
//
//  Created by sihao99 on 2019/5/28.
//  Copyright © 2019 SiHan. All rights reserved.
//

#import "HomeView.h"




@interface HomeView ()<UITextViewDelegate>
@property (nonatomic,strong)UITextView  *contentTV;
@property (nonatomic,strong)UIButton *leftBtn;
@property (nonatomic,strong)UIButton *rightBtn;
@property (nonatomic,strong)UIButton *changeLanguageBtn;
@property (nonatomic,strong)UIImageView *animationView;
@property (nonatomic,strong)NSString *languageFrom;
@property (nonatomic,strong)NSString *languageTo;
@property (nonatomic,strong)NSString *imageFrom;
@property (nonatomic,strong)NSString *imageTo;
@property (nonatomic,strong)UIButton *plaBtn;
@end
@implementation HomeView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        [self addData];
        [self addSubviews];
        [self addLayoutSubviews];

    }
    return self;
}
-(void)addData{
    self.languageFrom =[[Comn gb]_fromTranslateDictionaryLanguageTitle];
    self.languageTo = [[Comn gb]_toTranslateDictionaryLanguageTitle];
    self.imageTo = [[Comn gb]_toTranslateDictionaryLanguageImage];
    self.imageFrom = [[Comn gb]_frmoTranslateDictionaryLanguageImage];
    [self.leftBtn  setTitle:NSLocalizedString(self.languageFrom, nil) forState:UIControlStateNormal];
    [self.leftBtn setImage:GET_IMAGE(self.imageFrom) forState:UIControlStateNormal];
    [self.rightBtn  setTitle:NSLocalizedString(self.languageTo, nil) forState:UIControlStateNormal];
    [self.rightBtn setImage:GET_IMAGE(self.imageTo) forState:UIControlStateNormal];
}
-(void)addSubviews
{
    [self addSubview:self.contentTV];
    [self addSubview:self.leftBtn];
    [self addSubview:self.rightBtn];
    [self addSubview:self.changeLanguageBtn];
    [self addSubview:self.animationView];
    [self.contentTV addSubview:self.plaBtn];
}

-(void)addLayoutSubviews
{
    [self.contentTV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.left.mas_equalTo(20*FITScreenWidth);
        make.right.mas_equalTo(-20*FITScreenWidth);
        make.height.mas_equalTo(122*FITScreenHeight);
    }];
    
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20*FITScreenWidth);
        make.top.mas_equalTo(self.contentTV.mas_bottom).mas_equalTo(6*FITScreenHeight);
        make.size.mas_equalTo(CGSizeMake(165*FITScreenWidth, 45*FITScreenHeight));
    }];
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftBtn.mas_right).mas_equalTo(5*FITScreenWidth);
        make.top.mas_equalTo(self.leftBtn.mas_top);
        make.size.mas_equalTo(CGSizeMake(165*FITScreenWidth, 45*FITScreenHeight));
    }];
    [self.changeLanguageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-10*FITScreenHeight);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.left.right.mas_equalTo(0);
    }];
    
   [ self.animationView mas_makeConstraints:^(MASConstraintMaker *make) {
       
    }];
    
    
    
    [self.plaBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(0);
    }];
    
  
}
#pragma mark  action
-(void)buttonRecordingAction:(UIButton *)sender
{
    self.plaBtn.hidden = YES;
        if ([Comn CheckSpeechPermissions] && [Comn CheckMicrophonePermissions]) {
            NSString *langeuage;
            if (sender.tag ==100) {
                langeuage = ISKeyTanslateDictionaryLanguageFrom;
                if ([self.contentTV.text isEqualToString:@""]) {
                    UIButton *btn = [self viewWithTag:101];
                    btn.enabled = NO;

                }
            }else{
                langeuage = ISKeyTanslateDictionaryLanguageTo;
                if ([self.contentTV.text isEqualToString:@""]) {
                    UIButton *btn = [self viewWithTag:100];
                    btn.enabled = NO;
                    
                }
            }
            
            
            if (![self.contentTV.text isEqualToString:@""]) {
                self.animationView.hidden =YES;
                if ([self.lwDelegate respondsToSelector:@selector(homeViewStartTranslate:conten:)]) {
                    [self.lwDelegate  homeViewStartTranslate:langeuage conten:self.contentTV.text];
                }
            }else{
                if (!self.animationView.hidden) {
                    [self endRecordingAction];
                    return;
                }
                self.animationView.hidden =NO;
                [self.animationView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(self.contentTV.mas_bottom).mas_equalTo(6*FITScreenHeight);
                    make.size.mas_equalTo(CGSizeMake(165*FITScreenWidth, 45*FITScreenWidth));
                    if ([langeuage isEqualToString:ISKeyTanslateDictionaryLanguageFrom]) {
                        make.left.mas_equalTo(self.leftBtn.mas_left);
                    }else{
                        make.left.mas_equalTo(self.rightBtn.mas_left);
                    }
                }];
                if ([self.lwDelegate respondsToSelector:@selector(homeViewStartRecording:)]) {
                    [self.lwDelegate  homeViewStartRecording:langeuage];
                }
            }
         
        }
}
-(void)endRecordingAction
{
    
    if ([self.lwDelegate respondsToSelector:@selector(homeViewEndRecording)]) {
        [self.lwDelegate homeViewEndRecording];
    }
}
-(void)changelanguage
{
    if ([self.lwDelegate respondsToSelector:@selector(homeViewPresentChangeLanguageVC)]) {
        [self.lwDelegate homeViewPresentChangeLanguageVC];
    }
}
#pragma mark  SETTER GETTER
-(UITextView *)contentTV
{
    if (!_contentTV) {
        _contentTV = [[UITextView alloc]init];
        _contentTV.font = LWUIFONT(15);
        _contentTV.textColor = LWRGB16Color(0x999999, 1);
        [_contentTV setContentInset:UIEdgeInsetsMake(20, 10, 20, 10)];
        _contentTV.layer.cornerRadius =10;
        _contentTV.layer.masksToBounds =YES;
        _contentTV.delegate = self;
    }
    return _contentTV;
}
- (UIButton *)leftBtn
{
    if (!_leftBtn) {
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftBtn.titleLabel.font = LWUIFONT(24);
        [_leftBtn setTitleColor:LWRGB16Color(0x333333, 1) forState:UIControlStateNormal];
        [_leftBtn  setTitle:NSLocalizedString(self.languageFrom, nil) forState:UIControlStateNormal];
        [_leftBtn setImage:GET_IMAGE(self.imageFrom) forState:UIControlStateNormal];
        [_leftBtn setBackgroundImage:GET_IMAGE(@"button") forState:UIControlStateNormal];
        _leftBtn.titleLabel.adjustsFontSizeToFitWidth =  YES;
        [_leftBtn setContentHorizontalAlignment: UIControlContentHorizontalAlignmentCenter];
        [_leftBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -2.5*FITScreenWidth, 0, 2.5*FITScreenWidth)];
        [_leftBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 2.5*FITScreenWidth, 0, -2.5*FITScreenWidth)];
        _leftBtn.tag = 100;
        [_leftBtn addTarget:self action:@selector(buttonRecordingAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftBtn;
}
- (UIButton *)rightBtn
{
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightBtn.titleLabel.font = LWUIFONT(24);
        [_rightBtn setTitleColor:LWRGB16Color(0x333333, 1) forState:UIControlStateNormal];
        [_rightBtn  setTitle:NSLocalizedString(self.languageTo, nil) forState:UIControlStateNormal];
        [_rightBtn setImage:GET_IMAGE(self.imageTo) forState:UIControlStateNormal];
        [_rightBtn setBackgroundImage:GET_IMAGE(@"button") forState:UIControlStateNormal];
        [_rightBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -2.5*FITScreenWidth, 0, 2.5*FITScreenWidth)];
        [_rightBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -2.5*FITScreenWidth, 0, -2.5*FITScreenWidth)];
        _rightBtn.titleLabel.adjustsFontSizeToFitWidth =  YES;
        _rightBtn.tag = 101;
        [_rightBtn addTarget:self action:@selector(buttonRecordingAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}
- (UIButton *)changeLanguageBtn
{
    if (!_changeLanguageBtn) {
        _changeLanguageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_changeLanguageBtn setImage:GET_IMAGE(@"pushup") forState:UIControlStateNormal];
        [_changeLanguageBtn addTarget:self action:@selector(changelanguage) forControlEvents:UIControlEventTouchUpInside];

    }
    return _changeLanguageBtn;
}

-(UIImageView *)animationView
{
    if (!_animationView) {
        _animationView = [[UIImageView alloc]init];;
        _animationView.hidden = YES;
        _animationView.userInteractionEnabled = YES;
        _animationView.image = GET_IMAGE(@"button-1");
        [self frameAnimation:_animationView];
        UITapGestureRecognizer *tapGes  = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(endRecordingAction)];
        [_animationView addGestureRecognizer:tapGes];
    }
    return _animationView;
}
-(UIButton *)plaBtn
{
    if (!_plaBtn) {
        _plaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _plaBtn.titleLabel.font = LWUIFONT(15);
        [_plaBtn setTitleColor:LWRGB16Color(0x999999, 1) forState:UIControlStateNormal];
        [_plaBtn  setTitle:NSLocalizedString(@"touch input",nil) forState:UIControlStateNormal];
        [_plaBtn setImage:GET_IMAGE(@"keybord") forState:UIControlStateNormal];
        [_plaBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -2.5*FITScreenWidth, 0, 2.5*FITScreenWidth)];
        [_plaBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -2.5*FITScreenWidth, 0, -2.5*FITScreenWidth)];
        _plaBtn.titleLabel.adjustsFontSizeToFitWidth =  YES;
        _plaBtn.userInteractionEnabled = NO;
        
    }
    return _plaBtn;
}


-(void)frameAnimation:(UIImageView *)imgView
{
    NSMutableArray <UIImage *>* arrM=[NSMutableArray array];//protocol限定这个数组只用来装UIImage*，如果装其他的就提示警告

    for (int i=0;i<10;i++)
    {
        NSString *strimageName=[NSString stringWithFormat:@"button-%d",i+1];
        UIImage *image1=[UIImage imageNamed:strimageName];//给image1变量按照名字加载图片
        [arrM addObject:image1];//给可变数组加入图片
    }
    imgView.animationImages=arrM;//把图片数组加在到UIImageView控件里
    imgView.animationDuration=2;//几秒内完成动画数组
    imgView.animationRepeatCount=0;//重复次数
    [imgView startAnimating ];//开始动画
}

#pragma mark     contenDelegate
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if(textView.text.length < 1){
        self.plaBtn.hidden = NO;
    }
    
    if (![LWUserDefaults integerForKey:ISKeyBootViewTextTranslate] && textView.text.length >= 1 ) {
        if ([self.lwDelegate respondsToSelector:@selector(homeViewendEditContentView:)]) {
            [self.lwDelegate homeViewendEditContentView:textView.frame.size.height];
        }
    }
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.plaBtn.hidden = YES;
}

-(void)setContent:(NSString *)content
{
    _content =content;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.contentTV.text =content;
    });
}
-(void)setRecordState:(BOOL)recordState
{
    self.animationView.hidden = !recordState;
    if (self.animationView.hidden) {
        for (UIButton *btn in self.subviews) {
            if (btn.tag ==100 || btn.tag ==101) {
                btn.enabled = YES;

            }
        }
    }
   
}

@end
