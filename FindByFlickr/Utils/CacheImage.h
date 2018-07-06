//
//  CacheImage.h
//  FindByFlicker
//
//  Created by Nazifa Najish on 7/6/18.
//  Copyright © 2018 Nazifa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CacheImage : NSObject
+ (void)loadImage:(NSString*)url complete:(void (^)(UIImage* image))complete;
@end
