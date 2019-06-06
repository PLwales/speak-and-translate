//
//  HomeTableView.m
//  Translate
//
//  Created by sihao99 on 2019/5/28.
//  Copyright © 2019 SiHan. All rights reserved.
//

#import "HomeTableView.h"
#import "HomeTableViewCell.h"
#import "TranslateModel.h"
#import "HomeNoHistoryViewCell.h"
#import "TranslateDB.h"
#import "BootView.h"
@interface HomeTableView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableview;
@property (nonatomic,strong)NSIndexPath *currentIndexP;
@property (nonatomic,assign) BOOL isShow;
@end

@implementation HomeTableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _isShow =NO;
        CGAffineTransform transform =CGAffineTransformMakeRotation(M_PI);
        [self setTransform:transform];
        self.backgroundColor = [UIColor clearColor];
        self.tableview.backgroundColor = LWClearColor;
    }
    return self;
}

  

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArr.count==0) {
        return self.frame.size.height;
    }else{

        return UITableViewAutomaticDimension;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataArr.count ==0) {
        return 1;
    }else{

        return self.dataArr.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArr.count) {
        HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        TranslateModel *model = [[TranslateModel alloc]init];
        model = self.dataArr[indexPath.row];
        _isShow=  _currentIndexP == indexPath ? YES :NO;
        [cell setHistoryContentTranslateModel:model showTool:_isShow];
        if (indexPath.row ==0) {
            cell.lineView.hidden =YES;
        }else{
            cell.lineView.hidden =NO;
        }
        cell.upDataDBblock = ^{
            self.dataArr = [[[TranslateDB new]_getAllTrnaslateWithType:TypeTranslateDictionary] copy];
            _currentIndexP = nil;
            [self.tableview reloadData];
        };
        cell.againEditblock = ^(NSString * _Nonnull conten, NSString * _Nonnull uuid) {
            if ([self.delegate respondsToSelector:@selector(againEditConten:uuid:)]) {
                [self.delegate againEditConten:conten uuid:uuid];
            }
        };

        return cell;
    }else{
        HomeNoHistoryViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeNoCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        [cell setContent];
        return cell;
    }
    
   
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_currentIndexP ==nil) {
          self.currentIndexP = indexPath;
    }else{
        if (_currentIndexP.row == indexPath.row) {
            self.currentIndexP = nil;
        }else{
            self.currentIndexP = indexPath;
        }
    }
 
    [self.tableview reloadData];
}

#pragma mark settrt getter
-(UITableView *)tableview
{
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) style:UITableViewStylePlain];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.showsVerticalScrollIndicator = NO;
        _tableview.rowHeight = UITableViewAutomaticDimension;
        _tableview.estimatedRowHeight= 100;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:_tableview];
        [_tableview registerClass:[HomeTableViewCell class] forCellReuseIdentifier:@"HomeCell"];
        [_tableview registerClass:[HomeNoHistoryViewCell class] forCellReuseIdentifier:@"HomeNoCell"];
    }
    return _tableview;
}
-(void)setDataArr:(NSArray *)dataArr
{
    _dataArr = dataArr;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableview reloadData];
        HomeTableViewCell *cell = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        NSLog(@"高度 =%@",NSStringFromCGRect(cell.contentView.frame));

        if (![LWUserDefaults integerForKey:ISKeyBootViewHistory]  && self.dataArr.count==1 ) {
            if ([self.delegate respondsToSelector:@selector(homeTableViewOneHistoryCellFrame:)]) {
                [self.delegate homeTableViewOneHistoryCellFrame:cell.contentView.frame];
            }
        }
    });
}


@end
