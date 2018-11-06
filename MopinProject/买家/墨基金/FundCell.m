//
//  FundCell.m
//  MopinProject
//
//  Created by rt008 on 15/11/25.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "FundCell.h"
#import "FundModel.h"
#import "CouponMainModel.h"
#import "MyCouponModel.h"
#import "CouponMopinModel.h"

@interface FundCell()

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceMarkLabel;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@end
@implementation FundCell
{
    CouponMopinModel *_model;
}
- (void)awakeFromNib {
    
}
- (void)reloadCellWithModel:(FundModel *)model
{
    
    _bgImageView.image=[UIImage imageNamed:@"bg_white_fund.png"];
    _titleLabel.textColor=[UIColor blackColor];
    _dateLabel.textColor=[UIColor blackColor];
    _priceLabel.textColor=toPCcolor(@"ca3b2b");
    _priceMarkLabel.textColor=toPCcolor(@"ca3b2b");
    
    _titleLabel.text=[NSString stringWithFormat:@"%@|书家专用",model.Source];
     _priceLabel.text=[NSString stringWithFormat:@"%ld",model.Amount.integerValue];
    _dateLabel.text=[NSString stringWithFormat:@"有效期至%@",model.EndTime.length?model.EndTime:@""];
    
}
- (void)reloadCellWithCouponModel:(CouponMainModel *)model
{
    _bgImageView.image=[UIImage imageNamed:@"bg_mopin.png"];
    _titleLabel.textColor=toPCcolor(@"#e3d495");
    _priceLabel.textColor=toPCcolor(@"#e3d495");
    _priceMarkLabel.textColor=toPCcolor(@"#e3d495");
    _dateLabel.textColor=[UIColor whiteColor];
    _titleLabel.text=@"墨品券|全场通用";
     _priceLabel.text=[NSString stringWithFormat:@"%ld",model.Amount.integerValue];
    if(model.Type.integerValue==1){
        _dateLabel.text=@"首次登录获得";
    }else if(model.Type.integerValue==2){
        _dateLabel.text=@"首次分享获得";
    }else if(model.Type.integerValue==3){
        _dateLabel.text=@"首次定制获得";
    }
//    _dateLabel.text=[NSString stringWithFormat:@"%@",model.SendReason.length?model.SendReason:@""];
}
//TODO:我的墨基金
- (void)reloadcellWithMyCouponModel:(MyCouponModel *)model
{
    if(model.Type.intValue==1){
        _bgImageView.image=[UIImage imageNamed:@"bg_mopin.png"];
        _titleLabel.textColor=toPCcolor(@"#e3d495");
        _priceLabel.textColor=toPCcolor(@"#e3d495");
        _priceMarkLabel.textColor=toPCcolor(@"#e3d495");
        _dateLabel.textColor=[UIColor whiteColor];
        _titleLabel.text=@"墨品券|全场通用";
         _priceLabel.text=[NSString stringWithFormat:@"%ld",model.Amount.integerValue];
        _dateLabel.text=[NSString stringWithFormat:@"有效期至%@",model.EndTime.length?model.EndTime:@""];
        
    }else{
        _bgImageView.image=[UIImage imageNamed:@"bg_white_fund.png"];
        _titleLabel.textColor=[UIColor blackColor];
        _dateLabel.textColor=[UIColor blackColor];
        _priceLabel.textColor=toPCcolor(@"ca3b2b");
        _priceMarkLabel.textColor=toPCcolor(@"ca3b2b");
        
        _titleLabel.text=[NSString stringWithFormat:@"%@|书家专用",model.Source];
         _priceLabel.text=[NSString stringWithFormat:@"%ld",model.Amount.integerValue];
        _dateLabel.text=[NSString stringWithFormat:@"有效期至%@",model.EndTime.length?model.EndTime:@""];
        
    }
}
//TODO:领取墨品券
- (void)reloadCellWithMopinModel:(CouponMopinModel *)model
{
    _bgImageView.image=[UIImage imageNamed:@"bg_mopin.png"];
    _titleLabel.textColor=toPCcolor(@"#e3d495");
    _priceLabel.textColor=toPCcolor(@"#e3d495");
    _priceMarkLabel.textColor=toPCcolor(@"#e3d495");
    _dateLabel.textColor=[UIColor whiteColor];
    _titleLabel.text=@"墨品券|全场通用";
     _priceLabel.text=[NSString stringWithFormat:@"%ld",model.Amount.integerValue];
    _dateLabel.text=[NSString stringWithFormat:@"有效期至%@",model.EndTime.length?model.EndTime:@""];
    
}
//TODO:书家主页
- (void)reloadCellInPenmanDetailWithModel:(CouponMopinModel *)model
{
    _model=model;
    
    _bgImageView.image=[UIImage imageNamed:@"bg_white_fund.png"];
    _titleLabel.textColor=[UIColor blackColor];
    _dateLabel.textColor=[UIColor blackColor];
    _priceLabel.textColor=toPCcolor(@"ca3b2b");
    _priceMarkLabel.textColor=toPCcolor(@"ca3b2b");
    
    _titleLabel.text=[NSString stringWithFormat:@"%@|书家专用",model.Source];
    _priceLabel.text=[NSString stringWithFormat:@"%ld",model.Amount.integerValue];
    
    _dateLabel.text=[NSString stringWithFormat:@"有效期至%@",model.EndTime.length?model.EndTime:@""];
    [_dateLabel sizeToFit];
    _rightBtn.top = _rightBtn.top+3;
    _dateLabel.right = _rightBtn.right;
    _dateLabel.top = _rightBtn.bottom+6;
    
    _rightBtn.hidden=NO;
    if(model.Type.intValue==1){
        [_rightBtn setTitle:@"关注领取" forState:UIControlStateNormal];
    }else if(model.Type.intValue==2){
        [_rightBtn setTitle:@"分享领取" forState:UIControlStateNormal];
    }else if (model.Type.intValue==3){
        [_rightBtn setTitle:@"立即领取" forState:UIControlStateNormal];
    }
}
//TODO:点击领取按钮
- (IBAction)rightBtnClickInDetail:(id)sender {
    if(_delegate && [_delegate respondsToSelector:@selector(getCouponWithModel:)]){
        [_delegate getCouponWithModel:_model];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
