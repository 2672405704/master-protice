//
//  ComfireOrderVC.h
//  MopinProject
//
//  Created by xhd945 on 15/12/17.
//  Copyright © 2015年 rt008. All rights reserved.
//

#import "BaseSuperViewController.h"
#import "AddressModel.h"
#import "OrderRequestModel.h"

@interface ComfireOrderVC : BaseSuperViewController

@property(nonatomic,strong)AddressModel*addMod;
@property (nonatomic,strong)__block OrderRequestModel *orderMod;

- (instancetype)initWithMod:(OrderRequestModel*)mod;

@end


