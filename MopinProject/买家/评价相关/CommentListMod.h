//
//  CommentListMod.h
//  MopinProject
//
//  Created by xhd945 on 15/12/28.
//  Copyright © 2015年 rt008. All rights reserved.
//

#import "SuperModel.h"

@interface CommentListMod : SuperModel

@property(nonatomic,strong)NSString *EID;//评价ID
@property(nonatomic,strong)NSString *ArtName;//样品名称
@property(nonatomic,strong)NSString *PhotoPath;//评价者头像地址
@property(nonatomic,strong)NSString *Nickname;//评价者昵称
@property(nonatomic,strong)NSString *EDate;//评价日期 格式：2015年12月3日
@property(nonatomic,strong)NSString *Content;//评价内容
@property(nonatomic,strong)NSString *ReTime;//回复时间 格式: 2015年12月3日
@property(nonatomic,strong)NSString *ReContent;//评价回复内容
@property(nonatomic,strong)NSArray* ImageData ;//图片地址
   //EPicPath图片地址

@end
