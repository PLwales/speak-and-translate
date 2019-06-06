//
//  SoundPlayer.h
//  IScanner
//
//  Created by sihan on 2018/10/12.
//  Copyright © 2018年 sihan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface SoundPlayer : NSObject
@property(nonatomic,assign)float rate;   //语速

@property(nonatomic,assign)float volume; //音量

@property(nonatomic,assign)float pitchMultiplier;  //音调

@property(nonatomic,assign)BOOL  autoPlay;  //自动播放
@property (nonatomic,copy)void(^soundPlayStatus)(BOOL status);
//@YES:正在播放
@property (nonatomic, strong) RACSubject *subjectPlayStatus;
//类方法实例出对象

+(SoundPlayer *)SoundPlayerInit;

//基础设置，如果有别的设置，也很好实现

-(void)setDefaultWithVolume:(float)aVolume rate:(CGFloat)aRate pitchMultiplier:(CGFloat)aPitchMultiplier;

//播放并给出文字

-(void)play:(NSString *)string
   language:(NSString *)languageStr;
- (NSString *)_setLanguage:(SystemLanguage)sysLanguage;
- (void)stopPlaer;
- (BOOL)isPlayer;
-(BOOL)isSpeaking;
- (void)_playerWithUrl:(NSString *)urlString;
- (NSString *)_getPlayerLanguegeAbbreviationWithLanguageAB:(NSString *)languageAB;
@end
