
#import "Movie.h"

@implementation Movie

@synthesize imageURL;
@synthesize title;


#pragma mark - instance methods

- (NSString *) description
{
    return [NSString stringWithFormat:@"title: %@ posters: %@", self.title, [self.imageURL absoluteString]];
}

@end
