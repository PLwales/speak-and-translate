//
//  SoundPlayer.m
//  IScanner
//
//  Created by sihan on 2018/10/12.
//  Copyright © 2018年 sihan. All rights reserved.
//

#import "SoundPlayer.h"
//
//
//使用的例子：
//
//SDSoundPlayer *player = [SDSoundPlayer SDSoundPlayerInit];
//
//[player setDefaultWithVolume:-1.0 rate:0.4 pitchMultiplier:-1.0];
//
//[player play:@"要播放的文字"];
//
@interface SoundPlayer  ()<AVSpeechSynthesizerDelegate>
@property (nonatomic, strong) AVSpeechSynthesizer *player;
@property (nonatomic, strong) AVPlayer * playerURL;
@end
@implementation SoundPlayer
static SoundPlayer *soundplayer = nil;

+(SoundPlayer *)SoundPlayerInit
{
    if(soundplayer == nil)
    {
        soundplayer = [[SoundPlayer alloc]init];
        
        [soundplayer setDefaultWithVolume:-1.0 rate:-1.0 pitchMultiplier:-1.0];
        
    }
    
    return soundplayer;
    
}
- (void)_playerWithUrl:(NSString *)urlString {
    self.playerURL = nil;
    NSURL * url  = [NSURL URLWithString:urlString];
    AVPlayerItem * songItem = [[AVPlayerItem alloc]initWithURL:url];
    AVPlayer * playerURL = [[AVPlayer alloc]initWithPlayerItem:songItem];
    self.playerURL = playerURL;
    [playerURL play];
}
- (NSString *)_getPlayerLanguegeAbbreviationWithLanguageAB:(NSString *)languageAB {
    SystemLanguage index = [[Comn gb] _getCurrentSystemLanguageWithString:languageAB];
    NSArray * arrayL = [[Comn gb] _getLanguageArray];
    NSString * stringLanguage = arrayL[index];
    NSString * languageABNew = [[Comn gb] _getTranslateLanguegeABWithTranslateType:TypeTranslateUseSystemPlayer lanuageString:stringLanguage];
    return languageABNew;
}
- (NSString *)_setLanguage:(SystemLanguage)sysLanguage {
    switch (sysLanguage) {
            case SYSLAN_ENGLISH:
        {
            return @"en-US";
        }
            break;
            case SYSLAN_SIMPLE_CHINESE:
        {
            return @"zh-CN";
        }
            break;
            case SYSLAN_TRADI_CHINESE:
        {
            return @"zh-HK";
        }
            break;
            case SYSLAN_PORTUGUESE:
        {
            return @"pt-PT";
        }
            break;
            case SYSLAN_SPANISH:
        {
            return @"es-ES";
        }
            break;
            case SYSLAN_ITALIAN:
        {
            return @"it-IT";
        }
            break;
            case SYSLAN_FRENCH:
        {
            return @"fr-FR";
        }
            break;
            case SYSLAN_GERMAN:
        {
            return @"de-DE";
        }
            break;
            case SYSLAN_SWEDISH:
        {
            return @"sv-SE";
        }
            break;
            case SYSLAN_JAPANCE:
        {
            return @"ja-JP";
        }
            break;
            case SYSLAN_FINNISH:
        {
            return @"fi-FI";
        }
            break;
            case SYSLAN_DANISH:
        {
            return @"da-DK";
        }
            break;
            case SYSLAN_DUTCH:
        {
            return @"nl-BE";
        }
            break;
            case SYSLAN_RUS:
        {
            return @"ru-RU";
        }
            break;
            case SYSLAN_KOR:
        {
            return @"ko-KR";
        }
            break;
            
        default:
            return @"zh-CN";
            break;
    }
}
- (void)stopPlaer {
    if ([self.player continueSpeaking]) {
        [self.player stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
    }
}
- (BOOL)isPlayer {
    return [self.player continueSpeaking];
}
//判断播放状态
-(BOOL)isSpeaking
{
    return self.player.isSpeaking;
}
//播放声音

-(void)play:(NSString *)string
   language:(NSString *)languageStr

{
    [self stopPlaer];
    self.player = nil;
    NSString * language = nil;
    if (!languageStr) {
        NSUserDefaults * defalut = [NSUserDefaults standardUserDefaults];
        language = [self _setLanguage:(SystemLanguage)[defalut integerForKey:ISKeyRecognitionLanguage]];
    } else {
        language = languageStr;
    }
    if ([language isEqualToString:@"auto"]) {
        language = LWCurrentLanguage;
    }else{
//        language = @"ja-JP";
    }
    if(string && string.length > 0){
       
        AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc]initWithString:string];//设置语音内容
        
        utterance.voice  = [AVSpeechSynthesisVoice voiceWithLanguage:language];//设置语言
        
        utterance.rate   = self.rate;  //设置语速
        
        utterance.volume = self.volume;  //设置音量（0.0~1.0）默认为1.0
        
        utterance.pitchMultiplier    = self.pitchMultiplier;  //设置语调 (0.5-2.0)
        
        utterance.postUtteranceDelay = 1; //目的是让语音合成器播放下一语句前有短暂的暂停
        
        [self.player speakUtterance:utterance];
        
    }
    
}



//初始化配置

/**
 
 *  设置播放的声音参数 如果选择默认请传入 -1.0
 
 *
 
 *  @param aVolume          音量（0.0~1.0）默认为1.0
 
 *  @param aRate            语速（0.0~1.0）
 
 *  @param aPitchMultiplier 语调 (0.5-2.0)
 
 */

-(void)setDefaultWithVolume:(float)aVolume rate:(CGFloat)aRate pitchMultiplier:(CGFloat)aPitchMultiplier

{
    
    self.rate   = aRate;
    
    self.volume = aVolume;
    
    self.pitchMultiplier = aPitchMultiplier;
    
    
    
    if (aRate == -1.0) {
        
        self.rate = 1;
        
    }
    
    if (aVolume == -1.0) {
        
        self.volume = 1.0f;
        
    }
    
    if (aPitchMultiplier == -1.0) {
        
        self.pitchMultiplier = 1;
        
    }
    
}
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didStartSpeechUtterance:(AVSpeechUtterance *)utterance {
//    [self.subjectPlayStatus sendNext:@YES];
    self.soundPlayStatus(YES);
    NSLog(@"开始播放");
}
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance {
//    [self.subjectPlayStatus sendNext:@NO];
    self.soundPlayStatus(NO);
    NSLog(@"完成播放");

}
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didCancelSpeechUtterance:(AVSpeechUtterance *)utterance {
//    [self.subjectPlayStatus sendNext:@NO];
    self.soundPlayStatus(NO);
    NSLog(@"取消播放");

}

- (AVSpeechSynthesizer *)player {
    if (!_player) {
        _player = [[AVSpeechSynthesizer alloc]init];
        _player.delegate = self;
    }
    return _player;
}
- (RACSubject *)subjectPlayStatus {
    if (!_subjectPlayStatus) {
        _subjectPlayStatus = [RACSubject subject];
    }
    return _subjectPlayStatus;
}

@end


