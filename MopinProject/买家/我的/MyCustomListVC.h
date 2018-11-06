
//
//  MyCustomListVC.h
//  MopinProject
//
//  Created by xhd945 on 15/12/17.
//  Copyright © 2015年 rt008. All rights reserved.
//

#import "BaseSuperViewController.h"

@interface MyCustomListVC : BaseSuperViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)UITableView *allTableView;         //全部
@property (nonatomic,strong)UITableView *doingCostTableView;     //进行中
@property (nonatomic,strong)UITableView *waitCommentTableView;      //待评价
@property (nonatomic,strong)UITableView *finishTableView;       //已完成

@property (nonatomic,strong)NSMutableArray *orderData;
@property (nonatomic,strong)UITableView *tableView;       


@end
