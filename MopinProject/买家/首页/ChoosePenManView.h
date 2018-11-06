//
//  ChoosePenManView.h
//  MopinProject
//
//  Created by rt008 on 15/12/7.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChoosePenManViewDelegate <NSObject>

- (void)choosePenView:(NSString *)proviceId andCityId:(NSString *)cityId andPenmanType:(NSString *)type;

@end
@interface ChoosePenManView : UIView
@property(nonatomic,weak) id<ChoosePenManViewDelegate>delegate;
@end
