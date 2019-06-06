//
//  Constants.h
//  ScanPlant
//
//  Created by sihan on 2018/7/6.
//  Copyright © 2018年 sihan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIColor+Hex.h"
#import "Comn.h"
//#if DEBUG
//#define kAdUnitID                       @"ca-app-pub-3940256099942544/4411468910"
//#else
#define kAdUnitID                       @"ca-app-pub-5508395017258696/3832524997"
#define kAdUnitID_SCREEN                @"ca-app-pub-5508395017258696/3940336201"
//#endif
#define _APPID_                         1443689958

#define kStringPrivacy                  @"https://safasfasfasf.github.io/p2/privacy_scanner.html"
//百度翻译
#define APPID_BaiDuTranslate            20181023000223595
#define kEY_BaiDuTranslate              @"kHLiWHzJLDC85ea2AH1l"
#define kStringSearchSymbol             @"&"

#define _VERSION_NUMBER_                [NSString stringWithFormat:@"%@",[[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey]]
#define COLOR_GREEN_01                  COLOR_HEX(@"#01B96F")
#define COLOR_GREEN_38                  COLOR_HEX(@"#38CE92")
#define COLOR_GREEN_66                  COLOR_HEX(@"#66D45B")
#define COLOR_GRAY_F3                   COLOR_HEX(@"#F3F3F3")
#define REQUEST_ERROR                   @"1111"
#define kCountSaveDocumentFreeTranslate         10
//主页上拉后显示的textfield高度
#define kHeightEditTextField    50
#define kHeightTextField        35
#define kHeaderViewH            200
#define kHeaderViewMinH         60
#define kHeightSlideButton      40
#define kHeightKeyboard         50
//判断是否是ipad
#define isPad ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
//判断iPhone4系列
#define kiPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhone5系列
#define kiPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhone6系列
#define kiPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iphone6+系列
#define kiPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhoneX
#define IS_IPHONE_X ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPHoneXr
#define IS_IPHONE_Xr ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhoneXs
#define IS_IPHONE_Xs ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhoneXs Max
#define IS_IPHONE_Xs_Max ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)

#define BOOL_IS_PHONEX              (((IS_IPHONE_X==YES || IS_IPHONE_Xr ==YES || IS_IPHONE_Xs== YES || IS_IPHONE_Xs_Max== YES))?YES:NO)
//iphonex的高度
#define kHeightNavStatusPhoneX      28
#define kHeightGetNavStatusPhoneX   ((BOOL_IS_PHONEX)?kHeightNavStatusPhoneX:0)
#define kHeightNavigationBar        ((BOOL_IS_PHONEX)?78:64)
//底部导航
#define kHeightBottomBar            ((BOOL_IS_PHONEX)?83:49)
//中心导航按钮往下偏移
#define kHeightGetNavCenterYSpace   (BOOL_IS_PHONEX?14:10)
#define HEIGHT_SCREEN               [UIScreen mainScreen].bounds.size.height
#define WIDTH_SCREEN                [UIScreen mainScreen].bounds.size.width
#define FITScreenWidth              (WIDTH_SCREEN/375)
#define FITScreenHeight             (HEIGHT_SCREEN/667)

#define IS_STRING_VALID(__SRC__)    ((( (__SRC__) == [NSNull null]) || [ (__SRC__) length] == 0 )?(0):(1))
#define RGB(R,G,B,A)                [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]
//获取图片
#define GET_IMAGE(__NAME__)         [UIImage imageNamed:__NAME__]
#define kHeightHomeCell             55
//DistnguishCell
#define kHeightDistnguishCell               (160.0/667*(HEIGHT_SCREEN))
/**
 弱引用
 */
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self
//IOS6以上评论及购买地址
#define _LINK_BUY_    @"itms-apps://itunes.apple.com/app/id"
#define IS_IOS11_MINI  ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0)
#define IMAGE_SUFFIX                        @".JPG"
#define kNotificationRefreshHomeData        @"NotificationRefreshHomeData"
#define kNotificationRefreshDictionaryData  @"NotificationRefreshDictionaryData"
//带objest：YES：表格上滑置顶
#define kNotificationRefreshDialogueData    @"NotificationRefreshDialogueData"
#define kNotificationRefreshCollectData     @"NotificationRefreshCollectData"
#define kNotificationRefreshNewWordData     @"NotificationRefreshNewWordData"
#define kNotificationPushToCap              @"NotificationPushToCap"
#define kNotificationBuySuccess             @"NotificationBuySuccess"
//是否点击过评论
#define KEY_ISREVIEW                @"isReview"
//计数为偶数弹出提示
#define KEY_SHOW_MARK_NUM           @"showMarkNum"
@interface Constants : NSObject
//导航上按钮高度
extern const float kHeightNavigationBarBtn;
//主页拍照按钮高度
extern const float kHeightOrWidthButtonCamera;
extern const CGFloat kHeightDistnguishLabel;
//ad cell
extern const float kHeightADCell;
extern NSString * const kStringEmailAddress;
extern NSString * const kStringDBName;
extern NSString * const kStringDirectoryDataName;
extern NSString * const kStringDBBase;
//数据库中的名称
extern NSString * const kStringTranslateTBName;
extern NSString * const kStringTranslateUUID;
extern NSString * const kStringTranslateContent;
extern NSString * const kStringTranslateTranslate;
extern NSString * const kStringTranslateFromLanguage;
extern NSString * const kStringTranslateToLanguage;
extern NSString * const kStringTranslateCreatedTime;
extern NSString * const kStringTranslateType;
extern NSString * const kStringTranslateIsCollect;
extern NSString * const kStringTranslateIsHistory;
//对话表格才有
extern NSString * const kStringTranslateIsLeft;


