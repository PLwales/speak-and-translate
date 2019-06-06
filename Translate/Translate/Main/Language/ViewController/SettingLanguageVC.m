//
//  SettingLanguageVC.m
//  Translate
//
//  Created by sihao99 on 2019/5/29.
//  Copyright © 2019 SiHan. All rights reserved.
//

#import "SettingLanguageVC.h"
#import "SettingLanguageCell.h"
#import "SettingLanguageTitleCell.h"
#define kTableviewMarginWidth 15*FITScreenWidth
#define kTableviewMarginHeight  64*FITScreenHeight


@interface SettingLanguageVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UIButton *downBtn;
@property (nonatomic,strong) UITableView *tableview;
@property (nonatomic,assign) NSIndexPath *indexpath;//当前选中的行
@property (nonatomic,strong) NSArray *recentlyUsedArr;
@end

@implementation SettingLanguageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self addswipeDownRecognizer];
    self.view.backgroundColor = self.bgcolor;
    [self.downBtn setImage:GET_IMAGE(@"pushdown") forState:UIControlStateNormal];
    self.tableview.backgroundColor  = LWClearColor;
}
-(void)loadData
{
    //获取最近使用的语言
    self.recentlyUsedArr = [LWUserDefaults objectForKey:ISKeyTanslateLanguageRecentlyUsed];
    NSArray *allArr = [[Comn gb]_getLanguageArray];
    NSInteger teger = [allArr indexOfObject:self.currentLanguage];
    //判断当前选中的语言是否在recentlyUsedArr中
    if ([self.recentlyUsedArr containsObject:[NSString stringWithFormat:@"%ld",teger]]) {
        NSInteger  tegerU = [self.recentlyUsedArr  indexOfObject:[NSString stringWithFormat:@"%ld",teger]];
        self.indexpath = [NSIndexPath indexPathForRow:tegerU+1 inSection:0];
    }else{
        self.indexpath = [NSIndexPath indexPathForRow:teger+1 inSection:1];
    }
}
-(void)addswipeDownRecognizer
{
    UISwipeGestureRecognizer * recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(downBtnAction)];
    recognizer.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:recognizer];
}
#pragma mark   tableviewDelegaye datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return self.recentlyUsedArr.count+1;
    }else{
        return [[Comn gb]_getLanguageArray].count+1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section ==0) {
        if (indexPath.row ==0) {
            SettingLanguageTitleCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"cellT" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setTitleContent:NSLocalizedString(@"Recently used languages", nil)];
            return cell;
        }else{
            SettingLanguageCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            NSArray *iconArr = [[Comn gb]_getLanguageImageArray];
            NSArray *languageArr = [[Comn gb]_getLanguageArray];
            NSInteger cellrow = [self.recentlyUsedArr[indexPath.row-1] integerValue];
            [cell setContentCellicon:iconArr[cellrow] Language:languageArr[cellrow]];
            if (self.indexpath.section ==0 &&  self.indexpath.row  ==indexPath.row) {
                cell.currentBtn.hidden = NO;
            }else{
                  cell.currentBtn.hidden = YES;
            }
            return cell;
        }
    }else{
        if (indexPath.row ==0) {
            SettingLanguageTitleCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"cellT" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setTitleContent: [NSString stringWithFormat:@"%d %@",26,NSLocalizedString(@"Languages", nil)]];
            return cell;
        }else{
            SettingLanguageCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            NSArray *iconArr = [[Comn gb]_getLanguageImageArray];
            NSArray *languageArr = [[Comn gb]_getLanguageArray];
            [cell setContentCellicon:iconArr[indexPath.row-1] Language:languageArr[indexPath.row-1]];
            if (self.indexpath.section ==1 &&  self.indexpath.row  ==indexPath.row) {
                cell.currentBtn.hidden = NO;
            }else{
                cell.currentBtn.hidden = YES;
            }
            return cell;
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.indexpath = indexPath;
    [self.tableview reloadData];
    if (self.indexpath.section==0) {
      NSString *integ =   self.recentlyUsedArr[indexPath.row-1];
        [LWUserDefaults setInteger:[integ  integerValue] forKey:self.idf];
    }else{
        [LWUserDefaults setInteger:self.indexpath.row-1 forKey:self.idf];
    }
    [LWUserDefaults synchronize];
    self.updataLanguage(self.idf);
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 圆角弧度半径
    CGFloat cornerRadius = 6.f;
    // 设置cell的背景色为透明，如果不设置这个的话，则原来的背景色不会被覆盖
    cell.backgroundColor = UIColor.clearColor;
    
    // 创建一个shapeLayer
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    CAShapeLayer *backgroundLayer = [[CAShapeLayer alloc] init]; //显示选中
    // 创建一个可变的图像Path句柄，该路径用于保存绘图信息
    CGMutablePathRef pathRef = CGPathCreateMutable();
    // 获取cell的size
    // 第一个参数,是整个 cell 的 bounds, 第二个参数是距左右两端的距离,第三个参数是距上下两端的距离
    CGRect bounds = CGRectInset(cell.bounds, 0, 0);
    
    // CGRectGetMinY：返回对象顶点坐标
    // CGRectGetMaxY：返回对象底点坐标
    // CGRectGetMinX：返回对象左边缘坐标
    // CGRectGetMaxX：返回对象右边缘坐标
    // CGRectGetMidX: 返回对象中心点的X坐标
    // CGRectGetMidY: 返回对象中心点的Y坐标
    
    // 这里要判断分组列表中的第一行，每组section的第一行，每组section的中间行
    
    // CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius);
    if (indexPath.row == 0) {
        // 初始起点为cell的左下角坐标
        CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
        // 起始坐标为左下角，设为p，（CGRectGetMinX(bounds), CGRectGetMinY(bounds)）为左上角的点，设为p1(x1,y1)，(CGRectGetMidX(bounds), CGRectGetMinY(bounds))为顶部中点的点，设为p2(x2,y2)。然后连接p1和p2为一条直线l1，连接初始点p到p1成一条直线l，则在两条直线相交处绘制弧度为r的圆角。
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
        // 终点坐标为右下角坐标点，把绘图信息都放到路径中去,根据这些路径就构成了一块区域了
        CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
        
    } else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
        // 初始起点为cell的左上角坐标
        CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
        // 添加一条直线，终点坐标为右下角坐标点并放到路径中去
        CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
    } else {
        // 添加cell的rectangle信息到path中（不包括圆角）
        CGPathAddRect(pathRef, nil, bounds);
    }
    // 把已经绘制好的可变图像路径赋值给图层，然后图层根据这图像path进行图像渲染render
    layer.path = pathRef;
    backgroundLayer.path = pathRef;
    // 注意：但凡通过Quartz2D中带有creat/copy/retain方法创建出来的值都必须要释放
    CFRelease(pathRef);
    // 按照shape layer的path填充颜色，类似于渲染render
    // layer.fillColor = [UIColor colorWithWhite:1.f alpha:0.8f].CGColor;
    layer.fillColor = [UIColor whiteColor].CGColor;
    
    // view大小与cell一致
    UIView *roundView = [[UIView alloc] initWithFrame:bounds];
    // 添加自定义圆角后的图层到roundView中
    [roundView.layer insertSublayer:layer atIndex:0];
    roundView.backgroundColor = UIColor.clearColor;
    // cell的背景view
    cell.backgroundView = roundView;
    
    // 以上方法存在缺陷当点击cell时还是出现cell方形效果，因此还需要添加以下方法
    // 如果你 cell 已经取消选中状态的话,那以下方法是不需要的.
    UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:bounds];
    backgroundLayer.fillColor = [UIColor clearColor].CGColor;
    [selectedBackgroundView.layer insertSublayer:backgroundLayer atIndex:0];
    selectedBackgroundView.backgroundColor = UIColor.clearColor;
    cell.selectedBackgroundView = selectedBackgroundView;
    
}
#pragma   mark action
-(void)downBtnAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark getter  setter
-(UIButton *)downBtn
{
    if (!_downBtn) {
        _downBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_downBtn addTarget:self action:@selector(downBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_downBtn];
        [_downBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(30*FITScreenHeight);
            make.centerX.mas_equalTo(self.view.mas_centerX);
            make.left.right.mas_equalTo(0);

        }];
    }
    return _downBtn;
}

-(UITableView *)tableview
{
    if (!_tableview ) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(kTableviewMarginWidth,kTableviewMarginHeight, WIDTH_SCREEN-(kTableviewMarginWidth*2),HEIGHT_SCREEN-kTableviewMarginHeight ) style:UITableViewStyleGrouped];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.showsVerticalScrollIndicator = NO;
        [_tableview registerClass:[SettingLanguageCell class] forCellReuseIdentifier:@"cell"];
        [_tableview registerClass:[SettingLanguageTitleCell class] forCellReuseIdentifier:@"cellT"];
        [self.view addSubview:_tableview];
    }
    return _tableview;
}
@end
