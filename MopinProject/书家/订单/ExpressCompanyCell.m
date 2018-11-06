//
//  ExpressCompanyCell.m
//  MopinProject
//
//  Created by happyzt on 15/12/17.
//  Copyright © 2015年 rt008. All rights reserved.
//

#import "ExpressCompanyCell.h"

@implementation ExpressCompanyCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    UILabel *companyLabel = (UILabel *)[self.contentView viewWithTag:101];

    if (selected) {
        
        companyLabel.textColor = [UIColor blackColor];
        
    }else {
        
         companyLabel.textColor = [UIColor lightGrayColor];
    }
}

@end
