//
//  CouponMopinModel.h
//  MopinProject
//
//  Created by rt008 on 15/12/19.
//  Copyright © 2015年 rt008. All rights reserved.
//

#import "SuperModel.h"

@interface CouponMopinModel : SuperModel
@property (nonatomic,copy) NSString *Amount;  
@property (nonatomic,copy) NSString *BatchID;
@property (nonatomic,copy) NSString *EndTime;
@property (nonatomic,copy) NSString *Type;    //1.关注 2.分享 3.立即领取
@property (nonatomic,copy) NSString *Source;
@end
