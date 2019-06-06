//
//  Comn.h
//  ScanPlant
//
//  Created by sihan on 2018/7/9.
//  Copyright © 2018年 sihan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Sqlite.h"
typedef enum {
    SYSLAN_AUTO =0,
    SYSLAN_ENGLISH = 1,             //英语
    SYSLAN_SIMPLE_CHINESE = 2,      //简体中文
    SYSLAN_TRADI_CHINESE,       //繁体中文
    SYSLAN_PORTUGUESE,          //葡萄牙
    SYSLAN_SPANISH,             //西班牙
    SYSLAN_ITALIAN,             //意大利
    SYSLAN_FRENCH,              //法
    SYSLAN_GERMAN,              //德
    SYSLAN_SWEDISH,             //瑞典
    SYSLAN_JAPANCE,             //日语
    SYSLAN_FINNISH,             //芬兰文
    SYSLAN_DANISH,              //丹麦文
    SYSLAN_DUTCH,               //荷兰文
    SYSLAN_RUS,                 //俄语
    SYSLAN_KOR,                 //韩语
    SYSLAN_PL                   //波兰
}SystemLanguage;
//设置页面权限类型
typedef enum : NSUInteger
{
    //相册
    TypeSettingSysPermissionsPhotos = 0,
    //相机
    TypeSettingSysPermissionsCamera,
    //蓝牙
    TypeSettingSysPermissionsLocation
    
}TypeSettingSysPermissions;

typedef enum : NSUInteger
{
    TypeRequestBackNoToken = 0,
    TypeRequestBackSuccess,
    TypeRequestBackError,
    TypeRequestBackNetworkError
}TypeRequestBack;

//设置页面section
typedef NS_ENUM(NSUInteger, TypeSectionSetting)
{
    //高级功能
    TypeSectionSettingAdvancedFeatures = 0,
    //其他
    TypeSectionSettingOther,
    //通用
    TypeSectionSettinGeneral,
    //优秀app
    TypeSectionSettingOtherExcellentAPP
};
//广告类型
typedef NS_ENUM(NSUInteger, TypeAdOperate)
{
    //appstore 下载
    TypeAdOperateOpenAppStore = 0,
    //评论
    TypeAdOperateEvaluate
};
//类型
typedef NS_ENUM(NSUInteger, TypeTranslate)
{
    //翻译
    TypeTranslateWord = 1,
    //词典
    TypeTranslateDictionary,
    TypeTranslateHistoryWord,
    TypeTranslateHistoryDictionary,
    TypeTranslateCollectWord,
    TypeTranslateCollectDictionary,
    //对话
    TypeTranslateDialogue
};
//类型
typedef NS_ENUM(NSUInteger, TypeHomeTranslate)
{
    TypeHomeTranslateBaidu = 0,
    TypeHomeTranslateYouDao,
    TypeHomeTranslateGoogle
};
typedef NS_ENUM(NSUInteger, TypeDictionaryTranslate)
{
    TypeDictionaryTranslateBing = 0,
    TypeDictionaryTranslateJinShan
};
//翻译类型:保存数据库
typedef NS_ENUM(NSUInteger, TypeTranslateClass)
{
    TypeTranslateClassBaidu = 0,
    TypeTranslateClassYouDao,
    TypeTranslateClassGoogle,
    TypeTranslateClassBingDictionary,
    TypeTranslateClassJinShanDictionary
};
//类型
typedef NS_ENUM(NSUInteger, TypeTextViewStatus)
{
    TypeTextViewStatusEditShowHistory = 0,
    TypeTextViewStatusEditHidenHistory,
    TypeTextViewStatusEditRestore,
    TypeTextViewStatusTranslate,
    TypeTextViewStatusEditOnlyShowTextView
};
//类型
typedef NS_ENUM(NSUInteger, TypeHomeHeaderButton)
{
    TypeHomeHeaderButtonCapture = 0,
    TypeHomeHeaderButtonVoice,
    TypeHomeHeaderButtonMessage
};
//翻译使用的类型：语言缩写
typedef NS_ENUM(NSUInteger, TypeTranslateUse)
{
    TypeTranslateUseBaidu = 0,
    TypeTranslateUseYouDao,
    TypeTranslateUseGoogle,
    TypeTranslateUseBing,
    TypeTranslateUseJinShan,
    //系统语音识别
    TypeTranslateUseSystemSpeechRecognition,
    //系统语音播报
    TypeTranslateUseSystemPlayer
};
@interface Comn : NSObject
@property (nonatomic, retain) Sqlite* sqlDB;
//是否在审核
@property (nonatomic, assign) BOOL isLimit;
//是否去除了限制
@property (nonatomic, assign) BOOL isBuy;
//是否弹出过应用内系统评论
@property (nonatomic, assign) BOOL isSysReviewShow;
@property (nonatomic, assign) TypeHomeTranslate typeHomeTranslate;
@property (nonatomic, assign) TypeDictionaryTranslate typeDictionaryTranslate;
+(Comn *)gb;
//获取设备
- (NSString*)deviceVersion;
- (NSString *)_getFilePath:(NSString *)fileName fileType:(NSString*)fileType;
//创建文件夹
- (BOOL)_createPath:(NSString *)fileName;
- (BOOL)_removeImageAtPath:(NSString *)path;
- (NSString *)_generateUuidString;
//获取本地图片
- (UIImage *)_getLocalImageWithFileName:(NSString *)fileName;
- (BOOL)writeImgToFile:(NSString *)NewFileName image:(UIImage*)image quality:(CGFloat)Quality;
- (void)_openPermissionsAlertView:(TypeSettingSysPermissions)typeSettingSysPermissions;
//获取最顶层视图
- (UIViewController*)topViewController;
- (NSString *)getCurrentTime;
//分享
- (void)_shareWithTitle:(NSString *)titlw
                  image:(UIImage *)image;
