//
//  AppDelegate.m
//  Translate
//
//  Created by sihao99 on 2019/5/27.
//  Copyright © 2019 SiHan. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeVC.h"
#import "DBManager.h"
#import "GuideViewController.h"
@interface AppDelegate ()<GuideViewControllerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
 
    [[DBManager shareSingleton].g_sqlite openDatabase:kStringDBName];
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self _initDefault];
    [self initRootView];
    [self.window makeKeyAndVisible];

    return YES;
}
-(void)_initDefault
{
    [[Comn gb] _addLoadAppCount];  //启动app次数加1
    if ([[Comn gb]_getLoadAppCount]==1) {
         self.isFirstLoad = YES;
        [LWUserDefaults setInteger:1 forKey:ISKeyTanslateDictionaryLanguageFrom];
        [LWUserDefaults setInteger:2 forKey:ISKeyTanslateDictionaryLanguageTo];
        NSArray *arr =@[@"1",@"2"];
        [LWUserDefaults setObject:arr forKey:ISKeyTanslateLanguageRecentlyUsed];
        [LWUserDefaults setInteger:0 forKey:ISKeyBootViewHistory]; 
        [LWUserDefaults setInteger:0 forKey:ISKeyBootViewTextTranslate];
        [LWUserDefaults synchronize];
    }
  
}

-(void)initRootView
{
    if (self.isFirstLoad)
    {
        GuideViewController * guideVC = [GuideViewController new];
        guideVC.delegate = self;
        UINavigationController * navigationController = [[UINavigationController alloc] initWithRootViewController:guideVC];
        navigationController.navigationBarHidden = YES;
        _window.rootViewController = navigationController;
    }
    else
    {
        [self _initHomeVC];
    }
}
- (void)_initHomeVC
{
    HomeVC *vc = [[HomeVC alloc]init];
    self.window.rootViewController = vc;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark - GuideViewControllerDelegate
- (void)_GuideViewControllerDelegate_cancel
{
    [self _initHomeVC];
}
- (void)_GuideViewControllerDelegate_buyAction
{
    //    [self.fxHomeVc btnBuyNewAction];
}

@end
