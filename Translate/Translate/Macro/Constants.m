//
//  Constants.m
//  ScanPlant
//
//  Created by sihan on 2018/7/6.
//  Copyright © 2018年 sihan. All rights reserved.
//

#import "Constants.h"

@implementation Constants
const float kHeightNavigationBarBtn = 35;
//主页拍照按钮高度
const float kHeightOrWidthButtonCamera = 80;
const CGFloat kHeightDistnguishLabel = 50;
//ad cell
const float kHeightADCell = 80;
NSString * const kStringEmailAddress = @"icaoer@outlook.com";
NSString * const kStringDBName = @"Translate.sqlite";
NSString * const kStringDirectoryDataName = @"/AppSupport/";
NSString * const kStringDBBase = @"DataBase";
//数据库中的名称
NSString * const kStringTranslateTBName = @"TranslateTB";
NSString * const kStringTranslateUUID = @"UUID";
NSString * const kStringTranslateContent = @"Content";
NSString * const kStringTranslateTranslate = @"Translate";
NSString * const kStringTranslateFromLanguage = @"FromLanguage";
NSString * const kStringTranslateToLanguage = @"ToLanguage";
NSString * const kStringTranslateCreatedTime = @"CreateTime";
NSString * const kStringTranslateType = @"TranslateType";
NSString * const kStringTranslateIsCollect = @"IsCollect";
NSString * const kStringTranslateIsHistory = @"IsHistory";
NSString * const kStringTranslateIsLeft = @"IsLeft";
NSString * const kStringTranslateBaseInfo = @"BaseInfo";
NSString * const kStringTranslateExample = @"Example";
NSString * const kStringTranslateTranslateClass = @"TranslateClass";

NSString * const kStringTranslateDictionaryTBName = @"TranslateDictionaryTB";
NSString * const kStringTranslateDictionaryUUID = @"UUID";
NSString * const kStringTranslateDictionaryContent = @"Content";
NSString * const kStringTranslateDictionaryTranslate = @"Translate";
NSString * const kStringTranslateDictionaryFromLanguage = @"FromLanguage";
NSString * const kStringTranslateDictionaryToLanguage = @"ToLanguage";
NSString * const kStringTranslateDictionaryCreatedTime = @"CreateTime";
NSString * const kStringTranslateDictionaryType = @"TranslateType";
NSString * const kStringTranslateDictionaryIsCollect = @"IsCollect";
NSString * const kStringTranslateDictionaryIsHistory = @"IsHistory";
NSString * const kStringTranslateDictionaryExample = @"Example";
//例句按自己的格式保存
NSString * const kStringTranslateDictionaryExampleContentEN = @"ExampleContentEN";
NSString * const kStringTranslateDictionaryExampleContentCN = @"ExampleContentCN";
NSString * const kStringTranslateDictionaryMP3Url = @"ExampleMP3Url";


NSString * const kStringJinShanBaseInfo = @"baesInfo";
//音标/解释
NSString * const kStringJinShanSymbols = @"symbols";
NSString * const kStringJinShanParts = @"parts";
NSString * const kStringJinShanExample = @"sentence";


//百度百科信息
NSString * const kStringPlantAbstract = @"abstract";
NSString * const kStringPlantBaike = @"wapUrl";
//广告是否出现过
NSString * const ISKeyAdShow = @"adShowHome";
//默认识别语言
NSString * const ISKeyRecognitionLanguage = @"RecognitionLanguage";
//翻译语言
//NSString * const ISKeyTanslateLanguageFrom = @"TanslateLanguageFrom";
//NSString * const ISKeyTanslateLanguageTo = @"TanslateLanguageTo";
NSString * const ISKeyTanslateWordLanguageFrom = @"TanslateWordLanguageFrom";
NSString * const ISKeyTanslateWordLanguageTo = @"TanslateWordLanguageTo";
NSString * const ISKeyTanslateDictionaryLanguageFrom = @"TanslateDictionaryLanguageFrom";
NSString * const ISKeyTanslateDictionaryLanguageTo = @"TanslateDictionaryLanguageTo";
NSString * const ISKeyTanslateDialogueLanguageFrom = @"TanslateDialogueLanguageFrom";
NSString * const ISKeyTanslateDialogueLanguageTo = @"TanslateDialogueLanguageTo";
//对话翻译语言
NSString * const ISKeyTanslateLanguageFromDialogue = @"TanslateLanguageFromDialogue";
NSString * const ISKeyTanslateLanguageToDialogue = @"TanslateLanguageToDialogue";
//同事刷新翻译语言
NSString * const RefreshTranslationLanguageNSNotification = @"RefreshTranslationLanguageNSNotification";
NSString * const ChildScrollViewDidScrollNSNotification = @"ChildScrollViewDidScrollNSNotification";
NSString * const ChildScrollViewWillEndDraggingNSNotification = @"ChildScrollViewWillEndDraggingNSNotification";

//最近使用
NSString * const ISKeyTanslateLanguageRecentlyUsed = @"TanslateLanguageRecentlyUsed";
//第一次出现历史记录的引导页
NSString * const ISKeyBootViewHistory = @"BootViewHistory";
//第一次出现文字翻译的引导页
NSString * const ISKeyBootViewTextTranslate = @"BootViewTextTranslate";

@end
