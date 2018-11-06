//
//  AddressViewController.m
//  MopinProject
//
//  Created by rt008 on 15/11/26.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "AddressViewController.h"
#import "AddressCell.h"
#import "AddressModel.h"
#import "EditAddressViewController.h"
#import "CommonEmptyTableBgView.h"

@interface AddressViewController ()<UITableViewDelegate,UITableViewDataSource,AddressCellDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataArr;
    PersonalInfoSingleModel *_personalModel;
    NSInteger _selectedIndex;  //设置为默认地址的下标
    CommonEmptyTableBgView *_emptyBgView;
}
@end

@implementation AddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title=@"更改地址";
    [self setNavBackBtnWithType:1];
    [self setRightNavTitleStr:@"新增"];
    _dataArr=[[NSMutableArray alloc]init];
    _personalModel=[PersonalInfoSingleModel shareInstance];
    
    [self createTbaleView];
    [self downloadAddressList];
}
//TODO:点击新增
- (void)rightNavBtnClick
{
    EditAddressViewController *evc=[[EditAddressViewController alloc]initWithNibName:@"EditAddressViewController" bundle:nil];
     __weak typeof(self) weakSelf=self;
    [evc setReloadAddressList:^{
        [weakSelf downloadAddressList];
    }];
    [self.navigationController pushViewController:evc animated:YES];
    
}
- (void)downloadAddressList
{
    [_dataArr removeAllObjects];
    [SVProgressHUD show];
    
    NSMutableDictionary *parameterDic=[NSMutableDictionary dictionary];
    [parameterDic setValue:@"GetAddressList" forKey:@"Method"];
    [parameterDic setValue:Infversion forKey:@"Infversion"];
    [parameterDic setValue:_personalModel.UserID forKey:@"UserID"];
    
    [HTTPMethod NET_request:1 urlStr:HOSTURL ServiceParameters:parameterDic success:^(NSString *reponse) {
        NSData *jsonDate=[reponse dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary * jsonObject = [NSJSONSerialization JSONObjectWithData:jsonDate options:NSJSONReadingAllowFragments error:&error];
        
        NSString * code = [NSString stringWithFormat:@"%@", jsonObject[@"code"]];
        NSString * msg = jsonObject[@"msg"];
        [DictionaryTool showResult:msg withCode:code.integerValue];
        
        if (code.integerValue == 1000) {
            
            for(NSDictionary *dic in jsonObject[@"data"]){
                AddressModel *model=[[AddressModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [_dataArr addObject:model];
            }
            if(_dataArr.count==0){
                _emptyBgView.hidden=NO;
            }else{
                _emptyBgView.hidden=YES;
            }
        }
        [_tableView reloadData];
    } failure:^(NSError *error){
        
        [SVProgressHUD dismiss];
        NSLog(@"%@",error);
    }];
}
//TODO:创建表格
- (void)createTbaleView
{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kkDeviceWidth, kkDeviceHeight-mNavBarHeight) style:UITableViewStyleGrouped];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.tableFooterView=[[UIView alloc]init];
//    _tableView.separatorColor=[UIColor clearColor];
    _tableView.backgroundColor=self.view.backgroundColor;
    [self.view addSubview:_tableView];
    
    _emptyBgView=[[CommonEmptyTableBgView alloc]initWithFrame:CGRectMake(0, 0, kkDeviceWidth, kkDeviceHeight-mNavBarHeight)];
    _emptyBgView.tipsString=@"哦噢,还没有添加地址~";
    _emptyBgView.hidden = YES;
    [_tableView addSubview:_emptyBgView];
}
#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==0){
        if(_dataArr.count!=0){
            AddressModel *model=_dataArr[0];
            if(model.IsDefault.intValue==1){
                return 1;
            }
        }
        return _dataArr.count;
    }else{
        return _dataArr.count-1;
    }
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(_dataArr.count!=0){
        AddressModel *model=_dataArr[0];
        if(model.IsDefault.intValue==1){
            return 2;
        }
    }
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddressCell *cell=[tableView dequeueReusableCellWithIdentifier:@"AddressCell"];
    if(!cell){
        cell=[[[NSBundle mainBundle] loadNibNamed:@"AddressCell" owner:self options:nil]firstObject];
    }
    AddressModel *model;
    if(indexPath.section==0){
        if(_dataArr.count!=0){
            model=_dataArr[indexPath.row];
        }
    }else{
        if(_dataArr.count>=1){
            model=_dataArr[indexPath.row+1];
        }
    }
    cell.addressModel=model;
    cell.delegate=self;
    [cell reloadCell];
    return cell;
}
//TODO:选这地址，传回一个mod
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddressModel *model;
    if(indexPath.section==0){
        if(_dataArr.count!=0){
            model=_dataArr[indexPath.row];
        }
    }else{
        if(_dataArr.count>=1){
            model=_dataArr[indexPath.row+1];
        }
    }
    if(_finishChooseAddress)
    {
        _finishChooseAddress(model);
    }
    
    if(_fromComfireOrderVC == 1)
    {
       [self.navigationController popViewControllerAnimated:YES];
    }
    

}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    CATransform3D rotation;
//    rotation = CATransform3DMakeRotation(M_PI_2, 0, 0.7, 0.4);
//    rotation.m34=1.0/-600;
//    
//    cell.layer.shadowColor=[UIColor blackColor].CGColor;
//    cell.layer.shadowOffset=CGSizeMake(10, 10);
//    cell.alpha=0;
//    cell.layer.transform=rotation;
//    cell.layer.anchorPoint=CGPointMake(0, 0.5);
//    
//    [UIView beginAnimations:@"rotation" context:NULL];
//    [UIView setAnimationDuration:0.8];
//    cell.layer.transform=CATransform3DIdentity;
//    cell.alpha=1;
//    cell.layer.shadowOffset=CGSizeMake(0, 0);
//    [UIView commitAnimations];

