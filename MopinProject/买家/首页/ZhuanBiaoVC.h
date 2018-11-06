//
//  ZhuanBiaoVC.h
//  MopinProject
//
//  Created by xhd945 on 15/12/16.
//  Copyright © 2015年 rt008. All rights reserved.
//

#import "BaseSuperViewController.h"
@class ZhuanBiaoTypeMod;
@protocol FinishZhuanBiaoChooseDelegate <NSObject>

- (void)finishZhuanBiaoChooseWithZhuanBiaoModel:(ZhuanBiaoTypeMod*)mod;

@end


@interface ZhuanBiaoVC : BaseSuperViewController

@property(nonatomic,strong)NSString *ArtID;  //样品ID
@property(nonatomic,strong)NSString *ArtPic;  //样品图片
@property(nonatomic,weak)id<FinishZhuanBiaoChooseDelegate> delegate;

- (instancetype)initWithArtID:(NSString*)artID AndModel:(ZhuanBiaoTypeMod*)ZbTypeMod;

@end
