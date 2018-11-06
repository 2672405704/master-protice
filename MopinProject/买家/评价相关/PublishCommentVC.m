//
//  FirstViewController.m
//  导航控制器
//
//  Created by happyzt on 15-7-25.
//  Copyright (c) 2015年 www.iphonetrain.com无线互联. All rights reserved.
//

#define RGBA(r,g,b,a)	[UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a] //RGB颜色


#import "PublishCommentVC.h"
#import "XHDHelper.h"
#import "PicSelectView.h"
#import "Utility.h"
#import "DWTagList.h"  //按钮标签

#import "PhotoManagerViewController.h"

#define BntHeight 30

@interface PublishCommentVC ()<ChooseTagDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate>
{
    UITextView *_commenttextView ;
    UIView *_textViewbg;
    UIView *photoListView;
    NSInteger _selectedIndex;
    BOOL _selected;
    
    UIScrollView *_bgScrollView;
    
    DWTagList *tagListView; //标签列表
    UIButton *submitButton;
    
    NSMutableArray *_commentTagArr;//按钮标签数组
    NSMutableArray *_chooseTagArr; //选中的Tag的数组
    NSString *TagStr;  //标签拼接字符串
    UIControl *picControl;
    NSMutableArray *_selectedImageArr;  //选中的图片的数组
    NSMutableArray *_selectedImageIdArr; //选中的图片的ID数组
    NSString *picIDStr;
    UIButton *addImageBnt;  //添加图片的按钮
}

@property (assign) BOOL removeFromSuperViewOnHide;

@end

@implementation PublishCommentVC
- (instancetype)initWithCodeID:(NSString *)codeID
{
    self = [super init];
    if (self) {
       _commentTagArr = [[NSMutableArray alloc]init];
        _chooseTagArr = [[NSMutableArray alloc]init];
        _selectedImageArr = [[NSMutableArray alloc]init];
        _selectedImageIdArr = [[NSMutableArray alloc]init];
        [self getCommentTag];
        
        _orderId = codeID;
        
    }
    return self;
}

#pragma mark -- 创建基础滚动视图
-(void)createBgScrollView
{
   if(_bgScrollView == nil)
   {
       _bgScrollView = [[UIScrollView alloc]initWithFrame:mRect(0, 0, mScreenWidth, mScreenHeight-64)];
       _bgScrollView.backgroundColor = [UIColor clearColor];
       _bgScrollView.contentSize = CGSizeMake(0, kkDeviceHeight-64);
       [self.view addSubview:_bgScrollView];
   
   }

}

/*返回*/
- (void)backBtnClick
{
    [self setEditing:YES animated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.45 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"确定放弃评价吗?" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        [alert show];
    });
   
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
        switch (buttonIndex)
        {
            case 0:
            {
                [self setEditing:YES];
                [self.navigationController popViewControllerAnimated:YES];
            }
                break;
            default:
                break;
        }
}

#pragma mark --  视图循环
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title=@"发表评论";
    [self setNavBackBtnWithType:1];
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createBgScrollView];
    //选择评论按钮
    [self _createSelectCommentView];
    
   
}

#pragma mark -- 选择评论按钮
- (void)_createSelectCommentView
{
    //1>创建场景
    NSMutableArray *commentName = [[NSMutableArray alloc]init];
    for(NSDictionary *dic in _commentTagArr)
    {
        NSString *tit = dic[@"Title"];
        [commentName addObject:tit];
    }
    tagListView = [[DWTagList alloc] initWithFrame:mRect(0, 0, kkDeviceWidth, 105)];
    tagListView.delegate = self;
    tagListView.isSingChoose = NO;
    [tagListView setTags:commentName];
    for (UIButton*sub in tagListView.subviews)
    {
        sub.selected = NO;
    }
    tagListView.backgroundColor = [UIColor clearColor];
    [_bgScrollView addSubview:tagListView];
    
    //评论textView
    [self _cteateTextView];
    
    //选择照片
    [self _createPhotoView];
    
    //创建提交按钮
    [self _createSubmitAction];
}

/*按钮选中的代理方法*/
- (void)chooseTagWithIndex:(NSInteger)index  AndisChoose:(BOOL)isChoose
{
    if(isChoose) //将ID添加到一个数组
    {
        NSString *ID = _commentTagArr[index][@"TagID"];
        [_chooseTagArr addObject:ID];
    }
    else  //将ID充数组中删除
    {
        NSString *ID = _commentTagArr[index][@"TagID"];
        [_chooseTagArr removeObject:ID];
    }

}

