//
//  DisclaimerVC.m
//  MixiMixi
//
//  Created by xhd945 on 15/9/10.
//  Copyright (c) 2015年 HuangCaixia. All rights reserved.
//

#import "DisclaimerVC.h"


@interface DisclaimerVC ()<UIWebViewDelegate,UIScrollViewDelegate>
{
    UIWebView *webView;
}

@end

@implementation DisclaimerVC
- (instancetype)initWiteType:(NSInteger)type
{
    self = [super init];
    if (self) {
        _type = type;
        
        [self setNavBackBtnWithType:1];
        
        if(_type == 1)
        {
           self.navigationItem.title=@"退货(款)规则";
            
        }else if(type == 2)
        {
          self.navigationItem.title=@"申请售后";
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *urlStr;
    
    if(_type==1)
    {
      urlStr =BACKGOODSRULE;//@"退货(款)规则";
        
    }else if(_type==2)
    {
       urlStr = @"";
    }
    [self addWebViewWithAddress:urlStr];
    
}
//TODO:免责申明的内容
- (void)addWebViewWithAddress:(NSString*)urlStr
{
    webView = [[UIWebView alloc]initWithFrame:mRect(0,0, kkDeviceWidth, kkDeviceHeight-64)];
    webView.delegate = self;
    NSURL *url = [[NSURL alloc]initWithString:urlStr];
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    webView.scrollView.delegate = self;
    webView.backgroundColor = [UIColor clearColor];
    webView.scrollView.backgroundColor = [UIColor clearColor];
    //移除背景阴影
    UIScrollView*scrollView = webView.scrollView;
    for(int i = 0;i < scrollView.subviews.count ; i++) {
        
        UIView*view = [scrollView.subviews objectAtIndex:i];
        if([view isKindOfClass:[UIImageView class]])
        {
            view.hidden = YES ;
            
        }
    }
    [self.view addSubview:webView];
    
}
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"%@",@"start");
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
   NSLog(@"%@",@"finish");
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"%@----",error);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
      self.navigationController.navigationBarHidden = NO;
}

@end
