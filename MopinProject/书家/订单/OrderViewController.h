//
//  OrderViewController.h
//  MopinProject
//
//  Created by rt008 on 15/11/23.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "BaseSuperViewController.h"

@interface OrderViewController : BaseSuperViewController<UITableViewDataSource,UITableViewDelegate>


@property (nonatomic,strong)NSMutableArray *orderData;
@property (nonatomic,strong)NSArray *statusData;

@end
