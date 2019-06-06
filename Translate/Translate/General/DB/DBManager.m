//
//  DBManager.m
//  ScanPlant
//
//  Created by sihan on 2018/7/9.
//  Copyright © 2018年 sihan. All rights reserved.
//

#import "DBManager.h"
#import "TranslateDB.h"

@implementation DBManager
+ (DBManager *)shareSingleton {
    static DBManager * mySingleton = nil;
    @synchronized(self) {
        if (mySingleton == nil) {
            mySingleton = [[DBManager alloc]init];
        }
    }
    return mySingleton;
}

- (id)init {
    if(self = [super init]) {
        self.g_sqlite = [[Sqlite alloc]init];
    }
    return self;
}
- (NSMutableArray*)_getAllTrnaslateWithType:(TypeTranslate)typeTranslate {
    NSMutableArray * array = [NSMutableArray new];
    TranslateDB * translateDB = [TranslateDB new];
    NSArray * result = [translateDB _getAllTrnaslateWithType:typeTranslate];
    if (result) {
        [array addObjectsFromArray:result];
    }
    return array;
}
- (NSMutableArray *)_getAllPlant {
    PlantDB * plantDB = [PlantDB new];
    return [plantDB getAllPlant];
}
//- (PlantModel *)_getDBBaikeInfoWithPlantName:(NSString *)plantName {
//    PlantDB * plantDB = [PlantDB new];
//    return [plantDB getBaikePlantWithName:plantName];
//}
@end
