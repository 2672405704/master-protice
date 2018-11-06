//
//  ChooseDateView.h
//  MopinProject
//
//  Created by rt008 on 15/12/3.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChooseDateViewDelegate <NSObject>

- (void)chooseDate:(NSString *)date;

@end
@interface ChooseDateView : UIView
@property (nonatomic,weak) id<ChooseDateViewDelegate>delegate;
- (instancetype)initViewWithType:(NSInteger)type;
@end
