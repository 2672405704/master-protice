//
//  SecondSectionView.m
//  MopinProject
//
//  Created by xhd945 on 15/12/10.
//  Copyright © 2015年 rt008. All rights reserved.
//

#import "SecondSectionView.h"
#import "XHDHelper.h"
#import "CustomTitleView.h"
#import "CommetListCell.h"
#import "CommentListMod.h"
#import "CustomCommentVC.h" //买家评价

static NSString *identifyName = @"CommentListCell";

@implementation SecondSectionView
{
    UITableView *commentTable;

}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.backgroundColor = [UIColor clearColor];
        [self createTableView];
    }
    return self;
}
-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    commentTable.frame = mRect(0, 0,frame.size.width,frame.size.height);
}
-(void)setCommentArr:(NSArray *)CommentArr
{
   if(_CommentArr!=CommentArr)
   {
       _CommentArr = CommentArr;
   }
    [commentTable reloadData];
}

-(void)tableViewReloadDate
{
    [commentTable reloadData];
}

//表
- (void)createTableView
{
        commentTable = [[UITableView alloc]initWithFrame:mRect(0, 0,self.frame.size.width,self.frame.size.height) style:UITableViewStylePlain];
        commentTable.scrollEnabled = NO;
        commentTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        commentTable.delegate = self;
        commentTable.dataSource = self;
        commentTable.backgroundColor = [UIColor clearColor];
        [self addSubview:commentTable];
   
}
/*每一段多少行*/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
       return _CommentArr.count<=2?_CommentArr.count:2;
}

/*cell的显示*/
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommetListCell *cell =  [tableView dequeueReusableCellWithIdentifier:identifyName];
    if(cell ==nil)
    {
        cell = [[CommetListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifyName];
        cell.divLine.hidden = YES;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    if(_CommentArr.count>0)
    {
        CommentListMod *  mod = (CommentListMod*)_CommentArr[indexPath.row];
        [cell initUIWithCommentModInWorkDetail:mod];
    }
    return cell;
}

/*cell即将显示*/
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_CommentArr.count == 2)/*如果有俩行，且在第一行，则加一根分割线*/
    {
        if(indexPath.row == 0)
        {
            [XHDHelper addDivLineWithFrame:mRect(25,cell.height-3, cell.width-50, 0.4) SuperView:cell];
        }
    }
    
}

//TODO:段尾
- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    UIView *view;
    if(_CommentArr.count>0)
    {
      view = [[UIView alloc]initWithFrame:mRect(0,0, kkDeviceWidth, 70)];
      view.backgroundColor = tableView.backgroundColor;
      /*查看所有评价*/
       UIButton *checkAll = [XHDHelper createButton:mRect(view.width/2.0-50, 10, 100, 30) NomalTitle:@"查看所有评价" SelectedTitle:@"查看所有评价" NomalTitleColor:THEMECOLOR_1 SelectTitleColor:THEMECOLOR_1 NomalImage:nil SelectedImage:nil BoardLineWidth:0.5 target:self selector:@selector(checkAllComment)];
       checkAll.titleLabel.font = UIFONT(15);
       [view addSubview:checkAll];
    }
    
    return view;
}
/*行高*/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CommentListMod *mod = _CommentArr[indexPath.row];
    CGFloat cellHeight = [CommetListCell getCellHeightWithModel:mod];
    return cellHeight;
}
/*段尾高度*/
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return _CommentArr.count>0?70:0.1;
}
/*段头高度*/
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return _CommentArr.count>0?30.0f:50.0f;
}
/*段头*/
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:mRect(0,0, kkDeviceWidth, _CommentArr.count>0?30.0f:90.0f)];
    view.backgroundColor = [UIColor clearColor];
    
    //图标
    NSString *titleStr = [NSString stringWithFormat:@"%@条评论",_EvaluationNum.length?_EvaluationNum:@"0"];
    CustomTitleView *  logoTitView = [[CustomTitleView alloc]initWithFrame:mRect(self.width/2.0-50, 20,100,_CommentArr.count>0?10:20) AndImageName:@"comment_266px_1187838_easyicon.net" AndTitleName:titleStr];
    [view addSubview:logoTitView];
    
    if(_CommentArr.count==0)
    {
        //tips
        UILabel *labe = [XHDHelper createLabelWithFrame:mRect(0, logoTitView.bottom+5, view.width, 30) andText:@"此样品暂时没有评论" andFont:UIFONT(14.0) AndBackGround:[UIColor clearColor] AndTextColor:TipsFontColor];
        labe.textAlignment = NSTextAlignmentCenter;
        [view addSubview:labe];
    }
    return view;
}


#pragma mark -- 查看所有
- (void)checkAllComment
{
    //来至买家的评价
    CustomCommentVC *next = [[CustomCommentVC alloc]initWithType:1 AndTypeID:_ArtID];
    [self.delegate.navigationController pushViewController:next animated:YES];
    
}


#pragma mark -- 获取自身的高度
-(CGFloat)getSecondHeight
{
    CGFloat height = 90;
    if(_CommentArr)
    {
        if(_CommentArr.count==0)  //无评价
        {
            height = 90;
        }
        if(_CommentArr.count>0) //有评价
        {
            height = 250;//段头90+头像+昵称+段尾
            CommentListMod *mod =( CommentListMod *)_CommentArr[0];
            /*内容高度*/
            CGFloat height_content = [XHDHelper heightOfString:mod.Content.length?mod.Content:@"1234321" font:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(kkDeviceWidth-50, 1000)].height;
            height_content = height_content>40?height_content:40;
            height += height_content;
            
            /*图片高度*/
            if(mod.ImageData.count>0)
            {
                if( ((NSString*)mod.ImageData[0][@"EPicPath"]).length)
                {
                    height += 70;
                }
            }
            
            /*回复高度*/
            if(mod.ReContent.length)
            {
                height += 50;
                /*回复内容高度*/
                CGFloat height_reContent = [XHDHelper heightOfString:mod.ReContent font:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(kkDeviceWidth-60, 1000)].height;
                height_reContent = height_reContent>20?height_reContent:20;
                
                height += height_reContent+10;
            }
            
            if(_CommentArr.count>1) //评价大于1条
            {
                height = height +150.0f;
                CommentListMod *mod =( CommentListMod *)_CommentArr[1];
                /*内容高度*/
                CGFloat height_content = [XHDHelper heightOfString:mod.Content.length?mod.Content:@"1234321" font:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(kkDeviceWidth-50, 1000)].height;
                height_content = height_content>40?height_content:40;
                height += height_content;
                
                /*图片高度*/
                if(mod.ImageData.count>0)
                {
                    if( ((NSString*)mod.ImageData[0][@"EPicPath"]).length)
                    {
                        height += 70;
                    }
                    
                }
                
                /*回复高度*/
                if(mod.ReContent.length)
                {
                    height += 50;
                    /*回复内容高度*/
                    CGFloat height_reContent = [XHDHelper heightOfString:mod.ReContent font:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(kkDeviceWidth-60, 1000)].height;
                    height_reContent = height_reContent>20?height_reContent:20;
                    
                    height += height_reContent;
                }
                
            }
            
        }
        
    }
   
    return height;
}

@end
