//
//  PaySuccessfulVC.m
//  MopinProject
//
//  Created by xhd945 on 15/12/17.
//  Copyright © 2015年 rt008. All rights reserved.
//

#import "PaySuccessfulVC.h"
#import "ShareTools.h"
#import "ExmapleWorkDetailVC.h"
#import "MyCustomListVC.h"

#define TipsHeight kkDeviceHeight*0.0265
#define ButtonHeight kkDeviceHeight*0.043
#define TipsFontSize ((13/568.0)*kkDeviceHeight)

@interface PaySuccessfulVC ()
{
    UIView *firstView;
    UIView *secondView;
    UIView *thirdView;
}

@end

@implementation PaySuccessfulVC
- (instancetype)initWithSJCoupon:(NSString*)SJCoupon
                    InviteFriend:(NSString*)InviteFriend
                        IFReturn:(NSString*)IFReturn
                      OrderShare:(NSString*)OrderShare
{
    self = [super init];
    if (self) {
        
        _SJCoupon = SJCoupon;
        _InviteFriend = InviteFriend;
        _IFReturn = IFReturn;
        _OrderShare = OrderShare;
        
    }
    return self;
}


#pragma  mark -- 返回
-(void)backBtnClick
{
    /*返回控制，直接下单的话是跳到样品详情，从我的定制来的话，就条转到我的定制*/
    for (BaseSuperViewController *detail in self.navigationController.viewControllers)
    {
        if([detail isKindOfClass:[ExmapleWorkDetailVC class]])
        {
            [self.navigationController popToViewController:detail animated:YES];
            
        }
        if([detail isKindOfClass:[MyCustomListVC class]])
        {
            [self.navigationController popToViewController:detail animated:YES];
            
        }
        
    }

}

#pragma mark --  视图循环
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title=@"支付成功";
    [self setNavBackBtnWithType:1];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createHeaderView];
    [self inviteFriendNowView];
    [self shareToFriendNowView];
    
}

#pragma mark -- 上面的视图
- (void)createHeaderView
{
    firstView = [[UIView alloc]initWithFrame:mRect(0, 0, kkDeviceWidth, kkDeviceHeight*0.35)];
    [self.view addSubview:firstView];
    
    UIImageView * failImage = [XHDHelper createImageViewWithFrame:mRect(kkDeviceWidth*0.375+10, 45, kkDeviceWidth*0.25-20, kkDeviceWidth*0.25-20) AndImageName:@"checkmark_circle" AndCornerRadius:0 andGestureRecognizer:0 AndTarget:self AndAction:nil];
    [firstView addSubview:failImage];
    
    
    //定制成功
    UILabel *bigTips = [XHDHelper createLabelWithFrame:mRect(kkDeviceWidth/4.0-20,failImage.bottom+12, kkDeviceWidth/2.0+40, 30) andText:@"恭喜您，已经定制成功" andFont:UIFONT_Tilte(TipsFontSize+5) AndBackGround:[UIColor clearColor] AndTextColor:THEMECOLOR_1];
    bigTips.textAlignment = NSTextAlignmentCenter;
    [firstView addSubview:bigTips];
    
    //提示
    UILabel *smallTips_1 = [XHDHelper createLabelWithFrame:mRect(bigTips.origin.x,bigTips.bottom+10, bigTips.width, TipsHeight) andText:@"完成评价后" andFont:UIFONT(TipsFontSize) AndBackGround:[UIColor clearColor] AndTextColor:TipsFontColor];
    smallTips_1.textAlignment = NSTextAlignmentCenter;
    [firstView addSubview:smallTips_1];
    
    NSString*sjCoupon = [NSString stringWithFormat:@"您将获得%@元书家劵",_SJCoupon.length?_SJCoupon:@"0"];
    UILabel *smallTips_2 = [XHDHelper createLabelWithFrame:mRect(bigTips.origin.x,smallTips_1.bottom+5, bigTips.width, TipsHeight) andText:sjCoupon andFont:UIFONT(TipsFontSize) AndBackGround:[UIColor clearColor] AndTextColor:TipsFontColor];
    smallTips_2.textAlignment = NSTextAlignmentCenter;
    [firstView addSubview:smallTips_2];
    
    if(sjCoupon.integerValue == 0)
    {
        smallTips_1.hidden = YES;
        smallTips_2.hidden = YES;
    }
    
}
#pragma --mark 第二段立即邀请
- (void)inviteFriendNowView
{
    secondView = [[UIView alloc]initWithFrame:mRect(0, firstView.bottom+43, kkDeviceWidth, kkDeviceHeight*0.22)];
    secondView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:secondView];
    
    //提示
    NSString*inviteFriend = [NSString stringWithFormat:@"为好友第一次定制送上%@元墨品劵",_InviteFriend.length?_InviteFriend:@"0"];
    UILabel *smallTips_1 = [XHDHelper createLabelWithFrame:mRect(50,20, secondView.width-100, TipsHeight) andText:inviteFriend andFont:UIFONT(TipsFontSize) AndBackGround:[UIColor clearColor] AndTextColor:TipsFontColor];
    smallTips_1.textAlignment = NSTextAlignmentCenter;
    [secondView addSubview:smallTips_1];
    
    
    NSString* IFReturn = [NSString stringWithFormat:@"好友定制成功后将送你%@元墨品劵",_IFReturn.length?_IFReturn:@"0"];
    UILabel *smallTips_2 = [XHDHelper createLabelWithFrame:mRect(smallTips_1.origin.x,smallTips_1.bottom+5, smallTips_1.width, TipsHeight) andText:IFReturn andFont:UIFONT(TipsFontSize) AndBackGround:[UIColor clearColor] AndTextColor:TipsFontColor];
    smallTips_2.textAlignment = NSTextAlignmentCenter;
    [secondView addSubview:smallTips_2];
    
    //立即邀请按钮
    UIButton *inivteBnt = [XHDHelper createButton:mRect(secondView.width/2.0-50, smallTips_2.bottom+15, 100, ButtonHeight) NomalTitle:@"立即邀请" SelectedTitle:@"立即邀请"  NomalTitleColor:THEMECOLOR_1 SelectTitleColor:THEMECOLOR_1  NomalImage:nil SelectedImage:nil BoardLineWidth:0.8 target:self selector:@selector(inviteFriendNowAction:)];
    inivteBnt.titleLabel.font = UIFONT_Tilte(TipsFontSize+2);
    [secondView addSubview:inivteBnt];
    
    secondView.bottom = kkDeviceHeight-kkDeviceHeight*0.22-74;
    
    
}

