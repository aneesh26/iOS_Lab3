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
 * Purpose: An iOS application to manipulate Waypoints using UItable and JSON RPC
 *
 * @author Aneesh Shastry ashastry@asu.edu
 *         MS Computer Science, CIDSE, IAFSE, Arizona State University
 * @version April 5, 2015
 */

#import "ViewController.h"
#import "Waypoint.h"
#import "WpProxy.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *latTV;
@property (weak, nonatomic) IBOutlet UITextField *lonTV;
@property (weak, nonatomic) IBOutlet UITextField *nameTV;
@property (weak, nonatomic) IBOutlet UITextField *distTV;
@property (weak, nonatomic) IBOutlet UITextField *toTV;
@property (weak, nonatomic) IBOutlet UITextField *catTV;
@property (weak, nonatomic) IBOutlet UITextField *addrTV;

@property (strong, nonatomic) UIPickerView * namePicker;
@property (strong, nonatomic) UIPickerView * toPicker;

@property (strong, nonatomic) WpProxy * getProxy;
@property (strong, nonatomic) NSMutableData * receivedData;

@property (nonatomic, assign) BOOL * removeFlag;
@property (nonatomic, assign) BOOL * modifyFlag;
@property (nonatomic, assign) BOOL * modifyFlag2;
@property (nonatomic, assign) BOOL * distanceFlag;
@property (nonatomic, assign) BOOL * bearingFlag;

@property (strong, nonatomic) Waypoint * modifyTemp;
@property (nonatomic, assign) double  tempDist;





@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"View Waypoint";

    
    
   // UIBarButtonItem *btnDel = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash initWithTitle:@"Delete" style:UIBarButtonItemStylePlain target:self action:@selector(delClicked:)] ];
    UIBarButtonItem *btnDel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(delClicked:)];
    UIBarButtonItem *btnSave = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveClicked:)];
    
    
    self.navigationItem.rightBarButtonItems = @[btnSave,btnDel];
    
    
    self.getProxy = [[WpProxy alloc] initWithTarget:self action: @selector(callResult:)];
    
    [self.getProxy get:self.waypointName];
    
    
 /*   Waypoint * wpObject = [self.wpLib objectForKey:self.waypointName];
    [self.latTV setText:[NSString stringWithFormat:@"%4f",[wpObject lat]]];
    [self.lonTV setText:[NSString stringWithFormat:@"%4f",[wpObject lon]]];
    [self.nameTV setText:[wpObject name]];
    [self.addrTV setText:[wpObject address]];
    [self.catTV setText:[wpObject category]];
    
   */
    
    self.latTV.keyboardType = UIKeyboardTypeDecimalPad;
    self.lonTV.keyboardType = UIKeyboardTypeDecimalPad;
    self.nameTV.keyboardType = UIKeyboardTypeAlphabet;
    self.addrTV.keyboardType = UIKeyboardTypeAlphabet;
    self.catTV.keyboardType = UIKeyboardTypeAlphabet;
    
    
    
    
    self.namePicker = [[UIPickerView alloc] init];
    self.namePicker.delegate = self;
    self.namePicker.dataSource = self;
    
    self.toPicker = [[UIPickerView alloc] init];
    self.toPicker.delegate = self;
    self.toPicker.dataSource = self;
    
    
    self.toTV.inputView = self.toPicker;
   // self.nameTV.inputView = self.namePicker;
   // self.latTV setText:self.
   // self.latTV setText:self.wpLib.
    
    // Do any additional setup after loading the view, typically from a nib.
}



