//
//  DocumentModel.m
//  IScanner
//
//  Created by sihan on 2018/9/18.
//  Copyright © 2018年 sihan. All rights reserved.
//

#import "DocumentModel.h"
@implementation DocumentModel
- (NSMutableArray *)arrayPage {
    if (!_arrayPage) {
        _arrayPage = [NSMutableArray new];
    }
    return _arrayPage;
}
//- (BOOL)_addToDB {
//    DocumentDB * docDB = [DocumentDB new];
//    return [docDB addDocumentInfo:self];
//}
//- (void)setStringLastModified:(NSString *)stringLastModified {
//    _stringLastModified = stringLastModified;
//    self.stringLastModifiedShow = [[Comn gb] _getTimeWithString:stringLastModified];
//}
//- (void)setTypeDocument:(TypeDocument)typeDocument {
//    _typeDocument = typeDocument;
//    if (self.typeDocument == TypeDocumentPDF) {
//        self.stringDetail = NSLocalizedString(@"PDF document", nil);
//    }
//}
//- (void)_updateSearchContent
//- (BOOL)_DelDBInfo {
//    DocumentDB * docDB = [DocumentDB new];
//    return [docDB delDocumentWithUUID:self.stringUUID];
//}
//- (BOOL)_updateDocment {
//    DocumentDB * documentDB = [DocumentDB new];
//    return [documentDB _updateDocment:self];
//}
//- (void)_copyDocumentWithDocumentModel:(DocumentModel *)docModel {
//    self.stringUUID = [[Comn gb] generateUuidString];
//    self.stringName = docModel.stringName;
//    self.stringDetail = docModel.stringDetail;
//    self.stringCreateTime = [[Comn gb] getCurrentTime];
//    self.stringLastModified = self.stringCreateTime;
//    self.stringSearchContent = docModel.stringSearchContent;
//    self.stringProcessImgThumbnail = docModel.stringProcessImgThumbnail;
//    self.typeDocument = docModel.typeDocument;
//}
@end
