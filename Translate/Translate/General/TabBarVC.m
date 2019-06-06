//
//  TabBarVC.m
//  IScanner
//
//  Created by sihan on 2018/9/18.
//  Copyright © 2018年 sihan. All rights reserved.
//

#import "TabBarVC.h"
//#import "HomeVC.h"
//#import "SettingVC.h"
//#import "CustomTabBar.h"
//#import "DictionaryVC.h"

@interface TabBarVC ()
@property (nonatomic,assign) NSInteger index;
//@property (nonatomic,strong) HomeVC * homeVC;
//@property (nonatomic,strong) UITabBar * tabbarEdit;
@end

@interface TabBarVC ()

@end

@implementation TabBarVC
#pragma mark - lif cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createTabBar];
    self.hidesBottomBarWhenPushed = YES;
    
    
}
- (void)createTabBar {
//    CustomTabBar * tabBar = [[CustomTabBar alloc] init];
//    @weakify(self);
//    [tabBar.buttonActionSubject subscribeNext:^(id x) {
//        @strongify(self);
//        NSLog(@"Center action");
//        [self.homeVC _captureAction];
//    }];
//    [self setValue:tabBar forKey:@"tabBar"];
//    HomeVC * homeVC = [HomeVC new];
//    self.homeVC = homeVC;
//    [self createControllerWithTitle:NSLocalizedString(@"Translation", nil)
//                              image:@"bar_translate"
//                      selectedimage:@"bar_translate_select"
//                          className:homeVC];
//
//    DictionaryVC * dictionaryVC = [DictionaryVC new];
//    [self createControllerWithTitle:NSLocalizedString(@"Dictionary", nil)
//                              image:@"bar_dictionary"
//                      selectedimage:@"bar_dictionary_select"
//                          className:dictionaryVC];
//    SettingVC * settingVC = [SettingVC new];
//    [self createControllerWithTitle:NSLocalizedString(@"Setting", nil)
//                              image:@"bar_set"
//                      selectedimage:@"bar_set_select"
//                          className:settingVC];
}

//提取公共方法
- (void)createControllerWithTitle:(NSString *)title
                            image:(NSString *)image
                    selectedimage:(NSString *)selectedimage
                        className:(UIViewController *)classVC {
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:classVC];
    nav.navigationBarHidden = YES;
    nav.tabBarItem.title = title;
    nav.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav.tabBarItem.selectedImage = [[UIImage imageNamed:selectedimage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    [self addChildViewController:nav];
    nav.tabBarController.tabBar.backgroundColor = [UIColor whiteColor];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:COLOR_GREEN_01
                                                       ,NSForegroundColorAttributeName
                                                       ,nil
                                                       ,nil]
                                             forState:UIControlStateSelected];
}

// 点击tabbarItem自动调用
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    NSInteger index = [self.tabBar.items indexOfObject:item];
    self.currentIndex = index;
//
//    if (index != _index) {
//        [self animationWithIndex:index];
//        _index = index;
//    }
    
    
//    if([item.title isEqualToString:@"发现"])
//    {
//        // 也可以判断标题,然后做自己想做的事
//    }
    
}
- (void)animationWithIndex:(NSInteger) index {
    NSMutableArray * tabbarbuttonArray = [NSMutableArray array];
    for (UIView *tabBarButton in self.tabBar.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [tabbarbuttonArray addObject:tabBarButton];
        }
    }
    /**
     CABasicAnimation类的使用方式就是基本的关键帧动画。
     
     所谓关键帧动画，就是将Layer的属性作为KeyPath来注册，指定动画的起始帧和结束帧，然后自动计算和实现中间的过渡动画的一种动画方式。
     */
    CABasicAnimation*pulse = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    
    pulse.timingFunction= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pulse.duration = 0.2;
    pulse.repeatCount= 1;
    pulse.autoreverses= YES;
    pulse.fromValue= [NSNumber numberWithFloat:0.9];
    pulse.toValue= [NSNumber numberWithFloat:1.2];
    [[tabbarbuttonArray[index] layer]
     addAnimation:pulse forKey:nil];
    
}
//- (UITabBar *)tabbarEdit {
//    if (!_tabbarEdit) {
//        _tabbarEdit = [[UITabBar alloc]init];
//        _tabbarEdit.delegate = self;
//        NSArray * arrayImage = @[@"tabbar_del"
//                                 ,@"tabbar_copy"
//                                 ,@"tabbar_pb_export"
//                                 ,@"tabbar_pb_moveGroup"];
//        NSArray * arrayTitle = @[
//                                 NSLocalizedString(@"Delete", nil)
//                                 ,NSLocalizedString(@"Copy", nil)
//                                 ,NSLocalizedString(@"Export", nil)
//                                 ,NSLocalizedString(@"Group", nil)
//                                 ];
//        NSMutableArray * arrayItem = [NSMutableArray new];
//        for (int i = 0; i<arrayImage.count; i++) {
//            UITabBarItem * item = [[UITabBarItem alloc]initWithTitle:arrayTitle[i] image:GET_IMAGE(arrayImage[i]) tag:i];
//            [arrayItem addObject:item];
//        }
//        _tabbarEdit.items = arrayItem;
//    }
//    return _tabbarEdit;
//}
@end
