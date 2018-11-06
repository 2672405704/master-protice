//
//  OrderInfoView_second.h
//  MopinProject
//
//  Created by xhd945 on 15/12/17.
//  Copyright © 2015年 rt008. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TextEditVC;

@protocol FinishFillNumAndMarkDelegate <NSObject>

@end

@interface OrderInfoView_second : UIView<UITextFieldDelegate>

@property(nonatomic) __block NSString *chooseNumber;
@property(nonatomic) __block NSString *liuYanStr;

@property(nonatomic,assign)BOOL enableCheck;
@property(nonatomic,strong)TextEditVC *textvc;
@property(nonatomic,weak)UIViewController *delegate;

- (void)updateUI;

@end
