//
//  GHRepositoryResponse.m
//  Desafio-iOS
//
//  Created by Fabio Nogueira on 26/04/16.
//  Copyright © 2016 Fabio Nogueira. All rights reserved.
//

#import "GHRepositoryResponse.h"
#import "GHRepository.h"

@implementation GHRepositoryResponse

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.totalCount = [dictionary objectForKey:@"total_count"];
        self.incompleteStatus = [dictionary objectForKey:@"incomplete_status"];
        if ([dictionary objectForKey:@"items"]) {
            NSMutableArray *repositories = [NSMutableArray array];
            NSArray *items = [dictionary objectForKey:@"items"];
            for (NSDictionary *item in items) {
                GHRepository *repository = [[GHRepository alloc] initWithDictionary:item];
                [repositories addObject:repository];
            }
            self.items = [NSArray arrayWithArray:repositories];
        }
    }
    return self;
}

@end