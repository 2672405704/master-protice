//
//  CommetListCell.h
//  MopinProject
//
//  Created by xhd945 on 15/12/14.
//  Copyright © 2015年 rt008. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CommentListMod;
@interface CommetListCell : UITableViewCell

@property(nonatomic,strong)NSString*titleName; //标题
@property(nonatomic,strong)NSString*Photo; //头像URL
@property(nonatomic,strong)NSString*NikeName; //用户昵称
@property(nonatomic,strong)NSString*PulishDate;//发布时间
@property(nonatomic,strong)NSString*Content; //回复的内容
@property(nonatomic,strong)NSArray*ImageArr; //回复的图片
@property(nonatomic,strong)NSString*replyDate; //书家回复的时间
@property(nonatomic,strong)NSString*replyContent;//书家评论的内容


@property(nonatomic,strong)UIView *divLine; //分割线


/*样品详情中的评价*/
-(void)initUIWithCommentModInWorkDetail:(CommentListMod*)mod;
/*样品评价*/
-(void)initUIWithSampleCommentListMod:(CommentListMod*)mod;
/*评价管理*/
-(void)initUIWithCommentManagerListMod:(CommentListMod*)mod;

#pragma mark -- 获取高度
+(CGFloat)getCellHeightWithModel:(CommentListMod*)mod;

@end
