//
//  HomeVC.m
//  Translate
//
//  Created by sihao99 on 2019/5/28.
//  Copyright © 2019 SiHan. All rights reserved.
//

#import "HomeVC.h"
#import "HomeView.h"
#import "HomeTableView.h"
#import "RecordingManager.h"
#import "ChangeLanguageVC.h"
#import "RequestApiManage.h"
#import "BaiduTranslateModel.h"
#import "TranslateDB.h"
#import "TranslateModel.h"
#import "SoundPlayer.h"
#import "SettingVC.h"
#import "BootView.h"
#define HOMETABLEVIEWHEIGHT  375*FITScreenHeight


@interface HomeVC ()<HomeViewDelegate,RecordingManagerDelegate,HomeTableViewDelegate>
@property (nonatomic,strong) HomeTableView *homeTableview;
@property (nonatomic,strong) HomeView  *homeView;
@property (nonatomic,strong) UIButton *settingBtn;
@property (nonatomic,assign) BOOL recordingStaete;
@property (nonatomic,assign) BOOL isAgainEditStaete;
@property (nonatomic,strong)NSString *aginEditUUID;
@property (nonatomic,strong) NSString *recordingConten;
@property (nonatomic,strong) NSString *userLanguage;
@property (nonatomic,strong) NSMutableArray *historyData;
@property (nonatomic,strong) NSMutableArray *usedLanguagArr;

@property (nonatomic,assign)CGRect historyOneCellFrame;//第一条历史记录的位置
@property (nonatomic,assign)CGRect textTranslateBtnFrame;//文字翻译 按钮的位置
@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.historyData = [[TranslateDB new] _getAllTrnaslateWithType:TypeTranslateDictionary];
    _recordingStaete = NO;
    _isAgainEditStaete = NO;
    _recordingConten = @"";
    [self getbBackGroundView];
    [self addChildView];
    [self addswipeUpRecognizer];

}

-(void)getbBackGroundView
{
    UIImageView *bgv = [[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    bgv.image = GET_IMAGE(@"background");
    [self.view addSubview:bgv];
}
-(void)addChildView
{
    [self.view addSubview:self.settingBtn];
    [self.view addSubview:self.homeTableview];
    [self.view addSubview:self.homeView];
}
//添加滑动手势 设置语言
-(void)addswipeUpRecognizer
{
    UISwipeGestureRecognizer * recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeUpAction)];
    recognizer.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:recognizer];
}
-(void)swipeUpAction
{
    ChangeLanguageVC *vc  = [ChangeLanguageVC new];
    vc.updataLanguage = ^(NSString * _Nonnull idef) {
        [self.homeView addData];
    };
    [self presentViewController:vc animated:YES completion:nil];

}
#pragma mark  action
-(void)presentSettingVC
{
    [self presentViewController:[SettingVC new] animated:NO completion:nil];
}

