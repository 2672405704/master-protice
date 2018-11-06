//
//  CustomWorkListVC.h
//  MopinProject
//
//  Created by xhd945 on 15/12/16.
//  Copyright © 2015年 rt008. All rights reserved.
//

     /*调用的时候只传一个样品ID过来就行了*/

#import "BaseSuperViewController.h"

@class WorkDetailModel;

@interface CustomWorkListVC : BaseSuperViewController

@property (nonatomic,strong)NSString *ArtID; //样品ID
@property (nonatomic,strong)WorkDetailModel *workDetailMod;//样品详情Mod

- (id)initWithArtID:(NSString*)artID
      WorkDetailMod:(WorkDetailModel*)detailMod;

@end
