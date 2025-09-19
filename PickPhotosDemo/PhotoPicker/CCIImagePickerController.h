//
//  CTImagePickerController.h
//  MarsClass
//
//  Created by twb on 15/7/3.
//  Copyright (c) 2015年 Hujiang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, CCIImagePickerStatus) {
    CCIImagePickerStatusNone,
    CCIImagePickerStatusNotPhoto,
    CCIImagePickerStatusNotCamera
    
};

@interface CCIImagePickerController : NSObject

@property (nonatomic, assign) BOOL allowsEditing;

- (void)pickImageWithSourceType:(UIImagePickerControllerSourceType)sourceType
                     completion:(void (^)(UIImage *, CCIImagePickerStatus status))completion;

- (BOOL)isCameraAvailable;
- (BOOL)isPhotoLibraryAvailable;

@end

NS_ASSUME_NONNULL_END
