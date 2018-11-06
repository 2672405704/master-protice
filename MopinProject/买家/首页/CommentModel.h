//
//  CommentModel.h
//  MopinProject
//
//  Created by xhd945 on 15/12/10.
//  Copyright © 2015年 rt008. All rights reserved.
//


 /** 评论Model **/
#import <Foundation/Foundation.h>

@interface CommentModel : NSObject

@property(nonatomic,strong)NSString* EID;//评价ID

@property(nonatomic,strong)NSString* EPhoto	;//	评价者头像
@property(nonatomic,strong)NSString* EContent;//评价内容（前台最多显示两行）
@property(nonatomic,strong)NSString* EReContent	;//	评价回复（前台最多显示两行）
@property(nonatomic,strong)NSString* ENickName	;//	评价昵称（如果为空，显示：匿名）


@end
