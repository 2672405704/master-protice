//
//  AddressCell.h
//  MopinProject
//
//  Created by rt008 on 15/11/26.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddressModel;

@protocol AddressCellDelegate <NSObject>

- (void)setdefaultAddress:(AddressModel *)model;
- (void)editAddress:(AddressModel *)model;
- (void)deleteAddress:(AddressModel *)model;
@end
@interface AddressCell : UITableViewCell
@property (nonatomic,strong) AddressModel *addressModel;
@property (nonatomic,weak) id<AddressCellDelegate>delegate;
- (void)reloadCell;
@end
