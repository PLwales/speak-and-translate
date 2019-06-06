//
//  TranslateDictionaryModel.h
//  Translate
//
//  Created by sihan on 2018/11/15.
//  Copyright © 2018年 sihan. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TranslateDictionaryModel : BaseModel
//音标读音
@property (nonatomic, strong) NSString * ph1;
@property (nonatomic, strong) NSString * ph1Url;
@property (nonatomic, strong) NSString * ph2;
@property (nonatomic, strong) NSString * ph2Url;

@property (nonatomic, strong) NSMutableArray * arrayParts;

@property (nonatomic, strong) NSMutableArray * arrayExample;
@end

NS_ASSUME_NONNULL_END
