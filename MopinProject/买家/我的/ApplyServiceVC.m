//
//  ApplyServiceVC.m
//  MopinProject
//
//  Created by xhd945 on 15/12/18.
//  Copyright © 2015年 rt008. All rights reserved.
//

#import "ApplyServiceVC.h"
#import "DisclaimerVC.h"

@interface ApplyServiceVC ()<UITextViewDelegate>
{
    UITextView *applyServiceTextView;
    UIButton *ruleBnt;
    UIButton *redButton;
    NSString *_orderID;
}

@end

@implementation ApplyServiceVC


- (instancetype)initWithorderID:(NSString *)orderID {
    
    self = [super init];
    if (self) {
        
        _orderID = orderID;
        
    }
    
    return self;
    
}

#pragma mark --  视图循环
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title=@"申请售后";
    [self setNavBackBtnWithType:1];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createTextView];
    [self createServiceRuleButton];
    [self createCommitButton];
    
    
}

#pragma mark -- 墨品退货规则按钮
- (void)createServiceRuleButton
{
      ruleBnt = [XHDHelper createButton:mRect(kkDeviceWidth/2.0-70, applyServiceTextView.bottom+20, 140, 21) NomalTitle:@"墨品退换货(款)规则" SelectedTitle:@"墨品退换货(款)规则" NomalTitleColor:MainFontColor SelectTitleColor:MainFontColor NomalImage:nil SelectedImage:nil BoardLineWidth:0 target:self selector:@selector(checkRules:)];
    ruleBnt.titleLabel.font  = UIFONT(15);
    [ruleBnt setTitleColor:THEMECOLOR_1 forState:UIControlStateHighlighted];
    UIView *view = [[UIView alloc]initWithFrame:mRect(0, ruleBnt.height-3, ruleBnt.width, 1)];
    view.backgroundColor = MainFontColor;
    [ruleBnt addSubview:view];
    [self.view addSubview:ruleBnt];
}
/*墨品退货规则按钮动作*/
- (void)checkRules:(UIButton*)sender
{
    DisclaimerVC *dis = [[DisclaimerVC alloc]initWiteType:1];
    [self.navigationController pushViewController:dis animated:YES];

}
#pragma mark -- 申请售后按钮
- (void)createCommitButton
{
    redButton = [XHDHelper getRedGeneralButtonWithFrame:mRect(25, ruleBnt.bottom+25, kkDeviceWidth-50, 45) AndTitleString:@"申请售后"];
    [redButton addTarget:self action:@selector(commitAction:) forControlEvents:UIControlEventTouchUpInside];
    redButton.layer.cornerRadius = 4;
    redButton.clipsToBounds = YES;
    [self.view addSubview: redButton];
}
- (void)commitAction:(UIButton*)sender
{
    redButton.enabled = NO;
     if(applyServiceTextView.text.length==0 ||[applyServiceTextView.text isEqualToString:@"请说明申请售后的原因..."])
     {
         [SVProgressHUD showErrorWithStatus:@"请说明申请售后的原因"];
         redButton.enabled = YES;
         return;
     }else
     {
         [self requestData];
     }
}

#pragma mark -- 输入框
- (void)createTextView
{
    CGRect frame = mRect(0, 0, kkDeviceWidth, 150);
    UIView *textViewBg = [[UIView alloc] initWithFrame:frame];
    textViewBg.backgroundColor = [UIColor whiteColor];
    
    applyServiceTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 5, frame.size.width-20, frame.size.height-10)];
    applyServiceTextView.backgroundColor = [UIColor whiteColor];
    applyServiceTextView.delegate = self;
    applyServiceTextView.text = @"请说明申请售后的原因...";
    applyServiceTextView.font = [UIFont systemFontOfSize:14];
    applyServiceTextView.textColor = TipsFontColor;
    [textViewBg addSubview:applyServiceTextView];
    [XHDHelper addToolBarOnInputFiled:applyServiceTextView Action:@selector(selfEndEditing) Target:self];
    
    [self.view addSubview:textViewBg];
}
- (void)selfEndEditing
{
    [self.view endEditing:YES];
}
/*如果开始编辑状态，则将文本信息设置为空，颜色变为黑色：*/
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    
    textView.text=@"";
    textView.textColor = MainFontColor;
    return YES;
    
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length==0)
    {
        NSString *placeStr;
        
        placeStr =  @"请说明申请售后的原因...";
        
        textView.text = placeStr;
        textView.textColor = TipsFontColor;
    }
    
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
    }
    return YES;
}

#pragma mark -- 网络请求
- (void)requestData
{
    [SVProgressHUD show];
    NSMutableDictionary *parameterDic=[NSMutableDictionary dictionary];
    [parameterDic setValue:@"ApplyCustomerService" forKey:@"Method"];
    [parameterDic setValue:Infversion forKey:@"Infversion"];
    [parameterDic setValue:[PersonalInfoSingleModel shareInstance].UserID forKey:@"UserID"];
    [parameterDic setValue:_orderID forKey:@"OrderCode"];
    [parameterDic setValue:applyServiceTextView.text forKey:@"Content"];
    
    
    [HTTPMethod NET_request:1 urlStr:HOSTURL ServiceParameters:parameterDic success:^(NSString *reponse) {
        
        redButton.enabled = YES;
        
        NSData *jsonDate=[reponse dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary * jsonObject = [NSJSONSerialization JSONObjectWithData:jsonDate options:NSJSONReadingAllowFragments error:&error];
        
        NSString * code = [NSString stringWithFormat:@"%@", jsonObject[@"code"]];
        NSString * msg = jsonObject[@"msg"];
        [DictionaryTool showResult:msg withCode:code.integerValue];
        
        if (code.integerValue == 1000)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateMyOrderList"
                                                                object:nil
                                                              userInfo:nil];
            [self.navigationController popViewControllerAnimated:YES];
            
        }
    } failure:^(NSError *error){
        
        redButton.enabled = YES;
        [SVProgressHUD dismiss];
        NSLog(@"%@",error);
        
    }];
}




@end
