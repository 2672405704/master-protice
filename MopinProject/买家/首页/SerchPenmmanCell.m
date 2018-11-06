//
//  SerchPenmmanCell.m
//  MopinProject
//
//  Created by rt008 on 15/12/10.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "SerchPenmmanCell.h"
#import "UIImageView+WebCache.h"
#import "PenmanListModel.h"

@interface SerchPenmmanCell()

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *introLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIView *iconBgView;
@property (weak, nonatomic) IBOutlet UIImageView *penmanTypeIcon;
@property (weak, nonatomic) IBOutlet UIImageView *isBookIcon;
@property (weak, nonatomic) IBOutlet UIImageView *trendIcon;
@end

@implementation SerchPenmmanCell

- (void)awakeFromNib {
    // Initialization code
    _headerImageView.layer.cornerRadius=CGRectGetHeight(_headerImageView.frame)/2;
    _headerImageView.layer.masksToBounds=YES;
}
- (void)reloadCellWithModel:(PenmanListModel *)model
{
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:model.Photo] placeholderImage:[UIImage imageNamed:PlaceHeaderImage]];
    _nameLabel.text=model.PenmanName;
    _introLabel.text=model.Signature;
    _priceLabel.text=[NSString stringWithFormat:@"润格 %@元/平尺   均价 %@元/件",model.NPrice,model.AveragePrice];
    
    CGFloat x;
    if(model.PenmanType.intValue==3){
        _penmanTypeIcon.image=[UIImage imageNamed:@"ming_penmanList.png"];
        _penmanTypeIcon.hidden=NO;
        x=26;
    }else if(model.PenmanType.intValue==4){
        _penmanTypeIcon.image=[UIImage imageNamed:@"big_penmanList.png"];
        _penmanTypeIcon.hidden=NO;
        x=26;
    }else{
        _penmanTypeIcon.hidden=YES;
        x=0;
    }
    _isBookIcon.frame=CGRectMake(x,0, 21, 21);
    
    if(model.IsBooked.intValue==0){
        _isBookIcon.hidden=YES;
    }else{
        x=x+26;
        _isBookIcon.hidden=NO;
    }
    _trendIcon.frame=CGRectMake(x, 0, 21, 21);

    if(model.Trend.intValue==-1){
        _trendIcon.image=[UIImage imageNamed:@"down_icon_penmanList.png"];
    }else if(model.Trend.intValue==0){
        _trendIcon.image=[UIImage imageNamed:@"right_icon_penmanList.png"];
    }else{
        _trendIcon.image=[UIImage imageNamed:@"up_icon_penmanList.png"];
    }
    CGFloat width;
    if(IOS7_AND_LATER){
        width=[_nameLabel.text boundingRectWithSize:CGSizeMake(kkDeviceWidth-30-x-15-105,29) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:_nameLabel.font} context:nil].size.width;
    }else{
        width=[_nameLabel.text sizeWithFont:_nameLabel.font constrainedToSize:CGSizeMake(kkDeviceWidth-30-x-15-105,29) lineBreakMode:NSLineBreakByCharWrapping].width;
    }
    
    CGRect frame=_nameLabel.frame;
    frame.size.width=width;
    _nameLabel.frame=frame;
    
    frame=_iconBgView.frame;
    frame.size.width=x;
    frame.origin.x=CGRectGetMaxX(_nameLabel.frame)+15;
    _iconBgView.frame=frame;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
