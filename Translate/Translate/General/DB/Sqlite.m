//
//  Sqlite.m
//  ScanPlant
//
//  Created by sihan on 2018/7/9.
//  Copyright © 2018年 sihan. All rights reserved.
//

#import "Sqlite.h"
#define SH_CHECKINVALID(bOK) {if(!bOK){return NO;}}
@interface Sqlite ()
@end

@implementation Sqlite

- (BOOL)openDatabase:(NSString *)DBName {
    if (nil != self.queue)
    {
        [self.queue close];
        self.queue = nil;
    }
    self.queue = [self readyDatabse:DBName];
    if(nil == self.queue) {
        return NO;
    }
    return YES;
}
- (BOOL)closeDataBase {
    if (nil != self.queue) {
        [self.queue close];
        self.queue = nil;
    }
    return YES;
}
- (FMDatabaseQueue *)readyDatabse:(NSString *)DBName
{
    __block BOOL success = FALSE;
    [[Comn gb] _createPath:kStringDBBase];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *DbFilePathName =  [[Comn gb] _getFilePath:kStringDBName fileType:kStringDBBase];
    success = [fileManager fileExistsAtPath:DbFilePathName];
    FMDatabaseQueue *Queue = [FMDatabaseQueue databaseQueueWithPath:DbFilePathName];
    [Queue inDatabase:^(FMDatabase * _Nonnull db) {
        if ([db executeQuery:@"select * from table"] == nil) {
            if ([db open]) {
                [db setShouldCacheStatements:YES];
                if (!success) {
                    [db executeUpdate:@"blah blah blah"];
                    if ([db hadError]) {
                        BOOL result = [self initDataBaseTable:db];
                        if (!result) {
                            success = NO;
                        } else {
                            success = YES;
                        }
                    } else {
                        success = NO;
                    }
                }
            } else {
                success = NO;
            }
        }
    }];
    if (success) {
        return Queue;
    } else {
        return nil;
    }
}
- (BOOL)initDataBaseTable:(FMDatabase*)db {
    BOOL successed = NO;
    SH_CHECKINVALID(db);
    successed = [db executeUpdate:[NSString stringWithFormat:@"create table %@ (%@ text,%@ text,%@ text,%@ text,%@ text,%@ text,%@ text,%@ text,%@ text,%@ text,%@ text,%@ blob,%@ blob)"
                                   ,kStringTranslateTBName
                                   ,kStringTranslateUUID
                                   ,kStringTranslateContent
                                   ,kStringTranslateTranslate
                                   ,kStringTranslateFromLanguage
                                   ,kStringTranslateToLanguage
                                   ,kStringTranslateCreatedTime
                                   ,kStringTranslateType
                                   ,kStringTranslateIsCollect
                                   ,kStringTranslateIsHistory
                                   ,kStringTranslateIsLeft
                                   ,kStringTranslateTranslateClass
                                   ,kStringTranslateBaseInfo
                                   ,kStringTranslateExample
                                   ]];
    SH_CHECKINVALID(successed);
    
//    successed = [db executeUpdate:[NSString stringWithFormat:@"create table %@ (%@ text,%@ text,%@ text,%@ text,%@ text,%@ text,%@ text)"
//                                   ,kStringTranslateHistoryTBName
//                                   ,kStringTranslateHistoryUUID
//                                   ,kStringTranslateHistoryContent
//                                   ,kStringTranslateHistoryTranslate
//                                   ,kStringTranslateHistoryFromLanguage
//                                   ,kStringTranslateHistoryToLanguage
//                                   ,kStringTranslateHistoryCreatedTime
//                                   ,kStringTranslateHistoryType
//                                   ]];
//    SH_CHECKINVALID(successed);
    [db beginTransaction];
    [db commit];
    return YES;
}
@end
