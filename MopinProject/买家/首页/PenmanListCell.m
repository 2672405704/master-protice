//
//  PenmanListCell.m
//  MopinProject
//
//  Created by rt008 on 15/12/8.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "PenmanListCell.h"
#import "UIImageView+WebCache.h"
#import "PenmanListModel.h"
#import "PublicWelfareManager.h"

@interface PenmanListCell()
@property (weak, nonatomic) IBOutlet UIImageView *publicImageIcon;//公益标识

@property (weak, nonatomic) IBOutlet UIImageView *topImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *introLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIView *iconBgView;
@property (weak, nonatomic) IBOutlet UIImageView *penmanTypeIcon;
@property (weak, nonatomic) IBOutlet UIImageView *isBookIcon;
@property (weak, nonatomic) IBOutlet UIImageView *trendIcon;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@end

@implementation PenmanListCell

- (void)awakeFromNib {
    // Initialization code
    _topImageView.contentMode=UIViewContentModeScaleAspectFill;
    _topImageView.clipsToBounds=YES;
    [_priceLabel adjustsFontSizeToFitWidth];
}
- (void)reloadCell
{
    [_topImageView sd_setImageWithURL:[NSURL URLWithString:_model.Photo] placeholderImage:mImageByName(PlaceHeaderRectangularImage)];
    _nameLabel.text=_model.PenmanName;
    _introLabel.text=_model.Signature;
    _priceLabel.text=[NSString stringWithFormat:@"润格 %@元/平尺   均价 %@元/件",_model.NPrice,_model.AveragePrice];
    CGFloat x;
    
    
    /*公益作品相关处理*/
    _publicImageIcon.hidden = YES;
    if([[[PublicWelfareManager shareInstance]getPublicWelfareState] isEqualToString:@"1"])
    {
        /*书家列表公益标签*/
        if([_model.IsPublicGoodPM isEqualToString:@"0"])
        {
            _publicImageIcon.hidden = YES;
            
        }else{
            
            _publicImageIcon.hidden = NO;
            if([_model.IsPublicGoodPM isEqualToString:@"1"])
            {
                _publicImageIcon.image = [UIImage imageNamed:@"red_sign"];
                
            }else if([_model.IsPublicGoodPM isEqualToString:@"2"])
            {
                _publicImageIcon.image = [UIImage imageNamed:@"gray"];
            }
            
        }

    }else{
    
         _publicImageIcon.hidden = YES;
    }
    
    
    
    if(_model.PenmanType.intValue==3){
        _penmanTypeIcon.image=[UIImage imageNamed:@"ming_penmanList.png"];
        _penmanTypeIcon.hidden=NO;
        x=26;
    }else if(_model.PenmanType.intValue==4){
        _penmanTypeIcon.image=[UIImage imageNamed:@"big_penmanList.png"];
        _penmanTypeIcon.hidden=NO;
        x=26;
    }else{
        _penmanTypeIcon.hidden=YES;
        x=0;
    }
    _isBookIcon.frame=CGRectMake(x,0, 21, 21);
    
    if(_model.IsBooked.intValue==0){
        _isBookIcon.hidden=YES;
    }else{
        x=x+26;
        _isBookIcon.hidden=NO;
    }
    _trendIcon.frame=CGRectMake(x, 0, 21, 21);
    
    if(_model.Trend.intValue==-1){
        _trendIcon.image=[UIImage imageNamed:@"down_icon_penmanList.png"];
    }else if(_model.Trend.intValue==0){
        _trendIcon.image=[UIImage imageNamed:@"right_icon_penmanList.png"];
    }else{
        _trendIcon.image=[UIImage imageNamed:@"up_icon_penmanList.png"];
    }
    CGFloat width;
    if(IOS7_AND_LATER){
        width=[_nameLabel.text boundingRectWithSize:CGSizeMake(kkDeviceWidth-60-x-15,55) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:_nameLabel.font} context:nil].size.width;
    }else{
        width=[_nameLabel.text sizeWithFont:_nameLabel.font constrainedToSize:CGSizeMake(kkDeviceWidth-60-x-15,55) lineBreakMode:NSLineBreakByCharWrapping].width;
    }
    
    CGRect frame=_nameLabel.frame;
    frame.size.width=width;
    _nameLabel.frame=frame;
    
    frame=_iconBgView.frame;
    frame.size.width=x;
    frame.origin.x=CGRectGetMaxX(_nameLabel.frame)+15;
    _iconBgView.frame=frame;
}
- (void)reloadCellInMineAttention
{
    [_topImageView sd_setImageWithURL:[NSURL URLWithString:_model.Photo] placeholderImage:mImageByName(PlaceHeaderSquareImage)];
    _nameLabel.text=_model.PenmanName;
    _introLabel.text=_model.Signature;
    _priceLabel.text=[NSString stringWithFormat:@"润格 %@元/平尺   均价 %@元/件",_model.NPrice,_model.AveragePrice];
    _penmanTypeIcon.hidden=NO;
    CGFloat x;
    
    if(_model.PenmanType.intValue==3){
        _penmanTypeIcon.image=[UIImage imageNamed:@"ming_penmanList.png"];
        _penmanTypeIcon.hidden=NO;
        x=26;
    }else if(_model.PenmanType.intValue==4){
        _penmanTypeIcon.image=[UIImage imageNamed:@"big_penmanList.png"];
        _penmanTypeIcon.hidden=NO;
        x=26;
    }else{
        _penmanTypeIcon.hidden=YES;
        x=0;
    }
    _isBookIcon.frame=CGRectMake(x,0, 21, 21);
    
    if(_model.IsBooked.intValue==0){
        _isBookIcon.hidden=YES;
    }else{
        x=x+26;
        _isBookIcon.hidden=NO;
    }
    _trendIcon.frame=CGRectMake(x, 0, 21, 21);
    
    if(_model.Trend.intValue==-1){
        _trendIcon.image=[UIImage imageNamed:@"down_icon_penmanList.png"];
    }else if(_model.Trend.intValue==0){
        _trendIcon.image=[UIImage imageNamed:@"right_icon_penmanList.png"];
    }else{
        _trendIcon.image=[UIImage imageNamed:@"up_icon_penmanList.png"];
    }
    
    CGFloat width;
    if(IOS7_AND_LATER){
        width=[_nameLabel.text boundingRectWithSize:CGSizeMake(kkDeviceWidth-60-x-15-110,55) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:_nameLabel.font} context:nil].size.width;
    }else{
        width=[_nameLabel.text sizeWithFont:_nameLabel.font constrainedToSize:CGSizeMake(kkDeviceWidth-60-x-15-110,55) lineBreakMode:NSLineBreakByCharWrapping].width;
    }
    
    CGRect frame=_nameLabel.frame;
    frame.size.width=width;
    _nameLabel.frame=frame;
    
    frame=_iconBgView.frame;
    frame.size.width=x;
    frame.origin.x=CGRectGetMaxX(_nameLabel.frame)+15;
    _iconBgView.frame=frame;
    
    _priceLabel.hidden=YES;
    _cancelBtn.hidden=NO;
    _topImageView.frame=CGRectMake(30, 15, CGRectGetWidth(self.frame)-60, 170);
    _bgView.frame=CGRectMake(0, 0, CGRectGetWidth(self.frame), 265);
}
- (IBAction)cancelCareBtnClick:(id)sender {
    if(_delegate && [_delegate respondsToSelector:@selector(cancelAttentionWithModel:)]){
        [_delegate cancelAttentionWithModel:_model];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
