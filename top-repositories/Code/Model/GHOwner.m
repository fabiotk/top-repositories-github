//
//  GHOwner.m
//  Desafio-iOS
//
//  Created by Fabio Nogueira on 25/04/16.
//  Copyright © 2016 Fabio Nogueira. All rights reserved.
//

#import "GHOwner.h"

@implementation GHOwner

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.login = (NSString *)[dictionary objectForKey:GHOwnerLogin];
        self.avatarURL = [dictionary objectForKey:GHOwnerAvatarURL];
    }
    
    return self;
}

@end