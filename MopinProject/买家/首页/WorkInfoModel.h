//
//  WorkInfoModel.h
//  MopinProject
//
//  Created by xhd945 on 15/12/17.
//  Copyright © 2015年 rt008. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WorkInfoModel:NSObject

@property (nonatomic,strong)NSString *workID;//样品ID

@property (nonatomic,strong)NSString *PhotoURL;//样品图片
@property (nonatomic,strong)NSString *wordType;//字体
@property (nonatomic,strong)NSString *showType;//字体
@property (nonatomic,strong)NSString *size; //尺寸
@property (nonatomic,strong)NSString *content;//内容
@property (nonatomic,strong)NSString *tiKuanContent;//题款内容
@property (nonatomic,strong)NSString *paperType;//纸张类型
@property (nonatomic,strong)NSString *zhuangBiao;//装裱
@property (nonatomic,strong)NSString *zouQi;//创作周期
@property (nonatomic,strong)NSString *workPrice;//作品价格
@property (nonatomic,strong)NSString *zhuanBiaoPrice;//装裱价格
@end
