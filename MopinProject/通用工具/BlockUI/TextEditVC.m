//
//  TextEditVC.m
//  YKSSDoctor
//
//  Created by 黄彩霞 on 15/7/16.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "TextEditVC.h"

#define PlaceHoldText [NSString stringWithFormat:@"请输入%@，%ld字以内", _titleName, (long)_maxCount]

@interface TextEditVC ()<UITextViewDelegate, UIAlertViewDelegate>

@end

@implementation TextEditVC
{
    UITextView * _textView; //文本输入
    UILabel * _countLabel; //字数限制
}


- (void)viewDidLoad {
    [super viewDidLoad];
    _isCheck = NO;
    self.navigationItem.title=_titleName;
    [self setNavBackBtnWithType:1];
    [self setRightNavTitleStr:@"确定"];
    [self customView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//TODO:返回上一个界面
- (void)backBtnClick
{
    [self.view endEditing:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"确定放弃编辑吗?" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        [alert show];
        
    });
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        default:
            break;
    }
}
/*确定*/
-(void)rightNavBtnClick
{
    if ([_textView.text hasPrefix:@"请输入"] || !_textView.text.length) {
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"请输入%@", _titleName]];
        return;
    }
    if (_textView.text.length > _maxCount) {
        [SVProgressHUD showErrorWithStatus:@"字数超出限制"];
        return;
    }
    if (_isPhoneNumber) { //检测是否为电话号码
        if (![XHDHelper isphoneStyle:_textView.text]) {
            [SVProgressHUD showErrorWithStatus:@"请输入以1开头的11位电话号码"];
            return;
        }
    }
    _block(_textView.text);
    [self.navigationController popViewControllerAnimated:YES];
}


//TODO:定制界面
- (void)customView
{
    //文本输入
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, 120)];
    _textView.delegate = self;
    _textView.text = _text.length ? _text : PlaceHoldText;
    _textView.textColor = _text.length ? [UIColor blackColor] : [UIColor lightGrayColor];
    if (_isPhoneNumber) {
        _textView.keyboardType = UIKeyboardTypeNumberPad;
    }
    _textView.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:_textView];
    [XHDHelper addToolBarOnInputFiled:_textView Action:@selector(completedEidt) Target:self];
    
    //数字限制
    _countLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, GETVIEWORANGEY(_textView) + GETVIEWHEIGHT(_textView), mScreenWidth - 30, 30)];
    _countLabel.userInteractionEnabled = NO;
    _countLabel.textAlignment = NSTextAlignmentRight;
    _countLabel.textColor = [UIColor lightGrayColor];
    if (_text.length) {
        _countLabel.text = [NSString stringWithFormat:@"%ld/%ld", (long)_maxCount - [XHDHelper getLengthWithString:_text], (long)_maxCount];
    } else {
        _countLabel.text = [NSString stringWithFormat:@"%ld/%ld", (long)_maxCount, (long)_maxCount];
    }
    [self.view addSubview:_countLabel];
}

//TODO:TextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text hasPrefix:PlaceHoldText])
    {
        textView.textColor = [UIColor blackColor];
        textView.text = @"";
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text hasPrefix:PlaceHoldText] || !textView.text.length) {
        textView.textColor = [UIColor lightGrayColor];
        textView.text = PlaceHoldText;
    }
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
    }
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView
{
    NSUInteger len=[XHDHelper getLengthWithString:textView.text];
    NSInteger num = _maxCount - len;
    if (len > _maxCount) {
        num = 0;
    }
    _countLabel.text=[NSString stringWithFormat:@"%lu/%ld",(long)num, (long)_maxCount];
    if(len>_maxCount){
        _countLabel.textColor=[UIColor redColor];
    }else{
        _countLabel.textColor= [UIColor blackColor];
    }
}

-(void)completedEidt
{
    [self.view endEditing:YES];
}


@end
