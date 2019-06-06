//
//  EvaluationView.m
//  SamCard
//
//  Created by sihan on 2018/4/25.
//  Copyright © 2018年 Xiamen Worldscan Information Technology Co.,Ltd. All rights reserved.
//

#import "EvaluationView.h"
//获取图片
#define GET_IMAGE(__NAME__,__TYPE__)    [UIImage imageNamed:__NAME__]
#define COLOR_HEX(_HEX_) [UIColor colorWithHexString:_HEX_]
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
//a是透明度
#define COLOR_HEX_A(_HEX_,_A_) [UIColor colorWithHexString:_HEX_ alpha:_A_]
NSString *const kImageButtonCancel = @"evaluationView_cancel";
NSString *const kImageViewMedals = @"evaluationView_medals";
NSString *const kImageButtonStarNor = @"evaluationView_star_nor";
NSString *const kImageButtonStarNorSelect = @"evaluationView_star_select";
NSString *const kStringSend = @"send";
NSString *const kStringTip = @"How many stars would you give it?";

@interface EvaluationView ()
@property (nonatomic, retain) NSMutableArray * arrayStar;
@property (nonatomic, assign) NSInteger kIntStarCount;
@property (nonatomic,assign) id <EvaluationViewProtocol> evaluationViewProtocol;
@end
@implementation EvaluationView

