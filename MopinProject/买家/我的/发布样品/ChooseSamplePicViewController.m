//
//  ChooseSamplePicViewController.m
//  MopinProject
//
//  Created by rt008 on 15/11/29.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "ChooseSamplePicViewController.h"
#import "Utility.h"
#import "PublishSampleModel.h"
#import "PublishSample2ViewController.h"
#import "ImageModel.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"

@interface ChooseSamplePicViewController ()<UITextViewDelegate,UITextFieldDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    NSMutableArray *_imageArr;
//    NSMutableArray *_imageIdArr;
    NSInteger _selectedIndex;
}
@property (weak, nonatomic) IBOutlet UIScrollView *bgScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UIView *headBgView;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *widthTextField;
@property (weak, nonatomic) IBOutlet UITextField *heightTextField;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *placeHolderLabel;
@property (weak, nonatomic) IBOutlet UITextField *promotionTextField;
@property (weak, nonatomic) IBOutlet UIView *boomBgView;
@property (weak, nonatomic) IBOutlet UIView *imageBgView;
@end

@implementation ChooseSamplePicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title=@"发布样品";
    [self setNavBackBtnWithType:1];
    _imageArr=[[NSMutableArray alloc]init];
//    _imageIdArr=[[NSMutableArray alloc]init];
    _headImage.contentMode=UIViewContentModeScaleAspectFill;
    _headImage.clipsToBounds=YES;
    
