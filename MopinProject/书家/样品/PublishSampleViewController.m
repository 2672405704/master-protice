//
//  PublishSampleViewController.m
//  MopinProject
//
//  Created by rt008 on 15/11/27.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "PublishSampleViewController.h"
#import "MineListCell.h"
#import "ChooseWordNumViewController.h"
#import "PublishSampleModel.h"
#import "RecommendContentViewController.h"
#import "RecommendContentModel.h"
#import "IssueSampleViewController.h"

@interface PublishSampleViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSArray *_titleArr;
}
@end

@implementation PublishSampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title=@"发布作品";
    [self setNavBackBtnWithType:1];
    _titleArr=@[@"请选择定制正文字数",@"样品正文内容",@"您推荐的内容",@"是否接受题款"];
    
    [self createTbaleView];
}
//TODO:创建tableView
- (void)createTbaleView
{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kkDeviceWidth, kkDeviceHeight-mNavBarHeight-mTabBarHeight) style:UITableViewStylePlain];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.tableFooterView=[[UIView alloc]init];
    _tableView.backgroundColor=self.view.backgroundColor;
    _tableView.scrollEnabled=NO;
    [self.view addSubview:_tableView];
    
    UIButton *boomBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    boomBtn.frame=CGRectMake(0, kkDeviceHeight-mTabBarHeight-mNavBarHeight, kkDeviceWidth,mTabBarHeight);
    boomBtn.titleLabel.font=[UIFont fontWithName:XiaoBiaoSong size:18];
    [boomBtn setBackgroundImage:[UIImage imageNamed:@"red_button_apply.png"] forState:UIControlStateNormal];
    [boomBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [self.view addSubview:boomBtn];
    
    [boomBtn addTarget:self action:@selector(nextStepClick) forControlEvents:UIControlEventTouchUpInside];
}
//TODO:下一步
- (void)nextStepClick
{
    if(_publishModel.MinWordNum.length==0){
        [SVProgressHUD showErrorWithStatus:@"请选择定制正文字数"];
        return;
    }
    if(_publishModel.Content.length==0){
        [SVProgressHUD showErrorWithStatus:@"请输入样品正文内容"];
        return;
    }
    if(_publishModel.TiKuan.length==0){
        [SVProgressHUD showErrorWithStatus:@"请选择是否接受题款"];
        return;
    }
    
    IssueSampleViewController *isvc=[[IssueSampleViewController alloc]init];
    isvc.model=_publishModel;
    isvc.type=1;
    [self.navigationController pushViewController:isvc animated:YES];
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
    MineListCell *cell=[_tableView dequeueReusableCellWithIdentifier:@"MineListCell"];
    if(!cell){
        cell=[[[NSBundle mainBundle] loadNibNamed:@"MineListCell" owner:self options:nil]firstObject];
        cell.rightLabel.textColor=toPCcolor(@"888888");
        cell.rightLabel.hidden=NO;
    }
    if(indexPath.row==0){
        cell.titleLabel.frame=CGRectMake(30, 11, 180, CGRectGetHeight(cell.titleLabel.frame));
        if(_publishModel.MinWordNum.length!=0){
            cell.rightLabel.text=[NSString stringWithFormat:@"%@-%@字",_publishModel.MinWordNum,_publishModel.MaxWordNum];
        }
    }else if(indexPath.row==1){
        if(_publishModel.Content.length!=0){
            cell.rightLabel.text=_publishModel.Content;
        }
    }else if(indexPath.row==2){
        if(_publishModel.RCIDList.count!=0){
            RecommendContentModel *model=_publishModel.RCIDList[0];
            cell.rightLabel.text=model.RCContent;
        }
    }else{
        if(_publishModel.TiKuan.length!=0){
            if(_publishModel.TiKuan.intValue==0){
                cell.rightLabel.text=@"不接受题款";
            }else{
                cell.rightLabel.text=@"接受题款";
            }
        }
    }
//    cell.rightLabel.text=@"朱开发";
//    cell.titleLabel.backgroundColor=[UIColor redColor];
    cell.titleLabel.text=_titleArr[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakSelf=self;
    if(indexPath.row==0){
        ChooseWordNumViewController *cwnvc=[[ChooseWordNumViewController alloc]init];
        cwnvc.type=1;
        cwnvc.publishModel=_publishModel;
        [cwnvc setChooseWordNum:^(NSInteger minWordNum, NSInteger maxWordNum) {
            weakSelf.publishModel.MaxWordNum=[NSString stringWithFormat:@"%@",@(maxWordNum)];
            weakSelf.publishModel.MinWordNum=[NSString stringWithFormat:@"%@",@(minWordNum)];
            [_tableView reloadData];
        }];
        [self.navigationController pushViewController:cwnvc animated:YES];
    }else if(indexPath.row==1){
        ChooseWordNumViewController *cwnvc=[[ChooseWordNumViewController alloc]init];
        cwnvc.publishModel=_publishModel;
        cwnvc.type=2;
        [cwnvc setInputText:^(NSString *text) {
            weakSelf.publishModel.Content=text;
            [_tableView reloadData];
        }];
        [self.navigationController pushViewController:cwnvc animated:YES];
    }else if(indexPath.row==2){
        RecommendContentViewController *rvc=[[RecommendContentViewController alloc]init];
        rvc.RCArr=_publishModel.RCIDList;
        [rvc setGetrecommendContent:^(NSArray *recommendArr) {
            weakSelf.publishModel.RCIDList=recommendArr;
            [_tableView reloadData];
        }];
        [self.navigationController pushViewController:rvc animated:YES];
    }else{
        ChooseWordNumViewController *cwnvc=[[ChooseWordNumViewController alloc]init];
        cwnvc.publishModel=_publishModel;
        cwnvc.type=3;
        [cwnvc setChooseTikuan:^(NSInteger selectedIndex) {
            weakSelf.publishModel.TiKuan=[NSString stringWithFormat:@"%@",@(selectedIndex)];
            [_tableView reloadData];
        }];
        [self.navigationController pushViewController:cwnvc animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
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
