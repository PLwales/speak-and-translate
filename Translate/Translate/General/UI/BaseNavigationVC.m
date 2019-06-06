//
//  BaseNavigationVC.m
//  ScanPlant
//
//  Created by sihan on 2018/7/6.
//  Copyright © 2018年 sihan. All rights reserved.
//

#import "BaseNavigationVC.h"
#import "MBProgressHUDCustom.h"

@interface BaseNavigationVC ()
@property (nonatomic, retain) MBProgressHUD *hud;
//分割线
@property (nonatomic, retain) UIView * viewLine;
@end

@implementation BaseNavigationVC
#pragma mark - lif cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self _addSubviews];
    [self _layoutSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)ls_initData {
    
}

- (void)_addSubviews {
    
    [self.view addSubview:self.viewNavigation];
    [self.view addSubview:self.buttonLeft];
    [self.view addSubview:self.buttonRight];
    [self.view addSubview:self.labelTitle];
    [self.viewNavigation addSubview:self.viewLine];
}

- (void)_layoutSubviews {
    
    float kHeightNavigationBarLabel = 35;
    float kWidthNavigationBarLabel = 200;
    float kWidthLeftSpace = 10;
    WS(weakSelf);
    [_viewNavigation mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view).offset(0);
        make.top.equalTo(weakSelf.view).offset(0);
        make.height.mas_equalTo(kHeightNavigationBar);
        make.width.mas_equalTo(weakSelf.view);
    }];
    
    [_buttonLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kHeightNavigationBarBtn, kHeightNavigationBarBtn));
        make.centerY.mas_equalTo(weakSelf.viewNavigation).offset(kHeightGetNavCenterYSpace);
        make.left.mas_equalTo(kWidthLeftSpace);
    }];
    
    [_buttonRight mas_makeConstraints:^(MASConstraintMaker *make) {
        //有title则设置宽度
        make.size.mas_equalTo(CGSizeMake((weakSelf.buttonRight.currentTitle && weakSelf.buttonRight.currentTitle.length)?90: kHeightNavigationBarBtn, kHeightNavigationBarBtn));
        make.centerY.mas_equalTo(weakSelf.buttonLeft.mas_centerY);
        make.right.mas_equalTo(-kWidthLeftSpace*2);
    }];
    
    [_labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kWidthNavigationBarLabel, kHeightNavigationBarLabel));
        make.centerY.mas_equalTo(weakSelf.buttonLeft.mas_centerY);
        make.centerX.mas_equalTo(weakSelf.viewNavigation.mas_centerX);
    }];
    
    [_viewLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.bottom.equalTo(weakSelf.viewNavigation.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(WIDTH_SCREEN, 1));
    }];
    
}

- (void)ls_bindViewModel {
    
}
#pragma mark - event response
#pragma mark - private methods
- (void)_showMBProgressHUD:(NSString *)stringTitle
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUDCustom showSuccess:stringTitle toView:self.view];
    });
}
- (void)_showWaitView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.view.userInteractionEnabled = NO;
        self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.hud.userInteractionEnabled = NO;
    });
}
- (void)_hideWaitView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.view.userInteractionEnabled = YES;
        [self.hud hideAnimated:YES];
    });
}
#pragma mark - getters and setters
- (UIView *)viewNavigation
{
    if (!_viewNavigation) {
        _viewNavigation = [UIView new];
        _viewNavigation.backgroundColor = COLOR_GREEN_01;
    }
    return _viewNavigation;
}
- (UILabel *)labelTitle
{
    if (!_labelTitle) {
        _labelTitle = [UILabel new];
        _labelTitle.textAlignment = NSTextAlignmentCenter;
        _labelTitle.userInteractionEnabled = YES;
        _labelTitle.font = [UIFont systemFontOfSize:18];
        _labelTitle.textColor = [UIColor whiteColor];
        _labelTitle.adjustsFontSizeToFitWidth = YES;
    }
    return _labelTitle;
}
- (UIButton *)buttonLeft
{
    if (!_buttonLeft) {
        _buttonLeft = [UIButton new];
        _buttonLeft.contentMode =  UIViewContentModeScaleAspectFit;
    }
    return _buttonLeft;
}
- (UIButton *)buttonRight
{
    if (!_buttonRight) {
        _buttonRight = [UIButton new];
        _buttonRight.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _buttonRight.contentMode =  UIViewContentModeScaleAspectFit;
        _buttonRight.titleLabel.font = [UIFont systemFontOfSize:15];
        [_buttonRight setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _buttonRight;
}
- (UIView *)viewLine
{
    if (!_viewLine) {
        _viewLine = [UIView new];
        _viewLine.backgroundColor = [UIColor clearColor];
//        _viewLine.backgroundColor = RGB(230, 230, 230, 1);
    }
    return _viewLine;
}
@end
