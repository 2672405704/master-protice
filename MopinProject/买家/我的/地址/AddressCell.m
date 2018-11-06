//
//  AddressCell.m
//  MopinProject
//
//  Created by rt008 on 15/11/26.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "AddressCell.h"
#import "AddressModel.h"
#import "AddressDataCenter.h"

@interface AddressCell()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectedBtn;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@end

@implementation AddressCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)reloadCell
{
    AddressDataCenter *adc=[AddressDataCenter sharedInstance];
    
    if(_addressModel.IsDefault.intValue==0){
        _nameLabel.textColor=[UIColor blackColor];
        _phoneLabel.textColor=[UIColor blackColor];
        _addressLabel.textColor=[UIColor grayColor];
        self.backgroundColor=[UIColor whiteColor];
        
        _editBtn.selected=NO;
        _deleteBtn.selected=NO;
        _selectedBtn.selected=NO;
    }else{
        _nameLabel.textColor=[UIColor whiteColor];
        _phoneLabel.textColor=[UIColor whiteColor];
        _addressLabel.textColor=[UIColor whiteColor];
        self.backgroundColor=toPCcolor(@"444444");
        
        _editBtn.selected=YES;
        _deleteBtn.selected=YES;
        _selectedBtn.selected=YES;
    }
    _nameLabel.text=_addressModel.Name;
    _phoneLabel.text=_addressModel.Mobile;
    _addressLabel.text=[NSString stringWithFormat:@"%@%@",[adc getProvinceNameWith:_addressModel.ProvinceID andCityName:_addressModel.CityID andDistrictName:_addressModel.DistrictID],_addressModel.Address];
    
    CGFloat width;
    CGFloat height;
    if(IOS7_AND_LATER){
        width=[_nameLabel.text boundingRectWithSize:CGSizeMake(kkDeviceWidth-190,21) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:_nameLabel.font} context:nil].size.width;
        height=[_addressLabel.text boundingRectWithSize:CGSizeMake(kkDeviceWidth-50,MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:_addressLabel.font} context:nil].size.height;
    }else{
        width=[_nameLabel.text sizeWithFont:_nameLabel.font constrainedToSize:CGSizeMake(kkDeviceWidth-190,21) lineBreakMode:NSLineBreakByCharWrapping].width;
        height=[_addressLabel.text sizeWithFont:_addressLabel.font constrainedToSize:CGSizeMake(kkDeviceWidth-50,MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping].height;
    }
    CGRect frame=_phoneLabel.frame;
    frame.origin.x=CGRectGetMinX(_nameLabel.frame)+width+30;
    _phoneLabel.frame=frame;
    
    frame=_bgView.frame;
    frame.origin.y=GETVIEWORANGEY(_addressLabel)+height;
    _bgView.frame=frame;
}
- (IBAction)deleteBtnClick:(id)sender {
    if(_delegate && [_delegate respondsToSelector:@selector(deleteAddress:)]){
        [_delegate deleteAddress:_addressModel];
    }
}
- (IBAction)editBtnClick:(id)sender {
    if(_delegate && [_delegate respondsToSelector:@selector(editAddress:)]){
        [_delegate editAddress:_addressModel];
    }
}
- (IBAction)defeaultBtnClick:(id)sender {
    if(_delegate && [_delegate respondsToSelector:@selector(setdefaultAddress:)]){
        [_delegate setdefaultAddress:_addressModel];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
