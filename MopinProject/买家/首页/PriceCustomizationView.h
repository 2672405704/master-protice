//
//  PriceCustomizationView.h
//  MopinProject
//
//  Created by rt008 on 15/12/8.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GetSampleListModel;
@protocol PriceCustomizationViewDelegate <NSObject>

- (void)priceCustomizationWithModel:(GetSampleListModel *)model;

@end
@interface PriceCustomizationView : UIView
@property (nonatomic,weak) id<PriceCustomizationViewDelegate>delegate;
@end
