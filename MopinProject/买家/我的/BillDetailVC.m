//
//  BillDetailVC.m
//  MopinProject
//
//  Created by xhd945 on 15/12/18.
//  Copyright © 2015年 rt008. All rights reserved.
//

#import "BillDetailVC.h"

#define kkDefualtDeliverPrice  0.0f

@interface BillDetailVC ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *divLine_1;
@property (weak, nonatomic) IBOutlet UIView *divLine_2;
@property (weak, nonatomic) IBOutlet UIView *divLine_3;

@property (weak, nonatomic) IBOutlet UILabel *tipsContentLab; //提示内容
@property (weak, nonatomic) IBOutlet UIButton *comfireBnt; //确认按钮
@end


@implementation BillDetailVC
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        _personBnt.selected = NO;
        _companyBnt.selected = NO;
        _enableEidt = YES;
      
    }
    return self;

}
-(void)setEnableEidt:(BOOL)enableEidt
{
   if(_enableEidt != enableEidt)
   {
       _enableEidt = enableEidt;
   }
   if(_enableEidt == NO)
   {
       UIView *maskView = [[UIView alloc]initWithFrame:mRect(0,0,kkDeviceWidth, 250)];
       maskView.backgroundColor = [UIColor clearColor];
       [self.view addSubview:maskView];
   
   }
}

/*初始化UI设计*/
-(void)initSetupUI
{
    
    _bgView_1.backgroundColor = [UIColor whiteColor];
    _bgView_2.backgroundColor = [UIColor whiteColor];
    
   [_personBnt setTitleColor:THEMECOLOR_1 forState:UIControlStateSelected];
    [_personBnt setTitleColor:MainFontColor forState:UIControlStateNormal];
    
    [_companyBnt setTitleColor:THEMECOLOR_1 forState:UIControlStateSelected];
    [_companyBnt setTitleColor:MainFontColor forState:UIControlStateNormal];
    
    [_personBnt setImage:mImageByName(@"point_sample") forState:UIControlStateNormal];
    [_personBnt setImage:mImageByName(@"gou_red_sample") forState:UIControlStateSelected];
    
    [_companyBnt setImage:mImageByName(@"point_sample") forState:UIControlStateNormal];
    [_companyBnt setImage:mImageByName(@"gou_red_sample") forState:UIControlStateSelected];

    
    _divLine_1.backgroundColor = DIVLINECOLOR_1;
    _divLine_2.backgroundColor = DIVLINECOLOR_1;
    _divLine_3.backgroundColor = DIVLINECOLOR_1;
    _comfireBnt.layer.cornerRadius = 4;
    _comfireBnt.backgroundColor = THEMECOLOR_1;
    _comfireBnt.titleLabel.font = UIFONT_Tilte(19);
    
    _companyNameTextField.delegate = self;
    _companyNameTextField.enabled = _titleName.length?YES:NO;
    
    
    [XHDHelper addToolBarOnInputFiled:_companyNameTextField Action:@selector(endInput) Target:self];
    [_companyNameTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
}
- (void)endInput
{
    /*去除空格开头*/
    if(_companyNameTextField.text.length>0)
    {
        _companyNameTextField.text = [XHDHelper delSpaceWith:_companyNameTextField.text];
    }
    [_companyNameTextField resignFirstResponder];

}
#pragma mark --  视图循环
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title=@"发票明细";
    [self setNavBackBtnWithType:1];
    [self initSetupUI];
    if(_fromMark==1)
    {
        [_comfireBnt setTitle:@"关闭" forState:UIControlStateNormal];
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    /*填充代入的数据*/
    _companyNameTextField.adjustsFontSizeToFitWidth = YES;
    _companyNameTextField.minimumFontSize = 10;
    
    if(_titleName.length>0)
    {
        if([_titleName isEqualToString:@"个人"])
        {
            _personBnt.selected = YES;
            _companyBnt.selected = NO;
            _companyNameTextField.enabled = NO;
        }
        else{
        
            _personBnt.selected = NO;
            _companyBnt.selected = YES;
            _companyNameTextField.enabled = YES;
            _companyNameTextField.text = _titleName;
        }
    }
    
    /*编辑价格*/
    NSString *totalString = [NSString stringWithFormat:@"%.2f",_ZhuanBiaoPrice.floatValue + kkDefualtDeliverPrice];
    self.countOfZhuanBiaoLab.text = totalString;
    
}
//TODO:公司按钮点击
- (IBAction)companyBntAction:(UIButton *)sender
{
    _companyBnt.selected = !_companyBnt.isSelected;
    _personBnt.selected = NO;
    _companyNameTextField.enabled = _companyBnt.isSelected;
}

//TODO:个人按钮点击
- (IBAction)personBntAction:(UIButton *)sender
{
    _personBnt.selected = !_personBnt.isSelected;
    _companyBnt.selected = NO;
    _companyNameTextField.enabled = NO;
    _companyNameTextField.text = @"";
    
}

#pragma mark -- 确认按钮
- (IBAction)comfireBntAction:(UIButton *)sender
{
    if(_fromMark==2)
    {
        if(_personBnt.selected==YES)
        {
            if(_finishFill)
                
                _finishFill(@"个人");
            
        }
        if(_companyBnt.selected == YES)
        {
            [_companyNameTextField resignFirstResponder];
            if(_companyNameTextField.text.length==0)
            {
                [SVProgressHUD showErrorWithStatus:@"请输入公司的名称"];
                return;
            }else
            {
                if(_finishFill)
                    
                    _finishFill(_companyNameTextField.text);
            }
        }
    }
        [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -- textDelegte
- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == _companyNameTextField)
    {
        //该判断用于联想输入
        if( textField.text.length>=25)
        {
            [SVProgressHUD showErrorWithStatus:@"公司名称请输入在25个字以内"];
            textField.text = [textField.text substringToIndex:25];
            
        }
    }
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([string isEqualToString:@"\n"])
    {
        [textField resignFirstResponder];
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    /*去除空格开头*/
    if(textField.text.length>0)
    {
       textField.text = [XHDHelper delSpaceWith:textField.text];
    }
    [_companyNameTextField resignFirstResponder];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
