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
#import "WaypointTableViewController.h"
#import "Waypoint.h"
#import "ViewController.h"


@interface WaypointTableViewController ()
@property (strong, nonatomic) IBOutlet UITableView *wptTableView;

@property (strong, nonatomic) NSMutableDictionary * wpLib;

@end

@implementation WaypointTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.wptTableView.dataSource = self;

    
    
    Waypoint * ny = [[Waypoint alloc] initWithLat:40.7127 lon:-74.0059 name:@"New-York" address:@"Central Perk, Manhattan" category:@"Restaurant"];
    Waypoint * asup = [[Waypoint alloc] initWithLat:33.3056 lon:-111.6788 name:@"ASUPoly" address:@"Peralta Hall" category:@"Classroom"];
    Waypoint * asub = [[Waypoint alloc] initWithLat:33.4235 lon:-111.9389 name:@"ASUBrickyard" address:@"699 S Mill Avanue" category:@"Classroom"];
    Waypoint * paris = [[Waypoint alloc] initWithLat:48.8567 lon:2.3508 name:@"Paris" address:@"The Lourve, Paris" category:@"Muesuem"];
    Waypoint * moscow = [[Waypoint alloc] initWithLat:55.75 lon:37.6167 name:@"Moscow" address:@"The Red Square" category:@"Mueseum"];
    
    self.wpLib = [[NSMutableDictionary alloc] init];
    
    [self.wpLib setObject:ny forKey:@"New-York"];
    [self.wpLib setObject:asup forKey:@"ASUPoly"];
    [self.wpLib setObject:asub forKey:@"ASUBrickyard"];
    [self.wpLib setObject:paris forKey:@"Paris"];
    [self.wpLib setObject:moscow forKey:@"Moscow"];
    

    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

-(void) viewWillAppear:(BOOL)animated{
    [self.wptTableView reloadData];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [[self.wpLib allKeys] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    NSArray *keys = [self.wpLib allKeys];
    NSString * ret = @"unknown";
    
    if(indexPath.row < keys.count){
        ret = keys[indexPath.row];
    }
    
    cell.textLabel.text = ret;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    
    // Configure the cell...
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"waypointDetails"]){
        NSIndexPath * indexPath = [self.tableView indexPathForSelectedRow];
        NSArray * keys = [self.wpLib allKeys];
        NSString * ret  =@"Unknown";
        if(indexPath.row < keys.count){
            ret = keys[indexPath.row];
        }
        
        ViewController * destViewController = segue.destinationViewController;
        destViewController.waypointName = ret;
        destViewController.wpLib = self.wpLib;
    }
    
    else if([segue.identifier isEqualToString:@"addWaypoint"]){
        ViewController * destViewController = segue.destinationViewController;
        //destViewController.waypointName = ret;
        destViewController.wpLib = self.wpLib;
    }
    
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
