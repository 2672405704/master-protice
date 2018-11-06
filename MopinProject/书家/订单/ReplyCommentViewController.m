//
//  ReplyCommentViewController.m
//  MopinProject
//
//  Created by happyzt on 15/12/17.
//  Copyright © 2015年 rt008. All rights reserved.
//

#import "ReplyCommentViewController.h"
#import "XHDHelper.h"

@interface ReplyCommentViewController () {
    UITextView *replayContent;
    PersonalInfoSingleModel *_personalModel;

}

@end

@implementation ReplyCommentViewController


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.navigationItem.title=@"回复评价";
        [self setNavBackBtnWithType:1];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createTextView];
    
    [self createReplyButton];
}


//创建textView
- (void)createTextView {
    replayContent = [[UITextView alloc] initWithFrame:CGRectMake(30,20,mScreenWidth-60,140)];
    replayContent.editable = YES;
    replayContent.layer.cornerRadius = 3;
    replayContent.backgroundColor = [UIColor whiteColor];
    replayContent.text = @"  请输入您的回复";
    replayContent.textColor = [UIColor lightGrayColor];
    replayContent.font = [UIFont systemFontOfSize:15];
    replayContent.delegate = self;
    [self.view addSubview:replayContent];
    [XHDHelper addToolBarOnInputFiled:replayContent Action:@selector(cancleFirst:) Target:self];
    
}


- (void)createReplyButton {
    UIButton *replayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    replayButton.frame = CGRectMake(replayContent.left, replayContent.bottom+25, replayContent.width, 50);
    [replayButton setTitle:@"回复" forState:UIControlStateNormal];
    [replayButton setBackgroundImage:[UIImage imageNamed:@"return_button@2x.png"] forState:UIControlStateNormal];
    [replayButton addTarget:self action:@selector(replayAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:replayButton];
}


#pragma mark -  UITextView delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    textView.text = nil;
    return YES;
}


- (void)textViewDidBeginEditing:(UITextView *)textView {
    if (textView.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入回复内容"];
        return;
    }
}


// 这里限制了一下textView的文本长度
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSString *newString = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    if([newString length] > 200)
    {
        return NO;
    }
    return YES;
}


#pragma mark - 按钮点击事件
// 添加单击手势隐藏键盘
-(void)cancleFirst:(UITapGestureRecognizer *)singleTap
{
    if ([replayContent isFirstResponder])
    {
        [replayContent resignFirstResponder];
        return;
    }
    
}


//TODO：回复评价
- (void)replayAction:(UIButton *)button {
    
    if (replayContent.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入回复内容"];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
    
    [SVProgressHUD show];
    NSMutableDictionary *parameterDic=[NSMutableDictionary dictionary];
    [parameterDic setValue:@"CommentReply" forKey:@"Method"];
    [parameterDic setValue:Infversion forKey:@"Infversion"];
    [parameterDic setValue:_personalModel.UserID forKey:@"UserID"];
    [parameterDic setValue:@"1" forKey:@"EID"];  //评价ID  获取评价列表的出参
    [parameterDic setValue:replayContent.text forKey:@"Content"];
    
    [HTTPMethod NET_request:1 urlStr:HOSTURL ServiceParameters:parameterDic success:^(NSString *reponse) {
        NSData *jsonDate=[reponse dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary * jsonObject = [NSJSONSerialization JSONObjectWithData:jsonDate options:NSJSONReadingAllowFragments error:&error];
        
        NSString * code = [NSString stringWithFormat:@"%@", jsonObject[@"code"]];
        NSString * msg = jsonObject[@"msg"];
        [DictionaryTool showResult:msg withCode:code.integerValue];
        if (code.integerValue == 1000) {
            NSLog(@"%@",jsonObject);
            
            [self.navigationController popViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ReplyContentNotification"
                                                                object:self
                                                              userInfo:@{@"replyContent":replayContent.text}];
            
        }
    } failure:^(NSError *error){
        
        [SVProgressHUD dismiss];
        NSLog(@"error = %@",error);
        
    }];
}




@end