//    _bgScrollView.frame=CGRectMake(0, 0, kkDeviceWidth, kkDeviceHeight-mNavBarHeight-mTabBarHeight);
    _bgScrollView.contentSize=CGSizeMake(kkDeviceWidth, 540);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keybordShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keybordHide) name:UIKeyboardWillHideNotification object:nil];
    
    if(_publishModel.ArtID.length!=0){
        _imageArr=[_publishModel.SamplePicArr mutableCopy];
        _headBgView.hidden=YES;
        [_headImage sd_setImageWithURL:[NSURL URLWithString:[_imageArr.lastObject Image]] placeholderImage:mImageByName(PlaceHeaderSquareImage)];
        _selectedIndex=_imageArr.count-1;
        
        [_imageArr addObject:[UIImage imageNamed:@"plus_pic_sample.png"]];
        [self createImageView];
        
        _titleTextField.text=_publishModel.SampleName;
        _widthTextField.text=_publishModel.SizeWidth;
        _heightTextField.text=_publishModel.SizeHighet;
        _placeHolderLabel.hidden=YES;
        _textView.text=_publishModel.Recommendation;
        _promotionTextField.text=_publishModel.SaleDesc;
    }
    _widthTextField.inputAccessoryView=self.keyBordtoolBar;
    _heightTextField.inputAccessoryView=self.keyBordtoolBar;
}
//TODO:键盘隐藏
- (void)keybordHide
{
    [UIView animateWithDuration:0.3 animations:^{
        _bgScrollView.frame=CGRectMake(0, 0, kkDeviceWidth, kkDeviceHeight-mNavBarHeight-mTabBarHeight);
    }];
}
//TODO:键盘显示
- (void)keybordShow:(NSNotification *)notification
{
    //获取键盘高度
    NSDictionary *info=[notification userInfo];
    CGFloat kbHeight = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    CGFloat y;
    if(_imageBgView.frame.size.height!=0){
        y=667-kkDeviceHeight+95;
    }else{
        y=667-kkDeviceHeight;
    }
    
   [_bgScrollView scrollRectToVisible:CGRectMake(0,y, GETVIEWWIDTH(_bgScrollView), GETVIEWHEIGHT(_bgScrollView)) animated:YES];
    //获取输入框相对位置
//    CGFloat y=rect.origin.y-(kkDeviceHeight-105-kbHeight-mNavBarHeight);
//    if(y<=0){
//        return;
//    }
    if([_widthTextField isFirstResponder] || [_heightTextField isFirstResponder]){
        [UIView animateWithDuration:0.3 animations:^{
            _bgScrollView.frame=CGRectMake(0,-58, kkDeviceWidth, kkDeviceHeight-mNavBarHeight-mTabBarHeight);
        }];
    }
    if([_textView isFirstResponder]){
        [UIView animateWithDuration:0.3 animations:^{
            _bgScrollView.frame=CGRectMake(0,-kbHeight+120, kkDeviceWidth, kkDeviceHeight-mNavBarHeight-mTabBarHeight);
        }];
    }
    if([_promotionTextField isFirstResponder]){
        [UIView animateWithDuration:0.3 animations:^{
            _bgScrollView.frame=CGRectMake(0,-kbHeight+60, kkDeviceWidth, kkDeviceHeight-mNavBarHeight-mTabBarHeight);
        }];
    }
}
- (IBAction)nextStepBtnClick:(id)sender {
    if(_imageArr.count<4){
        [SVProgressHUD showErrorWithStatus:@"请上传3-5张照片"];
        return;
    }
    
    if(_titleTextField.text.length==0){
        [SVProgressHUD showErrorWithStatus:@"请为您的作品撰写标题"];
        return;
    }
    if(_titleTextField.text.length>SAMPLE_TITLE_LENGTH){
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"作品标题不能超过%@个字",@(SAMPLE_TITLE_LENGTH)]];
        return;
    }
    if(_widthTextField.text.intValue==0){
        [SVProgressHUD showErrorWithStatus:@"请为您的作品填写宽度"];
        return;
    }
    
    if(_heightTextField.text.intValue==0){
        [SVProgressHUD showErrorWithStatus:@"请为您的作品填写高度"];
        return;
    }

    if(_textView.text.length==0){
        [SVProgressHUD showErrorWithStatus:@"请为您的作品写几句推荐语"];
        return;
    }
    if([DictionaryTool isValidateEmpty:_titleTextField.text]){
        [SVProgressHUD showErrorWithStatus:@"标题不能全为空格"];
        return;
    }
    if([DictionaryTool isValidateEmpty:_textView.text]){
        [SVProgressHUD showErrorWithStatus:@"推荐语不能全为空格"];
        return;
    }
    if(_promotionTextField.text.length!=0){
        if([DictionaryTool isValidateEmpty:_promotionTextField.text]){
            [SVProgressHUD showErrorWithStatus:@"促销信息不能全为空格"];
            return;
        }
    }
    
    _publishModel.SampleName=_titleTextField.text;
    _publishModel.SizeWidth=_widthTextField.text;
    _publishModel.SizeHighet=_heightTextField.text;
    _publishModel.Recommendation=_textView.text;
    _publishModel.SaleDesc=_promotionTextField.text;
    
    NSMutableArray *tempArr=[[NSMutableArray alloc]init];
    for(int i=0;i<_imageArr.count-1;i++){
        ImageModel *model=_imageArr[i];
        [tempArr addObject:model.ID];
    }
    _publishModel.SamplePicID=[tempArr componentsJoinedByString:@","];
    tempArr=[_imageArr mutableCopy];
    [tempArr removeLastObject];
    _publishModel.SamplePicArr=[tempArr copy];
    
    PublishSample2ViewController *psvc2=[[PublishSample2ViewController alloc]init];
    psvc2.publishModel=_publishModel;
    [self.navigationController pushViewController:psvc2 animated:YES];
}
- (IBAction)chooseImage:(id)sender {
    [self.view endEditing:YES];
    
    UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
    [sheet showInView:self.view];
}
- (IBAction)deleteImageBtnClick:(id)sender {
    [_imageArr removeObjectAtIndex:_selectedIndex];
    if(_imageArr.count!=1){
        ImageModel *model=_imageArr[_imageArr.count-2];
        if(_selectedIndex!=_imageArr.count-1){
            [_headImage sd_setImageWithURL:[NSURL URLWithString:model.Image] placeholderImage:mImageByName(PlaceHeaderSquareImage)];
        }else{
            _selectedIndex=_selectedIndex-1;
            [_headImage sd_setImageWithURL:[NSURL URLWithString:model.Image] placeholderImage:mImageByName(PlaceHeaderSquareImage)];
        }
    }else{
        _headBgView.hidden=NO;
        [_imageArr removeAllObjects];
    }
    [self createImageView];
}
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
            UIAlertView *al=[[UIAlertView alloc]initWithTitle:nil message:@"相机不可用" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [al show];
            return;
        }
    }else if(buttonIndex==2){
        return;
    }
    [self presentViewController:picker animated:YES completion:nil];
}
//TODO:创建图片显示
- (void)createImageView
{
    [_imageBgView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    CGFloat width=(kkDeviceWidth-60-20)/5;
    NSInteger count=_imageArr.count==6?5:_imageArr.count;
    for(int i=0;i<count;i++){
        UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(30+(width+5)*i,10, width, 60)];
        bgView.backgroundColor=THEMECOLOR_1;
        
        UIButton *imageBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        imageBtn.imageView.contentMode=UIViewContentModeScaleAspectFill;
        imageBtn.imageView.clipsToBounds=YES;
        
        id image=_imageArr[i];
        if([image isKindOfClass:[UIImage class]]){
            [imageBtn setImage:_imageArr[i] forState:UIControlStateNormal];
        }else{
            [imageBtn sd_setImageWithURL:[NSURL URLWithString:[image Image]] forState:UIControlStateNormal placeholderImage:mImageByName(PlaceHeaderSquareImage)];
        }
        
        [bgView addSubview:imageBtn];
        [_imageBgView addSubview:bgView];
//        imageBtn.backgroundColor=[UIColor redColor];
        [imageBtn addTarget:self action:@selector(imageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        imageBtn.tag=100+i;
        if(i==_selectedIndex){
            imageBtn.frame=CGRectMake(2,2, width-4, 60-4);
        }else{
            imageBtn.frame=CGRectMake(0,0, width, 60);
        }
    }
    CGRect frame;
    if(_imageArr.count==0){
        frame=_imageBgView.frame;
        frame.size.height=0;
        _imageBgView.frame=frame;
        
        frame=_boomBgView.frame;
        frame.origin.y=CGRectGetMaxY(_imageBgView.frame);
        _boomBgView.frame=frame;
    }else{
        frame=_imageBgView.frame;
        frame.size.height=95;
        _imageBgView.frame=frame;
        
        frame=_boomBgView.frame;
        frame.origin.y=CGRectGetMaxY(_imageBgView.frame)+10;
        _boomBgView.frame=frame;
    }
    _bgScrollView.contentSize=CGSizeMake(kkDeviceWidth,CGRectGetMaxY(_boomBgView.frame));
}
- (void)imageButtonClick:(UIButton *)button
{
    if(button.tag==100+_imageArr.count-1){
        [self chooseImage:nil];
        return;
    }
    _selectedIndex=button.tag-100;
    [self createImageView];
    [_headImage sd_setImageWithURL:[NSURL URLWithString:[_imageArr[_selectedIndex] Image]] placeholderImage:mImageByName(PlaceHeaderSquareImage)];
}

#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //获取image
    UIImage *image=[info objectForKey:UIImagePickerControllerOriginalImage];
    image=[self fixOrientation:image];
    
    //赋值
    //    NSData *data= UIImagePNGRepresentation(image);
//    NSData *data = UIImageJPEGRepresentation(image, 0.5);
    NSData *data=UIImagePNGRepresentation(image);
    if(data.bytes)
    
    [self uploadHeaderImageView:UIImageJPEGRepresentation(image, 0.5)];
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
//TODO:处理图片旋转问题
- (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
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
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
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
//TODO:上传图片
- (void)uploadHeaderImageView:(NSData *)data
{
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
            _headBgView.hidden=YES;
            
            if(_imageArr.count==0){
                [_imageArr addObject:[UIImage imageNamed:@"plus_pic_sample.png"]];
            }
//            [_imageArr insertObject:image atIndex:_imageArr.count-1];
            ImageModel *model=[[ImageModel alloc]init];
            [model setValuesForKeysWithDictionary:responseObject[@"data"]];
            [_imageArr insertObject:model atIndex:_imageArr.count-1];
            
            [_headImage sd_setImageWithURL:[NSURL URLWithString:model.Image] placeholderImage:mImageByName(PlaceHeaderSquareImage)];
            _selectedIndex=_imageArr.count-2;
            [self createImageView];
        }
    } FailBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"uploadFail:%@",error);
        [SVProgressHUD showErrorWithStatus:@"网络有问题哟，请检查网络是否连接~"];
    }];
}
#pragma mark - textField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
#pragma mark textView delegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView
{
    if(textView.text.length>0){
        self.placeHolderLabel.hidden=YES;
        
    }else{
        self.placeHolderLabel.hidden=NO;
        
    }
}
//TODO:处理光标上下跳动
- (void)textViewDidChangeSelection:(UITextView *)textView
{
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        CGRect r = [textView caretRectForPosition:textView.selectedTextRange.end];
        CGFloat caretY =  MAX(r.origin.y - textView.frame.size.height + r.size.height + 8, 0);
        if (textView.contentOffset.y < caretY && r.origin.y != INFINITY) {
            textView.contentOffset = CGPointMake(0, caretY);
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
