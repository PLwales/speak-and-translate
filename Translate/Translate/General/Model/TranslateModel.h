//
//  TranslateModel.h
//  Translate
//
//  Created by sihan on 2018/10/31.
//  Copyright © 2018年 sihan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TranslateModel : NSObject
@property (nonatomic, strong) NSString * UUID;
@property (nonatomic, strong) NSString * content;
@property (nonatomic, strong) NSString * translate;
@property (nonatomic, strong) NSString * fromLanguage;
@property (nonatomic, strong) NSString * toLanguage;
@property (nonatomic, strong) NSString * createTime;
@property (nonatomic, assign) BOOL isCollect;
@property (nonatomic, assign) BOOL isHistory;
@property (nonatomic, assign) TypeTranslate typeTranslate;
//使用的是什么翻译
@property (nonatomic, assign) TypeTranslateClass typeTranslateClass;

@property (nonatomic, strong) NSDictionary * dictionaryBaseInfo;
//金山返回的数据
@property (nonatomic, strong) NSArray * arrayExample;
@property (nonatomic, strong) NSMutableAttributedString * detail;
//对话表格才有
@property (nonatomic, assign) BOOL isLeft;
//根据返回的数据生成自定义类组
@property (nonatomic, strong) NSMutableArray * arrayExamples;

- (BOOL)_addToDB;
- (BOOL)_delTranslateWithUUID;
- (BOOL)_updateToDB;
- (TranslateModel *)_getTranslateWithSelf;
- (void)_setInfoWithDictionary:(NSDictionary *)dictionary;
- (NSMutableAttributedString *)_getDetail;
- (NSMutableAttributedString *)_getBingDetail;
- (NSString *)_getBingTranslate;
- (void)_reloadTranslateExample;
- (NSMutableArray *)_getTranslateExample;
@end

NS_ASSUME_NONNULL_END
