//
//  SalesView.h
//  View
//
//  Created by happyzt on 15/12/10.
//  Copyright © 2015年 happyzt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThirdSectionView : UIView

@property(nonatomic,strong)NSString*ReturnCoupon;//返券金额
@property(nonatomic,strong)NSString*Promotional;//促销说明


- (void)initDisplayView;
-(void)updateUI;

@end
