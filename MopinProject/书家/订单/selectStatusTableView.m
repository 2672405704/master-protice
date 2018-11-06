//
//  selectStatusTableView.m
//  MopinProject
//
//  Created by happyzt on 15/12/17.
//  Copyright © 2015年 rt008. All rights reserved.
//

#import "selectStatusTableView.h"

@implementation selectStatusTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    
    if (self) {
        
        self.delegate = self;
        self.dataSource = self;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.statusData = [NSMutableArray new];
        self.backgroundColor = RGBA(39, 39, 39, 1);
        self.layer.cornerRadius = 3;
        
        if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
            
            [self setSeparatorInset:UIEdgeInsetsZero];
            
        }
        
        if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
            
            [self setLayoutMargins:UIEdgeInsetsZero];
            
        }
    }
    
    return self;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 9;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    self.statusData = @[@"全部",@"待创作",@"创作中",@"待装裱",@"装裱完成",@"待收货",@"待评价",@"售后",@"已完成"];
    UITableViewCell *cell =  [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"identify"];
  
    cell.textLabel.text = self.statusData[indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.font = UIFONT(15);
    cell.backgroundColor = RGBA(39, 39, 39, 1);
    cell.separatorInset = UIEdgeInsetsMake(0, -10, 0, 0);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textColor = [UIColor whiteColor];
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [cell setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [cell setLayoutMargins:UIEdgeInsetsZero];
        
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangelistStautsNotification"
                                                        object:self
     userInfo:@{@"name":self.statusData[indexPath.row],
                @"selectID":[NSString stringWithFormat:@"%ld",indexPath.row]}];
}




@end
