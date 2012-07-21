
#import <Foundation/Foundation.h>
#import "Request.h"

@class MovieRequest;
@class TweetRequest;

@interface TweetPicManager : NSObject <RequestDelegate>

@property (nonatomic, strong) MovieRequest *movieRequest;
@property (nonatomic, strong) TweetRequest *tweetRequest;

@end

extern NSString * const TweetPicsCreatedNotification;
extern NSString * const TweetPicsKey;
