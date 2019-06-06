//
//  Comn.m
//  ScanPlant
//
//  Created by sihan on 2018/7/9.
//  Copyright © 2018年 sihan. All rights reserved.
//

#import "Comn.h"
#import "sys/utsname.h"
#import "AppDelegate.h"
//#import "FXUIImageCategory.h"
#import <MessageUI/MessageUI.h>
#import "MBProgressHUDCustom.h"
#include <sys/types.h>
#include <sys/sysctl.h>
#import <StoreKit/StoreKit.h>
//#import "AdGrayView.h"
//#import "RequestApiManage.h"
#import <CommonCrypto/CommonDigest.h>
#import "Reachability.h"
#import <AVFoundation/AVFoundation.h>
#import <Speech/Speech.h>
@interface Comn ()<MFMailComposeViewControllerDelegate,SKStoreProductViewControllerDelegate>
@end
@implementation Comn
+(Comn *)gb
{
    static Comn * mySingleton = nil;
    @synchronized(self)
    {
        if (mySingleton == nil)
        {
            mySingleton = [[Comn alloc]init];
        }
    }
    return mySingleton;
}
- (id)init {
    
    if(self = [super init])
    {
    }
    return self;
}
- (void)_shareWithTitle:(NSString *)titlw
                  image:(UIImage *)image
{
    //分享的标题
    NSString *textToShare = titlw;
    //分享的图片
    UIImage *imageToShare = image;
    //分享的url
    NSURL *urlToShare = [NSURL URLWithString:@"https://itunes.apple.com/cn/app/%E7%BF%BB%E8%AF%91%E5%A4%A7%E5%85%A8-itranslate%E6%97%85%E8%A1%8C%E7%BF%BB%E8%AF%91%E5%AE%98/id1443689958?mt=8"];
    //在这里呢 如果想分享图片 就把图片添加进去  文字什么的通上
    NSArray *activityItems = @[textToShare,imageToShare,urlToShare];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
    //不出现在活动项目
    activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard,UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll];
    [[self topViewController] presentViewController:activityVC animated:YES completion:nil];
    // 分享之后的回调
    activityVC.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
        if (completed) {
            NSLog(@"completed");
            //分享 成功
        } else  {
            NSLog(@"cancled");
            //分享 取消
        }
    };
}
- (NSString*)deviceVersion
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString * deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    //iPhone
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    
    if ([deviceString isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    if ([deviceString isEqualToString:@"iPhone9,1"])    return @"iPhone 7";
    if ([deviceString isEqualToString:@"iPhone9,3"])    return @"iPhone 7";
    if ([deviceString isEqualToString:@"iPhone9,2"])    return @"iPhone 7P";
    if ([deviceString isEqualToString:@"iPhone9,4"])    return @"iPhone 7P";
    
    if ([deviceString isEqualToString:@"iPhone10,1"])    return @"iPhone 8";
    if ([deviceString isEqualToString:@"iPhone10,4"])    return @"iPhone 8";
    if ([deviceString isEqualToString:@"iPhone10,2"])    return @"iPhone 8P";
    if ([deviceString isEqualToString:@"iPhone10,5"])    return @"iPhone 8P";
    
    if ([deviceString isEqualToString:@"iPhone10,3"])    return @"iPhone X";
    if ([deviceString isEqualToString:@"iPhone10,6"])    return @"iPhone X";
    return deviceString;
}
- (NSString *)_getFilePath:(NSString *)fileName fileType:(NSString*)fileType
{
//    if (fileName.length == 0 || !fileType) {
//        return nil;
//    }
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *FilePath = [documentsDirectory stringByAppendingString:kStringDirectoryDataName];
    if (fileType && fileType.length>0) {
        FilePath = [FilePath stringByAppendingString:fileType];
        FilePath = [FilePath stringByAppendingString:@"/"];
    }
    return [FilePath stringByAppendingString:fileName];
}
- (BOOL)writeImgToFile:(NSString *)NewFileName image:(UIImage*)image quality:(CGFloat)Quality {
    if (!NewFileName || !image) {
        return NO;
    }
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask, YES);
    NSString *uniquePath=[[paths objectAtIndex:0] stringByAppendingPathComponent:kStringDirectoryDataName];
    uniquePath = [uniquePath stringByAppendingString:@"/"];
    uniquePath = [uniquePath stringByAppendingString:NewFileName];
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:uniquePath];
    if (blHave) {
        return NO;
    }
    NSData *data = UIImageJPEGRepresentation(image, Quality);
    BOOL result = [data writeToFile:uniquePath atomically:YES];
    if (!result) {
        return NO;
    }
    return YES;
}
//创建文件夹
- (BOOL)_createPath:(NSString *)fileName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    if (!documentDirectory)
    {
        return NO;
    }
    NSString *FilePath = [[documentDirectory stringByAppendingString:kStringDirectoryDataName] stringByAppendingString:fileName];
    if ([[NSFileManager defaultManager]fileExistsAtPath:FilePath])
    {
        return YES;
    }
    [fileManager createDirectoryAtPath:FilePath withIntermediateDirectories:YES attributes:nil error:nil];
    if ([fileManager fileExistsAtPath:FilePath])
    {
        return YES;
    }
    return NO;
}
//获取本地图片
- (UIImage *)_getLocalImageWithFileName:(NSString *)fileName {
    NSString *imgPath = [[Comn gb] _getFilePath:fileName fileType:nil];
    UIImage * localImage = [[UIImage alloc]initWithContentsOfFile:imgPath];
    return  localImage;
}

- (BOOL)_removeImageAtPath:(NSString *)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        BOOL success = [fileManager removeItemAtPath:path error:&error];
        if (!success) {
            NSLog(@"%@",[error localizedDescription]);
        }
        return success;
    }
    return NO;
}
- (NSString *)_generateUuidString
{
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    NSString *uuidString = (NSString *)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, uuid));
    CFRelease(uuid);
    return uuidString;
}
//打开设置里相应的权限页面
- (void)_openPermissionsAlertView:(TypeSettingSysPermissions)typeSettingSysPermissions
{
    NSString * title;
    NSString * urlString;
    switch (typeSettingSysPermissions) {
        case TypeSettingSysPermissionsPhotos:
        {
            title = [NSString stringWithFormat:NSLocalizedString(@"Inaccessible to album.Please open the Settings -> Privacy -> Photos->WorldScan.", nil),NSLocalizedString(@"AppName", nil)];
            urlString = @"root=Privacy&path=PHOTOS";
        }
            break;
        case TypeSettingSysPermissionsCamera:
        {
            title = NSLocalizedString(@"user denied access request", nil);
            urlString = @"root=Privacy&path=CAMERA";
        }
            break;
        case TypeSettingSysPermissionsLocation:
        {
            
            title = NSLocalizedString(@"Location on", nil);
            urlString = @"root=LOCATION_SERVICES";
        }
        default:
            break;
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    // Create the actions.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }];
//    [cancelAction setValue:COLOR_GREEN_08 forKey:@"_titleTextColor"];
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//        NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
        // iOS10 以前
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"prefs:%@",urlString]] options:@{} completionHandler:nil];
        } else {
            // iOS10 以后
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            [[UIApplication sharedApplication]openURL:url];
        }
    }];
