//
//  SearchViewController.h
//  MopinProject
//
//  Created by rt008 on 15/12/8.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "BaseSuperViewController.h"

typedef enum : NSUInteger {
    SearchTypeSample,     //首先显示搜索作品
    SearchhTypePenman,    //首先显示搜索书家
} SearchType;
@interface SearchViewController : BaseSuperViewController
@property (nonatomic,assign) SearchType type;
@end
