//
//  MineViewController.m
//  MopinProject
//
//  Created by rt008 on 15/11/23.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "MineViewController.h"
#import "MyTabBarController.h"
#import "LoginViewController.h"
#import "Register1ViewController.h"
#import "MineListCell.h"
#import "GetMopinFundViewController.h"
#import "AddressViewController.h"
#import "ApplyViewController.h"
#import "IssueSampleViewController.h"
#import "PersonalInfoViewController.h"
#import "MyAttentionViewController.h"
#import "MyCustomListVC.h"
#import "MessageViewController.h"
#import "InviteFriendViewController.h"

#import "HelpViewController.h"
#import "UIImageView+WebCache.h"

@interface MineViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    UIImageView *_headeImage;
    UILabel *_nameLabel;
    NSArray *_titleArr;
    PersonalInfoSingleModel *_personalModel;
}
@property (weak, nonatomic) IBOutlet UIView *loginView;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title=@"我的";
    [self setRightNavImageIconWithFrame:CGSizeMake(24, 24) andImageStr:@"what@2x.png"];
    _personalModel=[PersonalInfoSingleModel shareInstance];
    if([mUserDefaults boolForKey:@"Login"]){
        [self loginToMineInfo];
    }else{
        [self createLoginView];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginToMineInfo) name:RefreshMineInfo object:nil];
}
- (void)loginToMineInfo
{
    [self createTbaleView];
    if(_personalModel.UserType.intValue>=2){
        _titleArr=@[@"我的关注",@"我的定制",@"我的消息",@"我的墨基金",@"常用地址",@"邀请好友"];
    }else{
        _titleArr=@[@"我的关注",@"我的定制",@"我的消息",@"我的墨基金",@"常用地址",@"邀请好友",@"申请成为书家",@"发布样品"];
    }
}
//TODO:创建登录需要的界面
- (void)createLoginView
{
    _loginView.hidden=NO;
    _headerImageView.layer.cornerRadius=GETVIEWWIDTH(_headerImageView)/2;
    _headerImageView.layer.masksToBounds=YES;
}
- (IBAction)loginBtnClick:(id)sender {
    LoginViewController *lvc=[[LoginViewController alloc]init];
    lvc.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:lvc animated:YES];
}
- (IBAction)registerBtnClick:(id)sender {
    Register1ViewController *rvc=[[Register1ViewController alloc]init];
    rvc.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:rvc animated:YES];
}
//TODO:创建tableView
- (void)createTbaleView
{
    _loginView.hidden=YES;
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kkDeviceWidth, kkDeviceHeight-mNavBarHeight-mTabBarHeight) style:UITableViewStylePlain];
    _tableView.backgroundColor=toPCcolor(@"#eeeeee");
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];
    
    UIView *tableHeaderView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kkDeviceWidth, 140)];
    tableHeaderView.backgroundColor=toPCcolor(@"#eeeeee");
    
    _headeImage=[[UIImageView alloc]initWithFrame:CGRectMake((kkDeviceWidth-60)/2, 20, 60, 60)];
    [_headeImage sd_setImageWithURL:[NSURL URLWithString:_personalModel.Photo] placeholderImage:mImageByName(PlaceHeaderImage)];
    _headeImage.layer.cornerRadius=CGRectGetHeight(_headeImage.frame)/2;
    _headeImage.layer.masksToBounds=YES;
    [tableHeaderView addSubview:_headeImage];
    
    _nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 90, kkDeviceWidth, 30)];
    _nameLabel.text=_personalModel.NickName;
    _nameLabel.font=[UIFont systemFontOfSize:15];
    _nameLabel.textAlignment=NSTextAlignmentCenter;
    [tableHeaderView addSubview:_nameLabel];
    _tableView.tableHeaderView=tableHeaderView;
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headTap)];
    [tableHeaderView addGestureRecognizer:tap];
    
    if(_personalModel.UserType.intValue>=2){
        [self createFooterView];
    }else{
        _tableView.tableFooterView=[[UIView alloc]init];
    }
}
- (void)createFooterView
{
    UIView *footerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kkDeviceWidth, 55)];
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, kkDeviceWidth-20, 55)];
    label.text=@"切换到书家模式";
    label.textAlignment=NSTextAlignmentCenter;
    label.font=[UIFont systemFontOfSize:15];
    [footerView addSubview:label];
    CGFloat width=[self getWidthByLabel:label];
    label.frame=CGRectMake((kkDeviceWidth-width-10-24)/2, 0, width, 55);
    
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label.frame)+10,18, 24, 19)];
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
    PersonalInfoViewController *pivc=[[PersonalInfoViewController alloc]init];
    pivc.hidesBottomBarWhenPushed=YES;
    [pivc setReloadInfo:^{
        [_headeImage sd_setImageWithURL:[NSURL URLWithString:_personalModel.Photo] placeholderImage:mImageByName(PlaceHeaderImage)];
        _nameLabel.text=_personalModel.NickName;
    }];
    [self.navigationController pushViewController:pivc animated:YES];
}
//TODO:点击底部切换视图
- (void)footerTap{
    MyTabBarController *mtbc=[[MyTabBarController alloc]initWithType:2 andSelectedIndex:0];
    WINDOW.rootViewController=mtbc;
    
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    
    NSDictionary *dic=[ud valueForKey:@"PersonalInfo"];;
    NSMutableDictionary *mutabDic=[NSMutableDictionary dictionaryWithDictionary:dic];
    [mutabDic setValue:@"2" forKey:@"type"];
    
    PersonalInfoSingleModel *personalModel=[PersonalInfoSingleModel shareInstance];
    personalModel.type=@"2";
    
    [ud setValue:mutabDic forKey:@"PersonalInfo"];
    [ud synchronize];
}
//TODO:点击右边按钮
- (void)rightNavBtnClick
{
    HelpViewController *hvc=[[HelpViewController alloc]init];
    hvc.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:hvc animated:YES];
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
        MyAttentionViewController *mavc=[[MyAttentionViewController alloc]init];
        mavc.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:mavc animated:YES];
    }else if(indexPath.row==1){
        MyCustomListVC *myCustomVC=[[MyCustomListVC alloc]init];
        myCustomVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:myCustomVC animated:YES];
    }else if (indexPath.row==2){
        MessageViewController *mvc=[[MessageViewController alloc]init];
        mvc.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:mvc animated:YES];
    }else if(indexPath.row==3){
        GetMopinFundViewController *gpvc=[[GetMopinFundViewController alloc]init];
        gpvc.hidesBottomBarWhenPushed=YES;
        gpvc.type=3;
        [self.navigationController pushViewController:gpvc animated:YES];
    }else if(indexPath.row==4){
        AddressViewController *avc=[[AddressViewController alloc]init];
        avc.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:avc animated:YES];
    }else if(indexPath.row==5){
        InviteFriendViewController *ifvc=[[InviteFriendViewController alloc]init];
        ifvc.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:ifvc animated:YES];
    }else if(indexPath.row==6){
        if(_personalModel.UserType.intValue>=2){
            IssueSampleViewController *isvc=[[IssueSampleViewController alloc]init];
            isvc.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:isvc animated:YES];
        }else{
            ApplyViewController *avc=[[ApplyViewController alloc]init];
            avc.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:avc animated:YES];
        }
        
    }else if(indexPath.row==7){
        IssueSampleViewController *isvc=[[IssueSampleViewController alloc]init];
        isvc.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:isvc animated:YES];
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
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.shadowImage=[UIImage imageNamed:@""];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont fontWithName:XiaoBiaoSong size:18]}];
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
