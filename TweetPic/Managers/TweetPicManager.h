
#import <Foundation/Foundation.h>
#import "Request.h"

@class MovieRequest;
@class TweetRequest;

@interface TweetPicManager : NSObject <RequestDelegate, UIAlertViewDelegate>

@end

extern NSString * const TweetPicCreatedNotification;
extern NSString * const TweetPicKey;
extern NSString * const TweetPicsCreatedNotification;
extern NSString * const TweetPicsKey;
