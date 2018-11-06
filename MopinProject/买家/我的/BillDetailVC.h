//
//  BillDetailVC.h
//  MopinProject
//
//  Created by xhd945 on 15/12/18.
//  Copyright © 2015年 rt008. All rights reserved.
//

#import "BaseSuperViewController.h"

typedef void (^FinishFillBillInfo)(NSString *billContent);

@interface BillDetailVC : BaseSuperViewController
@property (weak, nonatomic) IBOutlet UIView *bgView_1;
@property (weak, nonatomic) IBOutlet UIView *bgView_2;

@property (weak, nonatomic) IBOutlet UIButton *personBnt; //个人按钮
@property (weak, nonatomic) IBOutlet UIButton *companyBnt;//公司按钮
@property (weak, nonatomic) IBOutlet UITextField *companyNameTextField;
@property (weak, nonatomic) IBOutlet UILabel *contentOfZhuanBiaoLab;//装裱发票内容
@property (weak, nonatomic) IBOutlet UILabel *countOfZhuanBiaoLab;//装裱发票内容

@property(nonatomic,copy)FinishFillBillInfo finishFill; //填写完成Block

#pragma mark -- 代入内容
@property(nonatomic,strong)NSString *titleName;  //发票抬头
@property(nonatomic,strong)NSString *ZhuanBiaoPrice; //装裱价格
@property(nonatomic,strong)NSString *wuliuPrice; //物流价格

@property(nonatomic,assign)BOOL enableEidt;  //是否允许编辑

@property(nonatomic,assign)NSInteger fromMark; //1.订单详情，2.确认下单

@end
