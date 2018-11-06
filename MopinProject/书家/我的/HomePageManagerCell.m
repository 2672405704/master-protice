//
//  HomePageManagerCell.m
//  MopinProject
//
//  Created by rt008 on 15/12/2.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "HomePageManagerCell.h"

@implementation HomePageManagerCell

- (void)awakeFromNib {
    // Initialization code
    _rightImageView.contentMode=UIViewContentModeScaleAspectFill;
    _rightImageView.layer.cornerRadius=3;
    _rightImageView.clipsToBounds=YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
