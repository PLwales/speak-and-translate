//
//  FXWebView.m
//  FoxCard
//
//  Created by s w on 14-4-22.
//  Copyright (c) 2014年 Xiamen Worldscan Information Technology Co.,Ltd. All rights reserved.
//

#import "FXWebView.h"
#import "SVProgressHUD.h"
#import "MBProgressHUDCustom.h"
#define BTN_WIDTH           35
@implementation FXWebView

- (id)initWithFrame:(CGRect)frame
{
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        self.delegate = self;
        self.scalesPageToFit = YES;
        UIView *btnBackgroungView = [[UIView alloc]init];
        btnBackgroungView.frame = CGRectMake(self.frame.origin.x, self.frame.size.height-kHeightNavigationBar, self.frame.size.width, kHeightNavigationBar);
        self.btnBackgroungView = btnBackgroungView;
        btnBackgroungView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.btnBackgroungView];
        
        UIImage* imageBottom = GET_IMAGE(@"dibu.png");
        
        UIImageView * backgroundView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.btnBackgroungView.frame.size.width, self.btnBackgroungView.frame.size.height)];
        backgroundView.image = imageBottom;
        [self.btnBackgroungView addSubview:backgroundView];
        
        [self setGoBackBtn];
        [self setGoForwardBtn];
        [self setReturnBtn];
        
    }
    return self;
}

//前进按钮
- (void)setGoForwardBtn
{
    UIButton * goForwardBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [goForwardBtn setBackgroundImage:GET_IMAGE(@"qianjin.png") forState:UIControlStateNormal];
    [goForwardBtn setBackgroundImage:GET_IMAGE(@"qianjin_p.png") forState:UIControlStateHighlighted];
    goForwardBtn.frame = CGRectMake(WIDTH_SCREEN - 70, (kHeightNavigationBar-BTN_WIDTH)/2, BTN_WIDTH, BTN_WIDTH);
    [goForwardBtn addTarget:self action:@selector(goForwardBtnAction) forControlEvents:UIControlEventTouchUpInside];
    self.goForwardBtn = goForwardBtn;
    [self.btnBackgroungView addSubview:self.goForwardBtn];
}

- (void)goForwardBtnAction
{
    [self goForward];
}

//后退按钮
- (void)setGoBackBtn
{
    UIButton * goBackBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [goBackBtn setBackgroundImage:GET_IMAGE(@"fanhui.png") forState:UIControlStateNormal];
    [goBackBtn setBackgroundImage:GET_IMAGE(@"fanhui_p.png") forState:UIControlStateHighlighted];
    goBackBtn.frame = CGRectMake((WIDTH_SCREEN-BTN_WIDTH)/2, (kHeightNavigationBar-BTN_WIDTH)/2, BTN_WIDTH, BTN_WIDTH);
    [goBackBtn addTarget:self action:@selector(goBackBtnAction) forControlEvents:UIControlEventTouchUpInside];
    self.goBackBtn = goBackBtn;
    [self.btnBackgroungView addSubview:self.goBackBtn];
}

- (void)goBackBtnAction
{
    [self goBack];
}

//返回按钮
- (void)setReturnBtn
{
    UIButton * returnBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    NSString * backString = NSLocalizedString(@"Back", nil) ;
//    CGSize size = [backString sizeWithFont:[UIFont systemFontOfSize:15]];
    CGSize size = [backString sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    [returnBtn setTitle:backString forState:UIControlStateNormal];
    [returnBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    returnBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    returnBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    returnBtn.frame = CGRectMake(20, (self.btnBackgroungView.frame.size.height-30)/2, size.width, 30);
    [returnBtn addTarget:self action:@selector(retutnBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.btnBackgroungView addSubview:returnBtn];
    
}

- (void)retutnBtnAction
{
   
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    [SVProgressHUD dismiss];
   
    [self removeFromSuperview];
    
}

#define delegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [SVProgressHUD showWithStatus:NSLocalizedString(@"loading", nil) maskType:SVProgressHUDMaskTypeNone];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, kHeightNavigationBar-2, 0);
    [SVProgressHUD dismiss];
    self.goForwardBtn.enabled = self.canGoForward;
    
    self.goBackBtn.enabled = self.canGoBack;
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [MBProgressHUDCustom showError:NSLocalizedString(@"load failed", nil)  toView:self];
//    [SVProgressHUD dismissWithError:NSLocalizedString(@"load failed", nil) afterDelay:1];
    self.goForwardBtn.enabled = self.canGoForward;
    
    self.goBackBtn.enabled = self.canGoBack;
}

#pragma mark 改变状态栏颜色
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (BOOL)prefersStatusBarHidden
{
    return YES; //返回NO表示要显示，返回YES将hiden
}
//旋转
- (BOOL)shouldAutorotate
{
    return NO;
}
-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
@end
