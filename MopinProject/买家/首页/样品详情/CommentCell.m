//
//  CommentCell.m
//  MopinProject
//
//  Created by xhd945 on 15/12/10.
//  Copyright © 2015年 rt008. All rights reserved.
//

#import "CommentCell.h"
#import "UIKit+AFNetworking.h"

@implementation CommentCell

- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
}
- (void)layoutSubviews
{
    _customID.text = _mod.ENickName.length?_mod.ENickName:@"匿名";
    _customID.textColor = MainFontColor;
    _contentLabel.textColor  = TipsFontColor;
    _contentLabel.text  = _mod.EContent;
    [_headerIcon setImageWithURL:[NSURL URLWithString:_mod.EPhoto] placeholderImage:mImageByName( PlaceHeaderIconImage)];
    
#warning 还差书家回复

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
