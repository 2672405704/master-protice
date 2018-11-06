//
//  SecondSectionView.h
//  MopinProject
//
//  Created by xhd945 on 15/12/10.
//  Copyright © 2015年 rt008. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondSectionView : UIView<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSString* EvaluationNum;//评论数
@property(nonatomic,strong)NSArray*CommentArr;//内容评论数组
@property(nonatomic,weak)UIViewController *delegate;//代理控制器
@property(nonatomic,weak)NSString *ArtID;  //订单编号

-(CGFloat)getSecondHeight;  //获取高度
-(void)tableViewReloadDate;

@end
