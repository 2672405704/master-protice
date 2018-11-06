//
//  PhotoManagerViewController.h
//  MopinProject
//
//  Created by rt008 on 15/12/2.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "BaseSuperViewController.h"

@interface PhotoManagerViewController : BaseSuperViewController

@property (nonatomic,strong) UIImage *image;
@property (nonatomic,strong) void (^deletePhoto)(UIImage *image);

@end
