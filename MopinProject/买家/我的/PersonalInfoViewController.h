//
//  PersonalInfoViewController.h
//  MopinProject
//
//  Created by rt008 on 15/12/7.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "BaseSuperViewController.h"

@interface PersonalInfoViewController : BaseSuperViewController
@property (nonatomic,strong) void (^reloadInfo)();
@end