#pragma mark -- 创建评论内容的TextView
- (void)_cteateTextView
{
    
    _textViewbg = [[UIView alloc] initWithFrame:CGRectMake(0, tagListView.bottom, kkDeviceWidth, 110)];
    _textViewbg.backgroundColor = [UIColor whiteColor];
    [_bgScrollView addSubview:_textViewbg];
    
    _commenttextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 0, kkDeviceWidth-20, 110)];
    _commenttextView.backgroundColor = [UIColor whiteColor];
    _commenttextView.delegate = self;
    _commenttextView.returnKeyType = UIReturnKeyDone;
    _commenttextView.text = @"亲，写点什么吧，您的意见对其他的墨客有很大的帮助！";
    _commenttextView.font = [UIFont systemFontOfSize:14];
    _commenttextView.textColor = TipsFontColor;
    [_textViewbg addSubview:_commenttextView];
    
}


/*如果开始编辑状态，则将文本信息设置为空，颜色变为黑色：*/
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    textView.text=@"";
    _commenttextView.textColor = [UIColor blackColor];
    return YES;
    
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if (textView.text.length==0)
    {
        _commenttextView.text = @"亲，写点什么吧，您的意见对其他的墨客有很大的帮助！";
        _commenttextView.textColor = TipsFontColor;
    }
    return YES;

}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
    }
    if(textView.text.length >120)
    {
        return NO;
    }
    return YES;
}

