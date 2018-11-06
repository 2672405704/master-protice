//
//  PenmanDetailSampleModel.h
//  MopinProject
//
//  Created by rt008 on 15/12/10.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "SuperModel.h"

@interface PenmanDetailSampleModel : SuperModel

@property (nonatomic,copy) NSString *ArtPic; //图片
@property (nonatomic,copy) NSString *ArtID; //样品id
@property (nonatomic,copy) NSString *BookedNum; //成交数量
@property (nonatomic,copy) NSString *CollectNum; //收藏数量
@property (nonatomic,copy) NSString *CouponsRatio; //样品所有券的比例
@property (nonatomic,copy) NSString *Price; //样品价格
@property (nonatomic,copy) NSString *ProductName; //样品名称
@property (nonatomic,copy) NSString *ShowType; //幅式
@property (nonatomic,copy) NSString *WordType; //字体
@property (nonatomic,copy) NSString *Size; //大小
@property (nonatomic,copy) NSString *ZanNum; //赞的数量
@property (nonatomic,copy)NSString*IsZan;
@property (nonatomic,copy)NSString*IsCollect;
/**
 *  是否是公益样品
 0：不是公益样品（不显示图标）
 1：公益样品（红色图标）
 2：是公益样品家但是没有库存（灰色图片）
 */
@property (nonatomic,copy)NSString*IsPublicGoodSample;
//公益库存
@property (nonatomic,copy)NSString*noncommercialstock;



@end
