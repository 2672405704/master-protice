//
//  SquareCouponViewController.m
//  MopinProject
//
//  Created by rt008 on 15/12/3.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "SquareCouponViewController.h"
#import "ChooseDateView.h"

@interface SquareCouponViewController ()<ChooseDateViewDelegate>
{
    NSInteger _price;
    ChooseDateView *_dateView;
    NSString *_date;
}
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *selectedBtn;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@end

@implementation SquareCouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title=@"广场发券";
    [self setNavBackBtnWithType:1];
    
    _textField.inputAccessoryView=self.keyBordtoolBar;
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
- (IBAction)selecteBtnClick:(id)sender {
    _selectedBtn.selected=!_selectedBtn.selected;
}
- (IBAction)chooseDateBtnClick:(id)sender {
    [self.view endEditing:YES];
    if(!_dateView){
        _dateView=[[ChooseDateView alloc]initViewWithType:1];
        [WINDOW addSubview:_dateView];
        
        _dateView.delegate=self;
    }else{
        _dateView.hidden=NO;
    }
}
- (IBAction)sureBtnClick:(id)sender {
    if(_price==0){
        [SVProgressHUD showErrorWithStatus:@"面值不能为0"];
        return;
    }
    if(_textField.text.intValue==0){
        [SVProgressHUD showErrorWithStatus:@"请输入发放数量"];
        return;
    }
    if(_date.length==0){
        [SVProgressHUD showErrorWithStatus:@"请设置有效期"];
        return;
    }

    _sureBtn.userInteractionEnabled=NO;
    
    [SVProgressHUD show];
    PersonalInfoSingleModel *personalModel=[PersonalInfoSingleModel shareInstance];
    
    NSMutableDictionary *parameterDic=[NSMutableDictionary dictionary];
    [parameterDic setValue:@"SendPublicCoupon" forKey:@"Method"];
    [parameterDic setValue:Infversion forKey:@"Infversion"];
    [parameterDic setValue:personalModel.UserID forKey:@"UserID"];
    
    [parameterDic setValue:_date forKey:@"ValidTime"];
    [parameterDic setValue:_textField.text forKey:@"SendNum"];
    [parameterDic setValue:[NSString stringWithFormat:@"%@",@(_price)] forKey:@"Amount"];
    [parameterDic setValue:[NSString stringWithFormat:@"%d",_selectedBtn.selected] forKey:@"IsSquare"];
    
    [HTTPMethod NET_request:1 urlStr:HOSTURL ServiceParameters:parameterDic success:^(NSString *reponse) {
        NSData *jsonDate=[reponse dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary * jsonObject = [NSJSONSerialization JSONObjectWithData:jsonDate options:NSJSONReadingAllowFragments error:&error];
        
        NSString * code = [NSString stringWithFormat:@"%@", jsonObject[@"code"]];
        NSString * msg = jsonObject[@"msg"];
        [DictionaryTool showResult:msg withCode:code.integerValue];
        
        _sureBtn.userInteractionEnabled=YES;
        if (code.integerValue == 1000) {
            
            [self backBtnClick];
        }
    } failure:^(NSError *error){
        _sureBtn.userInteractionEnabled=YES;
        
        [SVProgressHUD dismiss];
        NSLog(@"%@",error);
        
    }];
}
//TODO:选中日期
- (void)chooseDate:(NSString *)date
{
    _date=date;
    NSArray *dateArr=[date componentsSeparatedByString:@"-"];
    _dateLabel.text=[NSString stringWithFormat:@"%d年%d月%d日",[dateArr[0] intValue],[dateArr[1] intValue],[dateArr[2] intValue]];
}
- (void)dealloc
{
    [_dateView removeFromSuperview];
    _dateView=nil;
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
