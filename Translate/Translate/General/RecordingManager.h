//
//  RecordingManager.h
//  Translate
//
//  Created by sihan on 2018/11/9.
//  Copyright © 2018年 sihan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol RecordingManagerDelegate <NSObject>

-(void)returnRecordingToConten:(NSString *)content;
-(void)returnEndRecording; 
@end
@interface RecordingManager : NSObject
@property (nonatomic, strong) NSString * content;
@property (nonatomic,weak) id<RecordingManagerDelegate>delegate;
+ (RecordingManager *)recordingManagerInit;
- (void)_setLanguage:(NSString *)language;
- (void)startRecording;
- (void)endRecording;
@end

NS_ASSUME_NONNULL_END
