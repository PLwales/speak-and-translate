//
//  ChangeLanguageVC.m
//  Translate
//
//  Created by sihao99 on 2019/5/29.
//  Copyright © 2019 SiHan. All rights reserved.
//

#import "ChangeLanguageVC.h"
#import "ChangeLanguageView.h"
#import "SettingLanguageVC.h"

@interface ChangeLanguageVC ()<ChangeLanguageViewDelegate>
@property (nonatomic,strong)ChangeLanguageView *topView;
@property (nonatomic,strong)ChangeLanguageView *bottomView;
@property (nonatomic,strong)UIButton *downBtn;
@property (nonatomic,strong)NSString *leftLanguage;
@property (nonatomic,strong)NSString *rightLanguage;

@end

@implementation ChangeLanguageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addswipeDownRecognizer];
    self.topView.backgroundColor = LWRGB16Color(0xA7E5DA, 1);
    self.bottomView.backgroundColor = LWRGB16Color(0x93CCE7, 1);
    [self.downBtn setImage:GET_IMAGE(@"pushdown") forState:UIControlStateNormal];
}

-(void)downBtnAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)addswipeDownRecognizer
{
    UISwipeGestureRecognizer * recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(downBtnAction)];
    recognizer.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:recognizer];
}


#pragma   maek
-(void)ChangeLanguageViewPresentSetting:(NSString *)language color:(nonnull UIColor *)color ident:(nonnull NSString *)ident
{
    SettingLanguageVC *setLvc = [[SettingLanguageVC alloc]init];
    setLvc.bgcolor = color;
    setLvc.currentLanguage = language;
    setLvc.idf  = ident;
    setLvc.updataLanguage = ^(NSString * _Nonnull idef) {
        if ([idef isEqualToString:ISKeyTanslateDictionaryLanguageFrom]) {
            [self.topView reloadData:idef];
        }else{
            [self.bottomView reloadData:idef];
        }
        self.updataLanguage(idef);
    };
    [self presentViewController:setLvc animated:YES completion:nil];
}
#pragma mark setter getter
-(ChangeLanguageView *)topView
{
    if (!_topView) {
        _topView  = [[ChangeLanguageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, HEIGHT_SCREEN/2) LanguageKey:ISKeyTanslateDictionaryLanguageFrom];
        _topView.delegete  = self;
        [self.view addSubview:_topView];
    }
    return _topView;
}
-(ChangeLanguageView *)bottomView
{
    if (!_bottomView) {
        _bottomView  = [[ChangeLanguageView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topView.frame), WIDTH_SCREEN, HEIGHT_SCREEN/2) LanguageKey:ISKeyTanslateDictionaryLanguageTo];;
        _bottomView.delegete = self;
        [self.view addSubview:_bottomView];
    }
    return _bottomView;
}
-(UIButton *)downBtn
{
    if (!_downBtn) {
        _downBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_downBtn addTarget:self action:@selector(downBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_downBtn];
        [_downBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(30*FITScreenHeight);
            make.centerX.mas_equalTo(self.view.mas_centerX);
            make.left.right.mas_equalTo(0);

        }];
    }
    return _downBtn;
}
@end