- (id)initWithAlertTitle:(NSString *)title
                  delegate:(id)delegate
{
    
    if (self = [super init])
    {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.evaluationViewProtocol = delegate;
        //默认星星数
        self.kIntStarCount = 5;
        [self _initViewWithTitle:title];
        [self _setStarSelectWithNumber:self.kIntStarCount];
    }
    return self;
}
- (void)_initViewWithTitle:(NSString *)title
{
    UIView * viewGray = [[UIView alloc]initWithFrame:self.frame];
    viewGray.backgroundColor = COLOR_HEX_A(@"#000000", 0.6);
    [self addSubview:viewGray];
    
    CGFloat kWidthWhiteView = 500.0/750*SCREEN_WIDTH;
    kWidthWhiteView = kWidthWhiteView>400?400:kWidthWhiteView;
    CGFloat kHeightWhiteView = 540.0/500*kWidthWhiteView;
    
    //白色背景
    UIView * viewWhite = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-kWidthWhiteView)/2, (SCREEN_HEIGHT-kHeightWhiteView)/2, kWidthWhiteView, kHeightWhiteView)];
    viewWhite.clipsToBounds = YES;
    viewWhite.backgroundColor = COLOR_HEX(@"#ffffff");
    viewWhite.layer.cornerRadius = 10;
    [viewGray addSubview:viewWhite];
    
    //取消按钮
    CGFloat kWidthOrHeightButtonCancel = 35;
    UIButton * buttonCancel = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(viewWhite.frame)-kWidthOrHeightButtonCancel/2, viewWhite.frame.origin.y-kWidthOrHeightButtonCancel/2, kWidthOrHeightButtonCancel, kWidthOrHeightButtonCancel)];
    [buttonCancel setImage:GET_IMAGE(kImageButtonCancel, nil) forState:UIControlStateNormal];
    [buttonCancel addTarget:self action:@selector(singleTap) forControlEvents:UIControlEventTouchUpInside];
    [viewGray addSubview:buttonCancel];
    
    //奖牌
    CGFloat kHeightViewMedals = 230.0/540*kHeightWhiteView;
    CGFloat kWidthViewMedals = 140.0/203.0*kHeightViewMedals;
    UIImageView * imageViewMedals = [[UIImageView alloc]initWithFrame:CGRectMake((kWidthWhiteView-kWidthViewMedals)/2, 0, kWidthViewMedals, kHeightViewMedals)];
    imageViewMedals.image = GET_IMAGE(kImageViewMedals, nil);
    [viewWhite addSubview:imageViewMedals];
    
    //标题
    UILabel * labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(imageViewMedals.frame)+10, kWidthWhiteView-20, 20)];
    labelTitle.text = title;
    labelTitle.adjustsFontSizeToFitWidth = YES;
    labelTitle.numberOfLines = 0;
    labelTitle.textAlignment = NSTextAlignmentCenter;
    labelTitle.font = [UIFont systemFontOfSize:18];
    labelTitle.textColor = COLOR_HEX(@"#1d504f");
    [viewWhite addSubview:labelTitle];
    
    
    CGFloat kWidthOrHeightStar = 54.0/540*kHeightWhiteView;
    CGFloat kWidthStarSpace = 2;
    //第一个星星的x
    CGFloat kWidthButtonStarSpace = (kWidthWhiteView-kWidthOrHeightStar*5-kWidthStarSpace*4)/2;
    CGFloat kHeightHuttonStarSpace = 25.0/540*kHeightWhiteView;
    for (int i = 0; i<5; i++)
    {
        UIButton * buttonStar = [[UIButton alloc]initWithFrame:CGRectMake(kWidthButtonStarSpace+i*(kWidthStarSpace+kWidthOrHeightStar), CGRectGetMaxY(labelTitle.frame)+kHeightHuttonStarSpace, kWidthOrHeightStar, kWidthOrHeightStar)];
        buttonStar.tag = i;
        [buttonStar addTarget:self action:@selector(buttonStarAction:) forControlEvents:UIControlEventTouchUpInside];
        [buttonStar setImage:GET_IMAGE(kImageButtonStarNor, nil) forState:UIControlStateNormal];
        [buttonStar setImage:GET_IMAGE(kImageButtonStarNorSelect, nil) forState:UIControlStateSelected];
        buttonStar.selected = YES;
        [viewWhite addSubview:buttonStar];
        [self.arrayStar addObject:buttonStar];
    }
    
    
    CGFloat kHeightButtonSend = 60.0/540*kHeightWhiteView;
    CGFloat kHeightButtonSendBottomSpace = 30.0/540*kHeightWhiteView;
    CGFloat kHeightButtonSendSpace = kHeightWhiteView-kHeightButtonSendBottomSpace-kHeightButtonSend;
    UILabel * labelTip = [[UILabel alloc]initWithFrame:CGRectMake(10, kHeightButtonSendSpace-30, kWidthWhiteView-20, 20)];
    labelTip.text = title;
    labelTip.adjustsFontSizeToFitWidth = YES;
    labelTip.text = NSLocalizedString(kStringTip, nil);
    labelTip.numberOfLines = 0;
    labelTip.textAlignment = NSTextAlignmentCenter;
    labelTip.font = [UIFont systemFontOfSize:12];
    labelTip.textColor = COLOR_HEX(@"#666666");
    [viewWhite addSubview:labelTip];
    
    CGFloat kWidthButtonSend = 160.0/500*kWidthWhiteView;
    UIButton * buttonSend = [[UIButton alloc]initWithFrame:CGRectMake((kWidthWhiteView-kWidthButtonSend)/2, kHeightWhiteView-15-kHeightButtonSend, kWidthButtonSend, kHeightButtonSend)];
    buttonSend.clipsToBounds = YES;
    buttonSend.backgroundColor = LWRGB16Color(0x1b82d1, 1);
    buttonSend.layer.cornerRadius = 5;
    [buttonSend addTarget:self action:@selector(buttonSendAction) forControlEvents:UIControlEventTouchUpInside];
    [buttonSend setTitleColor:COLOR_HEX(@"#ffffff") forState:UIControlStateNormal];
    [buttonSend setTitle:NSLocalizedString(kStringSend, nil) forState:UIControlStateNormal];
    [viewWhite addSubview:buttonSend];
}
- (void)buttonStarAction:(UIButton *)btn
{
    [self _setStarSelectWithNumber:btn.tag];
    self.kIntStarCount = btn.tag+1;
}
- (void)buttonSendAction
{
    if ([self.evaluationViewProtocol respondsToSelector:@selector(_evaluationViewProtocolButtonSendIsSend:)])
    {
        [self.evaluationViewProtocol _evaluationViewProtocolButtonSendIsSend:self.kIntStarCount>3];
    }
    [self removeFromSuperview];
}
- (void)_setStarSelectWithNumber:(NSInteger)number
{
    for (int i = 0; i<self.arrayStar.count; i++)
    {
        UIButton * buttonStar = self.arrayStar[i];
        buttonStar.selected = i<=number;
    }
}
- (void)singleTap
{
    [self removeFromSuperview];
}
- (NSMutableArray *)arrayStar
{
    if (!_arrayStar) {
        _arrayStar = [NSMutableArray new];
    }
    return _arrayStar;
}
@end
