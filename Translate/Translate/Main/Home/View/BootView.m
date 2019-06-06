//
//  BootView.m
//  Translate
//
//  Created by sihao99 on 2019/6/5.
//  Copyright © 2019 SiHan. All rights reserved.
//

#import "BootView.h"

@implementation BootView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.8;
        self.userInteractionEnabled = YES;
        UIButton  *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = frame;
        [btn addTarget:self action:@selector(removeSuperview) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
    return self;
}

-(void)removeSuperview
{
    [self removeFromSuperview];
}

- (void)setHistoryBootView:(CGRect)frame
{
    
    [self setmask:frame];
    [self creatHistoryUI:frame image:@"bootUp"];

}

- (void)setTextTranslationBootView:(CGRect)frame
{
    [self setmask:frame];
    [self creatTextBootUI:frame image:@"bootDown"];

}

-(void)setmask:(CGRect)frame{
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.frame];
//    [path appendPath:[[UIBezierPath bezierPathWithRect:frame] bezierPathByReversingPath]];
    [path appendPath:[[UIBezierPath bezierPathWithRoundedRect:frame cornerRadius:10] bezierPathByReversingPath]];

    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    shapeLayer.backgroundColor = [UIColor redColor].CGColor;
    [self.layer setMask:shapeLayer];
}
-(void)creatHistoryUI:(CGRect )frame  image:(NSString *)imgStr
{
    UIImageView *imageV = [[UIImageView  alloc]initWithImage:GET_IMAGE(imgStr)];
    imageV.frame = CGRectMake(190, CGRectGetMaxY(frame)+10, GET_IMAGE(imgStr).size.width, GET_IMAGE(imgStr).size.height);
    [self addSubview:imageV];
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(45, CGRectGetMaxY(imageV.frame)+10, WIDTH_SCREEN-90, 30)];
    lab.textColor = [UIColor whiteColor];
    lab.text = NSLocalizedString(@"click to edit the translation record", nil);
    lab.font = LWUIFONT(27);
    [self addSubview:lab];
}
-(void)creatTextBootUI:(CGRect )frame  image:(NSString *)imgStr
{
    UIImageView *imageV = [[UIImageView  alloc]initWithImage:GET_IMAGE(imgStr)];
    imageV.frame = CGRectMake(103, frame.origin.y-10-GET_IMAGE(imgStr).size.height, GET_IMAGE(imgStr).size.width, GET_IMAGE(imgStr).size.height);
    [self addSubview:imageV];
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(45, imageV.frame.origin.y-16-30, WIDTH_SCREEN-90, 30)];
    lab.textColor = [UIColor whiteColor];
    lab.text = NSLocalizedString(@"select a language to start the translation", nil);
    lab.font = LWUIFONT(27);
    [self addSubview:lab];
}
@end
