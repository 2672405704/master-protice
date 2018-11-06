//
//  SelectedSexView.h
//  MopinProject
//
//  Created by rt008 on 15/12/7.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectedSexViewDelegate <NSObject>

- (void)selectedSex;

@end
@interface SelectedSexView : UIView
@property (nonatomic,weak) id<SelectedSexViewDelegate>delegate;
@end
