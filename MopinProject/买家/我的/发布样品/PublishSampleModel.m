//
//  PublishSampleModel.m
//  MopinProject
//
//  Created by rt008 on 15/11/27.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "PublishSampleModel.h"
#import "SampleAttributeModel.h"

@implementation PublishSampleModel

- (SampleAttributeModel *)WordTypeModel
{
    if(!_WordTypeModel){
        _WordTypeModel=[[SampleAttributeModel alloc]init];
    }
    return _WordTypeModel;
}
- (SampleAttributeModel *)ShowTypeModel
{
    if(!_ShowTypeModel){
        _ShowTypeModel=[[SampleAttributeModel alloc]init];
    }
    return _ShowTypeModel;
}
- (SampleAttributeModel *)MaterialCodeModel
{
    if(!_MaterialCodeModel){
        _MaterialCodeModel=[[SampleAttributeModel alloc]init];
    }
    return _MaterialCodeModel;
}
- (SampleAttributeModel *)DeliveryTimeCodeModel
{
    if(!_DeliveryTimeCodeModel){
        _DeliveryTimeCodeModel=[[SampleAttributeModel alloc]init];
    }
    return _DeliveryTimeCodeModel;
}
//- (void)setWordTypeModel:(SampleAttributeModel *)WordTypeModel
//{
//    if(!_WordTypeModel){
//        _WordTypeModel=[[SampleAttributeModel alloc]init];
//    }
//    _WordTypeModel=WordTypeModel;
//}
//- (void)setShowTypeModel:(SampleAttributeModel *)ShowTypeModel
//{
//    if(!_ShowTypeModel){
//        _ShowTypeModel=[[SampleAttributeModel alloc]init];
//    }
//    _ShowTypeModel=ShowTypeModel;
//}
//- (void)setMaterialCodeModel:(SampleAttributeModel *)MaterialCodeModel
//{
//    if(!_MaterialCodeModel){
//        _MaterialCodeModel=[[SampleAttributeModel alloc]init];
//    }
//    _MaterialCodeModel=MaterialCodeModel;
//}
//- (void)setDeliveryTimeCodeModel:(SampleAttributeModel *)DeliveryTimeCodeModel
//{
//    if(!_DeliveryTimeCodeModel){
//        _DeliveryTimeCodeModel=[[SampleAttributeModel alloc]init];
//    }
//    _DeliveryTimeCodeModel=DeliveryTimeCodeModel;
//}
//- (NSMutableArray *)PlaceCodeArr
//{
//    if(!_PlaceCodeArr){
//        _PlaceCodeArr=[NSMutableArray array];
//    }
//    return _PlaceCodeArr;
//}
//- (NSMutableArray *)UsedCodeArr
//{
//    if(!_UsedCodeArr){
//        _UsedCodeArr=[NSMutableArray array];
//    }
//    return _UsedCodeArr;
//}
@end
