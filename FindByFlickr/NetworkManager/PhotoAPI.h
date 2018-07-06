//
//  PhotoAPI.h
//  FindByFlicker
//
//  Created by Nazifa Najish on 7/6/18.
//  Copyright © 2018 Nazifa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Photo.h"

@interface PhotoAPI : NSObject

- (NSURLSessionDataTask*) photosByQuery:(void (^)(NSArray *photos))getPhotos failure:(void (^)(NSError *error))failure textQuery:(NSString*)query page:(int)page;
@end
