//
//  HomeTableView.h
//  Translate
//
//  Created by sihao99 on 2019/5/28.
//  Copyright © 2019 SiHan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HomeTableViewDelegate <NSObject>

-(void)againEditConten:(NSString *)content uuid:(NSString *)uuid;
-(void)homeTableViewOneHistoryCellFrame:(CGRect)frame;
@end
@interface HomeTableView : UIView
@property (nonatomic,strong)NSArray *dataArr;
@property (nonatomic,assign)BOOL soundStatue;
@property (nonatomic,weak)id<HomeTableViewDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
