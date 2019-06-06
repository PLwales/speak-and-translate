//
//  GoogleWebView.m
//  Translate
//
//  Created by sihan on 2018/11/2.
//  Copyright © 2018年 sihan. All rights reserved.
//

#import "GoogleWebView.h"

@interface GoogleWebView () <UIWebViewDelegate>

@end
@implementation GoogleWebView
- (void)_setGoogleURL {
    self.delegate = self;
    NSString *str2 = [NSString stringWithFormat:@"https://translate.google.cn/"];
    NSURL *url = [NSURL URLWithString:str2];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self loadRequest:request];
}
#define delegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if (error) {
        [self _setGoogleURL];
    }
}
@end
