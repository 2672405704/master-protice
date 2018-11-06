//
//  PicSelectView.m
//  MixiMixiBakers
//
//  Created by xhd945 on 15/10/7.
//  Copyright © 2015年 HuangCaixia. All rights reserved.
//

#import "PicSelectView.h"
#import "UIKit+AFNetworking.h"
#define BgImageName @"pic_border"
#define CancelImageName @"dptp_close"

@implementation PicSelectView
{
  UIImagePickerController *imgControl;//照片选择器
  UIImage *orginImage;   //原始照片
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        _isChange = NO;
        _cancelButton = [[UIButton alloc]initWithFrame:mRect((kkDeviceWidth-40)/4.0-31, 0, 20, 20)];
        _cancelButton.layer.cornerRadius = 10;
        _cancelButton.clipsToBounds = YES;
        _cancelButton.hidden = YES;
        [_cancelButton setImage:[UIImage imageNamed:CancelImageName] forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelSelectedImage:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_cancelButton];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(choosePicture:)];
        [self addGestureRecognizer:tap];
        self.userInteractionEnabled = YES;
        orginImage = self.image;

    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _isChange = NO;
        _cancelButton = [[UIButton alloc]initWithFrame:mRect(self.width-15, -5, 20, 20)];
        [_cancelButton setImage:[UIImage imageNamed:CancelImageName] forState:UIControlStateNormal];
        _cancelButton.layer.cornerRadius = 10;
        _cancelButton.clipsToBounds = YES;
        _cancelButton.hidden = YES;
        [_cancelButton addTarget:self action:@selector(cancelSelectedImage:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_cancelButton];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(choosePicture:)];
        [self addGestureRecognizer:tap];
        self.userInteractionEnabled = YES;
        orginImage = self.image;
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _isChange = NO;
        _cancelButton = [[UIButton alloc]initWithFrame:mRect(self.width-15, -5, 20, 20)];
        [_cancelButton setImage:[UIImage imageNamed:CancelImageName] forState:UIControlStateNormal];
        _cancelButton.layer.cornerRadius = 10;
        _cancelButton.clipsToBounds = YES;
        _cancelButton.hidden = YES;
        [_cancelButton addTarget:self action:@selector(cancelSelectedImage:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_cancelButton];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(choosePicture:)];
        [self addGestureRecognizer:tap];
        self.userInteractionEnabled = YES;
        orginImage = self.image;
    }
    return self;
}



//TODO:选择图片
- (void)choosePicture:(UITapGestureRecognizer*)tap
{
    PicSelectView *picView = (PicSelectView *)tap.view;
    UIActionSheet *choosePic = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
    choosePic.tag = picView.tag;
    [choosePic showInView:WINDOW];
}
/*----------------TODO:sheet代理协议--------------*/
//TODO:sheet 按钮选择事件
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0: //照相机
        {
            imgControl = [[UIImagePickerController alloc] init];
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                imgControl.sourceType = UIImagePickerControllerSourceTypeCamera;
                imgControl.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
                
            }
            imgControl.delegate = self;
            imgControl.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            imgControl.allowsEditing =YES;
            [self.delegate.navigationController presentViewController:imgControl animated:YES completion:^{
            }];
        }
            break;
        case 1: //相册选择
        {
            imgControl= [[UIImagePickerController alloc] init];
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                imgControl.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            }
            imgControl.delegate =self;
            imgControl.allowsEditing =YES;//自定义照片样式
            [self.delegate.navigationController presentViewController:imgControl animated:YES completion:^{
                
            }];
        }
        default:
            break;
    }
}
/*------------------TODO:照片选择器代理协议----------------------*/
//TODO:照片选择器结束选择照片后
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo NS_DEPRECATED_IOS(2_0, 3_0)
{
    [imgControl dismissViewControllerAnimated:YES completion:^{
        
        self.image = image;
        self.cancelButton.hidden = NO;
        _isChange = YES;
        
        
        if(_compelteSelected)
        {
            _compelteSelected(self.image);
        }
    }];
}

-(void)cancelSelectedImage:(UIButton*)sender
{
    self.image =[UIImage imageNamed:BgImageName];  //orginImage;
    sender.hidden = YES;
    //删除原有的图片也需要判断
    if(_cancelSelected)
    {
        _cancelSelected();
    }
}

@end
