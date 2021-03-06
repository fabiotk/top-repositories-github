//
//  GHDataSource.m
//  Desafio-iOS
//
//  Created by Fabio Nogueira on 25/04/16.
//  Copyright © 2016 Fabio Nogueira. All rights reserved.
//

#import "GHDataSource.h"
#import "GHRepositoryResponse.h"
#import "GHPullRequest.h"

#import <AFNetworking/AFNetworking.h>

@interface GHDataSource ()

@property (strong, nonatomic) AFHTTPSessionManager *manager;

@end

@implementation GHDataSource

#pragma mark - Getter

- (AFHTTPSessionManager *)manager {
    if (!_manager) {
        _manager = [[AFHTTPSessionManager manager] initWithBaseURL:[NSURL URLWithString:@"https://api.github.com/"]];
        _manager.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    
    return _manager;
}

#pragma mark - Public

- (void)fetchRepositoryForLanguage:(NSString *)language
                              page:(NSInteger)page
                           success:(GHPagedRequestSuccess)successBlock {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSString *url =
    [NSString stringWithFormat:@"https://api.github.com/search/repositories?q=language:%@&sort=stars&page=%ld", language, (long)page];
    
    [self.manager GET:url
           parameters:nil
             progress:nil
    success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        GHRepositoryResponse *repositories =
        [[GHRepositoryResponse alloc] initWithDictionary:responseObject];
        NSString *totalCount = [responseObject objectForKey:@"total_count"];

        if (successBlock) {
            return successBlock(repositories.items, totalCount.integerValue);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        NSLog(@"error: %@", error.description);
    }];
}

- (void)fetchPullRequestForRepository:(NSString *)repository
                                owner:(NSString *)owner
                              success:(GHPullRequestRequestSuccess)successBlock {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSString *url =
    [NSString stringWithFormat:@"https://api.github.com/repos/%@/%@/pulls", owner, repository];
    
    [self.manager GET:url
           parameters:nil
             progress:nil
    success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

        NSMutableArray *pullRequests = [NSMutableArray array];
        for (id object in responseObject) {
            GHPullRequest *pull = [[GHPullRequest alloc] initWithDictionary:object];
            [pullRequests addObject:pull];
        }
     
        if (successBlock) {
            return successBlock(pullRequests);
        }
      
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        NSLog(@"error: %@", error.description);
    }];
}

@end
