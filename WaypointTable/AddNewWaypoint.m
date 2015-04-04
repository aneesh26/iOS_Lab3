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



#import "AddNewWaypoint.h"
#import "Waypoint.h"
#import "WpProxy.h"

@interface AddNewWaypoint ()
@property (weak, nonatomic) IBOutlet UITextField *addLat;
@property (weak, nonatomic) IBOutlet UITextField *addLon;
@property (weak, nonatomic) IBOutlet UITextField *addName;
@property (weak, nonatomic) IBOutlet UITextField *addCat;
@property (weak, nonatomic) IBOutlet UITextField *addAddr;



@end

@implementation AddNewWaypoint

- (void) viewDidLoad{
    
    [super viewDidLoad];
    UIBarButtonItem *btnSave = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveClicked:)];
    self.navigationItem.rightBarButtonItem = btnSave;
    
    
    UIBarButtonItem *btnCancel = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelClicked:)];
    self.navigationItem.leftBarButtonItem = btnCancel;
    
    
    
    self.title = @"Add Waypoint";
    
    self.addLat.keyboardType = UIKeyboardTypeDecimalPad;
    self.addLon.keyboardType = UIKeyboardTypeDecimalPad;
    self.addName.keyboardType = UIKeyboardTypeAlphabet;
    self.addCat.keyboardType = UIKeyboardTypeAlphabet;
    self.addAddr.keyboardType = UIKeyboardTypeAlphabet;
    
    
    self.addLat.delegate = self;
    self.addLon.delegate = self;
    self.addName.delegate = self;
    self.addCat.delegate = self;
    self.addAddr.delegate = self;
    
    
}

- (void) saveClicked:(id) sender{
    //NSLog(@"Save Clicked");
    double newLat = [self.addLat.text doubleValue];
    double newLon = [self.addLon.text doubleValue];
    NSString * newName = self.addName.text;
    NSString * newAddr = self.addAddr.text;
    NSString * newCat = self.addCat.text;
    if( newLat == 0 || newLon == 0 || [newName isEqualToString:@""] || [newAddr isEqualToString:@""] || [newCat isEqualToString:@""]){
        
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:[NSString stringWithFormat:@"Incomplete / Incorrect Input"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        alert.alertViewStyle = UIAlertViewStyleDefault;
        [alert show];
    
    
    }else{
    
    
    Waypoint * newWP = [[Waypoint alloc] initWithLat:newLat lon:newLon name:newName address:newAddr category:newCat];
    
    [self.wpLib removeObjectForKey:self.addName.text];
    
   [self.wpLib setObject:newWP forKey:newWP.name];
    
        
        // ------adding a new waypoint here
        
        WpProxy * wpP = [[WpProxy alloc] initWithTarget:self action: @selector(callResult:)];
        
        
        //calling add method in wpProxy, which instead creates a JSON object
        [wpP add:newLat lon:newLon name:newName address:newAddr category:newCat];
        
        
        
        //-----end of call
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"New Waypoint" message:[NSString stringWithFormat:@"Waypoint '%@' added",self.addName.text] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    alert.alertViewStyle = UIAlertViewStyleDefault;
    [alert show];
    
    
    }
}


- (void) callResult:(NSNumber*) result {
    double res = [result doubleValue];
    NSLog([NSString stringWithFormat:@"%f",res ]);
    
  //  self.resultTF.text=[NSString stringWithFormat:@"%6.2f", res];
    //NSLog(@"call returned: %@",result);
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *title = [alertView title];
    
    
    if(![title isEqual:@"Warning"]){
    [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void) cancelClicked:(id) sender{
  //  NSLog(@"Cancel Clicked");
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.addLat resignFirstResponder];
    [self.addLon resignFirstResponder];
    [self.addName resignFirstResponder];
    [self.addAddr resignFirstResponder];
    [self.addCat resignFirstResponder];
};


@end
