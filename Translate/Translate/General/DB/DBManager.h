//
//  DBManager.h
//  ScanPlant
//
//  Created by sihan on 2018/7/9.
//  Copyright © 2018年 sihan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Sqlite.h"
#import "PlantDB.h"

@interface DBManager : NSObject
@property (nonatomic, retain) Sqlite * g_sqlite;

+ (DBManager *)shareSingleton;
- (NSMutableArray*)_getAllTrnaslateWithType:(TypeTranslate)typeTranslate;
- (NSMutableArray *)_getAllPlant;
//- (PlantModel *)_getDBBaikeInfoWithPlantName:(NSString *)plantName;
@end
