//
//  FifthSectionView.h
//  MopinProject
//
//  Created by xhd945 on 15/12/11.
//  Copyright © 2015年 rt008. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FifthSectionView : UIView

@property(nonatomic,strong)NSString*ShowType;//类型
@property(nonatomic,strong)NSString*WordType;//字体
@property(nonatomic,strong)NSString*WordNum;//样品字数（显示格式：2-4字）
@property(nonatomic,strong)NSString*Size;//篇幅
@property(nonatomic,strong)NSString*ISInscribe;//是否支持落款 0：不支持  1：支持
@property(nonatomic,strong)NSString*Material;//样品材料（显示文字）
@property(nonatomic,strong)NSString*ZhuBiao; //转表
@property(nonatomic,strong)NSString*CreateCycle;//创作周期（文字）

-(void)UpdateUI;

@end

@interface YaYueView : UIControl

@property(nonatomic,strong)NSString*titleStr;
@property(nonatomic,strong)NSString*ContentStr;
@property(nonatomic,strong)UIView*divLine;

@property(nonatomic,assign)BOOL isShowRightIcon;

-(instancetype)initWithFrame:(CGRect)frame
                    AndTitle:(NSString*)titleStr
                  AndContent:(NSString*)contentStr;

-(void)updateYaoYueUI;

@end
