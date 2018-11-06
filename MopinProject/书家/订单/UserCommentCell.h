//
//  UserCommentCell.h
//  MopinProject
//
//  Created by happyzt on 15/12/18.
//  Copyright © 2015年 rt008. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UserCommentCell : UITableViewCell{
    UILabel *TitleLab;
    UIImageView*customHeaderIcon; //用户头像
    UILabel *customNikeNameLab; //用户昵称
    UILabel *publishDateLab; //发布时间
    UILabel *contentLab; //内容Lab


}


@property(nonatomic,strong)NSString*titleName; //标题
@property(nonatomic,strong)NSString*Photo; //头像URL
@property(nonatomic,strong)NSString*NikeName; //用户昵称
@property(nonatomic,strong)NSString*PulishDate;//发布时间
@property(nonatomic,strong)NSString*Content; //回复的内容
@property(nonatomic,strong)NSArray*ImageArr; //回复的图片
@property(nonatomic,strong)NSString*replyDate; //书家回复的时间
@property(nonatomic,strong)NSString*replyContent;//书家评论的内容

@end
