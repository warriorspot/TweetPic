
#import <Foundation/Foundation.h>
#import "Request.h"

@class MovieRequest;
@class TweetRequest;

@interface TweetPicManager : NSObject <RequestDelegate>

@property (nonatomic, strong) MovieRequest *movieRequest;
@property (nonatomic, strong) TweetRequest *tweetRequest;

@end

extern NSString * const TweetPicCreatedNotification;
extern NSString * const TweetPicKey;
