//
//  RecordingManager.m
//  Translate
//
//  Created by sihan on 2018/11/9.
//  Copyright © 2018年 sihan. All rights reserved.
//

#import "RecordingManager.h"
#import <Speech/Speech.h>
API_AVAILABLE(ios(10.0))
@interface RecordingManager ()<SFSpeechRecognizerDelegate,SFSpeechRecognitionTaskDelegate>
@property (nonatomic, strong) SFSpeechRecognizer *recognizer;
@property (nonatomic, strong) SFSpeechAudioBufferRecognitionRequest * recognitionRequest;
@property (nonatomic, strong) SFSpeechRecognitionTask * recognitionTask ;
@property (nonatomic, strong) AVAudioEngine * audioEngine;
@property (nonatomic, strong) NSTimer *timer; //声明计时器属性
@property (nonatomic, assign)NSInteger seconds;

@end
@implementation RecordingManager
static RecordingManager *recordingManager = nil;

+ (RecordingManager *)recordingManagerInit {
    if(recordingManager == nil) {
        recordingManager = [[RecordingManager alloc]init];
    
    }
    return recordingManager;
    
}
- (void)_setLanguage:(NSString *)language {
    _recognizer = nil;
    _seconds = 0;
    if ([language  isEqualToString:@"auto"]) {
        language  = LWCurrentLanguage;
    }
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:language];
    if (@available(iOS 10.0, *)) {
        _recognizer = [[SFSpeechRecognizer alloc] initWithLocale:locale];
    } else {
        // Fallback on earlier versions
    }
    //把语音识别的代理设置为 self
    _recognizer.delegate = self;
    
}

-(void)requestJurisdiction {
    if (@available(iOS 10.0, *)) {
        [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
            
            BOOL isButtonEnable = NO;
            //检查验证的状态。如果被授权了，让microphone按钮有效。如果没有，打印错误信息然后让microphone按钮失效。
            switch (status) {
                case SFSpeechRecognizerAuthorizationStatusAuthorized:
                {
                    isButtonEnable = YES;
                    NSLog(@"用户授权语音识别");
                }
                    break;
                    
                case SFSpeechRecognizerAuthorizationStatusDenied:
                {
                    isButtonEnable = NO;
                    NSLog(@"用户拒绝授权语音识别");
                }
                    break;
                case SFSpeechRecognizerAuthorizationStatusRestricted:
                {
                    isButtonEnable = NO;
                    NSLog(@"设备不支持语音识别功能");
                }
                    break;
                case SFSpeechRecognizerAuthorizationStatusNotDetermined:
                {
                    isButtonEnable = NO;
                    NSLog(@"结果未知 用户尚未进行选择");
                }
                    break;
            }
        }];
    } else {
        // Fallback on earlier versions
    }
}


- (void)startRecording {
    if (self.recognitionTask) {
        
        NSLog(@"语音d开始释放");
        [self.recognitionTask cancel];
        self.recognitionTask = nil;
    }
    _content = nil;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioInterruption:) name:AVAudioSessionInterruptionNotification object:[AVAudioSession sharedInstance]];

    if (!audioSession) printf("ERROR INITIALIZING AUDIO SESSION! \n");
   
    else{
        
        NSError *nsError = nil;
        if (@available(iOS 10.0, *)) {
            [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord mode:AVAudioSessionModeVideoChat options:AVAudioSessionCategoryOptionDefaultToSpeaker error:&nsError];
        } else {
            // Fallback on earlier versions
        }
        if (nsError) printf("couldn't set audio category!");
        [audioSession setActive:YES error:&nsError];
        if (nsError) printf("AudioSession setActive = YES failed");
    }
//    bool  audioBool = [audioSession setCategory:AVAudioSessionCategoryRecord error:nil];
//    bool  audioBool1= [audioSession setMode:AVAudioSessionModeMeasurement error:nil];
//    bool  audioBool2= [audioSession setActive:true withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
//    if (audioBool || audioBool1||  audioBool2) {
//        NSLog(@"可以使用");
//    }else{
//        NSLog(@"这里说明有的功能不支持");
//    }
    
    AVAudioInputNode *inputNode = self.audioEngine.inputNode;
    
    self.recognitionRequest.shouldReportPartialResults = true;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(printNum) userInfo:nil repeats:YES];

    //开始识别任务
    //把上一过程中得到的语音请求转化成文字，这个过程是时时进行的。
    if (@available(iOS 10.0, *)) {
        self.recognitionTask = [self.recognizer recognitionTaskWithRequest:self.recognitionRequest resultHandler:^(SFSpeechRecognitionResult * _Nullable result, NSError * _Nullable error) {
            bool isFinal = false;
            if (result) {
                NSLog(@"语音转文本");
                //语音转文本
                isFinal = [result isFinal];
                NSString *bestResult = [[result bestTranscription] formattedString];
                self.content = bestResult;
                NSLog(@"语音输出%@",self.content);
                if ([self.delegate respondsToSelector:@selector(returnRecordingToConten:)]) {
                    [self.delegate returnRecordingToConten:self.content];
                }
                _seconds = 0;

            }
            NSLog(@"语音结束");
            if (error || isFinal) {
                NSLog(@"语音释放");
                [self.audioEngine stop];
                [inputNode removeTapOnBus:0];
                [self.recognitionTask cancel];
                self.recognitionRequest = nil;
                self.recognitionTask = nil;
                if ([self.delegate respondsToSelector:@selector(returnEndRecording)]) {
                    [self.delegate returnEndRecording];
                }
            }
        }];

    } else {
        // Fallback on earlier versions
    }
    
