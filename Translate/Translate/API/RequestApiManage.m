//
//  RequestApiManage.m
//  ScanPlant
//
//  Created by sihan on 2018/7/12.
//  Copyright © 2018年 sihan. All rights reserved.
//

#import "RequestApiManage.h"
#import <AFNetworking.h>
#import "BaiduTranslateModel.h"


@implementation RequestApiManage
+(RequestApiManage *)gb {
    static RequestApiManage * mySingleton = nil;
    @synchronized(self) {
        if (mySingleton == nil) {
            mySingleton = [[RequestApiManage alloc]init];
        }
    }
    return mySingleton;
}
- (void)beginTimer
{
    self.timeNumber = 0;
    if ([self.timer isValid]) {
        [self.timer invalidate];
        self.timer = nil;
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(_addTimeNumber) userInfo:nil repeats:YES];
}
-(void)closeTimer
{
    if ([self.timer isValid]) {
        [self.timer invalidate];
        self.timer = nil;
    }
}
- (void)_addTimeNumber {
    self.timeNumber += 1;
    if (self.timeNumber >= 21) {
        //去除限制
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationBuySuccess object:nil];
        [self closeTimer];
        self.timeNumber = 0;
    }
}
+ (void)_requestDetailAd:(void(^)(AdModel * admol))completion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        __block AdModel * admodel = nil;
        NSString *URLString = @"https://common.wordscan.net/api/getadset";
        NSString * stringTag = [NSString stringWithFormat:@"com.icao.translation.detailAd"];
        NSDictionary *parameters = @{@"tag":stringTag};
        NSError * error = nil;
        NSMutableURLRequest * request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:URLString parameters:parameters error:&error];
        NSLog(@"%@",error);
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        NSURLSessionUploadTask *uploadTask;
        uploadTask = [manager
                      uploadTaskWithStreamedRequest:request
                      progress:^(NSProgress * _Nonnull uploadProgress) {
                      }
                      completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                          if (error) {
                              NSLog(@"Error: %@", error);
                          } else {
                              NSLog(@"%@ %@", response, responseObject);
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  if (responseObject[@"data"] != nil) {
                                      NSArray * array = responseObject[@"data"];
                                      if (array.count && [array isKindOfClass:[NSArray class]]) {
                                          for (int i = 0; i<array.count; i++) {
                                              NSMutableDictionary * dic = array[i];
                                              NSString * stringLanguage = NSLocalizedString(@"language", nil);
                                              BOOL isSave = NO;
                                              if ([stringLanguage isEqualToString:@"zh-Hans"]
                                                  &&[dic[@"show_language"] isEqualToString:@"zh-Hans"]) {
                                                  isSave = YES;
                                              } else if (![stringLanguage isEqualToString:@"zh-Hans"]
                                                         &&![dic[@"show_language"] isEqualToString:@"zh-Hans"]){
                                                  isSave = YES;
                                              }
                                              if (isSave) {
                                                  AdModel * admol = [AdModel new];
                                                  if (dic[@"url"]) {
                                                      admol.adLinkUrl = dic[@"url"];
                                                  }
                                                  if (dic[@"name_cn"]) {
                                                      admol.adName = dic[@"name_cn"];
                                                  }
                                                  if (dic[@"content_cn"]) {
                                                      admol.adContent = dic[@"content_cn"];
                                                  }
                                                  if (dic[@"ad_id"]) {
                                                      admol.adId = dic[@"ad_id"];
                                                  }
                                                  admodel = admol;
                                              }
                                          }
                                      }
                                      if (!admodel) {
                                          admodel = [AdModel new];
                                          admodel.adLinkUrl = @"530020778";
                                          admodel.adName = NSLocalizedString(@"WordScan", nil);
                                      }
                                      completion(admodel);
                                  }
                              });
                          }
                      }];
        [uploadTask resume];
    });
}
//查询主页广告
+ (void)_selectHomeAD:(void(^)(AdModel * model))completion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *URLString = @"https://common.wordscan.net/api/getadset";
        NSDictionary *parameters = @{@"tag":@"com.icao.translation.idappGetAd"};
        NSError * error = nil;
        NSMutableURLRequest * request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:URLString parameters:parameters error:&error];
        NSLog(@"%@",error);
        
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        
        NSURLSessionUploadTask *uploadTask;
        uploadTask = [manager
                      uploadTaskWithStreamedRequest:request
                      progress:^(NSProgress * _Nonnull uploadProgress) {
                      }
                      completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                          if (error) {
                              NSLog(@"Error: %@", error);
                              
                          } else {
                              NSLog(@"%@ %@", response, responseObject);
                              
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  if (responseObject[@"data"]!=nil) {
                                      AdModel * admol = [AdModel new];
                                      NSString* strlan = NSLocalizedString(@"language", nil);
                                      if (responseObject[@"data"][@"url"]) {
                                          admol.adLinkUrl = responseObject[@"data"][@"url"];
                                      }
                                      if([strlan isEqualToString:@"zh-Hans"]) {
                                          if (responseObject[@"data"][@"content_0"]) {
                                              admol.adContent = responseObject[@"data"][@"content_0"];
                                          }
                                      }
                                      else {
                                          if (responseObject[@"data"][@"content_1"]) {
                                              admol.adContent = responseObject[@"data"][@"content_1"];
                                          }
                                      }
                                      completion(admol);
                                  }
                              });
                              
                          }
                      }];
        
        [uploadTask resume];
    });
    
}
//查询广告墙
+ (void)_selectADWall:(void(^)(NSMutableArray * arraydata))completion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableArray * arrayData = [NSMutableArray new];
        NSString *URLString = @"https://common.wordscan.net/api/getadset";
        NSDictionary *parameters = @{@"tag":@"com.icao.translation.getgoodappwall"};
        NSError * error = nil;
        NSMutableURLRequest * request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:URLString parameters:parameters error:&error];
        NSLog(@"%@",error);
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        NSURLSessionUploadTask *uploadTask;
        uploadTask = [manager
                      uploadTaskWithStreamedRequest:request
                      progress:^(NSProgress * _Nonnull uploadProgress) {
                      }
                      completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                          if (error) {
                              NSLog(@"Error: %@", error);
                          } else {
                              NSLog(@"%@ %@", response, responseObject);
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  
                                  if (responseObject[@"data"] != nil) {
                                      NSArray * array = responseObject[@"data"];
                                      if (array.count && [array isKindOfClass:[NSArray class]]) {
                                          for (int i = 0; i<array.count; i++) {
                                              NSMutableDictionary * dic = array[i];
                                              if (dic[@"open"])
                                              {
                                                  if ([dic[@"open"] boolValue]) {
                                                      AdModel * admol = [AdModel new];
                                                      if (dic[@"url"]) {
                                                          admol.adLinkUrl = dic[@"url"];
                                                      }
                                                      if (dic[@"name_cn"]) {
                                                          admol.adName = dic[@"name_cn"];
                                                      }
                                                      if (dic[@"icon"]) {
                                                          admol.icon = dic[@"icon"];
                                                      }
                                                      
                                                      if (dic[@"content_cn"]) {
                                                          admol.adContent = dic[@"content_cn"];
                                                      }
                                                      [arrayData addObject:admol];
                                                  }
                                              }
                                          }
                                      }
                                      completion(arrayData);
                                  }
                              });
                          }
                      }];
        [uploadTask resume];
    });
}
//查询广告,去除限制广告
//+ (void)_selectAD:(void(^)(AdModel * model))completion
//{
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSString *URLString = @"https://common.wordscan.net/api/getadset";
//        NSDictionary *parameters = @{@"tag":@"com_icao_scanplant_getadList"};
//        NSError * error = nil;
//        NSMutableURLRequest * request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:URLString parameters:parameters error:&error];
//        NSLog(@"%@",error);
//
//        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
//
//        NSURLSessionUploadTask *uploadTask;
//        uploadTask = [manager
//                      uploadTaskWithStreamedRequest:request
//                      progress:^(NSProgress * _Nonnull uploadProgress) {
//                      }
//                      completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
//                          if (error) {
//                              NSLog(@"Error: %@", error);
//                          } else {
//                              NSLog(@"%@ %@", response, responseObject);
//                              dispatch_async(dispatch_get_main_queue(), ^{
//
//                                  if (responseObject[@"data"]!=nil) {
//                                      NSArray * arayAd = responseObject[@"data"];
//                                      if (arayAd.count) {
//                                          int x = arc4random() % arayAd.count;
//                                          NSMutableDictionary * dic = arayAd[x];
//                                          AdModel * admol = [AdModel new];
//                                          NSString* strlan = NSLocalizedString(@"language", nil);
//                                          if (dic[@"url"]) {
//                                              admol.adLinkUrl = dic[@"url"];
//                                          }
//                                          if (dic[@"operatetype"]) {
//                                              admol.operateType = dic[@"operatetype"];
//                                          }
//                                          if (dic[@"icon"]) {
//                                              admol.icon = dic[@"icon"];
//                                          }
//                                          if([strlan isEqualToString:@"zh-Hans"]) {
//                                              if (dic[@"content_cn"]) {
//                                                  admol.adContent = dic[@"content_cn"];
//                                              }
//                                          }
//                                          else {
//                                              if (dic[@"content_en"]) {
//                                                  admol.adContent = dic[@"content_en"];
//                                              }
//                                          }
//                                          [RequestApiManage gb].adModel = admol;
//                                          completion(admol);
//                                      }
//
//                                  }
//                              });
//                          }
//                      }];
//        [uploadTask resume];
//    });
//}
////查询广告,去除限制广告
+ (void)_selectAD:(void(^)(AdModel * model))completion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *URLString = @"https://common.wordscan.net/api/getadset";
        NSDictionary *parameters = @{@"tag":@"com.icao.translation.getad"};
        NSError * error = nil;
        NSMutableURLRequest * request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:URLString parameters:parameters error:&error];
        NSLog(@"%@",error);

        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];

        NSURLSessionUploadTask *uploadTask;
        uploadTask = [manager
                      uploadTaskWithStreamedRequest:request
                      progress:^(NSProgress * _Nonnull uploadProgress) {
                      }
                      completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                          if (error) {
                              NSLog(@"Error: %@", error);
                          } else {
                              NSLog(@"%@ %@", response, responseObject);
                              dispatch_async(dispatch_get_main_queue(), ^{

                                  if (responseObject[@"data"]!=nil) {
                                      AdModel * admol = [AdModel new];
                                      NSString* strlan = NSLocalizedString(@"language", nil);
                                      if (responseObject[@"data"][@"url"]) {
                                          admol.adLinkUrl = responseObject[@"data"][@"url"];
                                      }
                                      if (responseObject[@"data"][@"operatetype"]) {
                                          admol.operateType = responseObject[@"data"][@"operatetype"];
                                      }
                                      if (responseObject[@"data"][@"icon"]) {
                                          admol.icon = responseObject[@"data"][@"icon"];
                                      }
                                      if([strlan isEqualToString:@"zh-Hans"]) {
                                          if (responseObject[@"data"][@"content_cn"]) {
                                              admol.adContent = responseObject[@"data"][@"content_cn"];
                                          }
                                      }
                                      else {
                                          if (responseObject[@"data"][@"content_en"]) {
                                              admol.adContent = responseObject[@"data"][@"content_en"];
                                          }
                                      }
                                      [RequestApiManage gb].adModel = admol;
                                      completion(admol);
                                  }
                              });
                          }
                      }];
        [uploadTask resume];
    });
}
//查询是否在审核
+ (void)_selectReview
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *URLString = @"https://common.wordscan.net/api/isreviewing";
        NSDictionary *parameters = @{@"bundleid":@"com.icao.translation"
                                     ,@"version":_VERSION_NUMBER_
                                     };
        NSError * error = nil;
        NSMutableURLRequest * request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:URLString parameters:parameters error:&error];
        NSLog(@"%@",error);
        
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        
        NSURLSessionUploadTask *uploadTask;
        uploadTask = [manager
                      uploadTaskWithStreamedRequest:request
                      progress:^(NSProgress * _Nonnull uploadProgress) {
                      }
                      completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                          if (error) {
                              NSLog(@"Error: %@", error);
                          } else {
                              NSLog(@"%@ %@", response, responseObject);
                              if (responseObject[@"data"][@"isreviewing"]) {
                                  [Comn gb].isLimit = [responseObject[@"data"][@"isreviewing"] boolValue];
                              }
                          }
                      }];
        [uploadTask resume];
    });
}
//百度翻译
+ (void)_baiduTranslate:(BaiduTranslateModel *)translateModel
             completion:(void(^)(BaiduTranslateModel * model))completion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *URLString = @"https://fanyi-api.baidu.com/api/trans/vip/translate";
        NSString * appid = [NSString stringWithFormat:@"%ld",APPID_BaiDuTranslate];
        NSString * appkey = [NSString stringWithFormat:@"%@",kEY_BaiDuTranslate];
        NSString * sale = [NSString stringWithFormat:@"%d",rand()];
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSData *data = [translateModel.content dataUsingEncoding:enc];
        NSString *retStr = [[NSString alloc] initWithData:data encoding:enc];
        
        NSString * sign = [NSString stringWithFormat:@"%@%@%@%@",appid,translateModel.content,sale,appkey];
        NSData *dataSign = [sign dataUsingEncoding:enc];
        NSString *signUFT8 = [[NSString alloc] initWithData:dataSign encoding:enc];
        NSString * contentMD5Hash = [Comn MD5HashWithStr:signUFT8];
        
        URLString = [URLString stringByAppendingFormat:@"?q=%@",[Comn URLEncodeWithStr:retStr]];
        if (translateModel.fromLanguage) {
            NSString *language  =[[Comn gb]_getTranslateLanguegeABWithTranslateType:TypeTranslateUseBaidu lanuageString:translateModel.fromLanguage];
            URLString = [URLString stringByAppendingFormat:@"&from=%@",[Comn URLEncodeWithStr:language]];
        }
        
        if (translateModel.toLanguage) {
            NSString *language  =[[Comn gb]_getTranslateLanguegeABWithTranslateType:TypeTranslateUseBaidu lanuageString:translateModel.toLanguage];
            URLString = [URLString stringByAppendingFormat:@"&to=%@",[Comn URLEncodeWithStr:language]];
        }
        URLString = [URLString stringByAppendingFormat:@"&appid=%@",[Comn URLEncodeWithStr:appid]];
        URLString = [URLString stringByAppendingFormat:@"&salt=%@",[Comn URLEncodeWithStr:sale]];
        URLString = [URLString stringByAppendingFormat:@"&sign=%@",[Comn URLEncodeWithStr:contentMD5Hash]];
        
        //2.获得会话对象
        NSURLSession *session = [NSURLSession sharedSession];
        
        //3.根据会话对象创建一个Task(发送请求）
        NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:URLString] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            BaiduTranslateModel * lModel = [BaiduTranslateModel new];
            if (data) {
                //5.解析数据
                NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                if (error) {
                    lModel.errorCode = @"1111";
                    NSLog(@"Error: %@", error);
                } else {
                    if (responseObject[@"error_code"]!=nil) {
                        lModel.errorCode = responseObject[@"error_code"];
                    }
                    NSLog(@"%@ %@", response, responseObject);
                    if (responseObject[@"trans_result"]!=nil) {
                        NSArray * array = responseObject[@"trans_result"];
                        NSMutableString * contentStr = [NSMutableString new];
                        if (array && array.count) {
                            for (int i = 0; i<array.count; i++) {
                                NSDictionary * dic = array[i];
                                if (dic && dic[@"dst"]) {
                                    if (i!=0) {
                                        [contentStr appendString:@"\n"];
                                    }
                                    [contentStr appendFormat:@"%@", dic[@"dst"]];
                                }
                            }
                        }
                        lModel.translateResule = contentStr;
                        lModel.toLanguage = translateModel.toLanguage;
                        lModel.fromLanguage = translateModel.fromLanguage;
                        lModel.content = translateModel.content;
                    }
                }
            } else {
                lModel.errorCode = [NSString stringWithFormat:@"%lu",(unsigned long)TypeTranslateReslutTimeOut];
            }
            completion(lModel);
            
        }];
        
        //4.执行任务
        [dataTask resume];
    });
}

@end
