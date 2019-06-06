//
//  FXWebView.h
//  FoxCard
//
//  Created by s w on 14-4-22.
//  Copyright (c) 2014年 Xiamen Worldscan Information Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FXWebView : UIWebView<UIWebViewDelegate>

@property (nonatomic, retain) UIView * btnBackgroungView;     //webView下的放置按钮面
@property (nonatomic, retain) UIButton * goForwardBtn;        //前进按钮
@property (nonatomic, retain) UIButton * goBackBtn;          //后退按钮

@end