- (void) callResult:(NSNumber*) result {
    double res = [result doubleValue];
  //  NSLog(@"Completed getting data from the server for getNames");
    
   // NSLog([NSString stringWithFormat:@"%f",res ]);
    
    if(self.removeFlag == YES){ //  this block removes the waypoint on the click of delete button
        if( [self.wpList containsObject:self.waypointName]){
            
            [self.wpList removeObject:self.waypointName];
        }
        
        
        [self.namePicker reloadAllComponents];
        [self.toPicker reloadAllComponents];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Waypoint Removed" message:[[@"Waypoint '" stringByAppendingString:self.waypointName] stringByAppendingString:@"' removed."] delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
        // optional - add more buttons:
        [alert addButtonWithTitle:@"OK"];
        [alert show];
        self.removeFlag = NO;
        
        
    }else if(self.modifyFlag == YES){
        if(self.modifyFlag2 == YES){// this block adds the new waypoint during the modification process
             [self.wpList addObject:self.nameTV.text];
         //   self.wpList = [self.wpList sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
            self.modifyFlag2 = NO;
            self.modifyFlag = NO;
            [self.navigationController popViewControllerAnimated:YES];
        }else{ //  this block removes he current waypoint during the modification process
            
        
        [self.wpList removeObject:self.waypointName];
        
        // add the new waypoint
        
       
        
        WpProxy * wpP = [[WpProxy alloc] initWithTarget:self action: @selector(callResult:)];
        
            self.modifyFlag2 = YES;
        //calling add method in wpProxy, which instead creates a JSON object
        [wpP add:self.modifyTemp.lat lon:self.modifyTemp.lon name:self.modifyTemp.name address:self.modifyTemp.address category:self.modifyTemp.category];
        
        }
        
        
    } else if(self.distanceFlag == YES){  //this block calculates the distance between the two waypoints
     //   double tempDistance;
        
        
        if(self.bearingFlag == YES){
            
            self.receivedData = [self.getProxy returnGetNames];
            NSError* error;
            NSDictionary* json = [NSJSONSerialization
                                  JSONObjectWithData:self.receivedData
                                  options:NSJSONReadingMutableContainers
                                  error:&error];
            
            [self.distTV setText: [NSString stringWithFormat:@"%.2f bearing %.2f",self.tempDist,[[json objectForKey:@"result"]  doubleValue]]];
            self.bearingFlag = NO;
            self.distanceFlag = NO;
            
        }else{
        self.receivedData = [self.getProxy returnGetNames];
        
        NSError* error;
        NSDictionary* json = [NSJSONSerialization
                              JSONObjectWithData:self.receivedData
                              options:NSJSONReadingMutableContainers
                              error:&error];
        self.tempDist = [[json objectForKey:@"result"]  doubleValue];
        
        [self.distTV setText: [NSString stringWithFormat:@"%.2f",[[json objectForKey:@"result"]  doubleValue] ]];
        self.bearingFlag = YES;
        self.getProxy = [[WpProxy alloc] initWithTarget:self action: @selector(callResult:)];
        
        [self.getProxy bearingGCInitTo:self.waypointName name2:self.toTV.text];
        
        }
        
    }
    else{ // this block loads the data when the Viewcontroller is called
    
    self.receivedData = [self.getProxy returnGetNames];
        
    
   // NSLog(@"Getnames result: %@", [[NSString alloc] initWithData:self.receivedData encoding:NSUTF8StringEncoding]);
    
    
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:self.receivedData
                          options:NSJSONReadingMutableContainers
                          error:&error];
    [self.nameTV setText:self.waypointName];
    
    //NSLog(@"Lat: %@",[[json objectForKey:@"result"] objectForKey:@"lat"]);
    [self.latTV setText: [NSString stringWithFormat:@"%.4f",[[[json objectForKey:@"result"] objectForKey:@"lat"] doubleValue] ]];
    [self.lonTV setText: [NSString stringWithFormat:@"%.4f",[[[json objectForKey:@"result"] objectForKey:@"lon"] doubleValue] ]];
    [self.catTV setText: [NSString stringWithFormat:@"%@",[[json objectForKey:@"result"] objectForKey:@"category"] ]];
     [self.addrTV setText: [NSString stringWithFormat:@"%@",[[json objectForKey:@"result"] objectForKey:@"address"] ]];
    
    
    //self.
    
   // NSLog(@"JSON data: %@", json);
    }
    
  /*
    if(self.wpList containsObject:self.waypointName){
        [self.wpList removeObject:self.waypointName];
    }
    
*/
    
    //  self.resultTF.text=[NSString stringWithFormat:@"%6.2f", res];
    //NSLog(@"call returned: %@",result);
}


- (void)delClicked:(id) sender{
   // NSLog(@"Delete Clicked");
    
    UIAlertView *deleteAlert = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                          message:[[@"Remove '" stringByAppendingString: self.nameTV.text] stringByAppendingString:@"' ?"]
                                                         delegate:self
                                                cancelButtonTitle:@"NO"
                                                otherButtonTitles:@"YES", nil];
    [deleteAlert show];
}

