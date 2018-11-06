//
//  ZhuanBiaoTypeMod.h
//  MopinProject
//
//  Created by xhd945 on 15/12/22.
//  Copyright © 2015年 rt008. All rights reserved.
//

#import "SuperModel.h"

@interface ZhuanBiaoTypeMod : SuperModel

@property(nonatomic,strong)NSString*ZhBTypeID; //装裱类别ID

@property(nonatomic,strong)NSString* ZhBStyle;//装裱样式ID
@property(nonatomic,strong)NSString*ZhBStyleName;//装裱样式名称
@property(nonatomic,strong)NSString*ZhBStylePic;//装裱样式图片地址
@property(nonatomic,strong)NSString*ZhBSize;//装裱后尺寸(文字)
@property(nonatomic,strong)NSString*ZhBPrice;//装裱价格

@end
