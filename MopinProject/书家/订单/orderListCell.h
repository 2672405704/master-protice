//
//  orderListCell.h
//  MopinProject
//
//  Created by happyzt on 15/12/16.
//  Copyright © 2015年 rt008. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "orderModel.h"

@interface orderListCell : UITableViewCell {

    __weak IBOutlet UILabel *orderID;    //订单编号
    __weak IBOutlet UILabel *orderStatus;    //状态
    __weak IBOutlet UIImageView *orderImg;    //商品图片
    __weak IBOutlet UILabel *orderName;       //样品名称
    __weak IBOutlet UILabel *orderSalEInfo;   //尺寸 文字
    __weak IBOutlet UILabel *orderMoney;     //金额
    __weak IBOutlet UILabel *buyer;       //买家
    __weak IBOutlet UILabel *orderDate;    //订单日期
    __weak IBOutlet UIButton *statuButton;
    __weak IBOutlet UIView *bgView;
    __weak IBOutlet UILabel *orderContent;   //促销信息
    
    __weak IBOutlet UILabel *moneyLabel;

    
    
 
}


@property (nonatomic,strong)orderModel *orderModel;
@property (nonatomic,copy)NSString *selectID;


@end
