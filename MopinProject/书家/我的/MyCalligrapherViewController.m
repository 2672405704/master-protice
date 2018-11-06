//
//  MyCalligrapherViewController.m
//  MopinProject
//
//  Created by rt008 on 15/11/23.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "MyCalligrapherViewController.h"
#import "MyTabBarController.h"
#import "MineListCell.h"
#import "ApplyMasterViewController.h"
#import "SetStockViewController.h"
#import "CertificationSignViewController.h"
#import "HomePageManagerViewController.h"
#import "CertificationSignFailViewController.h"
#import "CertificationSignScucessViewController.h"
#import "MessageViewController.h"
#import "UIImageView+WebCache.h"
#import "SucessfulViewController.h"
#import "ActivityWebVC.h"

@interface MyCalligrapherViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSArray *_titleArr;
    UIImageView *_headImage;
    UILabel *_nameLabel;
    PersonalInfoSingleModel *_personalModel;
}
@end

@implementation MyCalligrapherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title=@"我的";
    _personalModel=[PersonalInfoSingleModel shareInstance];
    if(_personalModel.UserType.intValue>2 && _personalModel.Sign.intValue!=2){
        _titleArr=@[@"主页管理",@"可接受定制数",@"我的消息",@"签约认证",@"书家指南"];
    }else if(_personalModel.UserType.intValue>2 && _personalModel.Sign.intValue==2){
        _titleArr=@[@"主页管理",@"可接受定制数",@"我的消息",@"书家指南"];
    }else if(_personalModel.UserType.intValue<=2 && _personalModel.Sign.intValue==2){
         _titleArr=@[@"主页管理",@"可接受定制数",@"我的消息",@"成为名家",@"书家指南"];
    }else{
        _titleArr=@[@"主页管理",@"可接受定制数",@"我的消息",@"签约认证",@"成为名家",@"书家指南"];
    }
    
    [self createTbaleView];
    [self downloadPMStockNum];
}
//TODO:下载可接受定制数
- (void)downloadPMStockNum
{
    [SVProgressHUD show];
    
    NSMutableDictionary *parameterDic=[NSMutableDictionary dictionary];
    [parameterDic setValue:@"GetPMStockNum" forKey:@"Method"];
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
            _personalModel.StockNum=jsonObject[@"data"][@"StockNum"];
            [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }
    } failure:^(NSError *error){
        
        [SVProgressHUD dismiss];
        NSLog(@"%@",error);
        
    }];
}
//TODO:创建tableView
- (void)createTbaleView
{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kkDeviceWidth, kkDeviceHeight-mNavBarHeight-mTabBarHeight) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=self.view.backgroundColor;
    [self.view addSubview:_tableView];
    
    UIView *tableHeaderView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kkDeviceWidth, 140)];
    tableHeaderView.backgroundColor=toPCcolor(@"#eeeeee");
    
    _headImage=[[UIImageView alloc]initWithFrame:CGRectMake((kkDeviceWidth-60)/2, 20, 60, 60)];
    _headImage.layer.cornerRadius=GETVIEWHEIGHT(_headImage)/2;
    _headImage.layer.masksToBounds=YES;
    
    [_headImage sd_setImageWithURL:[NSURL URLWithString:_personalModel.Photo] placeholderImage:mImageByName(PlaceHeaderImage)];
    [tableHeaderView addSubview:_headImage];
    
    _nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 90, kkDeviceWidth, 30)];
    _nameLabel.text=_personalModel.NickName;
    _nameLabel.font=[UIFont systemFontOfSize:15];
    _nameLabel.textAlignment=NSTextAlignmentCenter;
    [tableHeaderView addSubview:_nameLabel];
    _tableView.tableHeaderView=tableHeaderView;
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headTap)];
    [tableHeaderView addGestureRecognizer:tap];
    
    CGRect rect=[_tableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:_titleArr.count-1 inSection:0]];
    CGFloat height=kkDeviceHeight-(rect.origin.y+45)-mNavBarHeight-mTabBarHeight;
    CGFloat footerHeight=height>55?height:55;
    UIView *footerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kkDeviceWidth,footerHeight)];
    
    
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 55, (footerHeight-55), 55)];
    label.text=@"切换到买家模式";
    label.textAlignment=NSTextAlignmentCenter;
    label.font=[UIFont systemFontOfSize:15];
    [footerView addSubview:label];
    CGFloat width=[self getWidthByLabel:label];
    
    label.frame=CGRectMake((kkDeviceWidth-width-10-24)/2, footerHeight-55, width, 55);
    
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label.frame)+10,18+footerHeight-55, 24, 19)];
    imageView.image=[UIImage imageNamed:@"refresh_mine.png"];
    [footerView addSubview:imageView];
    
    _tableView.tableFooterView=footerView;
    
