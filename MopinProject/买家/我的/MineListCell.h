//
//  MineListCell.h
//  MopinProject
//
//  Created by rt008 on 15/11/25.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rightIcon;
@property (weak, nonatomic) IBOutlet UIImageView *pointImageView;
@end
