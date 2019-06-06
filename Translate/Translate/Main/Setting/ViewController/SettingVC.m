//
//  SettingVC.m
//  Translate
//
//  Created by sihao99 on 2019/5/31.
//  Copyright © 2019 SiHan. All rights reserved.
//

#import "SettingVC.h"
#import "SettingTableViewCell.h"
#import "SettingTableViewHeadView.h"
#import "CollectionVC.h"
#import "FeedbackVC.h"
#import "EvaluationView.h"
#import "FXWebView.h"
#define kSettingCellHeight  93*FITScreenHeight
#define kSettingHeadHeight   183*FITScreenHeight
#define kStringPrivacy                  @"https://safasfasfasf.github.io/p2/privacy_scanner.html"

@interface SettingVC ()<UITableViewDelegate,UITableViewDataSource,SettingTableViewHeadViewDelegate,EvaluationViewProtocol>
@property (nonatomic,strong)UITableView *tableview;
@property (nonatomic,strong)SettingTableViewHeadView *headView;
@property (nonatomic,copy) NSArray  *iconArr;
@property (nonatomic,copy) NSArray *titleArr;
@end

@implementation SettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    self.tableview.backgroundColor = LWRGB16Color(0x93CCE7, 1);
    [self addGestureRecognizer];
}

-(void)loadData
{
    self.iconArr  = @[@"setting_collect",@"setting_feedback",@"setting_zan",@"setting_yinsi",@"setting_reguide"];
    self.titleArr   = @[NSLocalizedString(@"Favorites", nil),
                        NSLocalizedString(@"Suggestion and Feedback", nil),
                        NSLocalizedString(@"Give us a rating", nil),
                        NSLocalizedString(@"Privacy Policy", nil)
                        ,NSLocalizedString(@"reset boot", nil)];
}
-(void)addGestureRecognizer
{
    UISwipeGestureRecognizer *swipeGes = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(blackAction)];
    swipeGes.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeGes];
}
-(void)swipeGesBlackVc
{
    [self dismissViewControllerAnimated:NO completion:nil];
}
-(void)blackAction
{
    CATransition *animation = [CATransition animation];
    animation.duration = 1.0;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    animation.type = @"kCATransitionPush";
    animation.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:animation forKey:nil];
    
    
    [self dismissViewControllerAnimated:YES completion:nil];

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.iconArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"setCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor =LWClearColor;
    [cell setContentIcon:self.iconArr[indexPath.row] Title:self.titleArr[indexPath.row]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row ==0) {
        [self presentViewController:[CollectionVC new] animated:YES completion:nil];
    }else if (indexPath.row ==1)
    {
        FeedbackVC *fVC = [[FeedbackVC alloc]init];
        UINavigationController *navg = [[UINavigationController alloc]initWithRootViewController:fVC];
        [self presentViewController:navg animated:YES completion:nil];
    }else if (indexPath.row ==2){
        EvaluationView * eval = [[EvaluationView alloc]initWithAlertTitle:[NSString stringWithFormat:NSLocalizedString(@"Give us a rating",nil)] delegate:self];
        [[UIApplication sharedApplication].keyWindow addSubview:eval];
    }else if (indexPath.row ==3){
        NSURL * url = [NSURL URLWithString:kStringPrivacy];
        FXWebView * webView = [[FXWebView alloc]initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, HEIGHT_SCREEN)];
        [webView loadRequest: [NSURLRequest requestWithURL:url]];
        [[UIApplication sharedApplication].keyWindow addSubview:webView];
    }else{
        [LWUserDefaults setInteger:0 forKey:ISKeyBootViewHistory];
        [LWUserDefaults setInteger:0 forKey:ISKeyBootViewTextTranslate];
        [MBProgressHUDCustom showSuccess:NSLocalizedString(@"reset successfully", nil) toView:self.view];
    }
}
-(void)_evaluationViewProtocolButtonSendIsSend:(BOOL)isSend
{
    if (isSend) {
        [[Comn gb] evaluate:_APPID_];
    }
    else
    {
        [MBProgressHUDCustom showSuccess:NSLocalizedString(@"send success", nil) toView:self.view];
    }
}
-(UITableView *)tableview
{
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
        _tableview.rowHeight = kSettingCellHeight;
        _tableview.delegate =self;
        _tableview.dataSource = self;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.showsVerticalScrollIndicator = YES;
        _tableview.tableHeaderView = self.headView;
        [_tableview registerClass:[SettingTableViewCell class] forCellReuseIdentifier:@"setCell"];
        
        [self.view addSubview:_tableview];
    }
    return _tableview;
}
-(SettingTableViewHeadView *)headView
{
    if (!_headView) {
        _headView = [[SettingTableViewHeadView alloc]initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, kSettingHeadHeight)];
        _headView.delegate = self;
    }
    return _headView;
}
@end
