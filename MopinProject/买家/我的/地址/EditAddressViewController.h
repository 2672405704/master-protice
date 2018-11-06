//
//  EditAddressViewController.h
//  MopinProject
//
//  Created by rt008 on 15/11/26.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "BaseSuperViewController.h"
@class AddressModel;
@interface EditAddressViewController : BaseSuperViewController
@property (nonatomic,strong) AddressModel *addressModel;
@property (nonatomic,strong) void (^reloadAddressList)();
@end
