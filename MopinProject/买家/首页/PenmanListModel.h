//
//  PenmanListModel.h
//  MopinProject
//
//  Created by rt008 on 15/12/8.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "SuperModel.h"

@interface PenmanListModel : SuperModel
@property (nonatomic,copy,readonly) NSString *UserID;   //书家ID
@property (nonatomic,copy,readonly) NSString *PenmanName;//书家名称
@property (nonatomic,copy,readonly) NSString *PenmanType;//书家类型 1：大家 2：名家 3：书家 4：签约
@property (nonatomic,copy,readonly) NSString *IsBooked; //是否签约0：未签约 1：签约
@property (nonatomic,copy,readonly) NSString *Signature;//书家签名（书家简介）
@property (nonatomic,copy,readonly) NSString *Photo;    //书家头像
@property (nonatomic,copy,readonly) NSString *Trend;    //-1:下降  0：不变  1：上升
@property (nonatomic,copy,readonly) NSString *NPrice;   //润格价格
@property (nonatomic,copy,readonly) NSString *AveragePrice; //均价
@property (nonatomic,copy,readonly) NSString *IsPublicGoodPM;
/*
是否是公益书家
0：不是公益书家（不显示图标）
1：公益书家（红色图标）
2：是公益书家但是没有库存（灰色图片）
 */
@end
