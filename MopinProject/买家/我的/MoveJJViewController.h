//
//  MoveJJViewController.h
//  MopinProject
//
//  Created by happyzt on 15/12/20.
//  Copyright © 2015年 rt008. All rights reserved.
//

#import "BaseSuperViewController.h"

typedef void(^ChooseJuanBlock)(NSString*,NSString*,NSMutableArray*,NSMutableArray*);
typedef void(^EmptyIDStringBlock)(void);


@interface MoveJJViewController : BaseSuperViewController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)NSString *PMIDofArt; //该样品的书家ID

@property (nonatomic,copy)NSString *moPinText;//可用的墨品劵
@property (nonatomic,copy)NSString *shuJiaText;//可用的书家劵

@property (nonatomic,copy)NSString *selectMoPinJuanPrice; //选中的墨品劵价格
@property (nonatomic,copy)NSString *selectMoPinJuanIDString;//选中的墨品劵ID字符串
@property (nonatomic,copy)NSString *selectShuJiaJuanPrice;//可用的书加劵价格
@property (nonatomic,copy)NSString *selectShuJiaJuanIDString;//选中的书家劵ID字符串

@property (nonatomic,copy)ChooseJuanBlock finishChooseJuan;//完成选择
@property (nonatomic,copy)EmptyIDStringBlock emptyChoosedId;//清空选中的ID
@end
