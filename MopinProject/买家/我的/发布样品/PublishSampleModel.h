//
//  PublishSampleModel.h
//  MopinProject
//
//  Created by rt008 on 15/11/27.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "SuperModel.h"

@class SampleAttributeModel;
@interface PublishSampleModel : SuperModel
@property (nonatomic,copy) NSString *ArtID;
@property (nonatomic,strong) SampleAttributeModel *WordTypeModel;
@property (nonatomic,strong) SampleAttributeModel *ShowTypeModel;
@property (nonatomic,copy) NSString *MaxWordNum;
@property (nonatomic,copy) NSString *MinWordNum;
@property (nonatomic,copy) NSString *Content;
@property (nonatomic,strong) NSArray *RCIDList;
@property (nonatomic,copy) NSString *TiKuan;
@property (nonatomic,copy) NSArray *PlaceCodeArr;
@property (nonatomic,copy) NSArray *UsedCodeArr;
@property (nonatomic,copy) NSString *SamplePicID;
@property (nonatomic,strong) NSArray *SamplePicArr;
@property (nonatomic,copy) NSString *SampleName;
@property (nonatomic,copy) NSString *SizeWidth;
@property (nonatomic,copy) NSString *SizeHighet;
@property (nonatomic,copy) NSString *Recommendation;
@property (nonatomic,copy) NSString *SaleDesc;
@property (nonatomic,strong) SampleAttributeModel *MaterialCodeModel;
@property (nonatomic,strong) SampleAttributeModel *DeliveryTimeCodeModel;
@property (nonatomic,copy) NSString *Price;
@property (nonatomic,copy) NSString *MPCouponPer;
@property (nonatomic,copy) NSString *WCouponPer;
@property (nonatomic,copy) NSString *RWCoupon;

@property (nonatomic,strong) NSDictionary *attributeDic;//配置字典
@end
