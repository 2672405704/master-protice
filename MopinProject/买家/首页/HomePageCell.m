//
//  HomePageCell.m
//  MopinProject
//
//  Created by rt008 on 15/12/7.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "HomePageCell.h"
#import "HomePageModel.h"
#import "UIImageView+WebCache.h"

@interface HomePageCell()

@property (weak, nonatomic) IBOutlet UIImageView *ADImageView;


@end
@implementation HomePageCell

- (void)awakeFromNib {
    // Initialization code
    
}
- (void)reloadCellWithModel:(HomePageModel *)model
{
    [_ADImageView sd_setImageWithURL:[NSURL URLWithString:model.PicPath] placeholderImage:mImageByName(PlaceHeaderRectangularImage)];
//    _ADImageView.image=[UIImage imageNamed:@"pic_01.png"];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
