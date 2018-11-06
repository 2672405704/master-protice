//
//  FundModel.h
//  MopinProject
//
//  Created by rt008 on 15/11/25.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "SuperModel.h"

@interface FundModel : SuperModel
@property (nonatomic,copy) NSString *UserID;  
@property (nonatomic,copy) NSString *Source;
@property (nonatomic,copy) NSString *Amount;
@property (nonatomic,copy) NSString *EndTime;
@property (nonatomic,copy) NSString *PenmanName;
@end
