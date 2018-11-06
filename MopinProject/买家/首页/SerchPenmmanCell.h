//
//  SerchPenmmanCell.h
//  MopinProject
//
//  Created by rt008 on 15/12/10.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PenmanListModel;
@interface SerchPenmmanCell : UITableViewCell
- (void)reloadCellWithModel:(PenmanListModel *)model;
@end
