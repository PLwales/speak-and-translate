//
//  EvaluationView.h
//  SamCard
//
//  Created by sihan on 2018/4/25.
//  Copyright © 2018年 Xiamen Worldscan Information Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EvaluationViewProtocol <NSObject>

- (void)_evaluationViewProtocolButtonSendIsSend:(BOOL)isSend;

@end

@interface EvaluationView : UIView
- (id)initWithAlertTitle:(NSString *)title
                delegate:(id)delegate;
@end
