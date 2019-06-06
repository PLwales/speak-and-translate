//
//  RequestApiManage.h
//  ScanPlant
//
//  Created by sihan on 2018/7/12.
//  Copyright © 2018年 sihan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AdModel.h"
//#import "BaiduTranslateModel.h"
@class BaiduTranslateModel;
//翻译接口返回
typedef NS_ENUM(NSUInteger, TypeTranslateReslut)
{
    //成功
    TypeTranslateReslutSuccess = 52000,
    //请求超时
    TypeTranslateReslutTimeOut = 52001,
    TypeTranslateReslutSystmError = 52002,
    //译文语言方向不支持
    TypeTranslateReslutlanguageError = 58001,
    TypeTranslateReslutUnknown
};


@interface RequestApiManage : NSObject
@property (nonatomic, assign) NSInteger timeNumber;
//点击广告后的计时器
@property (strong, nonatomic) NSTimer *timer;
//去除限制广告
@property (nonatomic, strong) AdModel * adModel;
+ (RequestApiManage *)gb;
//查询主页广告
+ (void)_selectHomeAD:(void(^)(AdModel * model))completion;
//查询广告
+ (void)_selectAD:(void(^)(AdModel * model))completion;
//查询广告墙
+ (void)_selectADWall:(void(^)(NSMutableArray * arraydata))completion;
//详情页最后一个按钮广告
+ (void)_requestDetailAd:(void(^)(AdModel * admol))completion;
//查询是否在审核
+ (void)_selectReview;
- (void)beginTimer;
//百度翻译
+ (void)_baiduTranslate:(BaiduTranslateModel *)translateModel
             completion:(void(^)(BaiduTranslateModel * model))completion;
@end
