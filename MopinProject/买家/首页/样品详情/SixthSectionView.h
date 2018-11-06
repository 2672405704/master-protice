//
//  SixthSectionView.h
//  MopinProject
//
//  Created by xhd945 on 15/12/11.
//  Copyright © 2015年 rt008. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol sixthSectionViewDelegate <NSObject>

-(void)checkPenManDetailWithPenManID:(NSString*)penManID;

@end

@interface SixthSectionView : UIView

@property(nonatomic,strong)NSString*PenmanName;//书家名称
@property(nonatomic,strong)NSString*PenmanID;  //书家ID
@property(nonatomic,strong)NSString*PenmanType;//书家类别
@property(nonatomic,strong)NSString*IsBooked;//是否签约 0：未签约 1：签约
@property(nonatomic,strong)NSString*Signature;//书家签名（书家简介）
@property(nonatomic,strong)NSString*Photo;//头像地址
@property(nonatomic,strong)NSString*Trend;//势：-1:下降  0：不变  1：上升
@property(nonatomic,strong)NSString*NPrice;//润格价格
@property(nonatomic,strong)NSString*AveragePrice;//均价
@property(nonatomic,weak)id<sixthSectionViewDelegate>delegate;

- (void)UpdateUI;

@end
