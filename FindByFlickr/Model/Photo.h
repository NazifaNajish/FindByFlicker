//
//  Photo.h
//  FindByFlicker
//
//  Created by Nazifa Najish on 7/6/18.
//  Copyright © 2018 Nazifa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Photo : NSObject

@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSString *owner;
@property (strong, nonatomic) NSString *secret;
@property (strong, nonatomic) NSString *server;
@property (strong, nonatomic) NSString *farm;
@property (strong, nonatomic) NSString *title;
@property (assign, nonatomic) BOOL ispublic;
@property (assign, nonatomic) BOOL isfriend;
@property (assign, nonatomic) BOOL isfamily;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;

@end
