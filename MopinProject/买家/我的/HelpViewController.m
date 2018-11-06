//
//  HelpViewController.m
//  MopinProject
//
//  Created by rt008 on 15/12/15.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "HelpViewController.h"
#import "MineListCell.h"
#import "FeedBackViewController.h"
#import "LoginViewController.h"
#import "ActivityWebVC.h"

#if 1 //1-测试 0-正式

#define kHostURL @"http://app.mopin.net"

#else

#define kHostURL @"http://101.200.74.205:8081"

#endif


@interface HelpViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation HelpViewController
{
    UITableView *_tableView;
    NSArray *_titleArr;  //标题数组
    PersonalInfoSingleModel *_personalModel;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title=@"帮助";
    [self setNavBackBtnWithType:1];
    _titleArr=@[@"定制说明",@"关于墨基金",@"装裱物流",@"售后须知",@"成为书家",@"发布样品",@"关于墨品",@"用户反馈",@"当前版本"];
    _personalModel=[PersonalInfoSingleModel shareInstance];
    
    [self createTableView];
}
//TODO:创建表格视图
- (void)createTableView
{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kkDeviceWidth, kkDeviceHeight-mNavBarHeight-mTabBarHeight) style:UITableViewStylePlain];
    _tableView.backgroundColor=self.view.backgroundColor;
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.tableFooterView=[[UIView alloc]init];
    _tableView.scrollEnabled=NO;
    [self.view addSubview:_tableView];
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
    }
    cell.titleLabel.text=_titleArr[indexPath.row];
    if(indexPath.row==_titleArr.count-1){
        cell.rightLabel.hidden=NO;
        cell.rightIcon.hidden=YES;
        cell.rightLabel.frame=CGRectMake(cell.frame.size.width-30-100, 0, 100,44);
        cell.rightLabel.text=@"1.0.0";//[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    }else{
        cell.rightLabel.hidden=YES;
        cell.rightIcon.hidden=NO;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *urlStr ;
    NSString *titleName;
    switch (indexPath.row) {
        case 0:  //@"定制说明"
        {
            urlStr = [NSString stringWithFormat:@"%@/moping-http/dzsm",kHostURL];
            titleName = @"定制说明";
            [self jumpHelpVCWithURLStr:urlStr titleName:titleName];
        }
            break;
        case 1:  //"关于墨基金"
        {
            urlStr = [NSString stringWithFormat:@"%@/moping-http/gymjj",kHostURL];
            titleName = @"关于墨基金";
            [self jumpHelpVCWithURLStr:urlStr titleName:titleName];
        }
            break;
        case 2: //@"装裱物流"

        {
            urlStr = [NSString stringWithFormat:@"%@/moping-http/zbsm",kHostURL];
            titleName = @"装裱物流";
            [self jumpHelpVCWithURLStr:urlStr titleName:titleName];
        }
            break;
        case 3: //@"售后须知"
        {
            urlStr = [NSString stringWithFormat:@"%@/moping-http/shxz",kHostURL];
            titleName = @"售后须知";
            [self jumpHelpVCWithURLStr:urlStr titleName:titleName];
        }
            break;
        case 4: //,@"成为书家"
        {
            urlStr = [NSString stringWithFormat:@"%@/moping-http/cwsj",kHostURL];
            titleName = @"成为书家";
            [self jumpHelpVCWithURLStr:urlStr titleName:titleName];
        }
            break;
        case 5:  //发布样品
        {
           urlStr = [NSString stringWithFormat:@"%@/moping-http/fbyp",kHostURL];
            titleName = @"发布样品";
            [self jumpHelpVCWithURLStr:urlStr titleName:titleName];
        }
            break;
        case 6:  //@"关于墨品"
        {
            urlStr = [NSString stringWithFormat:@"%@/moping-http/gymp",kHostURL];
            titleName = @"关于墨品";
            [self jumpHelpVCWithURLStr:urlStr titleName:titleName];
        }
            break;
        case 7:  //@"用户反馈"
        {
            if(!_personalModel.isLogin){
                [self login];
            }else{
                FeedBackViewController *fvc=[[FeedBackViewController alloc]initWithNibName:@"FeedBackViewController" bundle:nil];
                [self.navigationController pushViewController:fvc animated:YES];
            }
            
        }
            break;
            
        default:
            
            break;
    }
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
/*webVC跳转*/
-(void)jumpHelpVCWithURLStr:(NSString*)urlStr titleName:(NSString*)titleName
{
    ActivityWebVC *helpVC = [[ActivityWebVC alloc]initWithURL:[NSURL URLWithString:urlStr]];
    helpVC.titleName = titleName;
    helpVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:helpVC animated:YES];

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
//TODO:登录
- (void)login
{
    LoginViewController *lvc=[[LoginViewController alloc]init];
    lvc.formVCTag=1;
    lvc.hidesBottomBarWhenPushed=YES;
    UINavigationController *nc=[[UINavigationController alloc]initWithRootViewController:lvc];
    
    [self presentViewController:nc animated:YES completion:nil];
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
