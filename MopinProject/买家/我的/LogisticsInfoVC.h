//
//  LogisticsInfoVC.h
//  MopinProject
//
//  Created by xhd945 on 15/12/18.
//  Copyright © 2015年 rt008. All rights reserved.
//

#import "BaseSuperViewController.h"

@interface LogisticsInfoVC : BaseSuperViewController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)NSString*orderID; //订单ID

- (instancetype)initWithOrderId:(NSString*)orderID;

@end
