//
//  SettingTableViewHeadView.h
//  Translate
//
//  Created by sihao99 on 2019/5/31.
//  Copyright © 2019 SiHan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@protocol SettingTableViewHeadViewDelegate <NSObject>

-(void)blackAction;

@end


@interface SettingTableViewHeadView : UIView

@property(nonatomic,weak)id<SettingTableViewHeadViewDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
