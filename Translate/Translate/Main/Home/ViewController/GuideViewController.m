//
//  GuideViewController.m
//  FoxCard
//
//  Created by sihan on 2017/11/29.
//  Copyright © 2017年 Xiamen Worldscan Information Technology Co.,Ltd. All rights reserved.
//

#import "GuideViewController.h"
#import "MBProgressHUD.h"
#import "FXWebView.h"
#import "Reachability.h"

@interface GuideViewController ()<UIScrollViewDelegate>
@property (nonatomic, retain)UIScrollView *scrollView;
@property (nonatomic, retain)UIPageControl * pageControl;
@property (nonatomic, retain)UIButton * buttonBottom;
@property (nonatomic, retain)UIScrollView * scrollViewBg;
//购买信息-隐私协议、价格
//@property (nonatomic, retain)UILabel * labelBuyInfo;
//是否恢复过2次
@property (nonatomic, assign) BOOL isRestored;
//恢复失败则购买
@property (nonatomic, assign) BOOL isRestoredDefailWillBuy;

@end

@implementation GuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self _initView];


}
- (void)_initView
{
    NSArray * arrayImage = @[//@"guide_1"
                             @"guide_2"
                             ,@"guide_3"
                             ];
    NSArray * arrayTitle = @[//NSLocalizedString(@"Easy switching on multiple platforms", nil)
                             NSLocalizedString(@"Two authoritative dictionaries", nil)
                             ,NSLocalizedString(@"Multilingual dialogue translation", nil)
                             ];
    NSArray * arrayDetail = @[//NSLocalizedString(@"BaiDu YouDao Google", nil)
                              NSLocalizedString(@"Support multi-language, voice input, free hands", nil)
                              ,NSLocalizedString(@"Standard pronunciation, example interpretation, remember to be more secure", nil)
                              ];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, HEIGHT_SCREEN)];
    scrollView.delegate = self;
    [scrollView setContentSize:CGSizeMake(WIDTH_SCREEN*arrayImage.count, 0)];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.bounces = NO;
    scrollView.backgroundColor = [UIColor whiteColor];
    [scrollView setPagingEnabled:YES];
    self.scrollView = scrollView;
    [self.view addSubview:scrollView];
    
    CGFloat kHeightImage = HEIGHT_SCREEN/2*1.19;
    CGFloat kHeightImageVSpace = kHeightImage/22;
    
    CGFloat kHeightPageControlSpace = BOOL_IS_PHONEX?30:25;
    CGFloat kHeightButton = 45;
    CGFloat kWidthButton = WIDTH_SCREEN/2*1.3;
    for (int i=0; i<arrayImage.count; i++)
    {
        CGFloat kWidthScreenSpace = WIDTH_SCREEN*i;
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(kWidthScreenSpace, kHeightImageVSpace, WIDTH_SCREEN, kHeightImage)];
//        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(kWidthScreenSpace, 0, WIDTH_SCREEN, HEIGHT_SCREEN)];
        imageView.userInteractionEnabled = YES;
        imageView.contentMode = UIViewContentModeCenter;
        imageView.image = GET_IMAGE(arrayImage[i]);
        
        
        UILabel * labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(20+kWidthScreenSpace, CGRectGetMaxY(imageView.frame)+kHeightImageVSpace, WIDTH_SCREEN-40, HEIGHT_SCREEN/4.8)];
        labelTitle.font = [UIFont systemFontOfSize:15];
        labelTitle.numberOfLines = 0;
        labelTitle.textColor = [UIColor grayColor];
        labelTitle.textAlignment = NSTextAlignmentCenter;
        labelTitle.adjustsFontSizeToFitWidth = YES;
        NSDictionary *dic = @{NSKernAttributeName:@1.2f};
        NSString * titleInfoStr = [NSString stringWithFormat:@"%@\n%@",arrayTitle[i],arrayDetail[i]];
        NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:titleInfoStr attributes:dic];
        NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:6];//行间距
        paragraphStyle.alignment = NSTextAlignmentCenter;
        NSRange range = NSMakeRange(0, [arrayTitle[i] length]);
        [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:30] range:range];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:range];
        [labelTitle setAttributedText:attributedString];
        
        if (i == arrayImage.count-1)
        {
            CGFloat kHeightlabelTitleBottom = CGRectGetMaxY(labelTitle.frame);
            CGFloat kHeightButtonBottomSpace = HEIGHT_SCREEN-kHeightButton-kHeightGetNavStatusPhoneX-kHeightPageControlSpace;
            kHeightButtonBottomSpace = kHeightlabelTitleBottom>kHeightButtonBottomSpace?kHeightlabelTitleBottom:kHeightButtonBottomSpace;
            UIButton * buttonBottom = [[UIButton alloc]initWithFrame:CGRectMake(kWidthScreenSpace+(WIDTH_SCREEN-kWidthButton)/2, kHeightButtonBottomSpace, kWidthButton, kHeightButton)];
            buttonBottom.tag = i;
            buttonBottom.clipsToBounds = YES;
            buttonBottom.layer.cornerRadius = kHeightButton/2;
            buttonBottom.titleLabel.adjustsFontSizeToFitWidth = YES;
            buttonBottom.titleLabel.numberOfLines = 0;
            buttonBottom.titleLabel.font = [UIFont systemFontOfSize:18];
            buttonBottom.backgroundColor = COLOR_GREEN_01;
            [buttonBottom setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [buttonBottom setTitle:NSLocalizedString(@"Experience now", nil) forState:UIControlStateNormal];
            [buttonBottom addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
            [scrollView addSubview:buttonBottom];
        }
        else
        {
//            [buttonBottom setTitle:NSLocalizedString(@"Next", nil) forState:UIControlStateNormal];
//            [buttonBottom addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        [scrollView addSubview:imageView];
        [scrollView addSubview:labelTitle];
    }
    
    UIPageControl * pageControl = [[UIPageControl alloc] init];
    pageControl.frame = CGRectMake((WIDTH_SCREEN-100)/2, HEIGHT_SCREEN-kHeightPageControlSpace, 100, 20);//指定位置大小
    pageControl.numberOfPages = arrayImage.count;//指定页面个数
    pageControl.currentPage = 0;//指定pagecontroll的值，默认选中的小白点（第一个）
    //添加委托方法，当点击小白点就执行此方法
    // 设置非选中页的圆点颜色
    pageControl.pageIndicatorTintColor = COLOR_HEX_A(@"535353", 0.5);
    // 设置选中页的圆点颜色
    pageControl.currentPageIndicatorTintColor = COLOR_HEX(@"535353");
    self.pageControl = pageControl;
    [self.view addSubview:pageControl];
}

// scrollview滚动的时候调用
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
 //    计算页码
     CGFloat scrollviewW =  scrollView.frame.size.width;
     CGFloat x = scrollView.contentOffset.x;
     int page = (x + scrollviewW / 2) /  scrollviewW;
     self.pageControl.currentPage = page;
 }
- (void)buySuccess
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        //scrollview 在最后一个页面才会返回主页
        if (self.pageControl.currentPage == 3)
        {
            [self cancelAction];
        }
 });
}
- (void)buyNowAction
{
    [self cancelAction];
}
- (void)nextAction:(UIButton *)btn
{
    [UIView animateWithDuration:0.3 animations:^{
        self.scrollView.contentOffset = CGPointMake(WIDTH_SCREEN*(btn.tag+1), self.scrollView.contentOffset.y);
    }];
}
- (void)cancelAction
{
    [self.navigationController popViewControllerAnimated:YES];
    [self.delegate _GuideViewControllerDelegate_cancel];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
