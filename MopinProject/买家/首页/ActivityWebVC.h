//
//  ActivityWebVC.h
//  MopinProject
//
//  Created by xhd945 on 16/2/2.
//  Copyright © 2016年 rt008. All rights reserved.
//

#import "BaseSuperViewController.h"

@interface ActivityWebVC : BaseSuperViewController

@property(nonatomic,strong)NSString *titleName;
- (instancetype)initWithURL:(NSURL*)URL;

@end
