//
//  BaiduTranslateModel.h
//  IScanner
//
//  Created by sihan on 2018/10/9.
//  Copyright © 2018年 sihan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaiduTranslateModel : NSObject
@property (nonatomic, strong) NSString * fromLanguage;
@property (nonatomic, strong) NSString * toLanguage;
@property (nonatomic, strong) NSString * translateResule;
@property (nonatomic, strong) NSString * content;
@property (nonatomic, strong) NSString * errorCode;
@property (nonatomic, strong) NSMutableDictionary * dictionaryInfo;
@end
