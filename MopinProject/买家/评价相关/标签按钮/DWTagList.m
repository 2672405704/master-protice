//
//  DWTagList.m
//
//  Created by Dominic Wroblewski on 07/07/2012.
//  Copyright (c) 2012 Terracoding LTD. All rights reserved.
//

#import "DWTagList.h"
#import <QuartzCore/QuartzCore.h>

#define CORNER_RADIUS 3.0f
#define LABEL_MARGIN 5.0f
#define BOTTOM_MARGIN 8.0f
#define FONT_SIZE 13.0f
#define HORIZONTAL_PADDING 10.0f //水平宽度
#define VERTICAL_PADDING 10.0f  //竖直高度
#define TEXT_COLOR MainFontColor
#define TEXT_SHADOW_COLOR [UIColor whiteColor]
#define TEXT_SHADOW_OFFSET CGSizeMake(0.0f, 1.0f)
#define BORDER_COLOR DIVLINECOLOR_1.CGColor
#define BORDER_WIDTH 0.5f

#define OriginX  25.0f

#define NomalImage mImageByName(@"white_bg_01")
#define SelectImage mImageByName(@"red_bg")

@implementation DWTagList

@synthesize view, textArray;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self addSubview:view];
        self.userInteractionEnabled  = YES;
        _isSingChoose = YES;
        
    }
    return self;
}

- (void)setTags:(NSArray *)array
{
    textArray = [[NSArray alloc] initWithArray:array];
    sizeFit = CGSizeZero;
    [self display];
}

- (void)setLabelBackgroundColor:(UIColor *)color
{
    lblBackgroundColor = color;
    [self display];
    
}

//TODO:创建按钮
- (void)display
{
    for (UIButton *subview in [self subviews])
    {
        [subview removeFromSuperview];
    }
    
    float totalHeight = 0;
    CGRect previousFrame = CGRectZero;
    BOOL gotPreviousFrame = NO;
    NSInteger tagNum = 500;
    
    for (NSString *text in textArray)
    {
        CGSize textSize = [text boundingRectWithSize:CGSizeMake(kkDeviceWidth-OriginX*2, 1500) options:NSStringDrawingUsesDeviceMetrics attributes:@{NSFontAttributeName:UIFONT(FONT_SIZE)} context:nil].size;

        textSize.width += HORIZONTAL_PADDING*2;
        textSize.height += VERTICAL_PADDING*2;
        
        UIButton *button = nil;
        
        if (!gotPreviousFrame)
        {
            button = [[UIButton alloc] initWithFrame:CGRectMake(OriginX, 10, textSize.width, textSize.height)];
            totalHeight = textSize.height;
        }
        else
        {
            CGRect newRect = CGRectZero;
            if (previousFrame.origin.x + previousFrame.size.width + textSize.width + LABEL_MARGIN > self.frame.size.width)
            {
                newRect.origin = CGPointMake(OriginX, previousFrame.origin.y + textSize.height + BOTTOM_MARGIN);
                totalHeight += textSize.height + BOTTOM_MARGIN;
            }
            
            else
            {
                newRect.origin = CGPointMake(previousFrame.origin.x + previousFrame.size.width + LABEL_MARGIN, previousFrame.origin.y);
            }
            
            newRect.size = textSize;
            button = [[UIButton alloc] initWithFrame:newRect];
        }
        previousFrame = button.frame;
        gotPreviousFrame = YES;
        [button.titleLabel setFont:[UIFont systemFontOfSize:FONT_SIZE]];
        
        //设置默认颜色
        if (!lblBackgroundColor)
        {
            [button setBackgroundColor:[UIColor whiteColor]];
            
        } else
        {
            [button setBackgroundColor:lblBackgroundColor];
        }
        
        [button setTitleColor:TEXT_COLOR forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [button setTitle:text forState:UIControlStateNormal];
        button.tag = tagNum++;
        if(button.tag == 500)
        {
            button.selected = YES;
        }
        
        /*设置背景图片*/
        [button setBackgroundImage:NomalImage forState:UIControlStateNormal];
        [button setBackgroundImage:SelectImage forState:UIControlStateSelected];
        
        [button.titleLabel setShadowColor:TEXT_SHADOW_COLOR];
        [button.titleLabel setShadowOffset:TEXT_SHADOW_OFFSET];
        [button.layer setMasksToBounds:YES];
        [button.layer setCornerRadius:CORNER_RADIUS];
        [button.layer setBorderColor:BORDER_COLOR];
        [button.layer setBorderWidth: BORDER_WIDTH];
        [self addSubview:button];
        
        //按钮动作
        [button addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    if(totalHeight+20>122.5)
    {
       sizeFit = CGSizeMake(self.frame.size.width, 122.5);
        self.contentSize = CGSizeMake(self.frame.size.width,totalHeight+20);
    }else
    {
        sizeFit = CGSizeMake(self.frame.size.width, totalHeight+20);
    }
    
    
}

- (CGSize)fittedSize
{
    return sizeFit;
}
- (void)buttonClickAction:(UIButton*)sender
{
    if(_isSingChoose)
    {
        for (UIButton *subview in [self subviews])
        {
            subview.selected = NO;
        }
        sender.selected = YES;
        
        if([_chooseTagDelegate respondsToSelector:@selector(chooseTagWithIndex:)])
        {
            [_chooseTagDelegate chooseTagWithIndex:sender.tag-500];
        }
    }
    else
    {
        sender.selected = !sender.selected;
        if([_chooseTagDelegate respondsToSelector:@selector(chooseTagWithIndex: AndisChoose:)])
        {
            [_chooseTagDelegate chooseTagWithIndex:sender.tag-500 AndisChoose:sender.isSelected];
        }
    }
    
}


@end
