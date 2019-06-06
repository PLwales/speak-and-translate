//
//  TranslateDB.h
//  Translate
//
//  Created by sihan on 2018/10/31.
//  Copyright © 2018年 sihan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TranslateModel.h"

/*
 历史记录跟收藏使用的是同一条数据；
 isCollect：是否在收藏列表
 isHistory：是否在历史记录表
 isCollect = NO；&& isHistory = NO 才会删除这条记录
 */

NS_ASSUME_NONNULL_BEGIN

@interface TranslateDB : NSObject
- (BOOL)_addTranslateInfo:(TranslateModel *)translate;
- (NSMutableArray*)_getAllTrnaslateWithType:(TypeTranslate)typeTranslate;
- (BOOL)_delTranslateWithUUID:(NSString *)UUID;
- (BOOL)_delTranslateWithType:(TypeTranslate)typeTranslate;
- (BOOL)_updateStatusWithTranslate:(TranslateModel *)translate;
- (TranslateModel *)_getTrnaslateWithModel:(TranslateModel *)translateModel;
@end

NS_ASSUME_NONNULL_END
