//
//  InviteFriendViewController.m
//  MopinProject
//
//  Created by rt008 on 15/12/4.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "InviteFriendViewController.h"
#import "ShareTools.h"

@interface InviteFriendViewController ()

@end

@implementation InviteFriendViewController
{
    NSString *_inviteFriendPrice;//邀请好友好友获得钱
    NSString *_ifReturnPrice; //好友定制成功自己获得钱
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title=@"获取墨品券";
    [self setNavBackBtnWithType:1];
    
//    [self createUI];
    [self getInviteCoupon];
}
//TODO:获取邀请好友
- (void)getInviteCoupon
{
    [SVProgressHUD show];
    
    NSMutableDictionary *parameterDic=[NSMutableDictionary dictionary];
    [parameterDic setValue:@"GetIFCoupon" forKey:@"Method"];
    [parameterDic setValue:Infversion forKey:@"Infversion"];
    
    [HTTPMethod NET_request:1 urlStr:HOSTURL ServiceParameters:parameterDic success:^(NSString *reponse) {
        NSData *jsonDate=[reponse dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary * jsonObject = [NSJSONSerialization JSONObjectWithData:jsonDate options:NSJSONReadingAllowFragments error:&error];
        
        NSString * code = [NSString stringWithFormat:@"%@", jsonObject[@"code"]];
        NSString * msg = jsonObject[@"msg"];
        [DictionaryTool showResult:msg withCode:code.integerValue];
        
        if (code.integerValue == 1000) {
            for(NSDictionary *dic in jsonObject[@"data"]){
                _inviteFriendPrice=dic[@"InviteFriend"];
                _ifReturnPrice=dic[@"IFReturn"];
                [self createUI];
            }
        }
    } failure:^(NSError *error){
        
        [SVProgressHUD dismiss];
        NSLog(@"%@",error);
        
    }];
}
//TODO:创建View
- (void)createUI
{
    NSString *secondStr=[NSString stringWithFormat:@"送上%@元墨品券",_inviteFriendPrice];
    NSString *thirdStr=[NSString stringWithFormat:@"好友定制成功后将送您%@元墨品券",_ifReturnPrice];
    NSArray *titleArr=@[@"为好友第一次定制",secondStr,thirdStr];
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kkDeviceWidth, kkDeviceHeight-mNavBarHeight)];
    NSString *imagePath=[[NSBundle mainBundle] pathForResource:@"invite_bg_coupon@2x" ofType:@"png"];
    
    imageView.image=[UIImage imageWithContentsOfFile:imagePath];
    imageView.contentMode=UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds=YES;
    
    for(int i=0;i<3;i++){
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, kkDeviceHeight-mNavBarHeight-160+i*24, kkDeviceWidth, 24)];
        label.textColor=[UIColor whiteColor];
        label.textAlignment=NSTextAlignmentCenter;
        label.font=[UIFont boldSystemFontOfSize:19];
        label.text=titleArr[i];
        [imageView addSubview:label];
    }
    [self.view addSubview:imageView];
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"立即邀请" forState:UIControlStateNormal];
    button.frame=CGRectMake(0, kkDeviceHeight-50-mNavBarHeight, kkDeviceWidth, 50);
    [button setBackgroundImage:[UIImage imageNamed:@"red_button_apply.png"] forState:UIControlStateNormal];
    button.titleLabel.font=[UIFont fontWithName:XiaoBiaoSong size:18];
    [self.view addSubview:button];
    
    [button addTarget:self action:@selector(inviteBtnClick) forControlEvents:UIControlEventTouchUpInside];
}
//TODO:立即邀请
- (void)inviteBtnClick
{
//    [ShareTools shareAllButtonClickHandler:@"小伙伴们，快来和我一起加入墨品吧~" andUser:nil andUrl:@"www.baidu.com" andDes:@"快来和我一起加入墨品吧~"];
//    [ShareTools shareAllButtonClickHandler:@"全国的书法大家、名家和书家都汇聚在此，任您挑选！直接和心仪的书家定制您想要的：书体、幅式、内容、题款…" andUser:nil andUrl:SHARE_INVITE_URL andDes:nil andTitle:@"立即领取100元墨基金，千名书法家为你定制!"];
//    [ShareTools shareAllButtonClickHandler:@"全国的书法大家、名家和书家都汇聚在此，任您挑选！直接和心仪的书家定制您想要的：书体、幅式、内容、题款…" andType:ShareMopinInviteFriendType andUrl:SHARE_INVITE_URL andDes:nil andTitle:@"立即领取100元墨基金，千名书法家为你定制!"];
    
    ShareMopinModel *shareModel=[[ShareMopinModel alloc]init];
    shareModel.desc=@"全国的书法大家、名家和书家都汇聚在此，任您挑选！直接和心仪的书家定制您想要的：书体、幅式、内容、题款…";
    shareModel.type=ShareMopinInviteFriendType;
    shareModel.title=@"立即领取100元墨基金，千名书法家为你定制!";
    shareModel.shareUrl=SHARE_INVITE_URL;
    [ShareTools shareAllButtonClickHandler:shareModel andSucess:nil];
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
