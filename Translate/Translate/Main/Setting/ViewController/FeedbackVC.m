//
//  FeedbackVC.m
//  Translate
//
//  Created by sihao99 on 2019/6/3.
//  Copyright © 2019 SiHan. All rights reserved.
//

#import "FeedbackVC.h"
#import <AFNetworking.h>

#define ContentPlaceholder   @"描述问题"

@interface FeedbackVC ()<UITextViewDelegate>
@property (nonatomic,strong) UITextView  *feedBackTF;
@property (nonatomic,strong) UITextView *contactTF;
@property (nonatomic,strong) UIButton *submitBtn;
@end

@implementation FeedbackVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self  coutomNavigationController];
    self.view.backgroundColor  = LWRGBColor(239, 239, 239);
    self.feedBackTF.text  = @"描述问题";
    self.contactTF.text = @"联系方式";
    [self.submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [self addGestureRecognizer];
}

-(void)coutomNavigationController
{
    self.navigationController.navigationBar.barTintColor = LWRGB16Color(0x93CCE7, 1);
    UILabel *titleLab = [[UILabel alloc]init];
    titleLab.text =NSLocalizedString(@"Suggestion and Feedback", nil);
    self.navigationItem.titleView= titleLab;
    
    UIButton *backButton = [UIButton new];
    [backButton setBackgroundImage:GET_IMAGE(@"setting_black") forState:UIControlStateNormal];
    backButton.contentMode =  UIViewContentModeScaleAspectFit;
    backButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(swipeGesBlackVc) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem  =[[UIBarButtonItem alloc]initWithCustomView:backButton];
    
}

-(void)addGestureRecognizer
{
    UISwipeGestureRecognizer *swipeGes = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeGesBlackVc)];
    swipeGes.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeGes];
}
-(void)swipeGesBlackVc
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//提交数据
-(void)submitAction
{
    if ( ![self.feedBackTF.text isEqualToString:ContentPlaceholder]) {
        NSString *contactInfo ;
        if ([self.contactTF.text isEqualToString:@"联系方式"]) {
            contactInfo = @"";
        }else{
            contactInfo = self.contactTF.text;
        }
        NSString *URLString = @"http://ws.wordscan.net";
        NSDictionary *parameters = @{@"content":self.feedBackTF.text,
                                     @"contactInfo":contactInfo,
                                     @"systemType":@"0",  //客户端操作系统类型
                                     @"systemVersionNum":IOS_SYSTEM_STRING,//操作系统版本
                                     @"clientVersionNum":_VERSION_NUMBER_,//app版本
                                     @"language":LWCurrentLanguage,//操作系统语言
                                     @"deviceModel":[[Comn gb]getCurrentDeviceModel],//手机型号
                                     @"app_chn_name":NSLocalizedString(@"AppName", nil)//app 中文名
                                     };
        NSData *requestData = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
        //    NSData *requestData =[content dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableURLRequest *storeRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString]];
        [storeRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [storeRequest setHTTPMethod:@"POST"];
        [storeRequest setHTTPBody:requestData];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        [[session dataTaskWithRequest:storeRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (!error) {
                
                NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                NSLog(@"%@",jsonResponse);
           
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.feedBackTF.text = @"";
                    self.contactTF.text =@"";
                    [MBProgressHUDCustom showSuccess:NSLocalizedString(@"send success", nil) toView:self.view];
                    
                });

            }else{
                NSLog(@"%@",error);
            }
            
        }]resume];
        
    }
 
    
}
#pragma mark - UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if(textView.text.length < 1){
        if (textView.tag ==200) {
            textView.text = @"联系方式";

        }else{
            textView.text = @"描述问题";

        }
        textView.textColor = [UIColor grayColor];
    }
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
        textView.text=@"";
        textView.textColor=[UIColor blackColor];
}
-(UITextView *)feedBackTF
{
    if (!_feedBackTF) {
        _feedBackTF = [[UITextView  alloc]init];
    _feedBackTF.textColor = [UIColor grayColor];

        _feedBackTF.delegate = self;
        _feedBackTF.tag = 201;
        [self.view addSubview:_feedBackTF];
        
        [_feedBackTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.top.mas_equalTo((LWgetRectNavAndStatusHight)+10);
        }];
    }
    return _feedBackTF;
}

-(UITextView *)contactTF
{
    if (!_contactTF ) {
        _contactTF = [[UITextView  alloc]init];
        _contactTF.tag = 200;
        _contactTF.delegate = self;
        _contactTF.textColor = [UIColor grayColor];

        _contactTF.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_contactTF];
        [_contactTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.feedBackTF.mas_bottom).mas_equalTo(10);
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.height.mas_equalTo(80);
        }];
    }
    return _contactTF;
}


-(UIButton  *)submitBtn
{
    if (!_submitBtn) {
        _submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _submitBtn .backgroundColor = LWRGB16Color(0x1b82d1, 1);
        _submitBtn.layer.cornerRadius  = 10;
        [_submitBtn addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
        [_submitBtn.layer masksToBounds];
        [self.view addSubview:_submitBtn];
        [_submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.top.mas_equalTo(self.contactTF.mas_bottom).mas_equalTo(20);
            make.height.mas_equalTo(50);
            make.bottom.mas_equalTo(-80);
        }];
    }
    return _submitBtn;
}
@end

