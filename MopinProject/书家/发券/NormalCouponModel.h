//
//  NormalCouponModel.h
//  MopinProject
//
//  Created by rt008 on 15/12/3.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "SuperModel.h"

@interface NormalCouponModel : SuperModel
@property (nonatomic,copy) NSString *Type;
@property (nonatomic,copy) NSString *IsOpen;
@property (nonatomic,copy) NSString *Amount;
@end
