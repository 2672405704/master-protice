//
//  PenmanDetailSampleCell.h
//  MopinProject
//
//  Created by rt008 on 15/12/10.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PenmanDetailSampleModel;

@protocol PenmanDetailSampleCellDelegate <NSObject>

-(void)gotoLogin;

@end

@interface PenmanDetailSampleCell : UITableViewCell


@property(nonatomic,strong)PenmanDetailSampleModel *model;

@property(nonatomic,weak)id<PenmanDetailSampleCellDelegate> delegate;


@end
