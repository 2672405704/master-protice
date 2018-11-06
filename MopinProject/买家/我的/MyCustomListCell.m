//
//  MyCustomListCell.m
//  MopinProject
//
//  Created by happyzt on 15/12/18.
//  Copyright © 2015年 rt008. All rights reserved.
//

#import "MyCustomListCell.h"
#import "UIKit+AFNetworking.h"

@implementation MyCustomListCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
    }
    
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setMyOrderModel:(MyOrderModel *)myOrderModel {
    
    self.backgroundColor = [UIColor clearColor];
    _myOrderModel = myOrderModel;
    
    orderID.text = [NSString stringWithFormat:@"订单编号:%@", myOrderModel.OrderCode.length?myOrderModel.OrderCode:@""];
    orderName.text = myOrderModel.PenmanName.length?myOrderModel.PenmanName:@"";
    orderStandName.text = myOrderModel.ArtName.length?myOrderModel.ArtName:@"";
    
    orderMoney.text = myOrderModel.Price.length?myOrderModel.Price:@"0.00";
    [orderMoney adjustsFontSizeToFitWidth];
    
    orderStatus.text = [NSString stringWithFormat:@"%@",[self getOrderStatus:myOrderModel.OrderState.length?myOrderModel.OrderState:@""]];
    
    //样品图片
   [orderImg setImageWithURL:[NSURL URLWithString:myOrderModel.ArtPic] placeholderImage:mImageByName(PlaceHeaderSquareImage)];
   
    //尺寸 文字。。
    orderDesc.text = [NSString stringWithFormat:@"%@ %@ %@",myOrderModel.ShowType.length?myOrderModel.ShowType:@"",myOrderModel.WordType.length?myOrderModel.WordType:@"",myOrderModel.Size.length?myOrderModel.Size:@""];
    orderDesc.textColor = TipsFontColor;
    
    /*促销说明*/
    orderPromotionLab.text = _myOrderModel.Promotional.length?_myOrderModel.Promotional:@"";
    orderPromotionLab.textColor = TipsFontColor;
    
}