#pragma mark   homeTableviewViewDelegate
-(void)againEditConten:(NSString *)content uuid:(nonnull NSString *)uuid
{
    self.aginEditUUID = uuid;
    self.homeView.content = content;
    _isAgainEditStaete = YES;
}
-(void)homeTableViewOneHistoryCellFrame:(CGRect)frame
{
    self.historyOneCellFrame = frame;
    //第一次出现一条历史l记录的时候展示引导页
//    dispatch_async(dispatch_get_main_queue(), ^{
        if (![LWUserDefaults integerForKey:ISKeyBootViewHistory]  && self.historyData.count==1 && self.historyOneCellFrame.size.height > 44) {
            [self showHistoryBootview:self.historyOneCellFrame];
        }
//    });
}
#pragma mark   homeviewDelegate
-(void)homeViewStartTranslate:(NSString *)idef conten:(NSString *)content
{
    self.userLanguage = idef;
    [self starTranslate:content isVoice:NO];
}
-(void)homeViewStartRecording:(NSString *)idef
{
    NSString  *language = idef;
    self.userLanguage = idef;
    if (self.homeView.recordState) {
        [[RecordingManager recordingManagerInit] endRecording];
        return;
    }
    if ([language isEqualToString:ISKeyTanslateDictionaryLanguageTo]) {
        language = [[Comn gb]_getTranslateLanguegeABWithTranslateType:TypeTranslateUseBaidu lanuageString:[[Comn gb] _getToLanguageWithTypeTranslate:TypeTranslateDictionary]];
    }else{
        language = [[Comn gb]_getTranslateLanguegeABWithTranslateType:TypeTranslateUseBaidu lanuageString:[[Comn gb] _getFromLanguageWithTypeTranslate:TypeTranslateDictionary]];
    }
        [[RecordingManager  recordingManagerInit]_setLanguage:language];
        [RecordingManager recordingManagerInit].delegate  = self;
        [[RecordingManager recordingManagerInit] startRecording];

   
}
-(void)homeViewEndRecording
{
    [[RecordingManager recordingManagerInit] endRecording];
    self.homeView.recordState =NO;

}
-(void)homeViewPresentChangeLanguageVC
{
    ChangeLanguageVC *vc  = [ChangeLanguageVC new];
    vc.updataLanguage = ^(NSString * _Nonnull idef) {
        [self.homeView addData];
    };
    [self presentViewController:vc animated:YES completion:nil];
}
-(void)homeViewendEditContentView:(float)hetght
{
    [self showTextTranslateBootview:CGRectMake(10, CGRectGetMinY(self.homeView.frame)+5+hetght, WIDTH_SCREEN-20, 55*FITScreenHeight)];
}
#pragma mark  recordingDelegate
- (void)returnRecordingToConten:(NSString *)content
{
    self.homeView.content = content;
    _recordingConten =content;
    
}
//录音结束。切换状态。 开始翻译
-(void)returnEndRecording
{
    self.homeView.recordState =NO;
    if (_recordingConten) {
        [self starTranslate:_recordingConten isVoice:YES];
    }
}
-(void)starTranslate:(NSString *)conten  isVoice:(BOOL)isVoice
{
    //开始翻译
    BaiduTranslateModel *modelContent;
    modelContent  = isVoice ? [self voiceTovoice:conten] :[self textTovoice:conten];
    [RequestApiManage _baiduTranslate:modelContent completion:^(BaiduTranslateModel *model) {
        NSLog(@"");
        if (model.errorCode) {
            
        }else{
            TranslateDB * translateDB = [TranslateDB new];
            TranslateModel *tranModel = [TranslateModel new];
            tranModel.content = modelContent.content;
            tranModel.toLanguage =[[Comn gb]_getTranslateLanguageWithStr:modelContent.toLanguage];
            tranModel.fromLanguage =[[Comn gb]_getTranslateLanguageWithStr: modelContent.fromLanguage];
            tranModel.translate = model.translateResule;
            tranModel.isCollect= NO;
            tranModel.isHistory = YES;
            tranModel.typeTranslate = TypeTranslateDictionary;
            if ([model.content isEqualToString:@""] || model.translateResule ==nil) {
                
            }else{

                [self addusedLanguage:model.toLanguage];
                [self playPranslation:model];
                if (_isAgainEditStaete) {
                    tranModel.UUID = self.aginEditUUID;
                    [translateDB _updateStatusWithTranslate:tranModel];
                }else{
                    tranModel.UUID = [[Comn gb]_generateUuidString];
                    [translateDB _addTranslateInfo:tranModel];
                }
                self.historyData  = [translateDB _getAllTrnaslateWithType:TypeTranslateDictionary];
                self.homeTableview.dataArr = self.historyData;
            
            }
            self.homeView.content = @"";
        }
        
        
    }];
}

//翻译完之后开始播放译文
-(void)playPranslation:(BaiduTranslateModel *)model
{
    SoundPlayer *playS = [SoundPlayer SoundPlayerInit];
    [playS setDefaultWithVolume:1.0 rate:0.4 pitchMultiplier:-1.0];
    playS.soundPlayStatus = ^(BOOL status) {
        
    };
    [playS play:model.translateResule language:[[Comn gb]_getTranslateLanguegeABWithTranslateType:TypeTranslateUseBaidu lanuageString:model.toLanguage] ];
}

