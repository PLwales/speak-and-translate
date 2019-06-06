//
//  AdModel.m
//  ScanPlant
//
//  Created by sihan on 2018/7/10.
//  Copyright © 2018年 sihan. All rights reserved.
//

#import "AdModel.h"

@implementation AdModel
- (TypeAdOperate)_getAdType {
    if ([self.operateType isEqualToString:@"review"]) {
        return TypeAdOperateEvaluate;
    } else {
        return TypeAdOperateOpenAppStore;
    }
}

@end
