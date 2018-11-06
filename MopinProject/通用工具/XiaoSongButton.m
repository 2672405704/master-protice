//
//  XiaoSongButton.m
//  MopinProject
//
//  Created by rt008 on 15/12/19.
//  Copyright © 2015年 rt008. All rights reserved.
//

#import "XiaoSongButton.h"

@implementation XiaoSongButton

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.titleLabel.font=[UIFont fontWithName:XiaoBiaoSong size:self.titleLabel.font.pointSize];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if(self){
        
        self.titleLabel.font=[UIFont fontWithName:XiaoBiaoSong size:self.titleLabel.font.pointSize];
    }
    return self;
}
@end
