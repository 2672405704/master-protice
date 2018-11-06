//
//  XiaoSongLabel.m
//  MopinProject
//
//  Created by rt008 on 15/12/2.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "XiaoSongLabel.h"

@implementation XiaoSongLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.font=[UIFont fontWithName:XiaoBiaoSong size:self.font.pointSize];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if(self){
        self.font=[UIFont fontWithName:XiaoBiaoSong size:self.font.pointSize];
    }
    return self;
}
@end
