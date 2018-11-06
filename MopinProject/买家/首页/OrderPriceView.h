//
//  OrderPriceView.h
//  MopinProject
//
//  Created by xhd945 on 15/12/20.
//  Copyright © 2015年 rt008. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol chooseJuanDelegate <NSObject>

@optional
- (void)toChooseJuan;
- (void)finishChooseJuanWith:(NSString*)juanID;

@end

@interface OrderPriceView : UIView

@property(nonatomic,strong)NSString*priceStr; //价格
@property(nonatomic,strong)NSString*MpJuan;  //墨品劵
@property(nonatomic,strong)NSString*SjJuan;  //书家劵
@property(nonatomic,strong)NSString *usedMpJuan;
@property(nonatomic,strong)NSString *usedSjJuan;
@property(nonatomic,strong)NSString *usedTotalAmount; //已用的劵


@property(nonatomic,weak)id<chooseJuanDelegate>delegate; 

//未选劵之前展示
- (void)SetDisPlayVeiw;
//TODO:设置选择后的展示
- (void)setFinishedChooseDisplayView;
@end
