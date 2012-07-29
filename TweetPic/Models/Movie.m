
#import "Movie.h"

@implementation Movie

@synthesize imageURL;
@synthesize title;


#pragma mark - instance methods

- (NSString *) description
{
    return [NSString stringWithFormat:@"title: %@ poster: %@", self.title, [self.imageURL absoluteString]];
}

@end
