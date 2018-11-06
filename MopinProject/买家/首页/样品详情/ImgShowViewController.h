//
//  ImgShowViewController.h
//
//  图片展示控件
//
//  Created by Minr on 15-11-15.
//  Copyright (c) 2014年 XHD. All rights reserved.
//

#import "BaseSuperViewController.h"

@interface ImgShowViewController :BaseSuperViewController

@property(nonatomic ,assign)NSInteger index;  //标识
@property(nonatomic ,strong)NSMutableArray *data; //数据源

- (id)initWithSourceData:(NSMutableArray *)data withIndex:(NSInteger)index;


@end



