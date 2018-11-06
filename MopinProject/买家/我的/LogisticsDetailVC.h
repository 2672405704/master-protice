//
//  LogisticsDetailVC.h
//  MopinProject
//
//  Created by xhd945 on 15/12/18.
//  Copyright © 2015年 rt008. All rights reserved.
//

#import "BaseSuperViewController.h"

@interface LogisticsDetailVC : BaseSuperViewController<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSString *deliveryCode; //快递单号
@property(nonatomic,strong)NSString *deliveryCompanyName;//快递公司名称

-(instancetype)initWithDeliveryCode:(NSString*)code
                DeliveryCompanyName:(NSString*)name;

@end
