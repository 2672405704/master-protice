//
//  SucessfulViewController.h
//  MopinProject
//
//  Created by rt008 on 15/11/26.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "BaseSuperViewController.h"

@interface SucessfulViewController : BaseSuperViewController
@property (nonatomic,assign) NSInteger type; //1.等待审核 2.提交成功
@property (nonatomic,copy) NSString *navTitle;
@end
