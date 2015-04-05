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
 * Purpose: A sample Objective-C iOS app to demonstrate asynchronous NSURLConnections
 *
 * @author Tim Lindquist Tim.Lindquist@asu.edu
 *         Software Engineering, CIDSE, IAFSE, Arizona State University Polytechnic
 * @version March 29, 2015
 */

#import <Foundation/Foundation.h>

@interface CalcProxy : NSObject

- (id) initWithTarget: (id) target action: (SEL) action;

- (BOOL) add: (double) left to: (double) right;

- (BOOL) subtract: (double) left by: (double) right;

- (BOOL) multiply: (double) left times: (double) right;

- (BOOL) divide: (double) left by: (double) right;


@end
