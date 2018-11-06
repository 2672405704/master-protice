//
//  SearchViewController.m
//  MopinProject
//
//  Created by rt008 on 15/12/8.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "SearchViewController.h"
#import "SerchPenmmanCell.h"
#import "PenmanListModel.h"
#import "MineListCell.h"
#import "ExampleWorkCell.h"
#import "ExampleWorkModel.h"
#import "PenmanDetailViewController.h"
#import "ExmapleWorkDetailVC.h"
#import "CommonEmptyTableBgView.h"

static NSString const *kPageSize=@"10";
@interface SearchViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *bgView;        //背景
@property (weak, nonatomic) IBOutlet UITextField *textField;//文本输入框
@property (weak, nonatomic) IBOutlet UIView *buttnBgView;  //浮窗背景
@property (weak, nonatomic) IBOutlet UIButton *chooseBtn;  //选择按钮
@property (weak, nonatomic) IBOutlet UITableView *historyTableView;
@property (weak, nonatomic) IBOutlet UIView *resultBgView; //搜索结果背景
@property (weak, nonatomic) IBOutlet UITableView *resultTableView; //搜索结果
@property (weak, nonatomic) IBOutlet UIButton *priceBtn; //结果页的价格按钮
@property (weak, nonatomic) IBOutlet UIImageView *redLineImageView; //结果页的红线
@end

