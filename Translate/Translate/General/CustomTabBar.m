//
//  CustomTabBar.m
//  IScanner
//
//  Created by sihan on 2018/9/19.
//  Copyright © 2018年 sihan. All rights reserved.
//

#import "CustomTabBar.h"

@interface CustomTabBar ()

@property (nonatomic, strong) UIButton *centerBtn;
@end

@implementation CustomTabBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 设置tabBarItem选中状态时的颜色
//        self.tintColor = [UIColor redColor];
        // 添加中间按钮到tabBar上
//        [self addSubview:self.centerBtn];
    }
    
    return self;
}
//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    // 把 tabBarButton 取出来（把 tabBar 的 subViews 打印出来就明白了）
//    NSMutableArray *tabBarButtonArray = [NSMutableArray array];
//    for (UIView *view in self.subviews) {
//        if ([view isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
//            [tabBarButtonArray addObject:view];
//        }
//    }
//    
//    CGFloat barWidth = self.bounds.size.width;
//    CGFloat barHeight = self.bounds.size.height;
//    CGFloat centerBtnWidth = CGRectGetWidth(self.centerBtn.frame);
////    CGFloat centerBtnHeight = CGRectGetHeight(self.centerBtn.frame);
//    // 设置中间按钮的位置，居中，凸起一丢丢
//    self.centerBtn.center = CGPointMake(barWidth / 2, barHeight/2-(BOOL_IS_PHONEX?12:0));
//    // 重新布局其他 tabBarItem
//    // 平均分配其他 tabBarItem 的宽度
//    CGFloat barItemWidth = (barWidth - centerBtnWidth) / tabBarButtonArray.count;
//    // 逐个布局 tabBarItem，修改 UITabBarButton 的 frame
//    [tabBarButtonArray enumerateObjectsUsingBlock:^(UIView *  _Nonnull view, NSUInteger idx, BOOL * _Nonnull stop) {
//        
//        CGRect frame = view.frame;
//        if (idx >= tabBarButtonArray.count / 2) {
//            // 重新设置 x 坐标，如果排在中间按钮的右边需要加上中间按钮的宽度
//            frame.origin.x = idx * barItemWidth + centerBtnWidth;
//        } else {
//            frame.origin.x = idx * barItemWidth;
//        }
//        // 重新设置宽度
//        frame.size.width = barItemWidth;
//        view.frame = frame;
//    }];
//    // 把中间按钮带到视图最前面
//    [self bringSubviewToFront:self.centerBtn];
//    
//}
- (void)clickCenterBtn {
    [self.buttonActionSubject sendNext:nil];
}
#pragma mark - getters and setters
- (RACSubject *)buttonActionSubject {
    if (!_buttonActionSubject) {
        _buttonActionSubject = [RACSubject subject];
    }
    return _buttonActionSubject;
}
- (UIButton *)centerBtn
{
    if (!_centerBtn) {
        _centerBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 60)];
        [_centerBtn setImage:[UIImage imageNamed:@"tabbar_centerButton"] forState:UIControlStateNormal];
        [_centerBtn addTarget:self action:@selector(clickCenterBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _centerBtn;
}


@end