//    UITapGestureRecognizer *tap2=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(footerTap)];
//    [footerView addGestureRecognizer:tap2];
    UIControl *control=[[UIControl alloc]initWithFrame:CGRectMake(CGRectGetMinX(label.frame), CGRectGetMinY(label.frame), CGRectGetWidth(label.frame)+10+24, 55)];
    [control addTarget:self action:@selector(footerTap) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:control];
}
//TODD:点击头像
- (void)headTap
{
    
}
//TODO:点击底部切换视图
- (void)footerTap{
    MyTabBarController *mtbc=[[MyTabBarController alloc]initWithType:1 andSelectedIndex:0];
    WINDOW.rootViewController=mtbc;
    
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    
    NSDictionary *dic=[ud valueForKey:@"PersonalInfo"];;
    NSMutableDictionary *mutabDic=[NSMutableDictionary dictionaryWithDictionary:dic];
    [mutabDic setValue:@"1" forKey:@"type"];
    
    _personalModel.type=@"1";
    
    [ud setValue:mutabDic forKey:@"PersonalInfo"];
    [ud synchronize];
}
#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MineListCell *cell=[[[NSBundle mainBundle] loadNibNamed:@"MineListCell" owner:self options:nil]firstObject];
    cell.titleLabel.text=_titleArr[indexPath.row];
    if(indexPath.row==1){
        cell.rightLabel.hidden=NO;
        cell.rightLabel.textColor=toPCcolor(@"ca3b2b");
        cell.rightLabel.text=_personalModel.StockNum.length==0?@"":[NSString stringWithFormat:@"%@件",_personalModel.StockNum];
    }else{
        cell.rightLabel.hidden=YES;
    }
    if(indexPath.row==2){
        cell.pointImageView.hidden=NO;
        CGFloat width=[self getWidthByLabel:cell.titleLabel];
        CGRect frame=cell.pointImageView.frame;
        frame.origin.x=30+width;
        cell.pointImageView.frame=frame;
        
    }else{
        cell.pointImageView.hidden=YES;
    }

    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0){
        HomePageManagerViewController *hpvc=[[HomePageManagerViewController alloc]init];
        hpvc.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:hpvc animated:YES];
    }else if(indexPath.row==1){
        SetStockViewController *ssvc=[[SetStockViewController alloc]initWithNibName:@"SetStockViewController" bundle:nil];
        ssvc.hidesBottomBarWhenPushed=YES;
        [ssvc setReloadCell:^(NSString *count) {
            _personalModel.StockNum=count;
            [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }];
        [self.navigationController pushViewController:ssvc animated:YES];
    }else if(indexPath.row==2){
        MessageViewController *mvc=[[MessageViewController alloc]init];
        mvc.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:mvc animated:YES];
    }else if(indexPath.row==3){
        //已认证
        if(_personalModel.Sign.intValue==2){
            //已签约
            if(_personalModel.UserType.integerValue>2){
                [self openMasterGuide];
            }else{
                [self pushToApplyMasterViewController];
            }

            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            return;
        }
        
        if(_personalModel.Sign.intValue==0){
            CertificationSignViewController *csvc=[[CertificationSignViewController alloc]initWithNibName:@"CertificationSignViewController" bundle:nil];
            csvc.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:csvc animated:YES];
        }else if(_personalModel.Sign.intValue==1){
            SucessfulViewController *svc=[[SucessfulViewController alloc]initWithNibName:@"SucessfulViewController" bundle:nil];
            svc.type=1;
            svc.navTitle=@"签约认证";
            svc.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:svc animated:YES];
        }else if(_personalModel.Sign.intValue==2){
            CertificationSignScucessViewController *csvc=[[CertificationSignScucessViewController alloc]initWithNibName:@"CertificationSignScucessViewController" bundle:nil];
            csvc.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:csvc animated:YES];
        }else{
            CertificationSignFailViewController *csvc=[[CertificationSignFailViewController alloc]initWithNibName:@"CertificationSignFailViewController" bundle:nil];
            csvc.hidesBottomBarWhenPushed=YES;
            csvc.type=1;
            [self.navigationController pushViewController:csvc animated:YES];
        }
        
    }else if(indexPath.row==4){
        if(_personalModel.Sign.intValue==2 || _personalModel.UserType.integerValue>2){
                [self openMasterGuide];
            
        }else{
            [self pushToApplyMasterViewController];
        }
    }else if (indexPath.row==5){
        [self openMasterGuide];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
//TODO:书家指南
- (void)openMasterGuide
{
    ActivityWebVC *awvc=[[ActivityWebVC alloc]initWithURL:[NSURL URLWithString:BOOK_GUIDE_URL]];
    awvc.titleName=@"书家指南";
    awvc.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:awvc animated:YES];

}
//TODO:点击申请名家
- (void)pushToApplyMasterViewController
{
    if(_personalModel.UserType.intValue==2){
        if(_personalModel.ApplyState.intValue==0){
            SucessfulViewController *svc=[[SucessfulViewController alloc]initWithNibName:@"SucessfulViewController" bundle:nil];
            svc.type=1;
            svc.navTitle=@"申请成为书法名家";
            svc.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:svc animated:YES];
        }else if(_personalModel.ApplyState.intValue==2){
            CertificationSignFailViewController *csvc=[[CertificationSignFailViewController alloc]initWithNibName:@"CertificationSignFailViewController" bundle:nil];
            csvc.hidesBottomBarWhenPushed=YES;
            csvc.type=2;
            [self.navigationController pushViewController:csvc animated:YES];
        }else{
            ApplyMasterViewController *amvc=[[ApplyMasterViewController alloc]initWithNibName:@"ApplyMasterViewController" bundle:nil];
            amvc.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:amvc animated:YES];
        }
    }
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
//TODO:获取宽度
- (CGFloat)getWidthByLabel:(UILabel *)label
{
    CGFloat width;
    if(IOS7_AND_LATER){
        width=[label.text boundingRectWithSize:CGSizeMake(170,21) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:label.font} context:nil].size.width;
    }else{
        width=[label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(170,21) lineBreakMode:NSLineBreakByCharWrapping].width;
    }
    return width;
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