extern NSString * const kStringTranslateHistoryTBName;
extern NSString * const kStringTranslateHistoryUUID;
extern NSString * const kStringTranslateHistoryContent;
extern NSString * const kStringTranslateHistoryTranslate;
extern NSString * const kStringTranslateHistoryFromLanguage;
extern NSString * const kStringTranslateHistoryToLanguage;
extern NSString * const kStringTranslateHistoryCreatedTime;
extern NSString * const kStringTranslateHistoryType;
//词典信息：
extern NSString * const kStringTranslateBaseInfo;
//词典信息：例句
extern NSString * const kStringTranslateExample;
extern NSString * const kStringTranslateTranslateClass;

extern NSString * const kStringTranslateDictionaryTBName;
extern NSString * const kStringTranslateDictionaryUUID;
extern NSString * const kStringTranslateDictionaryContent;
extern NSString * const kStringTranslateDictionaryTranslate;
extern NSString * const kStringTranslateDictionaryFromLanguage;
extern NSString * const kStringTranslateDictionaryToLanguage;
extern NSString * const kStringTranslateDictionaryCreatedTime;
extern NSString * const kStringTranslateDictionaryType;
extern NSString * const kStringTranslateDictionaryIsCollect;
extern NSString * const kStringTranslateDictionaryIsHistory;
extern NSString * const kStringTranslateDictionaryExample;
//例句按自己的格式保存
extern NSString * const kStringTranslateDictionaryExampleContentEN;
extern NSString * const kStringTranslateDictionaryExampleContentCN;
extern NSString * const kStringTranslateDictionaryMP3Url;


extern NSString * const kStringJinShanBaseInfo;
//音标/解释
extern NSString * const kStringJinShanSymbols;
extern NSString * const kStringJinShanParts;
extern NSString * const kStringJinShanExample;

//百度百科信息
extern NSString * const kStringPlantAbstract;
extern NSString * const kStringPlantBaike;
//主页广告是否出现过
extern NSString * const ISKeyAdShow;
//默认识别语言
extern NSString * const ISKeyRecognitionLanguage;
//翻译语言
extern NSString * const ISKeyTanslateLanguageFrom;
extern NSString * const ISKeyTanslateLanguageTo;
extern NSString * const ISKeyTanslateWordLanguageFrom;
extern NSString * const ISKeyTanslateWordLanguageTo;
extern NSString * const ISKeyTanslateDictionaryLanguageFrom;
extern NSString * const ISKeyTanslateDictionaryLanguageTo;
extern NSString * const ISKeyTanslateDialogueLanguageFrom;
extern NSString * const ISKeyTanslateDialogueLanguageTo;
//对话翻译语言
extern NSString * const ISKeyTanslateLanguageFromDialogue;
extern NSString * const ISKeyTanslateLanguageToDialogue;

extern NSString * const RefreshTranslationLanguageNSNotification;
extern NSString * const ChildScrollViewDidScrollNSNotification;
extern NSString * const ChildScrollViewWillEndDraggingNSNotification;


//最近使用
extern NSString * const ISKeyTanslateLanguageRecentlyUsed;
//第一次出现历史记录的引导页
extern NSString * const ISKeyBootViewHistory;
//第一次出现文字翻译的引导页
extern NSString * const ISKeyBootViewTextTranslate;
@end

