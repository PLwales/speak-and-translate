//
//  HomeView.h
//  Translate
//
//  Created by sihao99 on 2019/5/28.
//  Copyright © 2019 SiHan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HomeViewDelegate <NSObject>

//开始翻译文字
-(void)homeViewStartTranslate:(NSString *)idef conten:(NSString *)content;
//开始录音
-(void)homeViewStartRecording:(NSString *)idef;
-(void)homeViewPresentChangeLanguageVC;
-(void)homeViewEndRecording;
-(void)homeViewendEditContentView:(float)hetght;
@end
@interface HomeView : UIView

@property(nonatomic,weak)id<HomeViewDelegate>lwDelegate;
@property (nonatomic,strong)NSString *content;
@property (nonatomic,assign)BOOL recordState;
-(void)addData;
@end

NS_ASSUME_NONNULL_END
