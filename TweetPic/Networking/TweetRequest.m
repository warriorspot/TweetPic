
#import "TweetRequest.h"

@implementation TweetRequest

@synthesize active;
@synthesize request;

- (void) start
{
    [self startWithSearchTerm:nil];
}

- (void) startWithSearchTerm:(NSString *)searchTerm
{
    if(searchTerm == nil || [searchTerm length] == 0)
    {
        return;
    }
    
    active = YES;
    
    NSString *term = [searchTerm stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *urlString = [NSString stringWithFormat:TwitterURL, term];
    NSURL *url = [NSURL URLWithString: urlString];
    
    request = [[TWRequest alloc] initWithURL: url
                                  parameters: nil 
                               requestMethod: TWRequestMethodGET];
    
    [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error)
    {
        active = NO;
        
        if ([urlResponse statusCode] == 200) 
        {
            NSError *error;        
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData 
                                                                 options:0 
                                                                   error:&error];
            NSLog(@"Twitter response: %@", json); 
            
            if(self.delegate && [self.delegate respondsToSelector:@selector(request:didSucceed:)])
            {
                [self.delegate request:self didSucceed:json];                    
            }
        }
        else
        {
            NSLog(@"Twitter error, HTTP response: %i", [urlResponse statusCode]);
            
            if(self.delegate && [self.delegate respondsToSelector:@selector(request:didFailWithError:)])
            {
                [self.delegate request:self didFailWithError:error];                    
            }
        }
    }];
}

@end

NSString * const TwitterURL = @"http://search.twitter.com/search.json?q=%@&rpp=100&result_type=recent";