@implementation SearchViewController
{
    NSUserDefaults *ud_;
    NSArray *_historyArr;  //搜索历史记录
    NSMutableArray *_resultDataArr;  //搜索结果
    NSInteger _selectedIndex;  //选择排序类型
    NSInteger _downloadType;   //下载类型 1作品 2书家
    
    CommonEmptyTableBgView *_emptyBgView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _bgView.layer.cornerRadius=3;
    _bgView.layer.masksToBounds=YES;
    _historyTableView.tableFooterView=[[UIView alloc]init];
    _resultDataArr=[[NSMutableArray alloc]init];
    _selectedIndex=1;
    
    ud_=[NSUserDefaults standardUserDefaults];
    
    [_textField becomeFirstResponder];
    [self createTableView];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keybordShow:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keybordHide) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keybordHeightChage:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    _emptyBgView=[[CommonEmptyTableBgView alloc]initWithFrame:CGRectMake(0, 0, kkDeviceWidth, kkDeviceHeight-mNavBarHeight-45)];
    _emptyBgView.hidden = YES;
    [_resultTableView addSubview:_emptyBgView];
    if(_type==SearchhTypePenman){
        [self penmanBtnClick:nil];
        _emptyBgView.tipsString=@"哦噢,没有符合条件的书法家~";
    }else{
        _emptyBgView.tipsString=@"哦噢,没有符合条件的作品~";
    }
}
- (IBAction)priceBtnClick:(id)sender {
    [_textField resignFirstResponder];
    if(_selectedIndex<3){
        UIButton *btn=(UIButton *)[self.view viewWithTag:100+_selectedIndex-1];
        btn.selected=NO;
    }
    [_priceBtn setImage:[UIImage imageNamed:@"arrow_red_up.png"] forState:UIControlStateNormal];
    [_priceBtn setTitleColor:toPCcolor(@"ca2b3b") forState:UIControlStateNormal];
    _priceBtn.selected=!_priceBtn.selected;
    if(_priceBtn.selected){
        _selectedIndex=3;
    }else{
        _selectedIndex=4;
    }
    [_resultTableView headerBeginRefreshing];
    //改变线条的位置
    [UIView animateWithDuration:0.3 animations:^{
        _redLineImageView.frame=CGRectMake((kkDeviceWidth/3-60)/2*3+(60+(kkDeviceWidth/3-60)/2)*(3-1), 43, 60, 2);
    }];
}
- (IBAction)sortBtnClick:(id)sender {
    [_textField resignFirstResponder];
    _priceBtn.selected=NO;
    [_priceBtn setImage:[UIImage imageNamed:@"arrow_gary_down.png"] forState:UIControlStateNormal];
    [_priceBtn setTitleColor:toPCcolor(@"888888") forState:UIControlStateNormal];
    
    UIButton *button=(UIButton *)sender;
    if(_selectedIndex==button.tag-100+1){
        
        return;
    }else{
        UIButton *btn=(UIButton *)[self.view viewWithTag:_selectedIndex+100-1];
        btn.selected=NO;
        button.selected=YES;
    }
    _selectedIndex=button.tag-100+1;
    //改变线条的位置
    [UIView animateWithDuration:0.3 animations:^{
        _redLineImageView.frame=CGRectMake((kkDeviceWidth/3-60)/2*_selectedIndex+(60+(kkDeviceWidth/3-60)/2)*(_selectedIndex-1), 43, 60, 2);
    }];
    [_resultTableView headerBeginRefreshing];
}
//TODO:添加上下拉刷新
- (void)createTableView
{
    _resultTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _resultTableView.tableFooterView=[[UIView alloc]init];
    [_resultTableView addHeaderWithTarget:self action:@selector(refreshData)];
    [_resultTableView addFooterWithTarget:self action:@selector(loadMoreData)];
}
//TODO:下拉刷新
- (void)refreshData
{
    _resultBgView.hidden=NO;
    _historyTableView.hidden=YES;
    page=1;
    if([[_chooseBtn titleForState:UIControlStateNormal] isEqualToString:@"书家"]){
        [self searchPenmanList];
    }else{
        [self searchSampleList];
    }
}
//TODO:上拉加载更多
- (void)loadMoreData
{
    page++;
    if([[_chooseBtn titleForState:UIControlStateNormal] isEqualToString:@"书家"]){
        [self searchPenmanList];
    }else{
        [self searchSampleList];
    }
}
//TODO:键盘高度改变
- (void)keybordHeightChage:(NSNotification *)notification
{
    //获取键盘高度
    NSDictionary *info=[notification userInfo];
//    CGFloat kbHeight = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    CGRect kbframe=[[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    if(kbframe.origin.y!=kkDeviceHeight){
        CGRect frame=_historyTableView.frame;
        frame.size.height=kkDeviceHeight-70-kbframe.size.height;
        _historyTableView.frame=frame;
    }else{
        CGRect frame=_historyTableView.frame;
        frame.size.height=kkDeviceHeight-70;
        _historyTableView.frame=frame;
    }
}
//TODO:输入框文字改变
- (void)textChange
{
    _historyTableView.hidden=NO;
    [self predicateSearchText];
    _resultBgView.hidden=YES;
}
//TODO:匹配
- (void)predicateSearchText
{
    if([ud_ objectForKey:@"HistorySearchArr"]){
        NSArray *tempArr=[[ud_ objectForKey:@"HistorySearchArr"] copy];
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"SELF CONTAINS %@",_textField.text];
        _historyArr=[tempArr filteredArrayUsingPredicate:predicate];
        if(_historyArr.count==0){
            _historyTableView.hidden=YES;
        }
        [_historyTableView reloadData];
    }
}
//TODO:搜索书家
- (void)searchPenmanList
{
    [SVProgressHUD show];
    
    NSMutableDictionary *parameterDic=[NSMutableDictionary dictionary];
    [parameterDic setValue:@"SearchPenmanList" forKey:@"Method"];
    [parameterDic setValue:_textField.text forKey:@"Content"];
    [parameterDic setValue:Infversion forKey:@"Infversion"];
    [parameterDic setValue:kPageSize forKey:@"PageSize"];
    [parameterDic setValue:[NSString stringWithFormat:@"%@",@(page)] forKey:@"PageIndex"];
    [parameterDic setValue:[NSString stringWithFormat:@"%@",@(_selectedIndex)] forKey:@"OrderType"];
    
    [HTTPMethod NET_request:1 urlStr:HOSTURL ServiceParameters:parameterDic success:^(NSString *reponse) {
        NSData *jsonDate=[reponse dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary * jsonObject = [NSJSONSerialization JSONObjectWithData:jsonDate options:NSJSONReadingAllowFragments error:&error];
        
        NSString * code = [NSString stringWithFormat:@"%@", jsonObject[@"code"]];
        NSString * msg = jsonObject[@"msg"];
        [DictionaryTool showResult:msg withCode:code.integerValue];
        [_resultTableView headerEndRefreshing];
        [_resultTableView footerEndRefreshing];
        if(page==1){
            [_resultDataArr removeAllObjects];
        }
        if (code.integerValue == 1000) {
            _downloadType=2;
            for(NSDictionary *dic in jsonObject[@"data"]){
                PenmanListModel *model=[[PenmanListModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [_resultDataArr addObject:model];
            }
            if(_resultDataArr.count==0){
                _emptyBgView.hidden=NO;
            }else{
                _emptyBgView.hidden=YES;
            }
            [_resultTableView reloadData];
        }
    } failure:^(NSError *error){
        [_resultTableView headerEndRefreshing];
        [_resultTableView footerEndRefreshing];
        
        [SVProgressHUD dismiss];
        NSLog(@"%@",error);
        
    }];
}
//TODO:搜索样品
- (void)searchSampleList
{
    [SVProgressHUD show];
    
    NSMutableDictionary *parameterDic=[NSMutableDictionary dictionary];
    [parameterDic setValue:@"SearchSampleList" forKey:@"Method"];
    [parameterDic setValue:_textField.text forKey:@"Content"];
    [parameterDic setValue:Infversion forKey:@"Infversion"];
    [parameterDic setValue:kPageSize forKey:@"PageSize"];
    [parameterDic setValue:[NSString stringWithFormat:@"%@",@(page)] forKey:@"PageIndex"];
    [parameterDic setValue:[NSString stringWithFormat:@"%@",@(_selectedIndex)] forKey:@"OrderType"];
    
    [HTTPMethod NET_request:1 urlStr:HOSTURL ServiceParameters:parameterDic success:^(NSString *reponse) {
        NSData *jsonDate=[reponse dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary * jsonObject = [NSJSONSerialization JSONObjectWithData:jsonDate options:NSJSONReadingAllowFragments error:&error];
        
        NSString * code = [NSString stringWithFormat:@"%@", jsonObject[@"code"]];
        NSString * msg = jsonObject[@"msg"];
        [DictionaryTool showResult:msg withCode:code.integerValue];
        [_resultTableView headerEndRefreshing];
        [_resultTableView footerEndRefreshing];
        if(page==1){
            [_resultDataArr removeAllObjects];
        }
        if (code.integerValue == 1000) {
            _downloadType=1;
            
            for(NSDictionary *dic in jsonObject[@"data"]){
                ExampleWorkModel *model=[[ExampleWorkModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [_resultDataArr addObject:model];
            }
            
            if(_resultDataArr.count==0){
                _emptyBgView.hidden=NO;
            }else{
                _emptyBgView.hidden=YES;
            }
            [_resultTableView reloadData];
        }
    } failure:^(NSError *error){
        [_resultTableView headerEndRefreshing];
        [_resultTableView footerEndRefreshing];
        
        [SVProgressHUD dismiss];
        NSLog(@"%@",error);
        
    }];
}
////TODO:键盘隐藏
//- (void)keybordHide
//{
//    
//}
////TODO:键盘显示
//- (void)keybordShow:(NSNotification *)notification
//{
//    //获取键盘高度
//    NSDictionary *info=[notification userInfo];
//    CGFloat kbHeight = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
//    
//    
//}
- (IBAction)cancelBtnClick:(id)sender {
    [_textField resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (IBAction)sampleBtnClick:(id)sender {
    _buttnBgView.hidden=YES;
    if([[_chooseBtn titleForState:UIControlStateNormal] isEqualToString:@"作品"]){
        return;
    }
    _emptyBgView.tipsString=@"哦噢,没有符合条件的作品~";
    
    [_chooseBtn setTitle:@"作品" forState:UIControlStateNormal];
    [_resultDataArr removeAllObjects];
    [_resultTableView reloadData];
    
    _textField.placeholder=@"行书/横幅/祝寿/内容";
}
- (IBAction)penmanBtnClick:(id)sender {
    _buttnBgView.hidden=YES;
    if([[_chooseBtn titleForState:UIControlStateNormal] isEqualToString:@"书家"]){
        return;
    }
    _emptyBgView.tipsString=@"哦噢,没有符合条件的书法家~";
    [_chooseBtn setTitle:@"书家" forState:UIControlStateNormal];
    [_resultDataArr removeAllObjects];
    [_resultTableView reloadData];
    
    _textField.placeholder=@"书家姓名/昵称";
}
- (IBAction)chooseBtnClick:(id)sender {
    _buttnBgView.hidden=!_buttnBgView.hidden;
}
#pragma mark - textField
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    _buttnBgView.hidden=YES;
    if(![ud_ objectForKey:@"HistorySearchArr"]){
        NSMutableArray *tempArr=[[NSMutableArray alloc]init];
        [tempArr addObject:textField.text];
        [ud_ setValue:tempArr forKey:@"HistorySearchArr"];
    }else{
        NSMutableArray *tempArr=[[ud_ objectForKey:@"HistorySearchArr"] mutableCopy];
        if(![tempArr containsObject:textField.text]){
            [tempArr addObject:textField.text];
            [ud_ setValue:tempArr forKey:@"HistorySearchArr"];
        }
    }
    [ud_ synchronize];
    [textField resignFirstResponder];
    
    [_resultTableView headerBeginRefreshing];
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self predicateSearchText];
    _resultBgView.hidden=YES;
    _historyTableView.hidden=NO;
    
    _buttnBgView.hidden=YES;
}
#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView==_historyTableView){
        return _historyArr.count;
    }
    return _resultDataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView==_historyTableView){
        return 40.0f;
    }else if(_downloadType==2){
        return 125.0f;
    }
    return 275.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(_resultTableView==tableView){
        return 0.0f;
    }
    return 65.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView==_historyTableView){
        MineListCell *cell=[tableView dequeueReusableCellWithIdentifier:@"MineListCell"];
        if(!cell){
            cell=[[[NSBundle mainBundle] loadNibNamed:@"MineListCell" owner:self options:nil]firstObject];
            cell.rightIcon.hidden=YES;
            cell.titleLabel.frame=CGRectMake(30, 0, kkDeviceWidth-30, 39);
        }
        cell.titleLabel.text=_historyArr[indexPath.row];
        return cell;
    }else if(_downloadType==2){
        SerchPenmmanCell *cell=[tableView dequeueReusableCellWithIdentifier:@"SerchPenmmanCell"];
        if(!cell){
            cell=[[[NSBundle mainBundle] loadNibNamed:@"SerchPenmmanCell" owner:self options:nil]firstObject];
        }
        if(_resultDataArr.count!=0){
            PenmanListModel *model=_resultDataArr[indexPath.row];
            [cell reloadCellWithModel:model];
        }
        
        return cell;
    }
    ExampleWorkCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ExampleWorkCell"];
    if(!cell){
        cell=[[[NSBundle mainBundle] loadNibNamed:@"ExampleWorkCell" owner:self options:nil]firstObject];
    }
    if(_resultDataArr.count!=0){
        ExampleWorkModel *model=_resultDataArr[indexPath.row];
        cell.mod=model;
    }
    cell.target = self;
    [cell reloadCellSearchSampleList];
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(tableView==_resultTableView){
        return nil;
    }
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,kkDeviceWidth, 65)];
    headerView.backgroundColor=[UIColor whiteColor];
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(30, 25, kkDeviceWidth-60, 40)];
    titleLabel.font=[UIFont systemFontOfSize:15];
    titleLabel.textColor=toPCcolor(@"888888");
    titleLabel.text=@"历史搜索";
//    UIImageView *line=[[UIImageView alloc]initWithFrame:CGRectMake(0, 64.5, kkDeviceWidth,0.5)];
//    line.image=[UIImage imageNamed:@"line_sample.png"];
//    [headerView addSubview:line];
    [headerView addSubview:titleLabel];
    
    return headerView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView==_historyTableView){
        _textField.text=_historyArr[indexPath.row];
        [self predicateSearchText];
    }else{
        if(_downloadType==1){
            ExampleWorkModel *model=_resultDataArr[indexPath.row];
            ExmapleWorkDetailVC *evc=[[ExmapleWorkDetailVC alloc]initWithArtID:model.ArtID AndArtPrice:model.Price PMID:model.PMID];
            [self.navigationController pushViewController:evc animated:YES];
        }else{
            PenmanListModel *model=_resultDataArr[indexPath.row];
            PenmanDetailViewController *pdvc=[[PenmanDetailViewController alloc]initWithNibName:@"PenmanDetailViewController" bundle:nil];
            pdvc.penmanID=model.UserID;
            [self.navigationController pushViewController:pdvc animated:YES];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
    if ([_historyTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_historyTableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([_historyTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_historyTableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
    if ([_resultTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_resultTableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([_resultTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_resultTableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden=YES;

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
