//
//  EditAddressViewController.m
//  MopinProject
//
//  Created by rt008 on 15/11/26.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "EditAddressViewController.h"
#import "AddressModel.h"
#import "CityModel.h"
#import "ChooseAddressView.h"
#import "AddressDataCenter.h"

@interface EditAddressViewController ()<UITextFieldDelegate,ChooseAddressViewDelegate>
{
    ChooseAddressView *_bgView;
    NSArray *_addressIdArr;
}
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@end

@implementation EditAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if(_addressModel){
        self.navigationItem.title=@"编辑地址";
        [self setProperty];
    }else{
        self.navigationItem.title=@"添加地址";
        _addressModel=[[AddressModel alloc]init];
    }
    [self setNavBackBtnWithType:1];
    
    _phoneTextField.inputAccessoryView=self.keyBordtoolBar;
}
//TODO:设置属性
- (void)setProperty
{
    AddressDataCenter *addressDataCenter=[AddressDataCenter sharedInstance];
    
    _nameTextField.text=_addressModel.Name;
    _phoneTextField.text=_addressModel.Mobile;
    _addressTextField.text=_addressModel.Address;
    _addressIdArr=@[_addressModel.ProvinceID,_addressModel.CityID,_addressModel.DistrictID];
    
    _cityLabel.textColor=[UIColor blackColor];
    _cityLabel.text=[addressDataCenter getProvinceNameWith:_addressModel.ProvinceID andCityName:_addressModel.CityID andDistrictName:_addressModel.DistrictID];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (IBAction)chooseCityBtnClick:(id)sender {

    [self.view endEditing:YES];
    if(!_bgView){
        _bgView=[[ChooseAddressView alloc]initWithFrame:CGRectMake(0, 0, kkDeviceWidth, kkDeviceHeight) andProvince:_addressModel.ProvinceID andCity:_addressModel.CityID andDistrict:_addressModel.DistrictID];
        
        _bgView.delegate=self;
        [WINDOW addSubview:_bgView];
    }else{
        _bgView.hidden=NO;
//        [_bgView releaseCount];
    }
}
- (void)chooseAddressIdWithArray:(NSArray *)arr
{
    CityModel *cityModel=arr[1];
    CityModel *proviceModel=arr[0];
    CityModel *districtModel=arr[2];

    _cityLabel.textColor=[UIColor blackColor];
    if([cityModel.Name isEqualToString:proviceModel.Name]){
        _cityLabel.text=[NSString stringWithFormat:@"%@%@",cityModel.Name,districtModel.Name];
    }else{
        _cityLabel.text=[NSString stringWithFormat:@"%@%@%@",proviceModel.Name,cityModel.Name,districtModel.Name];
    }
    _addressIdArr=@[proviceModel.Id,cityModel.Id,districtModel.Id];
//    _addressModel.CityID=cityModel.Id;
//    _addressModel.ProvinceID=proviceModel.Id;
//    _addressModel.DistrictID=districtModel.Id;
}

- (IBAction)sureBtnClick:(id)sender {
    if(_nameTextField.text.length==0){
        [SVProgressHUD showErrorWithStatus:@"请输入收货人姓名"];
        return;
    }
    if([DictionaryTool isValidateEmpty:_nameTextField.text]){
        [SVProgressHUD showErrorWithStatus:@"收货人姓名不能全为空格"];
        return;
    }
    if(![self phoneNumberIsRight:_phoneTextField.text]){
        [SVProgressHUD showErrorWithStatus:@"手机号格式不正确"];
        return;
    }
    if([_addressIdArr[0] length]==0){
        [SVProgressHUD showErrorWithStatus:@"请选择城市"];
        return;
    }
    if(_addressTextField.text.length==0){
        [SVProgressHUD showErrorWithStatus:@"请输入详细地址"];
        return;
    }
    [self submit];
}
//TODO:点击确定请求网络
- (void)submit
{
    [SVProgressHUD show];
    _sureBtn.userInteractionEnabled=NO;
    
    PersonalInfoSingleModel *personalModel=[PersonalInfoSingleModel shareInstance];
    NSMutableDictionary *parameterDic=[NSMutableDictionary dictionary];
    [parameterDic setValue:@"SaveAddress" forKey:@"Method"];
    [parameterDic setValue:Infversion forKey:@"Infversion"];
    [parameterDic setValue:personalModel.UserID forKey:@"UserID"];
    if(_addressModel.Addressid.length==0){
        [parameterDic setValue:@"0" forKey:@"Addressid"];
    }else{
        [parameterDic setValue:_addressModel.Addressid forKey:@"Addressid"];
    }
    [parameterDic setValue:_nameTextField.text forKey:@"Name"];
    [parameterDic setValue:_phoneTextField.text forKey:@"Mobile"];
    [parameterDic setValue:_addressTextField.text forKey:@"Address"];
    [parameterDic setValue:_addressIdArr[1] forKey:@"CityID"];
    [parameterDic setValue:_addressIdArr[0] forKey:@"ProvinceID"];
    [parameterDic setValue:_addressIdArr[2] forKey:@"DistrictID"];
    
    [HTTPMethod NET_request:1 urlStr:HOSTURL ServiceParameters:parameterDic success:^(NSString *reponse) {
        NSData *jsonDate=[reponse dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary * jsonObject = [NSJSONSerialization JSONObjectWithData:jsonDate options:NSJSONReadingAllowFragments error:&error];
        
        NSString * code = [NSString stringWithFormat:@"%@", jsonObject[@"code"]];
        NSString * msg = jsonObject[@"msg"];
        [DictionaryTool showResult:msg withCode:code.integerValue];
        _sureBtn.userInteractionEnabled=YES;
        
        if (code.integerValue == 1000) {
            _addressModel.Name=_nameTextField.text;
            _addressModel.Mobile=_phoneTextField.text;
            _addressModel.Address=_addressTextField.text;
            _addressModel.ProvinceID=_addressIdArr[0];
            _addressModel.CityID=_addressIdArr[1];
            _addressModel.DistrictID=_addressIdArr[2];
            
            [self.navigationController popViewControllerAnimated:YES];
            self.reloadAddressList();
        }
    } failure:^(NSError *error){
        _sureBtn.userInteractionEnabled=YES;
        
        [SVProgressHUD dismiss];
        NSLog(@"%@",error);
    }];
}
#pragma mark - textField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
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
