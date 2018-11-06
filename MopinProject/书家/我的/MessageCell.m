//
//  MessageCell.m
//  MopinProject
//
//  Created by rt008 on 15/12/14.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "MessageCell.h"
#import "UIImageView+WebCache.h"
#import "MyMessageModel.h"

@interface MessageCell()
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *pointImageView;

@end
@implementation MessageCell

- (void)awakeFromNib {
    // Initialization code
    _leftImageView.layer.cornerRadius=GETVIEWHEIGHT(_leftImageView)/2;
    _leftImageView.layer.masksToBounds=YES;
    
}
- (void)reloadCellWithModel:(MyMessageModel *)model
{
    _pointImageView.hidden=YES;
    [_leftImageView sd_setImageWithURL:[NSURL URLWithString:model.Photo] placeholderImage:mImageByName(PlaceInfoPhoto)];
    _titleLabel.text=model.Title;
    _dateLabel.text=model.CreateTime;
    _infoLabel.text=model.Content;
    
    CGFloat height;
    if(IOS7_AND_LATER){
        height=[_infoLabel.text boundingRectWithSize:CGSizeMake(kkDeviceWidth-145,MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:_infoLabel.font} context:nil].size.height;
    }else{
        height=[_infoLabel.text sizeWithFont:_infoLabel.font constrainedToSize:CGSizeMake(kkDeviceWidth-145,MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping].height;
    }
    CGRect frame=_infoLabel.frame;
    frame.size.height=height;
    _infoLabel.frame=frame;
}
+ (CGFloat)getHeightWithModel:(MyMessageModel *)model
{
    CGFloat height;
    if(IOS7_AND_LATER){
        height=[model.Content boundingRectWithSize:CGSizeMake(kkDeviceWidth-145,MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.height;
    }else{
        height=[model.Content sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(kkDeviceWidth-145,MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping].height;
    }
    return height+60;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