-(void)saveClicked:(id)sender{
  //  NSLog(@"Save Clicked");
    double newLat = [self.latTV.text doubleValue];
    double newLon = [self.lonTV.text doubleValue];
    NSString * newName = self.nameTV.text;
    NSString * newAddr = self.addrTV.text;
    NSString * newCat = self.catTV.text;
    
    if( newLat == 0 || newLon == 0 || [newName isEqualToString:@""] || [newAddr isEqualToString:@""] || [newCat isEqualToString:@""]){
        
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:[NSString stringWithFormat:@"Incomplete / Incorrect Input"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        alert.alertViewStyle = UIAlertViewStyleDefault;
        [alert show];
        
        
    }else{
    
    
  /*
    Waypoint * newWP = [[Waypoint alloc] initWithLat:newLat lon:newLon name:newName address:newAddr category:newCat];
    
     [self.wpLib removeObjectForKey:self.waypointName];
        
       
    [self.wpLib setObject:newWP forKey:newWP.name];
    */
        
         Waypoint * newWP = [[Waypoint alloc] initWithLat:newLat lon:newLon name:newName address:newAddr category:newCat];
        
        self.modifyTemp = newWP;
        
        self.modifyFlag = YES;
        
    //First remove the current waypoint
        self.getProxy = [[WpProxy alloc] initWithTarget:self action: @selector(callResult:)];
        
        [self.getProxy remove:self.waypointName];
        
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //  NSLog(@"Add button Clicked");
    
    
    NSString *title = [alertView title];
    
    
    if([title isEqual:@"Warning"]){
        
            NSString *buttonText = [alertView buttonTitleAtIndex:buttonIndex];
        
        if([buttonText isEqualToString:@"NO"])
        {
            
        }
        else if([buttonText isEqualToString:@"YES"])
        {
            self.removeFlag = YES;
            NSString * temp = self.nameTV.text;
            
            self.getProxy = [[WpProxy alloc] initWithTarget:self action: @selector(callResult:)];
            
            [self.getProxy remove:self.waypointName];
            
            
            
            
            
           //  [self.wpLib removeObjectForKey:self.nameTV.text];
            
          /*  [self.namePicker reloadAllComponents];
            [self.toPicker reloadAllComponents];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Waypoint Removed" message:[[@"Waypoint '" stringByAppendingString:temp] stringByAppendingString:@"' removed."] delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
            // optional - add more buttons:
            [alert addButtonWithTitle:@"OK"];
            [alert show];
           */
            
        }
        
    }else if([title isEqual:@"Waypoint Removed"]){
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
    
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    NSArray * keys = self.wpList;
    if(row < keys.count){
        
        
        if(pickerView == self.toPicker){
            [self.toTV resignFirstResponder];
            // add code to handle the to picker - to populate the TO text field
            // to get the distance
        //    NSArray * keys = [self.wpLib allKeys];
        //    NSArray * keys = self.wpList;
            [self.toTV setText:keys[row]];
            
         
            self.getProxy = [[WpProxy alloc] initWithTarget:self action: @selector(callResult:)];
            self.distanceFlag = YES;
            [self.getProxy distanceGCTo:self.waypointName name2:self.toTV.text];
            
            
            
            //get name wp and to wp.. call the functions inside name wp with the to wp lat and lon
         /*   if(![self.nameTV.text isEqual:@""])
            {
                [self calculateDistance ];
            }
            
           */
            
        }else{
            [self.nameTV resignFirstResponder];
            //add code to handle the name text picker, i.e., to populate the fields lat, lon, name
            NSArray * keys = [self.wpLib allKeys];
            NSString * selectedKey = keys[row];
            
            [self.nameTV setText:keys[row]];
            Waypoint * wpObject = [self.wpLib objectForKey:selectedKey];
            [self.latTV setText:[NSString stringWithFormat:@"%4f",[wpObject lat]]];
            [self.lonTV setText:[NSString stringWithFormat:@"%4f",[wpObject lon]]];
            [self.nameTV setText:[wpObject name]];
            [self.addrTV setText:[wpObject address]];
            [self.catTV setText:[wpObject category]];
            
            if(![self.toTV.text isEqual:@""])
            {
                [self calculateDistance ];
            }
            
            
        }
    }
    
}



- (void) calculateDistance;{
    Waypoint * nameWP = [self.wpLib objectForKey:self.nameTV.text];
    Waypoint * toWP = [self.wpLib objectForKey:self.toTV.text];
    //NSLog(@"Lattitude: %f",toWP.lat);
    // NSLog(@"Longitude: %f",toWP.lon);
    double dist = [nameWP distanceGCTo: toWP.lat lon: toWP.lon scale: Statute];
    // NSLog(@"Distance: %f",dist);
    double dir = [nameWP bearingGCInitTo: toWP.lat lon: toWP.lon];
    
    NSString * resultSTring = [NSString stringWithFormat: @"%.2f mi bearing %.2f",dist,dir];
    
    [self.distTV setText:resultSTring];
    
    
    
    
}

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    //NSArray * keys = [self.wpLib allKeys];
    NSArray * keys = self.wpList;
    
    
    NSString * returnString = @"Unknown Key";
    if(row < keys.count){
        returnString = keys[row];
    }
    //NSLog(@"%@",returnString);
    return returnString;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    //return [self.wpLib allKeys].count;
    return [self.wpList count];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
    
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.latTV resignFirstResponder];
    [self.lonTV resignFirstResponder];
    [self.nameTV resignFirstResponder];
    [self.toTV resignFirstResponder];
    [self.distTV resignFirstResponder];
    [self.addrTV resignFirstResponder];
    [self.catTV resignFirstResponder];
};







@end