//    [inputNode removeTapOnBus:0];

    //将语音引擎得到的语音数据添加到语音识别的请求中，这个过程也就是开始录音后的流程
    AVAudioFormat *recordingFormat = [inputNode outputFormatForBus:0];
    [inputNode installTapOnBus:0 bufferSize:1024 format:recordingFormat block:^(AVAudioPCMBuffer * _Nonnull buffer, AVAudioTime * _Nonnull when) {
        [self.recognitionRequest appendAudioPCMBuffer:buffer];
    }];
    [self.audioEngine prepare];
    NSError * error;
    bool audioEngineBool = [self.audioEngine startAndReturnError:&error];
    if (error) {
        NSLog(@"error----：%@",error);
    }
    NSLog(@"audioEngineBool：%d",audioEngineBool);
}

- (void)endRecording {
    if ([self.audioEngine isRunning]) {
        [self.audioEngine stop];
//        [self.audioEngine.inputNode removeTapOnBus:0];
        [self.recognitionRequest endAudio];
        [self.timer invalidate];
        self.timer =nil;
        _seconds=0;
    }
}
-(void)printNum
{
    _seconds ++;
    NSLog(@"%ld",(long)_seconds);
    if (_seconds>2) {
        [self  endRecording];
        [self.timer invalidate];
        self.timer =nil;
        _seconds=0;
    }
}
#pragma mark - delegate
//当语音识别操作可用性发生改变时会被调用
- (void)speechRecognizer:(SFSpeechRecognizer *)speechRecognizer availabilityDidChange:(BOOL)available API_AVAILABLE(ios(10.0)){
    if (available) {
        NSLog(@"");
    }else{
        
    }
}
//当开始检测音频源中的语音时首先调用此方法
-(void)speechRecognitionDidDetectSpeech:(SFSpeechRecognitionTask *)task
API_AVAILABLE(ios(10.0)){
    NSLog(@"检测语言");

}
//当识别出一条可用的信息后 会调用
/*需要注意，apple的语音识别服务会根据提供的音频源识别出多个可能的结果 每有一条结果可用 都会调用此方法 */
-(void)speechRecognitionTask:(SFSpeechRecognitionTask *)task didHypothesizeTranscription:(SFTranscription *)transcription
API_AVAILABLE(ios(10.0)){
    NSLog(@"识别一条");

}
//当识别完成所有可用的结果后调用
- (void)speechRecognitionTask:(SFSpeechRecognitionTask *)task didFinishRecognition:(SFSpeechRecognitionResult *)recognitionResult
API_AVAILABLE(ios(10.0)) API_AVAILABLE(ios(10.0)){
    NSLog(@"当识别完成所有可用的结果后调用");

}
//当不再接受音频输入时调用 即开始处理语音识别任务时调用
- (void)speechRecognitionTaskFinishedReadingAudio:(SFSpeechRecognitionTask *)task
API_AVAILABLE(ios(10.0)){
    NSLog(@"开始处理语音识别");

}
//当语音识别任务被取消时调用
- (void)speechRecognitionTaskWasCancelled:(SFSpeechRecognitionTask *)task
API_AVAILABLE(ios(10.0)){
    NSLog(@"语音识别取消");

}
//语音识别任务完成时被调用
- (void)speechRecognitionTask:(SFSpeechRecognitionTask *)task didFinishSuccessfully:(BOOL)successfully
API_AVAILABLE(ios(10.0)){
    NSLog(@"语音识别完成");
}
- (void)audioInterruption:(NSNotification *)noti {
    
    NSDictionary *info = noti.userInfo;
    AVAudioSessionInterruptionType type = [info[AVAudioSessionInterruptionTypeKey] unsignedIntegerValue];
    
    if (type == AVAudioSessionInterruptionTypeBegan) {
        
    } else {
        
        AVAudioSessionInterruptionOptions options = [info[AVAudioSessionInterruptionOptionKey] unsignedIntegerValue];
        if (options == AVAudioSessionInterruptionOptionShouldResume) {
            
        }
    }
}
#pragma mark - private methods

#pragma mark - getter or setter
- (AVAudioEngine *)audioEngine {
    if (!_audioEngine) {
        _audioEngine = [[AVAudioEngine alloc]init];
    }
    return _audioEngine;
}
- (SFSpeechAudioBufferRecognitionRequest *)recognitionRequest  API_AVAILABLE(ios(10.0)){
    if (!_recognitionRequest) {
        if (@available(iOS 10.0, *)) {
            _recognitionRequest = [[SFSpeechAudioBufferRecognitionRequest alloc]init];
        } else {
            // Fallback on earlier versions
        }
    }
    return _recognitionRequest;
}
@end