//    [otherAction setValue:COLOR_GREEN_08 forKey:@"_titleTextColor"];
    
    // Add the actions.
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    
    [[self topViewController] presentViewController:alertController animated:YES completion:nil];
}
//获取最顶层视图
- (UIViewController*)topViewController
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    return [self topViewControllerWithRootViewController:appDelegate.window.rootViewController];
}

- (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController
{
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarController = (UITabBarController *)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
    } else {
        return rootViewController;
    }
}
- (NSString *)getCurrentTime
{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%ld", (long int)a];
    return timeString;
}
//根据时间戳转换成时间
- (NSString *)_getTimeWithString:(NSString *)string
{
    // iOS 生成的时间戳是10位
    NSTimeInterval interval    = [string doubleValue];
    NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString       = [formatter stringFromDate: date];
    return dateString;
}
//评价
-(void)evaluate:(NSInteger)appId {
    if (IS_IOS11_MINI) {
        NSString *itunesurl = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/cn/app/id%ld?mt=8&action=write-review",(long)appId];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:itunesurl]];
    }
    else {
        NSString *str =  [NSString stringWithFormat:@"%@%ld",_LINK_BUY_,(long)appId];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
}
//显示系统评价框
- (void)_showSysReview {
    
    //弹出评论
    if ([Comn gb].isSysReviewShow) {
        if (@available(iOS 10.3, *)) {
            if([SKStoreReviewController respondsToSelector:@selector(requestReview)]) {
                //防止键盘遮挡
                [[UIApplication sharedApplication].keyWindow endEditing:YES];
                [SKStoreReviewController requestReview];
                [Comn gb].isSysReviewShow = NO;
                
            }
        } else {
            // Fallback on earlier versions
        }
    }
}
- (void)showAppInApp:(NSString *)_appId {
    
    //获取到的是appid还是链接
    NSRange range = [_appId rangeOfString:@"http"];
    if (range.location!=NSNotFound) {
        NSURL *url = [NSURL URLWithString:_appId];
        [[UIApplication sharedApplication] openURL:url];
    } else {
        NSString * stringCT;
        stringCT = @"Translation";
        Class isAllow = NSClassFromString(@"SKStoreProductViewController");
        if (isAllow != nil) {
            SKStoreProductViewController *sKStoreProductViewController = [[SKStoreProductViewController alloc] init];
            sKStoreProductViewController.delegate = self;
            [sKStoreProductViewController loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier: _appId,
                                                                      SKStoreProductParameterProviderToken:@"584477",
                                                                      SKStoreProductParameterCampaignToken:stringCT
                                                                      }
                                                    completionBlock:^(BOOL result, NSError *error) {
                                                        if (result) {
                                                            [[[Comn gb] topViewController] presentViewController:sKStoreProductViewController
                                                                                                        animated:YES
                                                                                                      completion:nil];
                                                        }
                                                        else{
                                                            NSLog(@"%@",error);
                                                        }
                                                    }];
        }
        else{
            //低于iOS6没有这个类
            NSString *string = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/us/app/id%@?mt=8",_appId];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];
        }
    }
}
#pragma mark - SKStoreProductViewControllerDelegate
//对视图消失的处理
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController {
    [viewController dismissViewControllerAnimated:YES
                                       completion:nil];
    
}
- (void)_setIsLimit:(BOOL)isLimit {
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    [userdefaults setBool:isLimit forKey:@"isLimit"];
    [userdefaults synchronize];
}
- (void)_getIsLimit {
    [Comn gb].isLimit = [[NSUserDefaults standardUserDefaults] boolForKey:@"isLimit"];
}
- (void)_getIsBuy {
    [Comn gb].isBuy = [[NSUserDefaults standardUserDefaults] boolForKey:@"isBuy"];
}
- (void)_setIsBuy:(BOOL)isBuy {
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    [userdefaults setBool:isBuy forKey:@"isBuy"];
    [userdefaults synchronize];
    [Comn gb].isBuy = YES;
}
//启动app次数
- (NSInteger)_getLoadAppCount {
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"loadAppCount"];
}
- (void)_addLoadAppCount {
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    [userdefaults setInteger:([[Comn gb] _getLoadAppCount]+1) forKey:@"loadAppCount"];
    [userdefaults synchronize];
}
//弹出广告
- (NSInteger)_getShowLimitAd {
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"showLimitAd"];
}
- (void)_setShowLimitAd:(NSInteger)count {
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    [userdefaults setInteger:count forKey:@"showLimitAd"];
    [userdefaults synchronize];
}
- (void)_setAddShowLimitCount {
    NSInteger currentCount = [[Comn gb] _getShowLimitAd];
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    if (currentCount == 0) {
        [userdefaults setInteger:3 forKey:@"showLimitAd"];
    } else {
        [userdefaults setInteger:(currentCount-1) forKey:@"showLimitAd"];
    }
    [userdefaults synchronize];
}
//弹出评论
- (void)_addEvaluationCount {
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    [userdefaults setInteger:[userdefaults integerForKey:KEY_SHOW_MARK_NUM]+1 forKey:KEY_SHOW_MARK_NUM];
    [userdefaults synchronize];
    
}
- (BOOL)_getCountIsEvaluation {
    return [[[NSUserDefaults standardUserDefaults] objectForKey:KEY_SHOW_MARK_NUM] integerValue]%3==0;
}
- (void)_setEvaluation:(BOOL)isEvaluation {
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setBool:isEvaluation forKey:KEY_ISREVIEW];
    [userDefault synchronize];
}
- (BOOL)_getIsEvaluation {
    return [[NSUserDefaults standardUserDefaults] boolForKey:KEY_ISREVIEW];
}
//处理图片符合百度标准
- (UIImage *)_getProcessImage:(UIImage *)image {
    UIImage* smallImage = [image fixOrientation];
    CGFloat kWidthOrHeightMax = 1800.0;
    if (smallImage.size.width>kWidthOrHeightMax || smallImage.size.height>kWidthOrHeightMax) {
        CGFloat kHeight;
        CGFloat kWidth;
        if (smallImage.size.width>smallImage.size.height) {
            kWidth = kWidthOrHeightMax;
            kHeight = kWidthOrHeightMax/smallImage.size.width*smallImage.size.height;
        } else {
            kHeight = kWidthOrHeightMax;
            kWidth = kWidthOrHeightMax/smallImage.size.height*smallImage.size.width;
        }
//        smallImage = [smallImage scaleToSize:CGSizeMake(kWidth, kHeight)];
        smallImage = [smallImage imageCompressForWidth:smallImage targetWidth:kWidth];
    }
    NSData *data = UIImageJPEGRepresentation(smallImage, 1);
    if (data.length > 2800000) {
        NSData *dataImage = UIImageJPEGRepresentation(smallImage, 0.6);
        UIImage * imageNew = [UIImage imageWithData:dataImage];
        return imageNew;
    }
    return smallImage;
}