/*立即邀请好友*/
- (void)inviteFriendNowAction:(UIButton*)sender
{

    NSString* shareStr_1 = [NSString stringWithFormat:@"立即领取%@元墨基金，千名书法家为你定制!",_OrderShare.length?_OrderShare:@"0"];
//    [ShareTools shareAllButtonClickHandler:@"全国的书法大家、名家和书家都汇聚在此，任您挑选！直接和心仪的书家定制您想要的：书体、幅式、内容、题款…" andUser:nil andUrl:SHARE_INVITE_URL andDes:nil andTitle:shareStr_1];
//    [ShareTools shareAllButtonClickHandler:@"全国的书法大家、名家和书家都汇聚在此，任您挑选！直接和心仪的书家定制您想要的：书体、幅式、内容、题款…" andType:ShareMopinInviteFriendType andUrl:SHARE_INVITE_URL andDes:nil andTitle:shareStr_1];
    
    ShareMopinModel *shareModel=[[ShareMopinModel alloc]init];
    shareModel.desc=@"全国的书法大家、名家和书家都汇聚在此，任您挑选！直接和心仪的书家定制您想要的：书体、幅式、内容、题款…";
    shareModel.type=ShareMopinInviteFriendType;
    shareModel.title=shareStr_1;
    shareModel.shareUrl=SHARE_INVITE_URL;
    [ShareTools shareAllButtonClickHandler:shareModel andSucess:nil];
    
}

#pragma --mark 第三段立即分享
- (void)shareToFriendNowView
{
    thirdView = [[UIView alloc]initWithFrame:mRect(0, secondView.bottom+10, kkDeviceWidth,secondView.height)];
    thirdView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:thirdView];
    thirdView.bottom = kkDeviceHeight-64;
    
    //提示
     NSString* OrderShare = [NSString stringWithFormat:@"本次定制可分享给好友%@元墨品劵",_OrderShare.length?_OrderShare:@"0"];
    UILabel *smallTips_1 = [XHDHelper createLabelWithFrame:mRect(50,25, thirdView.width-100, kkDeviceHeight*0.0265) andText:OrderShare andFont:UIFONT(TipsFontSize) AndBackGround:[UIColor clearColor] AndTextColor:TipsFontColor];
    smallTips_1.textAlignment = NSTextAlignmentCenter;
    [thirdView addSubview:smallTips_1];
    
    //立即邀请按钮
    UIButton *inivteBnt = [XHDHelper createButton:mRect(secondView.width/2.0-50, smallTips_1.bottom+15, 100, ButtonHeight) NomalTitle:@"立即分享" SelectedTitle:@"立即分享"  NomalTitleColor:THEMECOLOR_1 SelectTitleColor:THEMECOLOR_1  NomalImage:nil SelectedImage:nil BoardLineWidth:0.8 target:self selector:@selector(shareToFriendNowAction:)];
    inivteBnt.titleLabel.font = UIFONT_Tilte(TipsFontSize);
    [thirdView addSubview:inivteBnt];

}
/*立即分享*/
- (void)shareToFriendNowAction:(UIButton*)sender
{
     NSString* shareStr_2 = [NSString stringWithFormat:@"立即领取%@元墨基金，千名书法家为你定制!",_OrderShare.length?_OrderShare:@"0"];
//    [ShareTools shareAllButtonClickHandler:@"全国的书法大家、名家和书家都汇聚在此，任您挑选！直接和心仪的书家定制您想要的：书体、幅式、内容、题款…" andUser:nil andUrl:SHARE_INVITE_URL andDes:nil andTitle:shareStr_2];
//    [ShareTools shareAllButtonClickHandler:@"全国的书法大家、名家和书家都汇聚在此，任您挑选！直接和心仪的书家定制您想要的：书体、幅式、内容、题款…" andType:ShareMopinInviteFriendType andUrl:SHARE_INVITE_URL andDes:nil andTitle:shareStr_2];
    
    ShareMopinModel *shareModel=[[ShareMopinModel alloc]init];
    shareModel.desc=@"全国的书法大家、名家和书家都汇聚在此，任您挑选！直接和心仪的书家定制您想要的：书体、幅式、内容、题款…";
    shareModel.type=ShareMopinInviteFriendType;
    shareModel.title=shareStr_2;
    shareModel.shareUrl=SHARE_INVITE_URL;
    [ShareTools shareAllButtonClickHandler:shareModel andSucess:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

@end
