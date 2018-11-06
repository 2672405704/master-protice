//
//  ChooseAddressView.h
//  MopinProject
//
//  Created by rt008 on 15/11/26.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChooseAddressViewDelegate <NSObject>

- (void)chooseAddressIdWithArray:(NSArray *)arr;

@end
@interface ChooseAddressView : UIView
- (instancetype)initWithFrame:(CGRect)frame andProvince:(NSString *)province andCity:(NSString *)city andDistrict:(NSString *)district;
@property (nonatomic,weak) id<ChooseAddressViewDelegate> delegate;
- (void)releaseCount;
@end
