//
//  TranslateDB.m
//  Translate
//
//  Created by sihan on 2018/10/31.
//  Copyright © 2018年 sihan. All rights reserved.
//

#import "TranslateDB.h"
#import "DBManager.h"

@implementation TranslateDB
- (BOOL)_addTranslateInfo:(TranslateModel *)translate
{
    __block BOOL isSuccess = NO;
    [[DBManager shareSingleton].g_sqlite.queue inDatabase:^(FMDatabase *db) {
        
        NSMutableString * query = [[NSMutableString alloc]initWithFormat:@"INSERT INTO %@",kStringTranslateTBName];
        NSMutableString * keys = [[NSMutableString alloc]initWithString:@" ("];
        NSMutableString * values = [[NSMutableString alloc]initWithString:@" ( "];
        NSMutableArray * arguments = [NSMutableArray new];
        
        if (translate.UUID) {
            [keys appendFormat:@"%@,",kStringTranslateUUID];
            [values appendString:@"?,"];
            [arguments addObject:translate.UUID];
        }
        if (translate.content) {
            
            [keys appendFormat:@"%@,",kStringTranslateContent];
            [values appendString:@"?,"];
            [arguments addObject:translate.content];
        }
        if (translate.translate) {
            
            [keys appendFormat:@"%@,",kStringTranslateTranslate];
            [values appendString:@"?,"];
            [arguments addObject:translate.translate];
        }
        if (translate.fromLanguage) {
            
            [keys appendFormat:@"%@,",kStringTranslateFromLanguage];
            [values appendString:@"?,"];
            [arguments addObject:translate.fromLanguage];
        }
        if (translate.toLanguage) {
            
            [keys appendFormat:@"%@,",kStringTranslateToLanguage];
            [values appendString:@"?,"];
            [arguments addObject:translate.toLanguage];
        }
        if (translate.createTime) {
            
            [keys appendFormat:@"%@,",kStringTranslateCreatedTime];
            [values appendString:@"?,"];
            [arguments addObject:translate.createTime];
        }
//        if (translate.dictionaryBaseInfo) {
//            
//            [keys appendFormat:@"%@,",kStringTranslateBaseInfo];
//            [values appendString:@"?,"];
//            [arguments addObject:translate.dictionaryBaseInfo];
//        }
        [keys appendFormat:@"%@,",kStringTranslateType];
        [values appendString:@"?,"];
        [arguments addObject:[NSString stringWithFormat:@"%lu",(unsigned long)translate.typeTranslate]];
        
        
        [keys appendFormat:@"%@,",kStringTranslateIsCollect];
        [values appendString:@"?,"];
        [arguments addObject:[NSString stringWithFormat:@"%d",translate.isCollect]];
        
        
        [keys appendFormat:@"%@,",kStringTranslateIsHistory];
        [values appendString:@"?,"];
        [arguments addObject:[NSString stringWithFormat:@"%d",translate.isHistory]];
        
        [keys appendFormat:@"%@,",kStringTranslateIsLeft];
        [values appendString:@"?,"];
        [arguments addObject:[NSString stringWithFormat:@"%d",translate.isLeft]];
        
        [keys appendFormat:@"%@,",kStringTranslateTranslateClass];
        [values appendString:@"?,"];
        [arguments addObject:[NSString stringWithFormat:@"%lu",(unsigned long)translate.typeTranslateClass]];
        
        if (translate.dictionaryBaseInfo && translate.dictionaryBaseInfo.count)
        {
            [keys appendFormat:@"%@,",kStringTranslateBaseInfo];
            [values appendString:@"?,"];
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:translate.dictionaryBaseInfo];
            [arguments addObject:data];
        }
        if (translate.arrayExample && translate.arrayExample.count)
        {
            [keys appendFormat:@"%@,",kStringTranslateExample];
            [values appendString:@"?,"];
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:translate.arrayExample];
            [arguments addObject:data];
        }
        
        [keys appendString:@")"];
        [values appendString:@")"];
        [query appendFormat:@" %@ VALUES%@",
         [keys stringByReplacingOccurrencesOfString:@",)" withString:@")"],
         [values stringByReplacingOccurrencesOfString:@",)" withString:@")"]];
        NSLog(@"%@",query);
        
        isSuccess = [db executeUpdate:query withArgumentsInArray:arguments];
        
    }];
    return isSuccess;
    
}
- (NSMutableArray*)_getAllTrnaslateWithType:(TypeTranslate)typeTranslate {
    TypeTranslate type = typeTranslate;
    if (typeTranslate>TypeTranslateDictionary) {
        type -= 2;
    }
    if (typeTranslate == TypeTranslateHistoryDictionary || typeTranslate == TypeTranslateCollectDictionary || typeTranslate == TypeTranslateDictionary) {
        type = TypeTranslateDictionary;
    } else if (typeTranslate == TypeTranslateDialogue) {
        type = TypeTranslateDialogue;
    } else {
        type = TypeTranslateWord;
    }
    BOOL isHistory = (typeTranslate == TypeTranslateHistoryDictionary || typeTranslate == TypeTranslateHistoryWord || typeTranslate == TypeTranslateDialogue);
    BOOL isCollect = (typeTranslate == TypeTranslateCollectDictionary || typeTranslate == TypeTranslateCollectWord);
    __block NSMutableArray *infoAr = [NSMutableArray array];
    [[DBManager shareSingleton].g_sqlite.queue inDatabase:^(FMDatabase *db) {
        NSString * stringQ = [NSString stringWithFormat:@"select * from %@ where %@",kStringTranslateTBName,kStringTranslateType];
        if (isHistory) {
            stringQ = [NSString stringWithFormat:@"%@ = %@",stringQ,[NSString stringWithFormat:@"%lu",(unsigned long)type]];
            stringQ = [NSString stringWithFormat:@"%@ and %@ = %@ order by %@",stringQ,kStringTranslateIsHistory,@"1",kStringTranslateCreatedTime];
        } else if (isCollect) {
            if (type == TypeTranslateDictionary) {
                stringQ = [NSString stringWithFormat:@"%@ = %@",stringQ,[NSString stringWithFormat:@"%lu",(unsigned long)type]];
            } else {
                //对话的收藏也在收藏表中
                stringQ = [NSString stringWithFormat:@"%@ != %@",stringQ,[NSString stringWithFormat:@"%lu",(unsigned long)TypeTranslateDictionary]];
            }
            stringQ = [NSString stringWithFormat:@"%@ and %@ = %@ order by %@",stringQ,kStringTranslateIsCollect,@"1",kStringTranslateCreatedTime];
        } else {
            stringQ = [NSString stringWithFormat:@"%@ = %@",stringQ,[NSString stringWithFormat:@"%lu",(unsigned long)type]];
//            stringQ = [NSString stringWithFormat:@"%@ order by %@",stringQ,kStringTranslateCreatedTime];
        }
         FMResultSet *rs = [db executeQuery:stringQ];
         while ([rs next]) {
             TranslateModel * translate = [TranslateModel new];
             translate.UUID = [rs stringForColumn:kStringTranslateUUID];
             translate.content = [rs stringForColumn:kStringTranslateContent];
             translate.translate = [rs stringForColumn:kStringTranslateTranslate];
             translate.fromLanguage = [rs stringForColumn:kStringTranslateFromLanguage];
             translate.toLanguage = [rs stringForColumn:kStringTranslateToLanguage];
             translate.createTime = [rs stringForColumn:kStringTranslateCreatedTime];
             translate.typeTranslate = [[rs stringForColumn:kStringTranslateType] integerValue];
             translate.isHistory = [[rs stringForColumn:kStringTranslateIsHistory] integerValue];
             translate.isCollect = [[rs stringForColumn:kStringTranslateIsCollect] integerValue];
             translate.isLeft = [[rs stringForColumn:kStringTranslateIsLeft] integerValue];
             translate.typeTranslateClass = [[rs stringForColumn:kStringTranslateTranslateClass] integerValue];
             NSData * dataBase = [rs dataForColumn:kStringTranslateBaseInfo];
             if (dataBase) {
                 translate.dictionaryBaseInfo = [NSKeyedUnarchiver unarchiveObjectWithData:dataBase];
             }
             NSData * dataExaplem = [rs dataForColumn:kStringTranslateExample];
             if (dataExaplem) {
                 translate.arrayExample = [NSKeyedUnarchiver unarchiveObjectWithData:dataExaplem];
             }
             [infoAr insertObject:translate atIndex:0];
         }
         [rs close];
     }];
    return infoAr;
}
- (TranslateModel *)_getTrnaslateWithModel:(TranslateModel *)translateModel {
    __block TranslateModel *translate = [TranslateModel new];
    [[DBManager shareSingleton].g_sqlite.queue inDatabase:^(FMDatabase *db) {
        NSString * stringContent = [translateModel.content stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
        NSString * stringTranslate = [translateModel.translate stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
        NSString * stringQu = [NSString stringWithFormat:@"select * from %@ where %@ = '%@' and %@ = '%@' and %@ = '%@'",kStringTranslateTBName,kStringTranslateContent,stringContent,kStringTranslateTranslate,stringTranslate,kStringTranslateType,[NSString stringWithFormat:@"%lu",(unsigned long)translateModel.typeTranslate]];
        FMResultSet *rs = [db executeQuery:stringQu];
        while ([rs next]) {
            translate.UUID = [rs stringForColumn:kStringTranslateUUID];
            translate.content = [rs stringForColumn:kStringTranslateContent];
            translate.translate = [rs stringForColumn:kStringTranslateTranslate];
            translate.fromLanguage = [rs stringForColumn:kStringTranslateFromLanguage];
            translate.toLanguage = [rs stringForColumn:kStringTranslateToLanguage];
            translate.createTime = [rs stringForColumn:kStringTranslateCreatedTime];
            translate.typeTranslate = [[rs stringForColumn:kStringTranslateType] integerValue];
            translate.isHistory = [[rs stringForColumn:kStringTranslateIsHistory] integerValue];
            translate.isCollect = [[rs stringForColumn:kStringTranslateIsCollect] integerValue];
            translate.isLeft = [[rs stringForColumn:kStringTranslateIsLeft] integerValue];
            translate.typeTranslateClass = [[rs stringForColumn:kStringTranslateTranslateClass] integerValue];
            NSData * dataBase = [rs dataForColumn:kStringTranslateBaseInfo];
            if (dataBase) {
                translate.dictionaryBaseInfo = [NSKeyedUnarchiver unarchiveObjectWithData:dataBase];
            }
            NSData * dataExaplem = [rs dataForColumn:kStringTranslateExample];
            if (dataExaplem) {
                translate.arrayExample = [NSKeyedUnarchiver unarchiveObjectWithData:dataExaplem];
            }
        }
        [rs close];
    }];
    return translate;
}
- (BOOL)_delTranslateWithUUID:(NSString *)UUID {
    __block BOOL isSuccess = NO;
    [[DBManager shareSingleton].g_sqlite.queue inDatabase:^(FMDatabase *db)
     {
         NSString * query = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = '%@'",kStringTranslateTBName,kStringTranslateUUID,UUID];
         isSuccess = [db executeUpdate:query];
     }];
    return isSuccess;
}
- (BOOL)_delTranslateWithType:(TypeTranslate)typeTranslate {
    
    __block BOOL isSuccess = NO;
    [[DBManager shareSingleton].g_sqlite.queue inDatabase:^(FMDatabase *db) {
         NSString * query = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = '%@'",kStringTranslateTBName,kStringTranslateType,[NSString stringWithFormat:@"%lu",(unsigned long)typeTranslate]];
         isSuccess = [db executeUpdate:query];
     }];
    return isSuccess;
}
- (BOOL)_updateStatusWithTranslate:(TranslateModel *)translate
{
    __block BOOL isSuccess = NO;
    [[DBManager shareSingleton].g_sqlite.queue inDatabase:^(FMDatabase *db)
     {
         NSString * query = [NSString stringWithFormat:@"UPDATE %@ SET",kStringTranslateTBName];
         NSMutableString * temp = [NSMutableString stringWithCapacity:1];
         [temp appendFormat:@" %@ = '%@',",kStringTranslateIsHistory,[NSString stringWithFormat:@"%d",translate.isHistory]];
         [temp appendFormat:@" %@ = '%@',",kStringTranslateIsCollect,[NSString stringWithFormat:@"%d",translate.isCollect]];
         [temp appendFormat:@" %@ = '%@',",kStringTranslateTranslate,[NSString stringWithFormat:@"%@",translate.translate]];
         [temp appendFormat:@" %@ = '%@',",kStringTranslateCreatedTime,translate.createTime];
         [temp appendString:@")"];
         query = [query stringByAppendingFormat:@"%@ WHERE %@ = '%@'",
                  [temp stringByReplacingOccurrencesOfString:@",)" withString:@""],kStringTranslateUUID,translate.UUID];

         isSuccess = [db executeUpdate:query];
     }];
    return isSuccess;
}
@end
