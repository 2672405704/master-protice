//
//  ExampleWorkVC.h
//  MopinProject
//
//  Created by xhd945 on 15/12/9.
//  Copyright © 2015年 rt008. All rights reserved.
//

/*样品列表VC*/
/*从筛选进来的时候传一个model，从书家详情进来的时候传一个数组*/

#import "BaseSuperViewController.h"
#import "GetSampleListModel.h"

@interface ExampleWorkVC : BaseSuperViewController

@property (strong) GetSampleListModel *mod;

- (id)initWithModel:(GetSampleListModel*)model;

@end
