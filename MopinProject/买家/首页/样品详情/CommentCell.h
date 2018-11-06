//
//  CommentCell.h
//  MopinProject
//
//  Created by xhd945 on 15/12/10.
//  Copyright © 2015年 rt008. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentModel.h"

@interface CommentCell : UITableViewCell

@property(nonatomic,strong)CommentModel*mod;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;//内容
@property (weak, nonatomic) IBOutlet UIImageView *headerIcon;//头像
@property (weak, nonatomic) IBOutlet UILabel *customID;//买家ID
@property (weak, nonatomic) IBOutlet UIView *divLine;//分割线

@end
