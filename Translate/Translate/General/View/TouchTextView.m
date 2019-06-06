//
//  TouchTextView.m
//  TextViewTouch
//
//  Created by ldh on 2018/11/18.
//  Copyright © 2018年 ldh. All rights reserved.
//

#import "TouchTextView.h"

@implementation TouchTextView
// 重写触摸开始函数
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    // 获取当前触摸位置的字符所属的字母(提示：触摸位置需向下调整10个点，以便与文本元素对齐)
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    touchPoint.y -= 10;
    
    // 获取点击的字母的位置
    NSInteger characterIndex = [self.layoutManager characterIndexForPoint:touchPoint inTextContainer:self.textContainer fractionOfDistanceBetweenInsertionPoints:NULL];
    
    // 获取单词的范围。range 由起始位置和长度构成。
    NSRange range = [self getWordRange:characterIndex];
    
    // 高亮单词
    [self modifyAttributeInRange:range];
    
    //调用父类的方法
    [super touchesBegan: touches withEvent: event];
}
//获取单词的范围
- (NSRange)getWordRange:(NSInteger)characterIndex {
    NSInteger left = characterIndex - 1;
    NSInteger right = characterIndex + 1;
    NSInteger length = 0;
    NSString *string = self.attributedText.string;
    
    // 往左遍历直到空格
    while (left >=0) {
        NSString *s=[string substringWithRange:NSMakeRange(left, 1)];
        
        if ([self isLetter:s]) {
            left --;
        } else {
            break;
        }
    }
    
    // 往右遍历直到空格
    while (right < self.text.length) {
        NSString *s=[string substringWithRange:NSMakeRange(right, 1)];
        
        if ([self isLetter:s]) {
            right ++;
        } else {
            break;
        }
    }
    
    // 此时 left 和 right 都指向空格
    left ++;
    right --;
    NSLog(@"letf = %ld, right = %ld",left,right);
    
    length = right - left + 1;
    NSRange range = NSMakeRange(left, length);
    
    return range;
}

//判断是否字母
- (BOOL)isLetter:(NSString *)str {
    char letter = [str characterAtIndex:0];
    
    if ((letter >= 'a' && letter <='z') || (letter >= 'A' && letter <= 'Z')) {
        return YES;
    }
    return NO;
}

//修改属性字符串
- (void)modifyAttributeInRange:(NSRange)range {
    NSString *string = self.attributedText.string;
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc]initWithString:string attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]}];
    
    //添加文字颜色
    [attString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
    //添加文字背景颜色
    [attString addAttribute:NSBackgroundColorAttributeName value:[UIColor yellowColor] range:range];
    self.attributedText = attString;
    NSString * getString = [string substringWithRange:range];
    self.actionWithPapameterBlock(getString);
}


@end
