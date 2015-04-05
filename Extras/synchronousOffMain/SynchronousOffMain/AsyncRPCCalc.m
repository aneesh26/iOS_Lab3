/**
 * Copyright 2015 Tim Lindquist,
 * <p/>
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * <p/>
 * http://www.apache.org/licenses/LICENSE-2.0
 * <p/>
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * <p/>
 * Purpose: A sample Objective-C iOS app to demonstrate NSTimer and queue creation and dispatch_async
 *
 * @author Tim Lindquist Tim.Lindquist@asu.edu
 *         Software Engineering, CIDSE, IAFSE, Arizona State University Polytechnic
 * @version March 29, 2015
 */

#import "AsyncRPCCalc.h"

@interface AsyncRPCCalc()

@property (weak, nonatomic) UITextField * resultTF;
@property (strong, nonatomic) NSString * urlString;
@property (strong, nonatomic) NSArray * parms;
@property (strong, nonatomic) NSString * method;

@end

@implementation AsyncRPCCalc

- (id) initWithMethod: (NSString*) method parms: (NSArray*) parms resultTF: (UITextField*) resultTF {
    if( self = [super init] ){
        self.parms = parms;
        self.method = method;
        self.resultTF = resultTF;
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Server_URL" ofType:@"plist"];
        NSDictionary * serverDictionary = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
        self.urlString = [serverDictionary objectForKey:@"server_url"];
        //NSLog(@"server url in plist is: %@",[serverDictionary objectForKey:@"server_url"]);
    }
    return self;
}

- (void) execute {
    NSError *error;
    NSDictionary * rpcDict = @{@"jsonrpc":@"2.0",  @"method":self.method, @"params":self.parms, @"id":@1};
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:rpcDict options:0 error:&error];
    dispatch_queue_t queue = dispatch_queue_create("edu.asu.se.lindquis.CalcRPCRunLoopDispatchQ", NULL);
    dispatch_async(queue,^{
        NSData * result = [self doInBackground:jsonData];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self postExecute: result]; });
    });
}

- (NSData *) doInBackground: (NSData *) jsonRPCRequest {
    NSData * resultData = nil;
    NSURL *url = [NSURL URLWithString:self.urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    if(request){
        request.URL = url;
        request.HTTPMethod = @"POST";
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        request.HTTPBody= jsonRPCRequest;
        NSURLResponse * response;
        NSError *error;
        resultData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    }
    return resultData;
}

- (void) postExecute: (NSData*) result {
    double ret = 0;
    NSError * error;
    if(result){
        NSDictionary * myDictionary = [NSJSONSerialization
                                       JSONObjectWithData:result
                                       options:NSJSONReadingMutableContainers
                                       error:&error];
        ret = [[myDictionary objectForKey:@"result"] doubleValue];

    }
    self.resultTF.text = [NSString stringWithFormat:@"%6.2f", ret];
}

@end
