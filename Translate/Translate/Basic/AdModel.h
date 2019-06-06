//
//  AdModel.h
//  ScanPlant
//
//  Created by sihan on 2018/7/10.
//  Copyright © 2018年 sihan. All rights reserved.
//

#import "BaseModel.h"

@interface AdModel : BaseModel
@property (copy,nonatomic) NSString *adLinkUrl;
@property (copy,nonatomic) NSString *adContent;
@property (copy,nonatomic) NSString *adName;
@property (copy,nonatomic) NSString *operateType;
@property (copy,nonatomic) NSString *icon;
@property (copy,nonatomic) NSString *adId;

//返回广告类型
- (TypeAdOperate)_getAdType;
@end
