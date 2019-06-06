//
//  DocumentModel.h
//  IScanner
//
//  Created by sihan on 2018/9/18.
//  Copyright © 2018年 sihan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DocumentModel : NSObject
@property (nonatomic, strong) NSString * stringUUID;
@property (nonatomic, strong) NSString * stringTagUUID;
@property (nonatomic, strong) NSString * stringName;
@property (nonatomic, strong) NSString * stringDetail;
@property (nonatomic, strong) NSString * stringCreateTime;
@property (nonatomic, strong) NSString * stringLastModified;
@property (nonatomic, strong) NSString * stringSearchContent;
@property (nonatomic, strong) NSString * stringProcessImgThumbnail;
@property (nonatomic, strong) NSMutableArray * arrayPage;

//显示的时间
@property (nonatomic, strong) NSString * stringLastModifiedShow;
- (BOOL)_addToDB;
- (BOOL)_DelDBInfo;
- (BOOL)_updateDocment;
- (void)_copyDocumentWithDocumentModel:(DocumentModel *)docModel;
@end
