//
//  FirstSectionView.h
//  MopinProject
//
//  Created by xhd945 on 15/12/10.
//  Copyright © 2015年 rt008. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface CustomControl : UIControl

@property (nonatomic,strong)UIImageView *Icon;//小图表
@property (nonatomic,strong)UILabel *fuctionLabel;//功能说明
@property(nonatomic,strong)UILabel *NumbelLab;//数量

@end


@protocol FirstSectionDelegate <NSObject>

- (void)gotoLogin;  //点赞去登陆
- (void)backToRefreshPenmanDetail;

@end

@interface FirstSectionView : UIView

@property(nonatomic,weak)id<FirstSectionDelegate>delegate;

@property(nonatomic,strong)NSString *ArtID;  //样品ID
@property(nonatomic,strong)NSString*TitleStr; //标题
@property(nonatomic,strong)NSString*AttributeStr;//属性
@property(nonatomic,strong)NSString*EnableJuanStr;//可用劵
@property(nonatomic,strong)NSString*MoPinJuanStr;//磨品劵
@property(nonatomic,strong)NSString*ShujiaJuanStr;//书家劵
@property(nonatomic,strong)NSString*ArtIntroduceStr;//作品介绍
@property(nonatomic,strong)NSString*favoriteNum;//点赞按钮
@property(nonatomic,strong)NSString*collectionNum;//收藏按钮
@property(nonatomic,strong)NSString*finishNum;//成交按钮
@property(nonatomic,strong)NSString*isZan; //是否是赞了
@property(nonatomic,strong)NSString*isCollection; //是否收藏

- (void)UpdateUI;

@end