- (void)showPicker:(NSString *)addressee withObject:(NSString *)object andWithBody:(NSString *)body {
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (mailClass != nil) {
        if ([mailClass canSendMail]) {
            [self displayComposerSheet:addressee withObject:object andWithBody:body];
        }
        else {
            [self launchMailAppOnDevice];
        }
    }
    else {
        [self launchMailAppOnDevice];
    }
}
-(void)displayComposerSheet:(NSString *)addressee withObject:(NSString *)object andWithBody:(NSString *)body {
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (mailClass != nil) {
        if ([MFMailComposeViewController canSendMail])  {
            MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
            picker.mailComposeDelegate = self;
            [picker setSubject:object];
            NSArray *toRecipients = [NSArray arrayWithObject:addressee];
            NSArray *ccRecipients = [NSArray arrayWithObject:@""];
            
            [picker setToRecipients:toRecipients];
            [picker setCcRecipients:ccRecipients];
            
            
            NSString *emailBody = body;
            [picker setMessageBody:emailBody isHTML:NO];
            
            [[self topViewController]  presentViewController:picker animated:YES completion:nil];
        }
        else {
            [self launchMailAppOnDevice];
        }
    }
    else{
        [self launchMailAppOnDevice];
    }
}
- (void)launchMailAppOnDevice {
    NSString *recipients = @"mailto:first@example.com?cc=second@example.com,third@example.com&subject=Hello from California!";
    NSString *body = @"&body=It is raining in sunny California!";
    NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
    email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    switch (result) {
        case MFMailComposeResultCancelled:
            //@"邮件发送取消";
            break;
        case MFMailComposeResultSaved:
            [MBProgressHUDCustom showSuccess:NSLocalizedString(@"save success", nil)];
            break;
        case MFMailComposeResultSent:
            [MBProgressHUDCustom showSuccess:NSLocalizedString(@"send success", nil)];
            break;
        case MFMailComposeResultFailed:
            [MBProgressHUDCustom showError:NSLocalizedString(@"send failure", nil)];
            break;
        default:
            break;
    }
    [[self topViewController] dismissViewControllerAnimated:YES completion:nil];
}
- (NSString *)getCurrentDeviceModel
{
    int mib[2];
    size_t len;
    char *machine;
    
    mib[0] = CTL_HW;
    mib[1] = HW_MACHINE;
    sysctl(mib, 2, NULL, &len, NULL, 0);
    machine = malloc(len);
    sysctl(mib, 2, machine, &len, NULL, 0);
    
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 plus";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6S";
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6S plus";
    if ([platform isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    // 日行两款手机型号均为日本独占，可能使用索尼FeliCa支付方案而不是苹果支付
    if ([platform isEqualToString:@"iPhone9,1"])    return @"iPhone 7";
    if ([platform isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus";
    if ([platform isEqualToString:@"iPhone9,3"])    return @"iPhone 7";
    if ([platform isEqualToString:@"iPhone9,4"])    return @"iPhone 7 Plus";
    if ([platform isEqualToString:@"iPhone10,1"])   return @"iPhone 8";
    if ([platform isEqualToString:@"iPhone10,4"])   return @"iPhone 8";
    if ([platform isEqualToString:@"iPhone10,2"])   return @"iPhone 8 Plus";
    if ([platform isEqualToString:@"iPhone10,5"])   return @"iPhone 8 Plus";
    if ([platform isEqualToString:@"iPhone10,3"])   return @"iPhone X";
    if ([platform isEqualToString:@"iPhone10,6"])   return @"iPhone X";
    
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 plus";
    
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G";
    
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G";
    
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G";
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1";
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4";
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4";
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G";
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G";
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    return @"";
    
}
- (void)_showSystemReview {
    //弹出评论
    if (@available(iOS 10.3, *)) {
        if ([Comn gb].isSysReviewShow) {
            if([SKStoreReviewController respondsToSelector:@selector(requestReview)]) {
                //防止键盘遮挡
                [[UIApplication sharedApplication].keyWindow endEditing:YES];
                [SKStoreReviewController requestReview];
                [Comn gb].isSysReviewShow = NO;
            }
        }
    } else {
        // Fallback on earlier versions
    }
}
/*
 //必须一一对应
 _getLanguageImageArray
 _getLanguageArray
 SystemLanguage
 Loccalizable也要添加对应的缩写（百度、有道）
 */
- (NSArray *)_getLanguageArray {
    NSArray * arrayData = @[
                            NSLocalizedString(@"Automatic detection", nil)
                            ,NSLocalizedString(@"English", nil)
                            ,NSLocalizedString(@"Simple chinese", nil)
                            ,NSLocalizedString(@"Traditrational chinese", nil)
                            ,NSLocalizedString(@"japanese", nil)
                            ,NSLocalizedString(@"Korean", nil)
                            ,NSLocalizedString(@"Russian", nil)
                            ,NSLocalizedString(@"French", nil)
                            ,NSLocalizedString(@"Portuguese", nil)
                            ,NSLocalizedString(@"Spanish", nil)
                            ,NSLocalizedString(@"Italian", nil)
                            ,NSLocalizedString(@"German", nil)
                            ,NSLocalizedString(@"Swedish", nil)
                            ,NSLocalizedString(@"Finnish", nil)
                            ,NSLocalizedString(@"Danish", nil)
                            ,NSLocalizedString(@"Dutch", nil)
                            ,NSLocalizedString(@"Polish", nil)
                            ];
    return arrayData;
}
- (NSArray *)_getLanguageImageArray {
    NSArray * arrayData = @[
                            @"language_all"
                            ,@"language_en"
                            ,@"language_cn"
                            ,@"language_cn"
                            ,@"language_ja"
                            ,@"language_ko"
                            ,@"language_ru"
                            ,@"language_fr"
                   //         ,@"language_ae"
                            
                            ,@"language_po"
                            ,@"language_sp"
                            ,@"language_it"
                            ,@"language_de"
                            ,@"language_sw"
                            ,@"language_fi"
                            ,@"language_da"
                            ,@"language_du"
                            ,@"language_pl"
                            ];
    return arrayData;
}
//免费翻译次数
- (NSInteger)_getFreeTranslateCount {
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"freeTranslateCount"];
}
- (void)_addFreeTranslateCount {
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    [userdefaults setInteger:([[Comn gb] _getFreeTranslateCount]+1) forKey:@"freeTranslateCount"];
    [userdefaults synchronize];
}
//- (void)_showBuyAction {
//    AdGrayView * adGrayView = [[AdGrayView alloc]initWithViewModel:[self _getAdSectionViewModel]];
//    adGrayView.frame = CGRectMake(0, 0, WIDTH_SCREEN, HEIGHT_SCREEN);
//    [[UIApplication sharedApplication].keyWindow addSubview:adGrayView];
//}
//
//- (AdGrayViewModel *)_getAdSectionViewModel {
//    AdGrayViewModel * adGrayViewModel = [AdGrayViewModel new];
//    adGrayViewModel.adModel = [RequestApiManage gb].adModel;
//    return adGrayViewModel;
//}
- (void)_setOCRLanguage {
    //    NSInteger indexLanguage = 0;
    //    if ([NSLocalizedString(@"language", nil) isEqualToString:@"zh-Hans"]) {
    //        indexLanguage = 1;
    //    }
    NSInteger indexLanguage = [[Comn gb] _getCurrentSystemLanguage];
    NSUserDefaults * defalut = [NSUserDefaults standardUserDefaults];
    [defalut setInteger:indexLanguage forKey:ISKeyRecognitionLanguage];
    [defalut synchronize];
}
- (SystemLanguage)_getCurrentSystemLanguage {
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    return [self _getCurrentSystemLanguageWithString:currentLanguage];
}
- (SystemLanguage)_getCurrentSystemLanguageWithString:(NSString *)currentLanguage {
    if ([currentLanguage isEqualToString:@"zh-Hans"]
        || [currentLanguage isEqualToString:@"zh-Hans-CN"]
        || [currentLanguage isEqualToString:@"zh"]
        || [currentLanguage isEqualToString:@"cn"]
        || [currentLanguage isEqualToString:@"zh_CN"]
        || [currentLanguage isEqualToString:@"zh-CN"]) {
        return SYSLAN_SIMPLE_CHINESE;
    } else if ([currentLanguage isEqualToString:@"zh-Hant"]
               ||[currentLanguage isEqualToString:@"cht"]
               ||[currentLanguage isEqualToString:@"zh_Hant_HK"]
               ||[currentLanguage isEqualToString:@"zh_Hant_TW"]
               ||[currentLanguage isEqualToString:@"zh_Hant_MO"]) {
        return SYSLAN_TRADI_CHINESE;
    } else if ([currentLanguage isEqualToString:@"pt"]) {
        return SYSLAN_PORTUGUESE;
    } else if ([currentLanguage isEqualToString:@"es"]
               ||[currentLanguage isEqualToString:@"spa"]) {
        return SYSLAN_SPANISH;
    } else if ([currentLanguage isEqualToString:@"it"]) {
        return SYSLAN_ITALIAN;
    } else if ([currentLanguage isEqualToString:@"fr"]
               ||[currentLanguage isEqualToString:@"fra"]) {
        return SYSLAN_FRENCH;
    } else if ([currentLanguage isEqualToString:@"de"]) {
        return SYSLAN_GERMAN;
    } else if ([currentLanguage isEqualToString:@"sv"]
               ||[currentLanguage isEqualToString:@"swe"]) {
        return SYSLAN_SWEDISH;
    } else if ([currentLanguage isEqualToString:@"ja"]
               ||[currentLanguage isEqualToString:@"jp"]) {
        return SYSLAN_JAPANCE;
    } else if ([currentLanguage isEqualToString:@"fu"]
               ||[currentLanguage isEqualToString:@"fin"]) {
        return SYSLAN_FINNISH;
    } else if ([currentLanguage isEqualToString:@"da"]
               ||[currentLanguage isEqualToString:@"dan"]) {
        return SYSLAN_DANISH;
    } else if ([currentLanguage isEqualToString:@"nl"]) {
        return SYSLAN_DUTCH;
    } else if ([currentLanguage isEqualToString:@"ru"]) {
        return SYSLAN_RUS;
    } else if ([currentLanguage isEqualToString:@"ko"]
               ||[currentLanguage isEqualToString:@"kor"]) {
        return SYSLAN_KOR;
    } else if ([currentLanguage isEqualToString:@"pl"]) {
        return SYSLAN_PL;
    } else if([currentLanguage isEqualToString:@"en"]) {
        return SYSLAN_ENGLISH;
    }else{
        return SYSLAN_AUTO;
    }
}

- (NSString *)_getTranslateLanguageWithStr:(NSString *)str {
    if ([str isEqualToString:NSLocalizedString(@"Automatic detection", nil)]) {
        return @"auto";
    } else if ([str isEqualToString:NSLocalizedString(@"Simple chinese", nil)]) {
        return @"zh";
    } else if ([str isEqualToString:NSLocalizedString(@"Traditrational chinese", nil)]) {
        return @"cht";
    } else if ([str isEqualToString:NSLocalizedString(@"English", nil)]) {
        return @"en";
    } else if ([str isEqualToString:NSLocalizedString(@"French", nil)]) {
        return @"fra";
    } else if ([str isEqualToString:NSLocalizedString(@"German", nil)]) {
        return @"de";
    } else if ([str isEqualToString:NSLocalizedString(@"Spanish", nil)]) {
        return @"spa";
    } else if ([str isEqualToString:NSLocalizedString(@"Simple chinese", nil)]) {
        return @"zh";
    } else if ([str isEqualToString:NSLocalizedString(@"Portuguese", nil)]) {
        return @"pt";
    } else if ([str isEqualToString:NSLocalizedString(@"Swedish", nil)]) {
        return @"swe";
    } else if ([str isEqualToString:NSLocalizedString(@"Italian", nil)]) {
        return @"it";
    } else if ([str isEqualToString:NSLocalizedString(@"Finnish", nil)]) {
        return @"fin";
    } else if ([str isEqualToString:NSLocalizedString(@"Danish", nil)]) {
        return @"dan";
    } else if ([str isEqualToString:NSLocalizedString(@"Dutch", nil)]) {
        return @"nl";
    } else if ([str isEqualToString:NSLocalizedString(@"Korean", nil)]) {
        return @"kor";
    } else if ([str isEqualToString:NSLocalizedString(@"Russian", nil)]) {
        return @"ru";
    } else if ([str isEqualToString:NSLocalizedString(@"japanese", nil)]) {
        return @"jp";
    }
    return @"auto";
}
//- (NSString *)_getLanguageWithStr:(NSString *)str
//                 typeTranslateUse:(TypeTranslateUse)typeTranslateUse {
//    if ([str isEqualToString:NSLocalizedString(@"Automatic detection", nil)]) {
//        return @"auto";
//    } else if ([str isEqualToString:NSLocalizedString(@"Simple chinese", nil)]) {
//        if (typeTranslateUse == TypeTranslateUseSystemSpeechRecognition) {
//            return @"zh_CN";
//        } else if (typeTranslateUse == TypeTranslateUseYouDao) {
//            return @"zh-CHS";
//        }
//        return @"zh";
//    } else if ([str isEqualToString:NSLocalizedString(@"Traditrational chinese", nil)]) {
//        return @"cht";
//    } else if ([str isEqualToString:NSLocalizedString(@"English", nil)]) {
//        if (typeTranslateUse == TypeTranslateUseYouDao) {
//            return @"EN";
//        }
//        return @"en";
//    } else if ([str isEqualToString:NSLocalizedString(@"French", nil)]) {
//        if (typeTranslateUse == TypeTranslateUseYouDao) {
//            return @"fr";
//        }
//        return @"fra";
//    } else if ([str isEqualToString:NSLocalizedString(@"German", nil)]) {
//        return @"de";
//    } else if ([str isEqualToString:NSLocalizedString(@"Spanish", nil)]) {
//        if (typeTranslateUse == TypeTranslateUseYouDao) {
//            return @"es";
//        }
//        return @"spa";
//    } else if ([str isEqualToString:NSLocalizedString(@"Portuguese", nil)]) {
//        return @"pt";
//    } else if ([str isEqualToString:NSLocalizedString(@"Swedish", nil)]) {
//        return @"swe";
//    } else if ([str isEqualToString:NSLocalizedString(@"Italian", nil)]) {
//        return @"it";
//    } else if ([str isEqualToString:NSLocalizedString(@"Finnish", nil)]) {
//        return @"fin";
//    } else if ([str isEqualToString:NSLocalizedString(@"Danish", nil)]) {
//        return @"dan";
//    } else if ([str isEqualToString:NSLocalizedString(@"Dutch", nil)]) {
//        return @"nl";
//    } else if ([str isEqualToString:NSLocalizedString(@"Korean", nil)]) {
//        if (typeTranslateUse == TypeTranslateUseYouDao) {
//            return @"ko";
//        }
//        return @"kor";
//    } else if ([str isEqualToString:NSLocalizedString(@"Russian", nil)]) {
//        return @"ru";
//    } else if ([str isEqualToString:NSLocalizedString(@"japanese", nil)]) {
//        if (typeTranslateUse == TypeTranslateUseYouDao) {
//            return @"ja";
//        }
//        return @"jp";
//    }
//    return @"auto";
//}
//根据语言名称获取对于的语言缩写
- (NSString *)_getTranslateLanguegeABWithTranslateType:(TypeTranslateUse)typeTranslateUse
                                         lanuageString:(NSString *)language {
    if ([language isEqualToString:NSLocalizedString(@"Simple chinese", nil)]) {
        switch (typeTranslateUse) {
            case TypeTranslateUseBaidu:
                return @"zh";
            case TypeTranslateUseYouDao:
                return @"zh-CHS";
            case TypeTranslateUseSystemSpeechRecognition:
                return @"zh_CN";
            case TypeTranslateUseSystemPlayer:
                return @"zh-CN";
            default:
                return nil;
        }
    } else if ([language isEqualToString:NSLocalizedString(@"Traditrational chinese", nil)]) {
        switch (typeTranslateUse) {
            case TypeTranslateUseBaidu:
                return @"cht";
            case TypeTranslateUseYouDao:
                return nil;
            case TypeTranslateUseSystemSpeechRecognition:
                return @"zh_TW";
            case TypeTranslateUseSystemPlayer:
                return @"zh-TW";
            default:
                return nil;
        }
    } else if ([language isEqualToString:NSLocalizedString(@"English", nil)]) {
        switch (typeTranslateUse) {
            case TypeTranslateUseBaidu:
                return @"en";
            case TypeTranslateUseYouDao:
                return @"EN";
            case TypeTranslateUseSystemSpeechRecognition:
                return @"en_US";
            case TypeTranslateUseSystemPlayer:
                return @"en-US";
            default:
                return nil;
        }
    } else if ([language isEqualToString:NSLocalizedString(@"French", nil)]) {
        switch (typeTranslateUse) {
            case TypeTranslateUseBaidu:
                return @"fra";
            case TypeTranslateUseYouDao:
                return @"fr";
            case TypeTranslateUseSystemSpeechRecognition:
                return @"fr_FR";
            case TypeTranslateUseSystemPlayer:
                return @"fr-FR";
            default:
                return nil;
        }
    } else if ([language isEqualToString:NSLocalizedString(@"German", nil)]) {
        switch (typeTranslateUse) {
            case TypeTranslateUseBaidu:
                return @"de";
            case TypeTranslateUseYouDao:
                return @"de";
            case TypeTranslateUseSystemSpeechRecognition:
                return @"de_DE";
            case TypeTranslateUseSystemPlayer:
                return @"de-DE";
            default:
                return nil;
        }
    } else if ([language isEqualToString:NSLocalizedString(@"Spanish", nil)]) {
        switch (typeTranslateUse) {
            case TypeTranslateUseBaidu:
                return @"spa";
            case TypeTranslateUseYouDao:
                return @"es";
            case TypeTranslateUseSystemSpeechRecognition:
                return @"es_ES";
            case TypeTranslateUseSystemPlayer:
                return @"es-ES";
            default:
                return nil;
        }
    } else if ([language isEqualToString:NSLocalizedString(@"Portuguese", nil)]) {
        switch (typeTranslateUse) {
            case TypeTranslateUseBaidu:
                return @"pt";
            case TypeTranslateUseYouDao:
                return @"pt";
            case TypeTranslateUseSystemSpeechRecognition:
                return @"pt_BR";
            case TypeTranslateUseSystemPlayer:
                return @"pt-BR";
            default:
                return nil;
        }
    } else if ([language isEqualToString:NSLocalizedString(@"Swedish", nil)]) {
        switch (typeTranslateUse) {
            case TypeTranslateUseBaidu:
                return @"swe";
            case TypeTranslateUseYouDao:
                return nil;
            case TypeTranslateUseSystemSpeechRecognition:
                return @"sv_SE";
            case TypeTranslateUseSystemPlayer:
                return @"sv-SE";
            default:
                return nil;
        }
    } else if ([language isEqualToString:NSLocalizedString(@"Italian", nil)]) {
        switch (typeTranslateUse) {
            case TypeTranslateUseBaidu:
                return @"it";
            case TypeTranslateUseYouDao:
                return nil;
            case TypeTranslateUseSystemSpeechRecognition:
                return @"it_IT";
            case TypeTranslateUseSystemPlayer:
                return @"it-IT";
            default:
                return nil;
        }
    } else if ([language isEqualToString:NSLocalizedString(@"Finnish", nil)]) {
        switch (typeTranslateUse) {
            case TypeTranslateUseBaidu:
                return @"fin";
            case TypeTranslateUseYouDao:
                return nil;
            case TypeTranslateUseSystemSpeechRecognition:
                return @"fi_FI";
            case TypeTranslateUseSystemPlayer:
                return @"fi-FI";
            default:
                return nil;
        }
    } else if ([language isEqualToString:NSLocalizedString(@"Danish", nil)]) {
        switch (typeTranslateUse) {
            
            case TypeTranslateUseBaidu:
                return @"dan";
            case TypeTranslateUseYouDao:
                return nil;
            case TypeTranslateUseSystemSpeechRecognition:
                return @"da_DK";
            case TypeTranslateUseSystemPlayer:
                return @"da-DK";
            default:
                return nil;
        }
    } else if ([language isEqualToString:NSLocalizedString(@"Dutch", nil)]) {
        switch (typeTranslateUse) {
            
            case TypeTranslateUseBaidu:
                return @"nl";
            case TypeTranslateUseYouDao:
                return nil;
            case TypeTranslateUseSystemSpeechRecognition:
                return @"nl_NL";
            case TypeTranslateUseSystemPlayer:
                return @"nl-NL";
            default:
                return nil;
        }
    } else if ([language isEqualToString:NSLocalizedString(@"Korean", nil)]) {
        switch (typeTranslateUse) {
            
            case TypeTranslateUseBaidu:
                return @"kor";
            case TypeTranslateUseYouDao:
                return @"ko";
            case TypeTranslateUseSystemSpeechRecognition:
                return @"ko_KR";
            case TypeTranslateUseSystemPlayer:
                return @"ko-KR";
            default:
                return nil;
        }
    } else if ([language isEqualToString:NSLocalizedString(@"Russian", nil)]) {
        switch (typeTranslateUse) {
            
            case TypeTranslateUseBaidu:
                return @"ru";
            case TypeTranslateUseYouDao:
                return @"ru";
            case TypeTranslateUseSystemSpeechRecognition:
                return @"ru_RU";
            case TypeTranslateUseSystemPlayer:
                return @"ru-RU";
            default:
                return nil;
        }
    } else if ([language isEqualToString:NSLocalizedString(@"japanese", nil)]) {
        switch (typeTranslateUse) {
            
            case TypeTranslateUseBaidu:
                return @"jp";
            case TypeTranslateUseYouDao:
                return @"ja";
            case TypeTranslateUseSystemSpeechRecognition:
                return @"ja_JP";
            case TypeTranslateUseSystemPlayer:
                return @"ja-JP";
            default:
                return nil;
        }
    } else if ([language isEqualToString:NSLocalizedString(@"Polish", nil)]) {
        switch (typeTranslateUse) {
                
            case TypeTranslateUseBaidu:
                return @"pl";
            case TypeTranslateUseYouDao:
                return nil;
            case TypeTranslateUseSystemSpeechRecognition:
                return @"pl_PL";
            case TypeTranslateUseSystemPlayer:
                return @"pl-PL";
            default:
                return nil;
        }
    } else if ([language isEqualToString:NSLocalizedString(@"Automatic detection", nil)]) {
        switch (typeTranslateUse) {
                
            case TypeTranslateUseBaidu:
                return @"auto";
            case TypeTranslateUseYouDao:
                return @"auto";
            case TypeTranslateUseSystemSpeechRecognition:
                return @"auto";
            case TypeTranslateUseSystemPlayer:
                return @"auto";
            default:
                return @"auto";
        }
    }
    return nil;
}
//根据语言名称判断是否支持对于语言
- (BOOL)_isSupportTranslateType:(TypeTranslateUse)typeTranslateUse
                  lanuageString:(NSString *)language {
    if ([language isEqualToString:NSLocalizedString(@"Simple chinese", nil)]) {
        return YES;
    } else if ([language isEqualToString:NSLocalizedString(@"Traditrational chinese", nil)]) {
        switch (typeTranslateUse) {
            case TypeTranslateUseYouDao:
                return NO;
                
            default:
                return YES;
        }
    } else if ([language isEqualToString:NSLocalizedString(@"English", nil)]) {
        switch (typeTranslateUse) {
            default:
                return YES;
        }
    } else if ([language isEqualToString:NSLocalizedString(@"French", nil)]) {
        switch (typeTranslateUse) {
            default:
                return YES;
        }
    } else if ([language isEqualToString:NSLocalizedString(@"German", nil)]) {
        switch (typeTranslateUse) {
            default:
                return YES;
        }
    } else if ([language isEqualToString:NSLocalizedString(@"Spanish", nil)]) {
        switch (typeTranslateUse) {
            default:
                return YES;
        }
    } else if ([language isEqualToString:NSLocalizedString(@"Portuguese", nil)]) {
        switch (typeTranslateUse) {
            default:
                return YES;
        }
    } else if ([language isEqualToString:NSLocalizedString(@"Swedish", nil)]) {
        switch (typeTranslateUse) {
            case TypeTranslateUseYouDao:
                return NO;
            default:
                return YES;
        }
    } else if ([language isEqualToString:NSLocalizedString(@"Italian", nil)]) {
        switch (typeTranslateUse) {
            case TypeTranslateUseYouDao:
                return NO;
            default:
                return YES;
        }
    } else if ([language isEqualToString:NSLocalizedString(@"Finnish", nil)]) {
        switch (typeTranslateUse) {
            case TypeTranslateUseYouDao:
                return NO;
            default:
                return YES;
        }
    } else if ([language isEqualToString:NSLocalizedString(@"Danish", nil)]) {
        switch (typeTranslateUse) {
            case TypeTranslateUseYouDao:
                return NO;
            default:
                return YES;
        }
    } else if ([language isEqualToString:NSLocalizedString(@"Dutch", nil)]) {
        switch (typeTranslateUse) {
            case TypeTranslateUseYouDao:
                return NO;
            default:
                return YES;
        }
    } else if ([language isEqualToString:NSLocalizedString(@"Korean", nil)]) {
        switch (typeTranslateUse) {
            default:
                return YES;
        }
    } else if ([language isEqualToString:NSLocalizedString(@"Russian", nil)]) {
        switch (typeTranslateUse) {
            default:
                return YES;
        }
    } else if ([language isEqualToString:NSLocalizedString(@"japanese", nil)]) {
        switch (typeTranslateUse) {
            default:
                return YES;
        }
    }
    return NO;
}
//获取启动图
- (UIImage *)_getLauchImage {
    CGSize viewSize = [UIScreen mainScreen].bounds.size;
    NSString * viewO = @"Portrait";
    NSString * lanchImage = nil;
    NSArray * imagesDic = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for (NSDictionary * dict in imagesDic) {
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        if (CGSizeEqualToSize(imageSize, viewSize) && [viewO isEqualToString:dict[@"UILaunchImageOrientation"]]) {
            lanchImage = dict[@"UILaunchImageName"];
        }
    }
    return [UIImage imageNamed:lanchImage];
}
+ (NSString *)MD5HashWithStr:(NSString *)str {
    const char * cStr = [str UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, strlen(cStr), digest);
    NSMutableString * outPut = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
    for (int i = 0 ; i<CC_MD5_DIGEST_LENGTH; i++) {
        [outPut appendFormat:@"%02x",digest[i]];
    }
    return outPut;
}
+ (NSString *)URLEncodeWithStr:(NSString *)str {
    NSMutableString *output = [NSMutableString string];
    const unsigned char *source = (const unsigned char *)[str UTF8String];
    int sourceLen = strlen((const char *)source);
    for (int i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = source[i];
        if (thisChar == ' '){
            [output appendString:@"+"];
        } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
                   (thisChar >= 'a' && thisChar <= 'z') ||
                   (thisChar >= 'A' && thisChar <= 'Z') ||
                   (thisChar >= '0' && thisChar <= '9')) {
            [output appendFormat:@"%c", thisChar];
        } else {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    return output;
}
- (NSString *)_toTranslateWordLanguageTitle {
    NSUserDefaults * defalut = [NSUserDefaults standardUserDefaults];
    NSInteger intFrom = [defalut integerForKey:ISKeyTanslateWordLanguageTo];
    NSArray * array = [[Comn gb] _getLanguageArray];
    if (intFrom == -1) {
        return NSLocalizedString(@"Automatic detection", nil);
    }
    return array[intFrom];
}
- (NSString *)_fromTranslateWordLanguageTitle {
    NSUserDefaults * defalut = [NSUserDefaults standardUserDefaults];
    NSInteger intFrom = [defalut integerForKey:ISKeyTanslateWordLanguageFrom];
    NSArray * array = [[Comn gb] _getLanguageArray];
    if (intFrom == -1) {
        return NSLocalizedString(@"Automatic detection", nil);
    }
    return array[intFrom];
}
- (NSString *)_toTranslateDictionaryLanguageTitle {
    NSUserDefaults * defalut = [NSUserDefaults standardUserDefaults];
    NSInteger intFrom = [defalut integerForKey:ISKeyTanslateDictionaryLanguageTo];
    NSArray * array = [[Comn gb] _getLanguageArray];
    if (intFrom == -1) {
        return NSLocalizedString(@"Automatic detection", nil);
    }
    return array[intFrom];
}
- (NSString *)_fromTranslateDictionaryLanguageTitle {
    NSUserDefaults * defalut = [NSUserDefaults standardUserDefaults];
    NSInteger intFrom = [defalut integerForKey:ISKeyTanslateDictionaryLanguageFrom];
    NSArray * array = [[Comn gb] _getLanguageArray];
    if (intFrom == -1) {
        return NSLocalizedString(@"Automatic detection", nil);
    }
    return array[intFrom];
}
-(NSString *)_toTranslateDictionaryLanguageImage{
    NSUserDefaults * defalut = [NSUserDefaults standardUserDefaults];
    NSInteger intFrom = [defalut integerForKey:ISKeyTanslateDictionaryLanguageTo];
    NSArray * array = [[Comn gb] _getLanguageImageArray];
    if (intFrom == -1) {
        return @"language_all";
    }
    return array[intFrom];
}
-(NSString *)_frmoTranslateDictionaryLanguageImage{
    NSUserDefaults * defalut = [NSUserDefaults standardUserDefaults];
    NSInteger intFrom = [defalut integerForKey:ISKeyTanslateDictionaryLanguageFrom];
    NSArray * array = [[Comn gb] _getLanguageImageArray];
    if (intFrom == -1) {
        return @"language_all";
    }
    return array[intFrom];
}
- (NSString *)_toTranslateDialogueLanguageTitle {
    NSUserDefaults * defalut = [NSUserDefaults standardUserDefaults];
    NSInteger intFrom = [defalut integerForKey:ISKeyTanslateDialogueLanguageTo];
    NSArray * array = [[Comn gb] _getLanguageArray];
    if (intFrom == -1) {
        return NSLocalizedString(@"Automatic detection", nil);
    }
    return array[intFrom];
}
- (NSString *)_fromTranslateDialogueLanguageTitle {
    NSUserDefaults * defalut = [NSUserDefaults standardUserDefaults];
    NSInteger intFrom = [defalut integerForKey:ISKeyTanslateDialogueLanguageFrom];
    NSArray * array = [[Comn gb] _getLanguageArray];
    if (intFrom == -1) {
        return NSLocalizedString(@"Automatic detection", nil);
    }
    return array[intFrom];
}
- (NSString *)_getFromLanguageWithTypeTranslate:(TypeTranslate)typeTranslate {
    if (typeTranslate == TypeTranslateWord) {
        return [[Comn gb] _fromTranslateWordLanguageTitle];
    } else if (typeTranslate == TypeTranslateDictionary) {
        return [[Comn gb] _fromTranslateDictionaryLanguageTitle];
    } else if (typeTranslate == TypeTranslateDialogue) {
        return [[Comn gb] _fromTranslateDialogueLanguageTitle];
    }
    return NSLocalizedString(@"Automatic detection", nil);
}
- (NSString *)_getToLanguageWithTypeTranslate:(TypeTranslate)typeTranslate {
    if (typeTranslate == TypeTranslateWord) {
        return [[Comn gb] _toTranslateWordLanguageTitle];
    } else if (typeTranslate == TypeTranslateDictionary) {
        return [[Comn gb] _toTranslateDictionaryLanguageTitle];
    } else if (typeTranslate == TypeTranslateDialogue) {
        return [[Comn gb] _toTranslateDialogueLanguageTitle];
    }
    return NSLocalizedString(@"Automatic detection", nil);
}
- (void)_replaceFromAndToLanguageWithType:(TypeTranslate)typeTranslate {
    NSInteger intFrom = [[Comn gb] _getFromTranslateLanguageIndexWithType:typeTranslate];
    NSInteger intTo = [[Comn gb] _getToTranslateLanguegeIndexWithType:typeTranslate];
    //自动不能替换
    if (intFrom == -1) {
        return;
    }
    [[Comn gb] _setFromTranslateLanguageWithLanguege:intTo WithType:typeTranslate];
    [[Comn gb] _setToTranslateLanguageWithLanguege:intFrom WithType:typeTranslate];
}
- (NSInteger)_getFromTranslateLanguageIndexWithType:(TypeTranslate)typeTranslate {
    NSUserDefaults * defalut = [NSUserDefaults standardUserDefaults];
    NSInteger intFrom = [defalut integerForKey:ISKeyTanslateWordLanguageFrom];
    if (typeTranslate == TypeTranslateDictionary) {
        intFrom = [defalut integerForKey:ISKeyTanslateDictionaryLanguageFrom];
    } else if (typeTranslate == TypeTranslateDialogue) {
        intFrom = [defalut integerForKey:ISKeyTanslateDialogueLanguageFrom];
    }
    return intFrom;
}
- (NSInteger)_getToTranslateLanguegeIndexWithType:(TypeTranslate)typeTranslate {
    NSUserDefaults * defalut = [NSUserDefaults standardUserDefaults];
    NSInteger intFrom = [defalut integerForKey:ISKeyTanslateWordLanguageTo];
    if (typeTranslate == TypeTranslateDictionary) {
        intFrom = [defalut integerForKey:ISKeyTanslateDictionaryLanguageTo];
    } else if (typeTranslate == TypeTranslateDialogue) {
        intFrom = [defalut integerForKey:ISKeyTanslateDialogueLanguageTo];
    }
    return intFrom;
}
- (void)_setFromTranslateLanguageWithLanguege:(NSInteger)language
                                     WithType:(TypeTranslate)typeTranslate {
    NSUserDefaults * defalut = [NSUserDefaults standardUserDefaults];
    if (typeTranslate == TypeTranslateDictionary) {
        [defalut setInteger:language forKey:ISKeyTanslateDictionaryLanguageFrom];
    } else if (typeTranslate == TypeTranslateDialogue) {
        [defalut setInteger:language forKey:ISKeyTanslateDialogueLanguageFrom];
    } else {
        [defalut setInteger:language forKey:ISKeyTanslateWordLanguageFrom];
    }
    [defalut synchronize];
}
- (void)_setToTranslateLanguageWithLanguege:(NSInteger)language
                                   WithType:(TypeTranslate)typeTranslate {
    NSUserDefaults * defalut = [NSUserDefaults standardUserDefaults];
    if (typeTranslate == TypeTranslateDictionary) {
        [defalut setInteger:language forKey:ISKeyTanslateDictionaryLanguageTo];
    } else if (typeTranslate == TypeTranslateDialogue) {
        [defalut setInteger:language forKey:ISKeyTanslateDialogueLanguageTo];
    } else {
        [defalut setInteger:language forKey:ISKeyTanslateWordLanguageTo];
    }
    [defalut synchronize];
}
- (BOOL)isChinese:(NSString *)str
{
//    NSString *match = @"(^[\u4e00-\u9fa5]+$)";
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
//    return [predicate evaluateWithObject:str];
    for(int i=0; i< [str length];i++){
        int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff)
        {
            return YES;
        }
    }
    return NO;
}
//是否免费使用翻译
- (BOOL)_isFreeTranslate {
    return ([Comn gb].isLimit
            ||[Comn gb].isBuy
            ||[[Comn gb] _getFreeTranslateCount]<=kCountSaveDocumentFreeTranslate);
}
- (void)_showAlertWithTitle:(NSString *)title
                    message:(NSString *)message
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil)
                                              style:UIAlertActionStyleCancel
                                            handler:nil]];
    [[[Comn gb]topViewController] presentViewController:alert animated:YES completion:nil];
}
- (BOOL)canNetWork
{
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [reach currentReachabilityStatus];
    if (netStatus == NotReachable)
    {
        //        [[Comn gb] _showAlertViewTitle:nil message:NSLocalizedString(@"net can't use",nil)];
        return NO;
        
    }
    return YES;
}



