//
//  selectStatusTableView.h
//  MopinProject
//
//  Created by happyzt on 15/12/17.
//  Copyright © 2015年 rt008. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface selectStatusTableView : UITableView<UITableViewDataSource,UITableViewDelegate> {
    UILabel *listLabel;
}

@property (nonatomic,strong)NSArray *statusData;

@end
