//
//  ChooseWordNumViewController.m
//  MopinProject
//
//  Created by rt008 on 15/11/27.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "ChooseWordNumViewController.h"
#import "PublishSampleModel.h"

@interface ChooseWordNumViewController ()<UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate>
{
    NSInteger _minWordNum;
    NSInteger _maxWordNum;
    UITextField *_textField;
    NSInteger _selectedBtn;
}
@end

@implementation ChooseWordNumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if(_type==1){
        self.navigationItem.title=@"正文字数";
         [self createPickerView];
    }else if(_type==2){
        self.navigationItem.title=@"样品内容";
        [self createTextField];
    }else{
        self.navigationItem.title=@"是否题款";
        [self createChooseBtn];
    }
    [self setNavBackBtnWithType:1];
    
    [self createBottomButton];
}
//TODO:点击屏幕回收键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
//TODO:创建底部确定按钮
- (void)createBottomButton
{
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(0, kkDeviceHeight-mTabBarHeight-mNavBarHeight, kkDeviceWidth, mTabBarHeight);
    button.titleLabel.font=[UIFont fontWithName:XiaoBiaoSong size:18];
    [button setTitle:@"确定" forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"red_button_apply.png"] forState:UIControlStateNormal];
    [self.view addSubview:button];
    
    [button addTarget:self action:@selector(sureButoonClick) forControlEvents:UIControlEventTouchUpInside];

}
//TODO:创建按钮选择
- (void)createChooseBtn
{
    if(_publishModel.TiKuan.length!=0){
        _selectedBtn=_publishModel.TiKuan.integerValue;
    }else{
        _selectedBtn=-1;
    }
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kkDeviceWidth, 44)];
    bgView.backgroundColor=[UIColor whiteColor];
    NSArray *titleArr=@[@"接受题款",@"不接受题款"];
    for(int i=0;i<2;i++){
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font=[UIFont systemFontOfSize:15];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitle:titleArr[i] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"gou_red_sample.png"] forState:UIControlStateSelected];
        [button setImage:[UIImage imageNamed:@"point_sample.png"] forState:UIControlStateNormal];
        button.frame=CGRectMake((kkDeviceWidth-60)/2*i,0, (kkDeviceWidth-60)/2, 44);
        button.titleEdgeInsets=UIEdgeInsetsMake(0, 5, 0, 0);
        button.imageEdgeInsets=UIEdgeInsetsMake(0, -5, 0, 0);
        [bgView addSubview:button];
        button.tag=101-i;
        [button addTarget:self action:@selector(chooseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        if(_selectedBtn==button.tag-100){
            button.selected=YES;
        }
    }
    [self.view addSubview:bgView];
}
//TODO:点击题款按钮
- (void)chooseBtnClick:(UIButton *)button
{
    button.selected=YES;
    if(button.tag==100){
        UIButton *noSelectedBtn=(UIButton *)[self.view viewWithTag:101];
        noSelectedBtn.selected=NO;
    }else{
        UIButton *noSelectedBtn=(UIButton *)[self.view viewWithTag:100];
        noSelectedBtn.selected=NO;
    }
    _selectedBtn=button.tag-100;
}
//TODO:创createChooseBtn建输入框
- (void)createTextField
{
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kkDeviceWidth, 44)];
    bgView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:bgView];
    _textField=[[UITextField alloc]initWithFrame:CGRectMake(30, 0, kkDeviceWidth-60, 44)];
    _textField.placeholder=@"请输入样品正文内容";
    _textField.font=[UIFont systemFontOfSize:15];
    if(_publishModel.Content.length!=0){
        _textField.text=_publishModel.Content;
    }
    _textField.delegate=self;
    [bgView addSubview:_textField];
}
//TODO:点击底部按钮
- (void)sureButoonClick
{
    if(_type==1){
        if(_minWordNum>_maxWordNum){
            [SVProgressHUD showErrorWithStatus:@"右边的数字不能小于左边的数字"];
            return;
        }
        self.chooseWordNum(_minWordNum,_maxWordNum);
    }else if(_type==2){
        if(_textField.text.length==0){
            [SVProgressHUD showErrorWithStatus:@"请输入样品正文内容"];
            return;
        }
        if([DictionaryTool isValidateEmpty:_textField.text]){
            [SVProgressHUD showErrorWithStatus:@"样品内容不能全为空格"];
            return;
        }
        if(_textField.text.length>SAMPLE_CONTENT_LENGTH){
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"样品内容不能超过%@个字",@(SAMPLE_CONTENT_LENGTH)]];
            return;
        }
        self.inputText(_textField.text);
    }else{
        if(_selectedBtn==-1){
            [SVProgressHUD showErrorWithStatus:@"请选择是否接受题款"];
            return;
        }
        self.chooseTikuan(_selectedBtn);
    }
    [self backBtnClick];
}
//TODO:创建pickerView
- (void)createPickerView
{
    UIPickerView *pickerView=[[UIPickerView alloc]initWithFrame:CGRectMake(0, 0, kkDeviceWidth,162)];
    pickerView.backgroundColor=[UIColor whiteColor];
//    pickerView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    pickerView.frame=CGRectMake(0, 0, kkDeviceWidth, 162);
    pickerView.delegate=self;
    pickerView.dataSource=self;
    if(_publishModel.MinWordNum.length!=0){
        [pickerView selectRow:_publishModel.MinWordNum.integerValue-1 inComponent:0 animated:YES];
        [pickerView selectRow:_publishModel.MaxWordNum.integerValue-1 inComponent:2 animated:YES];
        
        _minWordNum=_publishModel.MinWordNum.integerValue;
        _maxWordNum=_publishModel.MaxWordNum.integerValue;
    }else{
        _minWordNum=1;
        _maxWordNum=1;
    }
    [self.view addSubview:pickerView];
}
#pragma mark - pickerView delegate
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(component==1){
        return 1;
    }
    return 12;
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40.0f;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return kkDeviceWidth/3;
}
//设置返回的标题的属性
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0,0,kkDeviceWidth/3,40)];
    label.textColor = [UIColor blackColor];
    [label setTextAlignment:NSTextAlignmentCenter];
    label.font = [UIFont systemFontOfSize:16];
    if(component==1){
        label.text=@"至";
    }else{
        label.text=[NSString stringWithFormat:@"%@",@(row+1)];
    }
    return label;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(component==0){
        _minWordNum=row+1;
    }else if(component==2){
//        if(row+1<_minWordNum){
//            [SVProgressHUD showErrorWithStatus:@"右边的数字不能小于左边的数字"];
//            return;
//        }
        _maxWordNum=row+1;
    }
}
#pragma mark - textField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
