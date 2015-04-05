//
//  WpProxy.h
//  WaypointTable
//
//  Created by ashastry on 4/2/15.
//  Copyright (c) 2015 Aneesh Shastry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WpProxy : NSObject

- (id) initWithTarget: (id) target action: (SEL) action;


- (BOOL) add: (double) lat lon: (double) lon  name: (NSString *) name address: (NSString *) address category:(NSString *) category;

- (BOOL) resetWaypoints;

- (BOOL) remove: (NSString *) name;

- (BOOL) modify: (NSString *) name;

- (BOOL) get: (NSString *) name;

- (BOOL) getNames;

- (BOOL) getCategoryNames;

- (BOOL) getNamesInCategory: (NSString *) category;

- (BOOL) distanceGCTo: (NSString *) name1 name2: (NSString *) name2;

- (BOOL) bearingGCInitTo: (NSString *) name1 name2: (NSString *) name2;

- (NSMutableData *) returnGetNames;




@end
