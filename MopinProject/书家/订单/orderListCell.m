//
//  orderListCell.m
//  MopinProject
//
//  Created by happyzt on 15/12/16.
//  Copyright © 2015年 rt008. All rights reserved.
//

#import "orderListCell.h"
#import "UIKit+AFNetworking.h"
#import "UIView+ViewController.h"
#import "SendOffMoPinViewController.h"

@implementation orderListCell

- (void)drawRect:(CGRect)rect {
    
    //设置状态按钮
    statuButton.layer.borderColor = DIVLINECOLOR_1.CGColor;
    statuButton.layer.cornerRadius = 4;
    statuButton.titleLabel.textColor = MainFontColor;
    statuButton.layer.borderWidth = 0.5;
    statuButton.titleLabel.textAlignment = NSTextAlignmentRight;
    
    //设置中间背景颜色
    bgView.backgroundColor = RGBA(246, 247, 248, 1);
    orderImg.image = [UIImage imageNamed:@"pic_02@2x.png"];
    
    orderMoney.textColor = THEMECOLOR_1;
    moneyLabel.textColor = THEMECOLOR_1;
    
    
    [orderID setTintColor:[UIColor lightGrayColor]];
    orderID.font = [UIFont systemFontOfSize:14];
    
    NSLog(@"%@",_orderModel.OrderState);
    
}


- (void)setOrderModel:(orderModel *)orderModel {
    
    _orderModel = orderModel;
    orderID.text = [NSString stringWithFormat:@"订单编号:%@",orderModel.OrderCode.length?orderModel.OrderCode:@"订单编号:"];

    moneyLabel.text = @"￥";
    
    //获得状态
    orderStatus.text = [self getOrderStatus:orderModel.OrderState];
    
    //样品图片
    [orderImg setImageWithURL:[NSURL URLWithString:orderModel.ArtPic] placeholderImage:mImageByName(PlaceHeaderSquareImage)];
    
    //样品名称
    orderName.text = [NSString stringWithFormat:@"%@",orderModel.ArtName.length?orderModel.ArtName:@""];
    
    //书家姓名
    buyer.text = [NSString stringWithFormat:@"%@",orderModel.PenmanName.length?orderModel.PenmanName: @""];
    
    //促销说明
    orderContent.text = [NSString stringWithFormat:@"%@",orderModel.Promotional.length?orderModel.Promotional: @""];
    
    //尺寸 文字。。
    orderSalEInfo.text = [NSString stringWithFormat:@"%@ %@ %@",orderModel.ShowType.length?orderModel.ShowType:@"",orderModel.WordType.length?orderModel.WordType:@"",orderModel.Size.length?orderModel.Size:@""];
    
    //订单总金额
    orderMoney.text = orderModel.Price.length?orderModel.Price:@"";
    
    
}


- (void)layoutSubviews {
    
    
    orderID.text = [NSString stringWithFormat:@"订单编号:%@",_orderModel.OrderCode.length?_orderModel.OrderCode:@"订单编号:00000000000000"];
    
    moneyLabel.text = @"￥";
    
    //获得状态
    orderStatus.text = [NSString stringWithFormat:@"状态:%@",[self getOrderStatus:_orderModel.OrderState] ];
    
    //样品图片
    [orderImg setImageWithURL:[NSURL URLWithString:_orderModel.ArtPic] placeholderImage:mImageByName(PlaceHeaderIconImage)];
    
    //样品名称
    orderName.text = _orderModel.ArtName.length?_orderModel.ArtName:@"";
    orderName.font = [UIFont boldSystemFontOfSize:15];
    
    //买家姓名
    buyer.text = _orderModel.PenmanName.length?_orderModel.PenmanName:@"";
    
    //促销说明
    orderContent.text = _orderModel.Promotional.length?_orderModel.Promotional:@"";
    
    //尺寸 文字。。
    orderSalEInfo.text = [NSString stringWithFormat:@"%@ %@ %@",_orderModel.ShowType.length?_orderModel.ShowType:@"",_orderModel.WordType.length?_orderModel.WordType:@"",_orderModel.Size.length?_orderModel.Size:@""];
    
    //日期
    NSString *dateStr =  [NSString stringWithFormat:@"日期:%@",_orderModel.OrderCreate.length?_orderModel.OrderCreate:@"0000-00-00"];
    NSMutableAttributedString *attributDateStr = [[NSMutableAttributedString alloc]initWithString:dateStr];
    [attributDateStr addAttributes:@{NSFontAttributeName:UIFONT(12)} range:NSMakeRange(3, dateStr.length-3)];
    
    orderDate.attributedText = attributDateStr;

    
    //订单总金额
    orderMoney.text = _orderModel.Price.length?_orderModel.Price:@"0.00";
    
    statuButton.hidden = YES;
    [statuButton setTitle:nil forState:UIControlStateNormal];
    
    //买家
    NSString *str = [NSString stringWithFormat:@"买家:%@",_orderModel.PenmanName.length?_orderModel.PenmanName:@""];
    NSMutableAttributedString *attributStr = [[NSMutableAttributedString alloc]initWithString:str];
    
    [attributStr addAttributes:@{NSForegroundColorAttributeName:MainFontColor} range:NSMakeRange(0, 3)];
    [attributStr addAttributes:@{NSForegroundColorAttributeName:TipsFontColor} range:NSMakeRange(3, str.length-3)];
    buyer.attributedText = attributStr;
  
    //不同状态下对应不同的按钮选择
    switch ([_orderModel.OrderState integerValue]) {
    
        case 2:{
    
            statuButton.hidden = NO;
            [statuButton setTitle:@"确认创作" forState:UIControlStateNormal];//已支付
        }
            break;
        case 3:{
         
            statuButton.hidden = NO;
            [statuButton setTitle:@"已寄墨品" forState:UIControlStateNormal];    //创作中
        }
            break;
        case 6:{
    
            statuButton.hidden = NO;
            [statuButton setTitle:@"查看进度" forState:UIControlStateNormal];   //已发货
        }
            break;
        default:
            statuButton.hidden = YES;
            [statuButton setTitle:nil forState:UIControlStateNormal];
            break;
    }

}




//通过状态码获取对应的状态
- (NSString *)getOrderStatus:(NSString *)orderState {
    
    switch ([orderState integerValue]) {
        case 1:
            return @"待支付";
        case 2:
            return @"已支付";
        case 3:
            return @"创作中";
        case 4:
            return @"装裱中";
            
        case 5:
            return @"已装裱";
            
        case 6:
            return @"已发货";
           
        case 7:
            return @"待评价";
            
        case 8:
            return @"已完成";
            break;
            
        case 9:
            return @"售后中";
            
        case 10:
            return @"取消订单";
            
        default:
            return @"待返回";
    }
    
}

- (IBAction)sendOffAction:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"statusPush"
                                                        object:nil
                                                      userInfo:@{@"orderStatus":_orderModel.OrderState,
                                                                 @"OrderCode":_orderModel.OrderCode}];
 
}


@end
