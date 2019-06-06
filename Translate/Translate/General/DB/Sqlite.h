//
//  Sqlite.h
//  ScanPlant
//
//  Created by sihan on 2018/7/9.
//  Copyright © 2018年 sihan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "FMDatabaseQueue.h"

@interface Sqlite : NSObject

@property (nonatomic,retain) FMDatabaseQueue *queue;

-(BOOL)openDatabase:(NSString *)DBName;
-(BOOL)closeDataBase;
@end
