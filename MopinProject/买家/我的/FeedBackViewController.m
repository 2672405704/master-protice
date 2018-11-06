//
//  FeedBackViewController.m
//  MopinProject
//
//  Created by rt008 on 15/12/19.
//  Copyright © 2015年 rt008. All rights reserved.
//

#import "FeedBackViewController.h"
#import "XiaoSongButton.h"

@interface FeedBackViewController ()<UITextViewDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet XiaoSongButton *submitBtn;
@end

@implementation FeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title=@"用户反馈";
    [self setNavBackBtnWithType:1];
    
    _bgView.layer.cornerRadius=3;
    _bgView.layer.masksToBounds=YES;
    
    
}
- (IBAction)submitBtnClick:(id)sender {
    if(_textView.text.length==0){
        [SVProgressHUD showErrorWithStatus:@"请输入反馈内容"];
        return;
    }
    
    _submitBtn.userInteractionEnabled=NO;
    [SVProgressHUD show];
    PersonalInfoSingleModel *personalModel=[PersonalInfoSingleModel shareInstance];
    
    NSMutableDictionary *parameterDic=[NSMutableDictionary dictionary];
    [parameterDic setValue:@"Feedback" forKey:@"Method"];
    [parameterDic setValue:Infversion forKey:@"Infversion"];
    [parameterDic setValue:personalModel.UserID forKey:@"UserID"];
    
    [parameterDic setValue:_textView.text forKey:@"Content"];
    
    [HTTPMethod NET_request:1 urlStr:HOSTURL ServiceParameters:parameterDic success:^(NSString *reponse) {
        NSData *jsonDate=[reponse dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary * jsonObject = [NSJSONSerialization JSONObjectWithData:jsonDate options:NSJSONReadingAllowFragments error:&error];
        
        NSString * code = [NSString stringWithFormat:@"%@", jsonObject[@"code"]];
        NSString * msg = jsonObject[@"msg"];
        [DictionaryTool showResult:msg withCode:code.integerValue];
        
        _submitBtn.userInteractionEnabled=YES;
        if (code.integerValue == 1000) {
            
            
            UIAlertView *AlertView = [[UIAlertView alloc]initWithTitle:@"反馈成功" message:@"感谢您提的宝贵意见,我们将会尽快处理" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [AlertView show];
            
        }
    } failure:^(NSError *error){
        _submitBtn.userInteractionEnabled=YES;
        [SVProgressHUD dismiss];
        NSLog(@"%@",error);
        
    }];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
   if(buttonIndex==0)
   {
      [self backBtnClick];
   }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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
