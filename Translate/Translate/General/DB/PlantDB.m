//
//  PlantDB.m
//  ScanPlant
//
//  Created by sihan on 2018/7/9.
//  Copyright © 2018年 sihan. All rights reserved.
//

#import "PlantDB.h"
#import "DBManager.h"

@implementation PlantDB
//- (BOOL)addPlantInfo:(PlantModel *)plantModel
//              tbName:(NSString *)tbName
//{
//    __block BOOL isSuccess = NO;
//    [[DBManager shareSingleton].g_sqlite.queue inDatabase:^(FMDatabase *db) {
//
//        NSMutableString * query = [[NSMutableString alloc]initWithFormat:@"INSERT INTO %@",tbName];
//        NSMutableString * keys = [[NSMutableString alloc]initWithString:@" ("];
//        NSMutableString * values = [[NSMutableString alloc]initWithString:@" ( "];
//        NSMutableArray * arguments = [NSMutableArray new];
//
//        if (plantModel.stringUUID) {
//
//            [keys appendFormat:@"%@,",kStringPlantUUID];
//            [values appendString:@"?,"];
//            [arguments addObject:plantModel.stringUUID];
//        }
//        if (plantModel.stringPlantName) {
//
//            [keys appendFormat:@"%@,",kStringPlantName];
//            [values appendString:@"?,"];
//            [arguments addObject:plantModel.stringPlantName];
//        }
//        if (plantModel.stringPlantName1) {
//
//            [keys appendFormat:@"%@,",kStringPlantName1];
//            [values appendString:@"?,"];
//            [arguments addObject:plantModel.stringPlantName1];
//        }
//        if (plantModel.stringPlantName2) {
//
//            [keys appendFormat:@"%@,",kStringPlantName2];
//            [values appendString:@"?,"];
//            [arguments addObject:plantModel.stringPlantName2];
//        }
//        if (plantModel.stringDetail) {
//
//            [keys appendFormat:@"%@,",kStringPlantDetail];
//            [values appendString:@"?,"];
//            [arguments addObject:plantModel.stringDetail];
//        }
//        if (plantModel.stringCreateTime) {
//
//            [keys appendFormat:@"%@,",kStringPlantCreatedTime];
//            [values appendString:@"?,"];
//            [arguments addObject:plantModel.stringCreateTime];
//        }
//        if (plantModel.stringLastModifiedTime) {
//
//            [keys appendFormat:@"%@,",kStringPlantLastModified];
//            [values appendString:@"?,"];
//            [arguments addObject:plantModel.stringLastModifiedTime];
//        }
//        if (plantModel.stringOriImage) {
//
//            [keys appendFormat:@"%@,",kStringPlantOriginImg];
//            [values appendString:@"?,"];
//            [arguments addObject:plantModel.stringOriImage];
//        }
//        if (plantModel.stringOriImageThumbnail) {
//
//            [keys appendFormat:@"%@,",kStringPlantOriginImgThumbnail];
//            [values appendString:@"?,"];
//            [arguments addObject:plantModel.stringOriImageThumbnail];
//        }
//        if (plantModel.stringBaikeUrl) {
//
//            [keys appendFormat:@"%@,",kStringPlantBaike];
//            [values appendString:@"?,"];
//            [arguments addObject:plantModel.stringBaikeUrl];
//        }
//        if (plantModel.stringDetailAbstract) {
//
//            [keys appendFormat:@"%@,",kStringPlantAbstract];
//            [values appendString:@"?,"];
//            [arguments addObject:plantModel.stringDetailAbstract];
//        }
//        [keys appendString:@")"];
//        [values appendString:@")"];
//        [query appendFormat:@" %@ VALUES%@",
//         [keys stringByReplacingOccurrencesOfString:@",)" withString:@")"],
//         [values stringByReplacingOccurrencesOfString:@",)" withString:@")"]];
//        NSLog(@"%@",query);
//
//        isSuccess = [db executeUpdate:query withArgumentsInArray:arguments];
//
//    }];
//    return isSuccess;
//
//}
//- (NSMutableArray*)getAllPlant
//{
//    __block NSMutableArray *infoAr = [NSMutableArray array];
//    [[DBManager shareSingleton].g_sqlite.queue inDatabase:^(FMDatabase *db)
//     {
//         FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"select * from %@",kStringPlantTBName]];
//         while ([rs next])
//         {
//             PlantModel * plantModel = [PlantModel new];
//             plantModel.stringUUID = [rs stringForColumn:kStringPlantUUID];
//             plantModel.stringPlantName = [rs stringForColumn:kStringPlantName];
//             plantModel.stringPlantName1 = [rs stringForColumn:kStringPlantName1];
//             plantModel.stringPlantName2 = [rs stringForColumn:kStringPlantName2];
//             plantModel.stringDetail = [rs stringForColumn:kStringPlantDetail];
//             plantModel.stringCreateTime = [rs stringForColumn:kStringPlantCreatedTime];
//             plantModel.stringLastModifiedTime = [rs stringForColumn:kStringPlantLastModified];
//             plantModel.stringOriImage = [rs stringForColumn:kStringPlantOriginImg];
//             plantModel.stringOriImageThumbnail = [rs stringForColumn:kStringPlantOriginImgThumbnail];
//             plantModel.stringLastModifiedShow = [[Comn gb] _getTimeWithString:plantModel.stringLastModifiedTime];
//             [infoAr insertObject:plantModel atIndex:0];
//         }
//         [rs close];
//     }];
//    return infoAr;
//}
//- (PlantModel*)getBaikePlantWithName:(NSString *)name
//{
//    __block PlantModel * plantModel = nil;
//    [[DBManager shareSingleton].g_sqlite.queue inDatabase:^(FMDatabase *db)
//     {
//         FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"select * from %@ where %@ = '%@'",kStringPlantTBBaikeName,kStringPlantName,name]];
//         while ([rs next])
//         {
//             plantModel = [PlantModel new];
//             plantModel.stringUUID = [rs stringForColumn:kStringPlantUUID];
//             plantModel.stringPlantName = [rs stringForColumn:kStringPlantName];
//             plantModel.stringDetail = [rs stringForColumn:kStringPlantDetail];
//             plantModel.stringCreateTime = [rs stringForColumn:kStringPlantCreatedTime];
//             plantModel.stringLastModifiedTime = [rs stringForColumn:kStringPlantLastModified];
//             plantModel.stringOriImage = [rs stringForColumn:kStringPlantOriginImg];
//             plantModel.stringDetailAbstract = [rs stringForColumn:kStringPlantAbstract];
//             plantModel.stringBaikeUrl = [rs stringForColumn:kStringPlantBaike];
//         }
//         [rs close];
//     }];
//    return plantModel;
//}
////修改表格的detail
////- (BOOL)UpdateTimestampWithUUID:(NSString *)uuid
////{
////    __block BOOL isSuccess = NO;
////    [[DBManager shareSingleton].g_sqlite.queue inDatabase:^(FMDatabase *db)
////     {
////         NSString * query = [NSString stringWithFormat:@"UPDATE %@ SET",kStringPlantTBName];
////         NSMutableString * temp = [NSMutableString stringWithCapacity:5];
////
////         [temp appendFormat:@" %@ = '%@',",RESPONSE_TIME_STAMP,timestamp];
////         [temp appendString:@")"];
////         query = [query stringByAppendingFormat:@"%@ WHERE %@ = '%@'",
////                  [temp stringByReplacingOccurrencesOfString:@",)" withString:@""],uuidName,uuidStr];
////
////         isSuccess = [db executeUpdate:query];
////     }];
////    return isSuccess;
////}
////删除信息
//- (BOOL)delPlantWithUUID:(NSString *)UUID
//{
//    __block BOOL isSuccess = NO;
//    [[DBManager shareSingleton].g_sqlite.queue inDatabase:^(FMDatabase *db)
//     {
//         NSString * query = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = '%@'",kStringPlantTBName,kStringPlantUUID,UUID];
//         isSuccess = [db executeUpdate:query];
//     }];
//    return isSuccess;
//}
////删除信息
//- (BOOL)delPlantBaikeWithName:(NSString *)name
//{
//    __block BOOL isSuccess = NO;
//    [[DBManager shareSingleton].g_sqlite.queue inDatabase:^(FMDatabase *db)
//     {
//         NSString * query = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = '%@'",kStringPlantTBBaikeName,kStringPlantName,name];
//         isSuccess = [db executeUpdate:query];
//     }];
//    return isSuccess;
//}
@end
