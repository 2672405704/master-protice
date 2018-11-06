//
//  GetSampleListModel.h
//  MopinProject
//
//  Created by rt008 on 15/12/8.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "SuperModel.h"

@interface GetSampleListModel : SuperModel
@property (nonatomic,copy) NSString *NPriceL;   //润格价格低
@property (nonatomic,copy) NSString *NPriceH;   //润格价格高
@property (nonatomic,copy) NSString *AveragePriceL;//均价低
@property (nonatomic,copy) NSString *AveragePriceH;//均价高
@property (nonatomic,copy) NSString *PerCouponL;   //优惠券比例低
@property (nonatomic,copy) NSString *PerCouponH;   //优惠券比例高
@end
