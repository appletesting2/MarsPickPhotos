//
//  MarsPhotoPicker.h
//  MarsPhoto
//
//  Created by twb on 15/9/3.
//  Copyright (c) 2025年 Twb. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, MarsPhotoPickerStatus) {
    MarsPhotoPickerNone,
    MarsPhotoPickerNoPhoto,
    MarsPhotoPickerNoCamera
};

@interface MarsPhotoPicker : NSObject

@property (nonatomic, assign) BOOL allowsEditing;

- (void)pickImageWithSourceType:(UIImagePickerControllerSourceType)sourceType
                     completion:(void (^)(UIImage *, MarsPhotoPickerStatus status))completion;

- (BOOL)isCameraAvailable;
- (BOOL)isPhotoLibraryAvailable;

@end

NS_ASSUME_NONNULL_END