//检测语音识别权限
+(BOOL )CheckMicrophonePermissions
{
    __block   BOOL micrAccess = NO;
    AVAudioSessionRecordPermission permissionStatus = [[AVAudioSession sharedInstance] recordPermission];
    if (permissionStatus == AVAudioSessionRecordPermissionUndetermined) {
        [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
            micrAccess = granted;
        }];
    } else if (permissionStatus == AVAudioSessionRecordPermissionDenied) {
        micrAccess = NO;
    } else {
        micrAccess = YES;
    }
    return micrAccess;
}

//检测语音识别权限
+(BOOL)CheckSpeechPermissions
{
    __block BOOL speechAccess;
    SFSpeechRecognizerAuthorizationStatus speechAuthStatus = [SFSpeechRecognizer authorizationStatus];
    if (speechAuthStatus == SFSpeechRecognizerAuthorizationStatusNotDetermined) {
        [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
            if (status == SFSpeechRecognizerAuthorizationStatusAuthorized) {
                speechAccess = YES;
            } else {
                speechAccess = YES;
            }
        }];
    } else if (speechAuthStatus == SFSpeechRecognizerAuthorizationStatusAuthorized) {
        speechAccess  = YES;
    } else{
        speechAccess = NO;
    }
    return speechAccess;
}





@end
