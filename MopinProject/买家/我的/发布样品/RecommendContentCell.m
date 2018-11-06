//
//  RecommendContentCell.m
//  MopinProject
//
//  Created by rt008 on 15/11/29.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "RecommendContentCell.h"
#import "RecommendContentModel.h"

@interface RecommendContentCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end

@implementation RecommendContentCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)reloadCell
{
    _titleLabel.text=_model.RCContent;
}
- (IBAction)deleteBtnClick:(id)sender {
    if(_delegate && [_delegate respondsToSelector:@selector(deleteRecommendContent:)]){
        [_delegate deleteRecommendContent:_model];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
