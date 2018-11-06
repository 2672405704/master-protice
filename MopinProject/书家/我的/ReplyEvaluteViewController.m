//
//  ReplyEvaluteViewController.m
//  MopinProject
//
//  Created by rt008 on 15/12/4.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "ReplyEvaluteViewController.h"
#import "EvaluteSampleCell.h"
#import "EvaluteListModel.h"

@interface ReplyEvaluteViewController ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *placeHolderLabel;
@property (weak, nonatomic) IBOutlet UIButton *replyBtn;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@end

@implementation ReplyEvaluteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title=@"评价管理";
    [self setNavBackBtnWithType:1];
    
    _bgView.layer.cornerRadius=3;
    _bgView.layer.masksToBounds=YES;
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keybordShow:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keybordHide) name:UIKeyboardWillHideNotification object:nil];
}
////TODO:键盘隐藏
//- (void)keybordHide
//{
//    [UIView animateWithDuration:0.3 animations:^{
//        _bgScrollView.frame=CGRectMake(0, 0, kkDeviceWidth, kkDeviceHeight-mNavBarHeight);
//    }];
//}
////TODO:键盘显示
//- (void)keybordShow:(NSNotification *)notification
//{
//    //获取键盘高度
//    //    NSDictionary *info=[notification userInfo];
//    //    CGFloat kbHeight = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
//    CGFloat y=_bgScrollView.contentSize.height-_bgScrollView.frame.size.height;
////    if(_imageBgView.frame.size.height!=0){
////        y=667-kkDeviceHeight+95;
////    }else{
////        y=667-kkDeviceHeight;
////    }
//    
//    [_bgScrollView scrollRectToVisible:CGRectMake(0,y<=0?0:y, GETVIEWWIDTH(_bgScrollView), GETVIEWHEIGHT(_bgScrollView)) animated:YES];
//    //获取输入框相对位置
//    //    CGFloat y=rect.origin.y-(kkDeviceHeight-105-kbHeight-mNavBarHeight);
//    //    if(y<=0){
//    //        return;
//    //    }
//    [UIView animateWithDuration:0.3 animations:^{
//        _bgScrollView.frame=CGRectMake(0,-58-100, kkDeviceWidth, kkDeviceHeight-mNavBarHeight);
//    }];
//}
- (IBAction)replyBtnClick:(id)sender {
    if(_textView.text.length==0){
        [SVProgressHUD showErrorWithStatus:@"请输入回复内容"];
        return;
    }
    if([DictionaryTool isValidateEmpty:_textView.text]){
        [SVProgressHUD showErrorWithStatus:@"回复内容不能全为空格"];
        return;
    }
    
    PersonalInfoSingleModel *personalmModel=[PersonalInfoSingleModel shareInstance];
    [SVProgressHUD show];
    
    NSMutableDictionary *parameterDic=[NSMutableDictionary dictionary];
    [parameterDic setValue:@"CommentReply" forKey:@"Method"];
    [parameterDic setValue:Infversion forKey:@"Infversion"];
    [parameterDic setValue:personalmModel.UserID forKey:@"UserID"];
    [parameterDic setValue:_textView.text forKey:@"Content"];
    [parameterDic setValue:_model.EID forKey:@"EID"];
    
    [HTTPMethod NET_request:1 urlStr:HOSTURL ServiceParameters:parameterDic success:^(NSString *reponse) {
        NSData *jsonDate=[reponse dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary * jsonObject = [NSJSONSerialization JSONObjectWithData:jsonDate options:NSJSONReadingAllowFragments error:&error];
        
        NSString * code = [NSString stringWithFormat:@"%@", jsonObject[@"code"]];
        NSString * msg = jsonObject[@"msg"];
        [DictionaryTool showResult:msg withCode:code.integerValue];
        
        if (code.integerValue == 1000) {
            self.reloadCell();
            [self backBtnClick];
        }
    } failure:^(NSError *error){
        
        [SVProgressHUD dismiss];
        NSLog(@"%@",error);
        
    }];
}
#pragma mark textView delegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView
{
    if(textView.text.length>0){
        self.placeHolderLabel.hidden=YES;
        
    }else{
        self.placeHolderLabel.hidden=NO;
        
    }
}
//TODO:处理光标上下跳动
- (void)textViewDidChangeSelection:(UITextView *)textView
{
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        CGRect r = [textView caretRectForPosition:textView.selectedTextRange.end];
        CGFloat caretY =  MAX(r.origin.y - textView.frame.size.height + r.size.height + 8, 0);
        if (textView.contentOffset.y < caretY && r.origin.y != INFINITY) {
            textView.contentOffset = CGPointMake(0, caretY);
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
