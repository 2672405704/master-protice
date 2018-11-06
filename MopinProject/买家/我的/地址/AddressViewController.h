//
//  AddressViewController.h
//  MopinProject
//
//  Created by rt008 on 15/11/26.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "BaseSuperViewController.h"
@class AddressModel;
typedef void(^ChooseAddressBlock) (AddressModel*);

@interface AddressViewController : BaseSuperViewController
@property(nonatomic,assign) NSInteger fromComfireOrderVC;
@property(nonatomic,copy)ChooseAddressBlock finishChooseAddress;

@end
