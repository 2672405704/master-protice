//
//  ProgressModel.h
//  MopinProject
//
//  Created by xhd945 on 16/1/4.
//  Copyright © 2016年 rt008. All rights reserved.
//

#import "SuperModel.h"

@interface ProgressModel : SuperModel
@property(nonatomic,strong)NSString* ProcessID; //进度ID
@property(nonatomic,strong)NSString*Type; //类型 3创作中4装裱中5已装裱6已发货
@property(nonatomic,strong)NSString*Content;// 内容
@property(nonatomic,strong)NSString*SendToMPCode;//快递单号 只有Type=6时，才有用，其他情况显示空字符串
@property(nonatomic,strong)NSString*CoName; //快递公司名字 只有Type=6时，才有用，其他情况显示空字符串
@property(nonatomic,strong)NSString*Createtime;//时间

@end
