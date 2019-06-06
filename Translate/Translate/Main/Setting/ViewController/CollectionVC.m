//
//  CollectionVC.m
//  Translate
//
//  Created by sihao99 on 2019/5/31.
//  Copyright © 2019 SiHan. All rights reserved.
//

#import "CollectionVC.h"
#import "HomeTableViewCell.h"
#import "TranslateDB.h"
#import "TranslateModel.h"

@interface CollectionVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableview;
@property (nonatomic,copy) NSArray *dataArr;
@property (nonatomic,strong)NSIndexPath *currentIndexP;
@property (nonatomic,assign) BOOL isShow;

@end

@implementation CollectionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isShow = NO;
    [self loadData];
    [self creatBgView];
    self.tableview.backgroundColor =LWClearColor;
}
-(void)creatBgView
{
    UIImageView *bgv = [[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    bgv.image = GET_IMAGE(@"background");
    [self.view addSubview:bgv];
    
    UIButton  *blackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [blackBtn setBackgroundImage:GET_IMAGE(@"setting_black") forState:UIControlStateNormal];
    [blackBtn addTarget:self action:@selector(dismissViewC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:blackBtn];
    [blackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(50);
    }];
    
    UISwipeGestureRecognizer *swipeGes = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(dismissViewC)];
    swipeGes.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeGes];
}
-(void)loadData
{
  NSArray *arr =[[TranslateDB new]_getAllTrnaslateWithType:TypeTranslateDictionary];
    NSMutableArray *mutArr = [NSMutableArray array];
    if (arr.count) {
        for (TranslateModel *model in arr) {
            if (model.isCollect) {
                [mutArr addObject:model];
            }
        }
    }
    self.dataArr = mutArr;
}

-(void)dismissViewC
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CollectCell" forIndexPath:indexPath];
    cell.backgroundColor = LWClearColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    TranslateModel *model = [[TranslateModel alloc]init];
    model = self.dataArr[indexPath.row];
    _isShow=  _currentIndexP == indexPath ? YES :NO;
    [cell setCollectContentTranslateModel:model showTool:_isShow];
    cell.upDataDBblock = ^{
        [self loadData];
        [self.tableview reloadData];
    };
    return cell;
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




-(UITableView *)tableview
{
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 80, WIDTH_SCREEN, HEIGHT_SCREEN-80) style:UITableViewStylePlain];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.showsVerticalScrollIndicator = NO;
        _tableview.rowHeight = UITableViewAutomaticDimension;
        _tableview.estimatedRowHeight= 100;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableview];
        [_tableview registerClass:[HomeTableViewCell class] forCellReuseIdentifier:@"CollectCell"];
    }
    return _tableview;
}

//-(NSMutableArray *)dataArr
//{
//    if (!_dataArr) {
//        _dataArr = [NSMutableArray array];
//    }
//    return _dataArr;
//}


@end
