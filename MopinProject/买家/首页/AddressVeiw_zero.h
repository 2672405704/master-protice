//
//  AddressVeiw_zero.h
//  MopinProject
//
//  Created by xhd945 on 15/12/17.
//  Copyright © 2015年 rt008. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressModel.h"

@interface AddressVeiw_zero : UIControl

@property(nonatomic,strong)AddressModel *mod;


@property(nonatomic,assign)BOOL isShowRightArrow;//是否显示右键

- (instancetype)initWithFrame:(CGRect)frame
                   AddressMod:(AddressModel*)mod;



@end
