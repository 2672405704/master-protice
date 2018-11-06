//
//  HomePageCell.h
//  MopinProject
//
//  Created by rt008 on 15/12/7.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HomePageModel;
@interface HomePageCell : UITableViewCell
- (void)reloadCellWithModel:(HomePageModel *)model;
@end