//设置语言 1. 语音录入的情况
//设置语言 2. 文字录入的情况
-(BaiduTranslateModel *)voiceTovoice:(NSString *)str
{
    BaiduTranslateModel *modelContent = [BaiduTranslateModel new];
    modelContent.content = str;
    if (self.userLanguage ==ISKeyTanslateDictionaryLanguageTo) {
        modelContent.fromLanguage = [[Comn gb] _getToLanguageWithTypeTranslate:TypeTranslateDictionary];
        modelContent.toLanguage= [[Comn gb] _getFromLanguageWithTypeTranslate:TypeTranslateDictionary];
    }else{
        modelContent.fromLanguage = [[Comn gb] _getFromLanguageWithTypeTranslate:TypeTranslateDictionary];
        modelContent.toLanguage= [[Comn gb] _getToLanguageWithTypeTranslate:TypeTranslateDictionary];
    }
    
    return modelContent;
}
-(BaiduTranslateModel *)textTovoice:(NSString *)str
{
    BaiduTranslateModel *modelContent = [BaiduTranslateModel new];
    modelContent.content = str;
    if (self.userLanguage ==ISKeyTanslateDictionaryLanguageTo) {
        modelContent.fromLanguage = [[Comn gb] _getFromLanguageWithTypeTranslate:TypeTranslateDictionary];
        modelContent.toLanguage= [[Comn gb] _getToLanguageWithTypeTranslate:TypeTranslateDictionary];
    }else{
        modelContent.fromLanguage = [[Comn gb] _getToLanguageWithTypeTranslate:TypeTranslateDictionary];
        modelContent.toLanguage= [[Comn gb] _getFromLanguageWithTypeTranslate:TypeTranslateDictionary];
    }
    return modelContent;
}

//f翻译成功之后把语言种类添加到s数据中
-(void)addusedLanguage:(NSString *)language
{
    NSArray *userArr= [LWUserDefaults objectForKey:ISKeyTanslateLanguageRecentlyUsed];
    NSArray *arr = [[Comn gb]_getLanguageArray];
    NSInteger inde =[arr indexOfObject:language];
    if (inde != NSNotFound) {
        if ([userArr containsObject:[NSString stringWithFormat:@"%ld",(long)inde]]) {
            NSLog(@"");
        }else{
          NSMutableArray *array = [userArr mutableCopy];
            [array addObject:[NSString stringWithFormat:@"%ld",(long)inde]];
            [LWUserDefaults setObject:array forKey:ISKeyTanslateLanguageRecentlyUsed];
            [LWUserDefaults synchronize];
        }
    }else{
        NSLog(@"不存在");
    }

}


#pragma mark     showBoot
-(void)showTextTranslateBootview:(CGRect)frame
{
    BootView *bootV = [[BootView alloc]initWithFrame:self.view.frame];
    [bootV setTextTranslationBootView:frame];
    [self.view addSubview:bootV];
    [LWUserDefaults setInteger:1 forKey:ISKeyBootViewTextTranslate];
    [LWUserDefaults synchronize];
}
-(void)showHistoryBootview:(CGRect)frame
{
    BootView *bootV = [[BootView alloc]initWithFrame:self.view.frame];
    [bootV setHistoryBootView:CGRectMake(20*FITScreenWidth, HEIGHT_SCREEN-self.homeView.frame.size.height-self.historyOneCellFrame.size.height-10*FITScreenHeight, self.historyOneCellFrame.size.width-40, self.historyOneCellFrame.size.height)];
    [self.view addSubview:bootV];
    [LWUserDefaults setInteger:1 forKey:ISKeyBootViewHistory];
    [LWUserDefaults synchronize];

}
#pragma mark    getter   setter
-(UIButton *)settingBtn
{
    if (!_settingBtn) {
        CGSize size = GET_IMAGE(@"shezhi").size;
        _settingBtn = [[UIButton alloc]initWithFrame:CGRectMake(333*FITScreenWidth, 20*FITScreenHeight, size.width*2, size.height*2)];
        [_settingBtn addTarget:self action:@selector(presentSettingVC) forControlEvents:UIControlEventTouchUpInside];
        [_settingBtn setImage:GET_IMAGE(@"shezhi") forState:UIControlStateNormal];
    }
    return _settingBtn;
}
-(HomeTableView *)homeTableview
{
    if (!_homeTableview) {
        _homeTableview = [[HomeTableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.settingBtn.frame), WIDTH_SCREEN, HOMETABLEVIEWHEIGHT)];
        _homeTableview.delegate = self;
        _homeTableview.dataArr = self.historyData;
    }
    return _homeTableview;
}
-(HomeView *)homeView
{
    if (!_homeView) {
        _homeView =[[HomeView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.homeTableview.frame)+10*FITScreenHeight, WIDTH_SCREEN, HEIGHT_SCREEN-CGRectGetMaxY(self.homeTableview.frame)-10*FITScreenHeight)];
        _homeView.lwDelegate = self;
        [self.view addSubview:_homeView];
    }
    return _homeView;
}


-(NSMutableArray *)historyData
{
    if (!_historyData) {
        _historyData  = [NSMutableArray array];
    }
    return _historyData;
}

@end
