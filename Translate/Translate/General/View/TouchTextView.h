//
//  TouchTextView.h
//  TextViewTouch
//
//  Created by ldh on 2018/11/18.
//  Copyright © 2018年 ldh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TouchTextView : UITextView
@property (copy, nonatomic) void (^actionWithPapameterBlock)(NSString * stringWord);
@end
