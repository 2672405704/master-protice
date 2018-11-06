//
//  MyCustomListCell.h
//  MopinProject
//
//  Created by happyzt on 15/12/18.
//  Copyright © 2015年 rt008. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyOrderModel.h"

@interface MyCustomListCell : UITableViewCell {
    
    __weak IBOutlet UILabel *orderPromotionLab;  //促销信息
    __weak IBOutlet UILabel *orderID;  //订单id
    __weak IBOutlet UILabel *orderStatus;//订单状态
    __weak IBOutlet UIImageView *orderImg; //订单图片
    __weak IBOutlet UILabel *orderName;//作家名称
    __weak IBOutlet UILabel *orderStandName;//作品名字
    __weak IBOutlet UILabel *orderDesc;//描叙信息
    __weak IBOutlet UILabel *orderMoney;//订单价格
    __weak IBOutlet UIButton *confirmButton;//确认按钮
    NSInteger _status;  //状态码
    __weak IBOutlet UIButton *firstButton;//取消按钮
    __weak IBOutlet UILabel *moneyLabel; //￥
    __weak IBOutlet UIView *bottomBgView;//按钮背景

    __weak IBOutlet UILabel *TotalAmountTitle; //总金额
}
@property (weak, nonatomic) IBOutlet UIView *divLine;

@property (nonatomic,strong)MyOrderModel *myOrderModel;








@end
