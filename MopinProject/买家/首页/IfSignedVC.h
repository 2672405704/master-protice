//
//  IfSignedVC.h
//  MopinProject
//
//  Created by xhd945 on 15/12/16.
//  Copyright © 2015年 rt008. All rights reserved.
//

#import "BaseSuperViewController.h"
/*返回一个是否题款以及题款内容*/
@protocol CustomWorkIsTikuanDelegate <NSObject>

- (void)finishedChooseWorkIsTikuan:(BOOL)isTiKuan
                        AndContent:(NSString*)customContent;

@end


@interface IfSignedVC : BaseSuperViewController

@property(nonatomic,strong)NSString *inputContent;//输入数据
@property (weak)id<CustomWorkIsTikuanDelegate>delegate;

@end
