//
//  ExampleWorkModel.h
//  MopinProject
//
//  Created by xhd945 on 15/12/10.
//  Copyright © 2015年 rt008. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExampleWorkModel : NSObject

@property (nonatomic,strong)NSString*ArtID;//书家ID
@property (nonatomic,strong)NSString*ArtName;//作品名字
@property (nonatomic,strong)NSString*ShowType;//幅式
@property (nonatomic,strong)NSString*WordType;//字体
@property (nonatomic,strong)NSString*Size;//规格
@property (nonatomic,strong)NSString*ArtPic;//样品图片
@property (nonatomic,strong)NSString*Photo;//书家头像
@property (nonatomic,strong)NSString*Price;//价格
@property (nonatomic,strong)NSString*CouponsRatio;//样品所有券的比例
@property (nonatomic,strong)NSString*PMID; //书家ID

@property (nonatomic,strong)NSString*IsPublicGoodSample;
//	是否是公益样品
/*
0：不是公益样品（不显示图标）
1：公益样品（红色图标）
2：是公样品家但是没有库存（灰色图片）
 */

@end
