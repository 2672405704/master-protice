//
//  ActivityWebVC.m
//  MopinProject
//
//  Created by xhd945 on 16/2/2.
//  Copyright © 2016年 rt008. All rights reserved.
//

#import "ActivityWebVC.h"
#import "CommonEmptyTableBgView.h"

#import <JavaScriptCore/JavaScriptCore.h>

#import "ExmapleWorkDetailVC.h"
#import "PenmanDetailViewController.h"
#import "AppDelegate.h"
#import "MyTabBarController.h"
#import "LoginViewController.h"

@interface ActivityWebVC ()<UIWebViewDelegate>
{
    NSURL *_URLPath;  //活动地址
    CommonEmptyTableBgView *emptyView; //空载也
    
}
@property (strong,nonatomic)UIWebView *webView;
@property (nonatomic, strong) JSContext *jsContext;

@end

@implementation ActivityWebVC

- (instancetype)initWithURL:(NSURL*)URL
{
    self = [super init];
    if (self) {
        
        _URLPath = URL;
    }
    return self;
}
#pragma mark -- 视图循环
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden=NO;
    self.navigationController.navigationBar.shadowImage=[UIImage imageNamed:@""];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont fontWithName:XiaoBiaoSong size:18]}];
    
    [SVProgressHUD dismiss];
    
    NSLog(@"activity %d",self.navigationController.tabBarController.tabBar.hidden);
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.title=_titleName.length?_titleName:@"墨品";
    [self setNavBackBtnWithType:1];
    [self createWebView];
    
}


#pragma mark -- 创建webview
- (void)createWebView
{
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0,mScreenWidth, mScreenHeight - mNavBarHeight)];
    self.webView.backgroundColor = [UIColor whiteColor];
    self.webView.delegate = self;
    [self.view addSubview:_webView];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:_URLPath]];
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"%@",request.URL.absoluteString);
    
    if([request.URL.absoluteString hasSuffix:@"hello.html"]){
        
        [self.navigationController popViewControllerAnimated:NO];

        AppDelegate * dele = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        [dele.mtbc selectedIndexClick:1];
        
        [_webView removeFromSuperview];
//        [self.navigationController popViewControllerAnimated:YES];
    }
    return YES;
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if(emptyView == nil)
    {
        emptyView = [[CommonEmptyTableBgView alloc]initWithFrame:mRect(0,0, _webView.width, _webView.height)];
        emptyView.tipsString=@"加载失败，请稍后重试！";
        [_webView addSubview:emptyView];
    }
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

}
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    if(emptyView)
    {
        [emptyView removeFromSuperview];
        emptyView = nil;
    }
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

#pragma mark -- JS交互代码
    __weak typeof(self) WeakSelf  = self;
    if (_jsContext == nil) {
        _jsContext = [[JSContext alloc] init];
        
        // 1.
        _jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
        
        // 2. 关联打印异常
        _jsContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
            context.exception = exceptionValue;
            NSLog(@"异常信息：%@", exceptionValue);
        };
        
        /*样品详情*/
        _jsContext[@"toSample"] = ^() {
            NSArray *args = [JSContext currentArguments];
            NSString * ID = [NSString stringWithFormat:@"%@",args.firstObject];
            
            ExmapleWorkDetailVC * vc = [[ExmapleWorkDetailVC alloc] initWithArtID:ID AndArtPrice:@"" PMID:@""];
            [WeakSelf.navigationController pushViewController:vc animated:YES];
        };
        
        /*书家主页*/
        _jsContext[@"toPenman"] = ^() {
            NSArray *args = [JSContext currentArguments];
            NSString * ID = [NSString stringWithFormat:@"%@",args.firstObject];
            
            PenmanDetailViewController * vc = [[PenmanDetailViewController alloc] init];
            vc.penmanID = ID;
            [WeakSelf.navigationController pushViewController:vc animated:YES];
        };
        
        /*跳转墨基金*/
        _jsContext[@"toMojijin"] = ^() {
            NSArray *args = [JSContext currentArguments];
            NSLog(@"===%@===",args);
            [WeakSelf.navigationController popToRootViewControllerAnimated:YES];
            AppDelegate * dele = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [dele.mtbc setSelectedIndex:1];
        };
        /*跳转登录*/
        _jsContext[@"toLogin"] = ^() {
            PersonalInfoSingleModel *personalModel=[PersonalInfoSingleModel shareInstance];
            if(![personalModel isLogin]){
                LoginViewController *lvc=[[LoginViewController alloc]init];
                
                [WeakSelf.navigationController pushViewController:lvc animated:YES];
            }else{
                [super backBtnClick];
            }
        };
    }
    
    
}
- (void)dealloc
{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
