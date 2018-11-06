//
//  SendOffMoPinViewController.h
//  MopinProject
//
//  Created by happyzt on 15/12/16.
//  Copyright © 2015年 rt008. All rights reserved.
//

#import "BaseSuperViewController.h"

@interface SendOffMoPinViewController : BaseSuperViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)NSMutableArray *companyData;
@property (nonatomic,strong)NSMutableArray *companyID;

- (instancetype)initWithOrderID:(NSString *)orderID;

@end