//评价
-(void)evaluate:(NSInteger)appId;
//处理图片符合百度标准
- (UIImage *)_getProcessImage:(UIImage *)image;
//去下载
- (void)showAppInApp:(NSString *)_appId;
//显示系统评价框
- (void)_showSysReview;

- (void)_getIsBuy;
- (void)_setIsBuy:(BOOL)isBuy;
//启动app次数
- (NSInteger)_getLoadAppCount;
- (void)_addLoadAppCount;
//弹出广告
- (NSInteger)_getShowLimitAd;
- (void)_setShowLimitAd:(NSInteger)count;
- (void)_setAddShowLimitCount;
//弹出评论
- (void)_addEvaluationCount;
- (BOOL)_getCountIsEvaluation;
- (void)_setEvaluation:(BOOL)isEvaluation;
- (BOOL)_getIsEvaluation;
//根据时间戳转换成时间
- (NSString *)_getTimeWithString:(NSString *)string;
- (void)showPicker:(NSString *)addressee withObject:(NSString *)object andWithBody:(NSString *)body;
//获取手机型号
- (NSString *)getCurrentDeviceModel;
- (void)_showSystemReview;
- (NSArray *)_getLanguageArray;
- (NSArray *)_getLanguageImageArray;
//免费翻译次数
- (NSInteger)_getFreeTranslateCount;
- (void)_addFreeTranslateCount;

//出现去除限制提示
- (void)_showBuyAction;
//获取启动图
- (UIImage *)_getLauchImage;
- (void)_setOCRLanguage;
+ (NSString *)MD5HashWithStr:(NSString *)str;
+ (NSString *)URLEncodeWithStr:(NSString *)str;
- (SystemLanguage)_getCurrentSystemLanguageWithString:(NSString *)currentLanguage;

- (NSString *)_toTranslateWordLanguageTitle;
- (NSString *)_fromTranslateWordLanguageTitle;

//获取国家
- (NSString *)_toTranslateDictionaryLanguageTitle;
- (NSString *)_fromTranslateDictionaryLanguageTitle;

//获取国旗
-(NSString *)_frmoTranslateDictionaryLanguageImage;
-(NSString *)_toTranslateDictionaryLanguageImage;


- (NSString *)_toTranslateDialogueLanguageTitle;
- (NSString *)_fromTranslateDialogueLanguageTitle;

- (NSString *)_getFromLanguageWithTypeTranslate:(TypeTranslate)typeTranslate;
- (NSString *)_getToLanguageWithTypeTranslate:(TypeTranslate)typeTranslate;

//国家名->缩写
- (NSString *)_getTranslateLanguageWithStr:(NSString *)str;
//交换语言
- (void)_replaceFromAndToLanguageWithType:(TypeTranslate)typeTranslate;
- (BOOL)isChinese:(NSString *)str;
//- (NSString *)_getLanguageWithStr:(NSString *)str
//                 typeTranslateUse:(TypeTranslateUse)typeTranslateUse;
//根据语言名称获取对于的语言缩写
- (NSString *)_getTranslateLanguegeABWithTranslateType:(TypeTranslateUse)typeTranslateUse
                                         lanuageString:(NSString *)language;
//根据语言名称判断是否支持对于语言
- (BOOL)_isSupportTranslateType:(TypeTranslateUse)typeTranslateUse
                  lanuageString:(NSString *)language;
//是否免费使用翻译
- (BOOL)_isFreeTranslate;
- (void)_showAlertWithTitle:(NSString *)title
                    message:(NSString *)message;
- (BOOL)canNetWork;



+(BOOL )CheckMicrophonePermissions;
+(BOOL)CheckSpeechPermissions;




@end
