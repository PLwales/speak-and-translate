//
//  HomeTableViewCell.h
//  Translate
//
//  Created by sihao99 on 2019/5/30.
//  Copyright © 2019 SiHan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TranslateModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeTableViewCell : UITableViewCell
//历史记录的cell
-(void)setHistoryContentTranslateModel:(TranslateModel *)model showTool:(BOOL )isShow;
//收藏记录的cell
-(void)setCollectContentTranslateModel:(TranslateModel *)model showTool:(BOOL )isShow;

-(void)updateSoundStatue:(BOOL)statue;
@property (nonatomic,strong)UIView      *lineView;
@property(nonatomic,copy)void(^upDataDBblock)(void);
@property(nonatomic,copy)void(^againEditblock)(NSString *conten,NSString *uuid);
@end

NS_ASSUME_NONNULL_END
