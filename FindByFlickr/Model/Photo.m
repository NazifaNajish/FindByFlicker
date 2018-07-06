//
//  Photo.m
//  FindByFlicker
//
//  Created by Nazifa Najish on 7/6/18.
//  Copyright © 2018 Nazifa. All rights reserved.
//

#import "Photo.h"

@implementation Photo
- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    self.id = [attributes valueForKey:@"id"];
    
    self.owner = [attributes valueForKey:@"owner"];
    
    self.secret = [attributes valueForKey:@"secret"];
    
    self.server = [attributes valueForKey:@"server"];
    
    self.farm = [attributes valueForKey:@"farm"];
    
    self.title = [NSString stringWithFormat:@"%@",[attributes valueForKey:@"title"]];
    
    self.ispublic = [[attributes valueForKey:@"ispublic"] boolValue];
    
    self.isfriend = [[attributes valueForKey:@"isfriend"] boolValue];
    
    self.isfamily = [[attributes valueForKey:@"isfamily"] boolValue];
    
    return self;
    
}
@end
