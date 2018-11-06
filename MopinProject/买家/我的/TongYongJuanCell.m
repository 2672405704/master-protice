//
//  FundCell.m
//  MopinProject
//
//  Created by rt008 on 15/11/25.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "TongYongJuanCell.h"

#import "MyCouponModel.h"


@interface TongYongJuanCell()


@property (weak, nonatomic) IBOutlet UIImageView *chooseIcon;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceMarkLabel;

@end
@implementation TongYongJuanCell

- (void)awakeFromNib
{
    _chooseIcon.hidden = YES;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    if(_mod.Type.intValue==1)
    {
        _bgImageView.image=[UIImage imageNamed:@"bg_mopin.png"];
        _titleLabel.textColor=toPCcolor(@"#e3d495");
        _priceLabel.textColor=toPCcolor(@"#e3d495");
        _priceMarkLabel.textColor=toPCcolor(@"#e3d495");
        _dateLabel.textColor=[UIColor whiteColor];
        _titleLabel.text=@"墨品券|全场通用";
        _priceLabel.text=[NSString stringWithFormat:@"%ld",_mod.Amount.integerValue];
        _dateLabel.text= [NSString stringWithFormat:@"有效期至:%@", _mod.EndTime.length?_mod.EndTime:@"00-00-00"];
        [_dateLabel adjustsFontSizeToFitWidth];
        _chooseIcon.hidden = !_mod.isChoose;
       
    }
    else
    {
        _bgImageView.image=[UIImage imageNamed:@"bg_white_fund.png"];
        _titleLabel.textColor=[UIColor blackColor];
        _dateLabel.textColor=[UIColor blackColor];
        _priceLabel.textColor=toPCcolor(@"ca3b2b");
        _priceMarkLabel.textColor=toPCcolor(@"ca3b2b");
        _titleLabel.text=[NSString stringWithFormat:@"%@|书家专用",_mod.Source];
        _priceLabel.text=[NSString stringWithFormat:@"%ld",_mod.Amount.integerValue];
        _dateLabel.text= [NSString stringWithFormat:@"有效期至:%@", _mod.EndTime.length?_mod.EndTime:@"00-00-00"];
        [_dateLabel adjustsFontSizeToFitWidth];
        _chooseIcon.hidden = !_mod.isChoose;
       
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    _chooseIcon.hidden = !selected;
}

@end
