//
//  PrivateCouponViewController.m
//  MopinProject
//
//  Created by rt008 on 15/12/3.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "PrivateCouponViewController.h"
#import "AppointCouponViewController.h"

@interface PrivateCouponViewController ()<UITextFieldDelegate,UITextViewDelegate>
{
    NSInteger _price;
}
@property (weak, nonatomic) IBOutlet UIScrollView *bgScrollView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@end

@implementation PrivateCouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title=@"指定发券";
    [self setNavBackBtnWithType:1];
    
    _textField.inputAccessoryView=self.keyBordtoolBar;
    _bgScrollView.contentSize=CGSizeMake(kkDeviceWidth, 360);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardHide) name:UIKeyboardWillHideNotification object:nil];
}
//TODO:显示键盘
- (void)keyboardShow
{
    if(iPhone4){
        if([_textField isFirstResponder]){
            self.view.frame=CGRectMake(0,0, kkDeviceWidth, kkDeviceHeight-mNavBarHeight);
        }
    }
    if([_textView isFirstResponder]){
        CGFloat y=kkDeviceHeight-480+mNavBarHeight-200;
        self.view.frame=CGRectMake(0,y>=64?64:y, kkDeviceWidth, kkDeviceHeight-mNavBarHeight);
    }
}
//TODO:隐藏键盘
- (void)keyBoardHide
{
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame=CGRectMake(0,mNavBarHeight, kkDeviceWidth, kkDeviceHeight-mNavBarHeight);
    }];
}
//TODO:加
- (IBAction)rightBtnClick:(id)sender {
    _price+=50;
    _priceLabel.text=[NSString stringWithFormat:@"￥%@",@(_price)];
}
//TODO:减
- (IBAction)leftBtnClick:(id)sender {
    if(_price==0){
        [SVProgressHUD showErrorWithStatus:@"不能再减少了"];
        return;
    }
    _price-=50;
    _priceLabel.text=[NSString stringWithFormat:@"￥%@",@(_price)];
}
- (IBAction)sendBtnClick:(id)sender {
    if(_price==0){
        [SVProgressHUD showErrorWithStatus:@"金额不能为0"];
        return;
    }
    if(![self phoneNumberIsRight:_textField.text]){
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
        return;
    }
    if(_textView.text.length==0){
        [SVProgressHUD showErrorWithStatus:@"请输入送券说明"];
        return;
    }
    if([DictionaryTool isValidateEmpty:_textView.text]){
        [SVProgressHUD showErrorWithStatus:@"送券说明不能全为空格"];
        return;
    }
    AppointCouponViewController *acvc=[[AppointCouponViewController alloc]initWithNibName:@"AppointCouponViewController" bundle:nil];
    acvc.price=[NSString stringWithFormat:@"%@",@(_price)];
    acvc.phoneNumber=_textField.text;
    acvc.intro=_textView.text;
    [self.navigationController pushViewController:acvc animated:YES];
}
//TODO:判断电话号码是11位且为1开头的数字
-(BOOL)phoneNumberIsRight:(NSString *)str{
    if(str.length==11 && [str characterAtIndex:0]=='1'){
        for(int i=1;i<11;i++){
            if([str characterAtIndex:i]<'0' || [str characterAtIndex:i]>'9'){
                return NO;
            }
        }
        return YES;
    }
    return NO;
}
#pragma mark - textField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
