/**
 * Copyright 2015 Aneesh Shastry,
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
 * Purpose: An iOS application to manipulate Waypoints using UItable
 *
 * @author Aneesh Shastry ashastry@asu.edu
 *         MS Computer Science, CIDSE, IAFSE, Arizona State University
 * @version March 30, 2015
 */



#import "WaypointLibrary.h"

@implementation WaypointLibrary
- (void) addWaypoint:(Waypoint*) waypoint{
    if(self.wpDict==nil){
        self.wpDict =  [[NSMutableDictionary alloc] init] ;
    }
    [self.wpDict setObject:waypoint forKey:waypoint.name];
}
- (BOOL) removeWaypointNamed: (NSString*) wpName{
    Waypoint
    *wp=self.wpDict[wpName];
    if (wp == nil) {
        return false;
    }else{
        [self.wpDict removeObjectForKey: wpName];
        return true;
    }
    
}
- (Waypoint*) getWaypointNamed: (NSString*) wpName{
    return self.wpDict[wpName];
}
- (NSArray*) getNames{
    NSArray *keys=[self.wpDict allKeys];
    return keys;
}


@end