- (void)layoutSubviews {
    
    //状态判断
    CGFloat width = [orderMoney.text sizeWithFont:orderMoney.font constrainedToSize:CGSizeMake(MAXFLOAT, 30)].width;
    
    orderMoney.width = width;
    orderMoney.right = self.width-20;
    moneyLabel.right = orderMoney.left;
    TotalAmountTitle.right = moneyLabel.left-3;
    
     confirmButton.hidden = YES;
    _divLine.hidden = YES;
    [confirmButton setBackgroundColor:[UIColor clearColor]];
    [confirmButton setTitleColor:MainFontColor forState:UIControlStateNormal];
    
    confirmButton.layer.borderColor = DIVLINECOLOR_1.CGColor;
     [confirmButton setTitle:nil forState:UIControlStateNormal];
    
     firstButton.hidden = YES;
     [firstButton setTitle:nil forState:UIControlStateNormal];

    switch ([_myOrderModel.OrderState integerValue]) {
        case 1: {       //待支付
            //取消订单+去支付
            bottomBgView.hidden = NO;
            confirmButton.hidden = NO;
            [confirmButton setTitle:@"取消订单" forState:UIControlStateNormal];
            [confirmButton addTarget:self action:@selector(OrderBAction:) forControlEvents:UIControlEventTouchUpInside];
            
            firstButton.hidden = NO;
            [firstButton setTitle:@"去支付" forState:UIControlStateNormal];
            firstButton.backgroundColor = THEMECOLOR_1;
            firstButton.layer.borderColor = [UIColor clearColor].CGColor;
            [firstButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [firstButton addTarget:self action:@selector(OrderAAction:) forControlEvents:UIControlEventTouchUpInside];
            _divLine.hidden = NO;
        }
            break;
        case 6:{    //已发货
            //查看物流+确认收货
            confirmButton.hidden = NO;
            bottomBgView.hidden = NO;
            [confirmButton setTitle:@"查看物流" forState:UIControlStateNormal];
            [confirmButton addTarget:self action:@selector(OrderBAction:) forControlEvents:UIControlEventTouchUpInside];
            
            firstButton.hidden = NO;
            firstButton.backgroundColor = [UIColor clearColor];
            [firstButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [firstButton setTitle:@"确认收货" forState:UIControlStateNormal];
            [firstButton addTarget:self action:@selector(OrderAAction:) forControlEvents:UIControlEventTouchUpInside];
            _divLine.hidden = NO;
        }
            
            break;
        case 7: {      //待评价
            //去评价
            confirmButton.hidden = NO;
            bottomBgView.hidden = NO;
            [confirmButton setTitle:@"去评价" forState:UIControlStateNormal];
            [confirmButton addTarget:self action:@selector(OrderBAction:) forControlEvents:UIControlEventTouchUpInside];
            
            firstButton.hidden = YES;
            _divLine.hidden = NO;
        }
            
            break;
        case 8:{       //已完成
            //申请售后
            confirmButton.hidden = NO;
            bottomBgView.hidden = NO;
            [confirmButton setTitle:@"申请售后" forState:UIControlStateNormal];
            [confirmButton addTarget:self action:@selector(OrderBAction:) forControlEvents:UIControlEventTouchUpInside];
            
            firstButton.hidden = YES;
            _divLine.hidden = NO;
        }
            break;
            
        default:{
            confirmButton.hidden = YES;
            [confirmButton setTitle:nil forState:UIControlStateNormal];
            
            firstButton.hidden = YES;
            [firstButton setTitle:nil forState:UIControlStateNormal];
            
            bottomBgView.hidden = YES;
            _divLine.hidden = YES;
        }
            break;
    }
}

- (void)drawRect:(CGRect)rect{

    self.width = kkDeviceWidth;
    
    //设置状态按钮
    moneyLabel.text = @"￥";

      orderName.font = UIFONT_Tilte(14.5);  //作家名字改成小宋字体
    orderStatus.textColor = THEMECOLOR_1;
    
    
    confirmButton.layer.borderColor = DIVLINECOLOR_1.CGColor;
    confirmButton.layer.cornerRadius = 4;
    confirmButton.layer.borderWidth = 0.5;
    
    firstButton.layer.borderColor = DIVLINECOLOR_1.CGColor;
    firstButton.layer.cornerRadius = 4;
    firstButton.layer.borderWidth = 0.5;
    
    self.backgroundColor = [UIColor redColor];
    
    //设置中间背景颜色
//    orderImg.image = [UIImage imageNamed:@"pic_02@2x.png"];

}


//通过状态码获取对应的状态
- (NSString *)getOrderStatus:(NSString *)orderState {
    
    switch ([orderState integerValue]) {
        case 1:
            return @"待支付";
             break;
        case 2:
            return @"已支付";
             break;
        case 3:
            return @"创作中";
             break;
        case 4:
            return @"装裱中";
             break;
            
        case 5:
            return @"已装裱";
             break;
            
        case 6:
            return @"已发货";
             break;
            
        case 7:
            return @"待评价";
             break;
            
        case 8:
            return @"已完成";
            break;
            
        case 9:
            return @"售后中";
            break;
            
        case 10:
            return @"取消订单";
             break;
            
        default:
            return @"未确定";
             break;
    }
    
}




#pragma mark -- 第一个按钮的点击事件
- (void)OrderAAction:(UIButton *)button {
    
    
    NSDictionary *dic = @{@"orderStatus":_myOrderModel.OrderState,
                          @"orderCode":_myOrderModel.OrderCode,
                          @"orderPrice":_myOrderModel.Price,
                          @"SJCoupon":_myOrderModel.SJCoupon,
                          @"IFReturn":_myOrderModel.IFReturn,
                          @"InviteFriend":_myOrderModel.InviteFriend,
                          @"OrderShare":_myOrderModel.OrderShare,
                          };
    [[NSNotificationCenter defaultCenter] postNotificationName:@"OrderAActionNotification"
                                                        object:nil                                                    userInfo:dic];
}


#pragma mark -- 第二个按钮的点击事件
- (void)OrderBAction:(UIButton *)button {
    
    NSDictionary *dic =@{@"orderStatus":_myOrderModel.OrderState,
                         @"orderCode":_myOrderModel.OrderCode,
                         @"orderPrice":_myOrderModel.Price
                         };
    [[NSNotificationCenter defaultCenter] postNotificationName:@"OrderBActionNotification"
                                                        object:nil
                                                      userInfo:dic];

    
}



@end