#pragma mark -- 选择上传照片 ---------ok
- (void)_createPhotoView
{
    //上传照片标题
    picControl =  [[UIControl alloc] initWithFrame:CGRectMake(0, _textViewbg.bottom+10, kkDeviceWidth,35)];
    picControl .backgroundColor = [UIColor whiteColor];
    //[control addTarget:self action:@selector(upPhotoAction:) forControlEvents:UIControlEventTouchUpInside];
    [_bgScrollView addSubview:picControl];
    
    UILabel *photoLabel = [[UILabel alloc] initWithFrame:CGRectMake(25,5, 100, 25)];
    photoLabel.text = @"上传照片";
    photoLabel.font = UIFONT(15);
    photoLabel.textColor = MainFontColor;
    [picControl  addSubview:photoLabel];
    
    //分割线
    [XHDHelper addDivLineWithFrame:mRect(0, picControl .height-0.5, kkDeviceWidth, 0.5) SuperView:picControl ];
   
    photoListView = [[UIView alloc] initWithFrame:CGRectMake(0, picControl.bottom, self.view.width, (kkDeviceWidth-57.5)/4.0+20)];
    photoListView.backgroundColor = [UIColor whiteColor];
    [_bgScrollView addSubview:photoListView];
    
    /*添加图片按钮*/
    addImageBnt = [[UIButton alloc]initWithFrame:mRect(25, 10, (kkDeviceWidth-52.5)/4.0, (kkDeviceWidth-52.5)/4.0)];
    [addImageBnt setBackgroundImage:mImageByName(@"plus_pic_sample") forState:UIControlStateNormal];
    addImageBnt.tag = 909;
    [addImageBnt addTarget:self action:@selector(addImageButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [photoListView addSubview:addImageBnt];
    
}
/*添加图片按钮的点击事件*/
- (void)addImageButtonAction:(UIButton*)sender
{
    UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
    [sheet showInView:self.view];

}
/*创建图片视图*/
- (void)createImageView
{
    NSArray *imageArr =_selectedImageArr;
    UIView *bgView  = photoListView;
    UIButton *addBtn = addImageBnt;
    
    for(UIView *subView in bgView.subviews)
    {
        if(subView.tag!=909){
            [subView removeFromSuperview];
        }
    }
   
    for(int i=0;i<imageArr.count;i++)
    {
        UIButton *imageBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        imageBtn.frame=CGRectMake(25+(i*(kkDeviceWidth-35)/4.0+5), 10, (kkDeviceWidth-52.5)/4.0, (kkDeviceWidth-52.5)/4.0);
        imageBtn.contentMode=UIViewContentModeScaleAspectFill;
        imageBtn.clipsToBounds=YES;
        [imageBtn setImage:imageArr[i] forState:UIControlStateNormal];
        imageBtn.tag=100+i;
        [bgView addSubview:imageBtn];
        
        [imageBtn addTarget:self action:@selector(imageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    if(imageArr.count==3)
    {
        addBtn.hidden=YES;
    }else
    {
        addBtn.hidden=NO;
        addBtn.frame=CGRectMake(33+(kkDeviceWidth-35)/4.0*imageArr.count, 10, (kkDeviceWidth-52.5)/4.0, (kkDeviceWidth-52.5)/4.0);
    }
}
/*TODO:点击图片,跳到图片管理器去删除选中的图片*/
- (void)imageBtnClick:(UIButton *)button
{
    __weak typeof(self) weakSelf=self;
    PhotoManagerViewController *pmvc=[[PhotoManagerViewController alloc]initWithNibName:@"PhotoManagerViewController" bundle:nil];
    pmvc.image=[button imageForState:UIControlStateNormal];
    [pmvc setDeletePhoto:^(UIImage *image) {
        
        if([_selectedImageArr containsObject:image])
        {
            [_selectedImageIdArr removeObjectAtIndex:[_selectedImageArr indexOfObject:image]];
            [_selectedImageArr removeObject:image];
            
            [weakSelf createImageView];
        }
    }];
    [self.navigationController pushViewController:pmvc animated:YES];
}


/*提交按钮*/
- (void)_createSubmitAction
{
    submitButton = [[UIButton alloc] initWithFrame:CGRectMake(30, photoListView.bottom+20, kkDeviceWidth-60, 40)];
    [submitButton setTitle:@"提交评价" forState:UIControlStateNormal];
    [submitButton setBackgroundColor:RGBA(206, 59, 51, 1)];
    submitButton.titleLabel.font = [UIFont systemFontOfSize:18];
    submitButton.layer.cornerRadius = 3;
    submitButton.layer.borderColor = [UIColor clearColor].CGColor;
    submitButton.layer.borderWidth = 1;
    [submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_bgScrollView addSubview:submitButton];
    [submitButton addTarget:self action:@selector(sumbitAction:) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark -- 提交评价
- (void)sumbitAction:(UIButton *)button
{
     //1.判断是否选择了标签,拼接标签字符串
    TagStr = @"";
    if(_chooseTagArr.count==0)
    {
        [SVProgressHUD showErrorWithStatus:@"请选择评价标签~"];
        return;
    }else
    {
       for(NSString *idStr in _chooseTagArr)
       {
          TagStr =  [TagStr stringByAppendingString:[NSString stringWithFormat:@"%@,",idStr]];
       }
    }
     //2.判断是是否填充了内容
//    if(_commenttextView.text.length == 0 || [_commenttextView isEqual:@"亲，写点什么吧，您的意见对其他的墨客有很大的帮助！"] )
//    {
//        [SVProgressHUD showErrorWithStatus:@"请选择填写评价内容"];
//        return;
//    }

    /*不要求必填*/
    if( [_commenttextView isEqual:@"亲，写点什么吧，您的意见对其他的墨客有很大的帮助！"] )
    {
       _commenttextView.text = @"";
    }
    
     //4.拼接图片字符串
   if(_selectedImageIdArr.count>0)
    {
        picIDStr  = [_selectedImageIdArr componentsJoinedByString:@","];
    }
    
    [self commitCommentToService];
    
}

#pragma mark -- 标签按钮的选择
- (void)selecteCommentAction:(UIButton *)button
{
    button.selected = !button.selected;
    if (button.selected)
    {
        NSLog(@"选中状态。。。。。");
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else
    {
        NSLog(@"未选中状态。。。。。");
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
}

#pragma mark -- 更多按钮的选择
- (void)MoreButtonClickAction:(UIButton*)sender
{


}

#pragma mark -- 网络请求相关 ----------ok
- (void)commitCommentToService
{

    NSMutableDictionary *parameterDic=[NSMutableDictionary dictionary];
    [parameterDic setValue:@"OrderEvaluate" forKey:@"Method"];
    [parameterDic setValue:Infversion forKey:@"Infversion"];
    [parameterDic setValue:[PersonalInfoSingleModel shareInstance].UserID forKey:@"UserID"];
    [parameterDic setValue:_orderId.length?_orderId:@"1" forKey:@"OrderCode"];//订单ID
    [parameterDic setValue:TagStr forKey:@"EID"];//评价标签ID,如果多个标签，用英文逗号隔开
    [parameterDic setValue:_commenttextView.text forKey:@"Content"];//内容
    [parameterDic setValue:picIDStr forKey:@"EPicID"];//评论图片ID
   
    
    [HTTPMethod NET_request:1 urlStr:HOSTURL ServiceParameters:parameterDic success:^(NSString *reponse) {
        NSData *jsonDate=[reponse dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary * jsonObject = [NSJSONSerialization JSONObjectWithData:jsonDate options:NSJSONReadingAllowFragments error:&error];
        
        NSString * code = [NSString stringWithFormat:@"%@", jsonObject[@"code"]];
        NSString * msg = jsonObject[@"msg"];
        [DictionaryTool showResult:msg withCode:code.integerValue];
        
        if (code.integerValue == 1000)
        {
            /*发个通知，刷新列表*/
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateMyOrderList"
                                                                object:nil
                                                              userInfo:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSError *error){
        
        [SVProgressHUD dismiss];
        NSLog(@"%@",error);
        
    }];

}


/*获取评价标签*/
- (void)getCommentTag
{
    NSMutableDictionary *parameterDic=[NSMutableDictionary dictionary];
    [parameterDic setValue:@"GetEvaluateTag" forKey:@"Method"];
    [parameterDic setValue:Infversion forKey:@"Infversion"];
    
    [HTTPMethod NET_request:1 urlStr:HOSTURL ServiceParameters:parameterDic success:^(NSString *reponse) {
        NSData *jsonDate=[reponse dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary * jsonObject = [NSJSONSerialization JSONObjectWithData:jsonDate options:NSJSONReadingAllowFragments error:&error];
        
        NSString * code = [NSString stringWithFormat:@"%@", jsonObject[@"code"]];
        NSString * msg = jsonObject[@"msg"];
        [DictionaryTool showResult:msg withCode:code.integerValue];
        
        if (code.integerValue == 1000)
        {
            NSMutableArray *titleArr = [[NSMutableArray alloc]init];
            for(NSDictionary *dic in jsonObject[@"data"])
            {
                //填充数据
                [_commentTagArr addObject:dic];
                NSString *title = dic[@"Title"];
                [titleArr addObject:title];
            }
            
            [tagListView setTags:titleArr];
            [self updateUI];
            
        }
    } failure:^(NSError *error){
        
        [SVProgressHUD dismiss];
        NSLog(@"%@",error);
        
    }];
}


#pragma mark -- 上传图片相关 ------------------ok
#pragma mark - actionSheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *picker=[[UIImagePickerController alloc]init];
        picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        picker.delegate=self;
        if(buttonIndex==0){
            //选择相机
            if([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]){
                picker.sourceType=UIImagePickerControllerSourceTypeCamera;
                picker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
            }else{
                [SVProgressHUD showErrorWithStatus:@"相机不可用！"];
                return;
            }
        }else if(buttonIndex==2)
        {
            return;
        }
        [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //获取image
    UIImage *image=[info objectForKey:UIImagePickerControllerOriginalImage];
    image=[self fixOrientation:image];
    [self uploadHeaderImageView:image];
    [self dismissViewControllerAnimated:YES completion:nil];
}
/*TODO:处理图片旋转问题*/
- (UIImage *)fixOrientation:(UIImage *)aImage
{
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}
/*TODO:上传图片*/
- (void)uploadHeaderImageView:(UIImage *)image
{
    NSData *data=UIImageJPEGRepresentation(image, 0.3);
    
    [SVProgressHUD show];
    NSMutableDictionary *parameterDic=[NSMutableDictionary dictionary];
    [parameterDic setValue:@"SavePic" forKey:@"Method"];
    [parameterDic setValue:Infversion forKey:@"Infversion"];
    
    [HTTPMethod uploadImageWithParameters:parameterDic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSString *strname = [NSString stringWithFormat:@"%@.png",[Utility stringWithUUID]];
        [formData appendPartWithFileData:data name:@"file" fileName:strname mimeType:@"image/png"];
    } SuccessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString * mssg = responseObject[@"msg"];
        NSInteger code = [responseObject[@"code"] integerValue];
        [DictionaryTool showResult:mssg withCode:code];
        if(code==1000){
            
                [_selectedImageArr addObject:[UIImage imageWithData:data]];
                [_selectedImageIdArr addObject:responseObject[@"data"][@"ID"]];
            /*创建图片视图*/
            [self createImageView];
        }
    } FailBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"uploadFail:%@",error);
        [SVProgressHUD showErrorWithStatus:@"网络有问题哟，请检查网络是否连接~"];
    }];
}

-(void)updateUI
{
    tagListView.frame = CGRectMake(tagListView.origin.x, tagListView.origin.y, [tagListView fittedSize].width, [tagListView fittedSize].height);
    
    _textViewbg.top = tagListView.bottom;
    picControl.top = _textViewbg.bottom+10;
    photoListView.top = picControl.bottom;
    submitButton.top = photoListView.bottom+20;
    
  CGFloat height =  tagListView.height+_textViewbg.height+picControl.height+photoListView.height+submitButton.height+50;
    _bgScrollView.contentSize = CGSizeMake(0,height>kkDeviceHeight-64?height:kkDeviceHeight-64);
    
}

@end
