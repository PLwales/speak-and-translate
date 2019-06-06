//
//  BaiduTranslateModel.m
//  IScanner
//
//  Created by sihan on 2018/10/9.
//  Copyright © 2018年 sihan. All rights reserved.
//

#import "BaiduTranslateModel.h"

@implementation BaiduTranslateModel
- (NSMutableDictionary *)dictionaryInfo {
    if (!_dictionaryInfo) {
        _dictionaryInfo = [NSMutableDictionary new];
    }
    return _dictionaryInfo;
}
@end
