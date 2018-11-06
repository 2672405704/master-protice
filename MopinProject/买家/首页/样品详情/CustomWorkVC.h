//
//  CustomWorkVC.h
//  MopinProject
//
//  Created by xhd945 on 15/12/15.
//  Copyright © 2015年 rt008. All rights reserved.
//

#import "BaseSuperViewController.h"

/*返回一个内容*/
@protocol CustomWorkContentDelegate <NSObject>

- (void)finishedChooseWorkContent:(NSString*)customContent;

@end

@interface CustomWorkVC : BaseSuperViewController

@property(nonatomic,strong)NSString *ArtID;  //样品ID
@property(nonatomic,strong)NSString *chooseContent; //选中内容

@property(nonatomic,assign)NSInteger minNum;  //输入的最小字数
@property(nonatomic,assign)NSInteger maxNum;  //最大输入字数

@property (weak)id<CustomWorkContentDelegate>delegate;

- (instancetype)initWithArtID:(NSString*)artID
             AndChooseContent:(NSString*)chooseContent;

@end
