
#import "TweetRequest.h"

@implementation TweetRequest

@synthesize active;
@synthesize request;

- (void) startWithSearchTerm:(NSString *)searchTerm
{
    if(searchTerm == nil || [searchTerm length] == 0)
    {
        return;
    }
    
    active = YES;
    
    NSMutableString *baseURL = [NSMutableString stringWithString:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"TwitterBaseURL"]];
    NSString *path = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"TwitterPath"];
    NSString *term = [searchTerm stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *searchString = [NSString stringWithFormat: path, term];
    [baseURL appendString: searchString];
    
    NSURL *url = [NSURL URLWithString: baseURL];
    
    request = [[TWRequest alloc] initWithURL: url
                                  parameters: nil 
                               requestMethod: TWRequestMethodGET];
    
    [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error)
    {
        active = NO;
        
        if ([urlResponse statusCode] == 200) 
        {
            NSError *jsonError;        
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData 
                                                                 options:0 
                                                                   error:&jsonError];
            NSLog(@"Twitter response: %@", json); 
            
            if(error)
            {
                [self performSelectorOnMainThread:@selector(postFailure:) withObject:error waitUntilDone:NO];
            }
            else if(jsonError)
            {
                NSString *dataString = [NSString stringWithCString:[responseData bytes] encoding:NSUTF8StringEncoding];
                NSLog(@"data: %@", dataString);
                
                [self performSelectorOnMainThread:@selector(postFailure:) withObject:jsonError waitUntilDone:NO];
            }
            else
            {
                [self performSelectorOnMainThread:@selector(postSuccess:) withObject:json waitUntilDone:NO];
            }
        }
        else
        {
            NSLog(@"Twitter error, HTTP response: %i", [urlResponse statusCode]);
            
            [self performSelectorOnMainThread:@selector(postFailure:) withObject:error waitUntilDone:NO];
        }
    }];
}

#pragma mark - private methods

- (void) postFailure: (NSError *) error
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(request:didFailWithError:)])
    {
        [self.delegate request:self didFailWithError:error];                    
    }
}

- (void) postSuccess: (NSDictionary *) json
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(request:didSucceed:)])
    {
        [self.delegate request:self didSucceed:json];                    
    }
}

@end


