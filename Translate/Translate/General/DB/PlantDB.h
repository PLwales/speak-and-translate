//
//  PlantDB.h
//  ScanPlant
//
//  Created by sihan on 2018/7/9.
//  Copyright © 2018年 sihan. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "PlantModel.h"

@interface PlantDB : NSObject
//- (BOOL)addPlantInfo:(PlantModel *)plantModel
//              tbName:(NSString *)tbName;
- (NSMutableArray*)getAllPlant;
//- (PlantModel*)getBaikePlantWithName:(NSString *)name;
//删除record信息
- (BOOL)delPlantWithUUID:(NSString *)UUID;
//删除信息
- (BOOL)delPlantBaikeWithName:(NSString *)name;
@end
