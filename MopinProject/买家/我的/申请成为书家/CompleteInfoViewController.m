//
//  CompleteInfoViewController.m
//  MopinProject
//
//  Created by rt008 on 15/11/26.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "CompleteInfoViewController.h"
#import "MineListCell.h"
#import "ChooseAddressView.h"
#import "CityModel.h"
#import "VertifyInfoViewController.h"
#import "EmailViewController.h"
#import "ApplyModel.h"

@interface CompleteInfoViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,ChooseAddressViewDelegate>
{
    UITableView *_tableView;
    NSArray *_titleArr;
    ChooseAddressView *_bgView;
    NSArray *_addressArr;
    NSString *_email;
    UITextField *_realNameTextField;
    UITextField *_penNameTextField;
}
@end

@implementation CompleteInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title=@"完善个人信息";
    _titleArr=@[@"电子邮箱",@"籍贯"];
    [self setNavBackBtnWithType:1];
    
    [self createTableView];
}
//TODO:创建表格
- (void)createTableView
{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kkDeviceWidth, kkDeviceHeight-mNavBarHeight-mTabBarHeight) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=self.view.backgroundColor;
    [self.view addSubview:_tableView];
    _tableView.scrollEnabled=NO;
    
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kkDeviceWidth, 90)];
    headerView.backgroundColor=self.view.backgroundColor;
    
    NSArray *titleArr=@[@[@"真实姓名:",@"常用笔名:"],@[@"请输入您的真实姓名",@"请输入您的常用笔名"]];
    for(int i=0;i<2;i++){
        UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0,45*i, kkDeviceWidth, 44)];
        bgView.backgroundColor=[UIColor whiteColor];
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(30, 0, 70, 44)];
        label.font=[UIFont systemFontOfSize:15];
        label.text=titleArr[0][i];
        [bgView addSubview:label];
        
        UITextField *textField=[[UITextField alloc]initWithFrame:CGRectMake(100, 0, kkDeviceWidth-30-30-70, 44)];
        textField.placeholder=titleArr[1][i];
        textField.font=[UIFont systemFontOfSize:15];
        textField.delegate=self;
        [bgView addSubview:textField];
        if(i==0){
            _realNameTextField=textField;
        }else{
            _penNameTextField=textField;
        }
        [headerView addSubview:bgView];
    }
    _tableView.tableHeaderView=headerView;
    
//    UIView *footerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kkDeviceWidth, 110)];
//    footerView.backgroundColor=self.view.backgroundColor;
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(0, kkDeviceHeight-mTabBarHeight-mNavBarHeight, kkDeviceWidth, 49);
    button.titleLabel.font=[UIFont fontWithName:XiaoBiaoSong size:18];
    [button setTitle:@"去验证个人身份" forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"red_button_apply.png"] forState:UIControlStateNormal];
    [self.view addSubview:button];
    
    [button addTarget:self action:@selector(vertiftyBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    _tableView.tableFooterView=[[UIView alloc]init];
}
//TODO:点击验证个人身份
- (void)vertiftyBtnClick
{
    if(_realNameTextField.text.length==0){
        [SVProgressHUD showErrorWithStatus:@"请输入您的真实姓名"];
        return;
    }
//    if(_penNameTextField.text.length==0){
//        [SVProgressHUD showErrorWithStatus:@"请输入您的常用笔名"];
//        return;
//    }
    if([DictionaryTool isValidateEmpty:_realNameTextField.text]){
        [SVProgressHUD showErrorWithStatus:@"真实姓名不能全为空格"];
        return;
    }
    if(_penNameTextField.text.length!=0){
        if([DictionaryTool isValidateEmpty:_penNameTextField.text]){
            [SVProgressHUD showErrorWithStatus:@"常用笔名不能全为空格"];
            return;
        }
    }
    if(_email.length==0){
        [SVProgressHUD showErrorWithStatus:@"请输入您的电子邮箱"];
        return;
    }
    if(_addressArr.count==0){
        [SVProgressHUD showErrorWithStatus:@"请选择籍贯"];
        return;
    }
    ApplyModel *model=[[ApplyModel alloc]init];
    model.TrueName=_realNameTextField.text;
    if(_penNameTextField.text.length==0){
        model.PenName=@"";
    }else{
        model.PenName=_penNameTextField.text;
    }
    
    model.Email=_email;
    model.HJProviceID=[_addressArr[0] Id];
    model.HJCityID=[_addressArr[1] Id];
    model.HJAreaID=[_addressArr[2] Id];
    
    VertifyInfoViewController *vfc=[[VertifyInfoViewController alloc]initWithNibName:@"VertifyInfoViewController" bundle:nil];
    vfc.applyModel=model;
    [self.navigationController pushViewController:vfc animated:YES];
}
#pragma mark - textField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MineListCell *cell=[[[NSBundle mainBundle] loadNibNamed:@"MineListCell" owner:self options:nil]firstObject];
    cell.titleLabel.text=_titleArr[indexPath.row];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.rightLabel.hidden=NO;
    if(indexPath.row==0){
        if(_email.length!=0){
            cell.rightLabel.text=_email;
        }
    }else{
        if(_addressArr.count!=0){
            cell.rightLabel.text=[NSString stringWithFormat:@"%@%@",[_addressArr[1] Name],[_addressArr[2] Name]];
        }
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    if(indexPath.row==0){
        EmailViewController *evc=[[EmailViewController alloc]initWithNibName:@"EmailViewController" bundle:nil];
        [evc setConfirmEmail:^(NSString *email) {
            _email=email;
            [_tableView reloadData];
        }];
        [self.navigationController pushViewController:evc animated:YES];
    }else if(indexPath.row==1){
        if(!_bgView){
            _bgView=[[ChooseAddressView alloc]initWithFrame:CGRectMake(0, 0, kkDeviceWidth, kkDeviceHeight)];
            _bgView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
            _bgView.delegate=self;
            [WINDOW addSubview:_bgView];
        }else{
            _bgView.hidden=NO;
        }
    }
}
- (void)chooseAddressIdWithArray:(NSArray *)arr
{
    _addressArr=arr;
    [_tableView reloadData];
}
//TODO:让tableView的分割线从头开始
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    if([cell respondsToSelector:@selector(setLayoutMargins:)]){
        [cell setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}
- (void)viewDidLayoutSubviews
{
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
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
