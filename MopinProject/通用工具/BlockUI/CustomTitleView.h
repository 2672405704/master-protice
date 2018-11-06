//
//  CustomTitleView.h
//  MopinProject
//
//  Created by xhd945 on 15/12/11.
//  Copyright © 2015年 rt008. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTitleView : UIView

@property (nonatomic,strong)NSString *imageName;
@property (nonatomic,strong)NSString *titleStr;


- (instancetype)initWithFrame:(CGRect)frame
                 AndImageName:(NSString*)imageName
                 AndTitleName:(NSString*)titleStr;

@end