//    if(_selectedIndex!=0){
//        
//        CGRect rectInTable=[tableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:_selectedIndex-1 inSection:1]];
//        CGRect rect=[tableView convertRect:rectInTable toView:self.view];
//        cell.transform=CGAffineTransformMakeTranslation(rect.origin.x, rect.origin.y);
//        [UIView animateWithDuration:0.8 animations:^{
//            cell.transform=CGAffineTransformIdentity;
//        }];
//        
//    }
//   
//    _selectedIndex=0;

    if([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    if([cell respondsToSelector:@selector(setLayoutMargins:)]){
        [cell setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    AddressModel *model=_dataArr[indexPath.row];
//    
//}
//TODO:让tableView的分割线从头开始
//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//}
- (void)viewDidLayoutSubviews
{
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}
#pragma mark - addressCellDeleagte
- (void)deleteAddress:(AddressModel *)model
{
    [SVProgressHUD show];
    NSMutableDictionary *parameterDic=[NSMutableDictionary dictionary];
    [parameterDic setValue:@"DeleteAddress" forKey:@"Method"];
    [parameterDic setValue:model.Addressid forKey:@"AddressID"];
    [parameterDic setValue:Infversion forKey:@"Infversion"];
    [parameterDic setValue:_personalModel.UserID forKey:@"UserID"];
    
    [HTTPMethod NET_request:1 urlStr:HOSTURL ServiceParameters:parameterDic success:^(NSString *reponse) {
        NSData *jsonDate=[reponse dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary * jsonObject = [NSJSONSerialization JSONObjectWithData:jsonDate options:NSJSONReadingAllowFragments error:&error];
        
        NSString * code = [NSString stringWithFormat:@"%@", jsonObject[@"code"]];
        NSString * msg = jsonObject[@"msg"];
        [DictionaryTool showResult:msg withCode:code.integerValue];
        
        if (code.integerValue == 1000) {
            
            [_dataArr removeObject:model];
            [_tableView reloadData];
            
            if(_dataArr.count==0){
                _emptyBgView.hidden=NO;
            }
        }
    } failure:^(NSError *error){
        
        [SVProgressHUD dismiss];
        NSLog(@"%@",error);
    }];
    
}
- (void)editAddress:(AddressModel *)model
{
    EditAddressViewController *evc=[[EditAddressViewController alloc]init];
    evc.addressModel=model;
//    __weak typeof(_tableView) weakTableView=_tableView;
    [evc setReloadAddressList:^{
        [_tableView reloadData];
    }];
    [self.navigationController pushViewController:evc animated:YES];
}
- (void)setdefaultAddress:(AddressModel *)model
{
    if(model.IsDefault.intValue==1){
        return;
    }
    [SVProgressHUD show];
    NSMutableDictionary *parameterDic=[NSMutableDictionary dictionary];
    [parameterDic setValue:@"SetDefaultAddress" forKey:@"Method"];
    [parameterDic setValue:model.Addressid forKey:@"AddressID"];
    [parameterDic setValue:Infversion forKey:@"Infversion"];
    [parameterDic setValue:_personalModel.UserID forKey:@"UserID"];
    
    [HTTPMethod NET_request:1 urlStr:HOSTURL ServiceParameters:parameterDic success:^(NSString *reponse) {
        NSData *jsonDate=[reponse dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary * jsonObject = [NSJSONSerialization JSONObjectWithData:jsonDate options:NSJSONReadingAllowFragments error:&error];
        
        NSString * code = [NSString stringWithFormat:@"%@", jsonObject[@"code"]];
        NSString * msg = jsonObject[@"msg"];
        [DictionaryTool showResult:msg withCode:code.integerValue];
        
        if (code.integerValue == 1000) {
            
            model.IsDefault=@"1";
            NSInteger index=[_dataArr indexOfObject:model];
            if(index!=0){
                AddressModel *tempModel=_dataArr[0];
                tempModel.IsDefault=@"0";
                [_dataArr removeObject:model];
                [_dataArr insertObject:model atIndex:0];
            }
            _selectedIndex=index;
            [_tableView reloadData];
        }
        [_tableView reloadData];
    } failure:^(NSError *error){
        
        [SVProgressHUD dismiss];
        NSLog(@"%@",error);
    }];
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
