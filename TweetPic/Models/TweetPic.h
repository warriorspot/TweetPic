
#import <Foundation/Foundation.h>

@interface TweetPic : NSObject

@property (nonatomic, strong) NSString *tweet;
@property (nonatomic, strong) UIImage *image;

- (id) initWithTweet: (NSString *) tweet image: (UIImage *) image;


@end
