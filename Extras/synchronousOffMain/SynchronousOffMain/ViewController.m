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

#import "ViewController.h"
#import "AsyncRPCCalc.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *valueTF;
@property (strong, atomic) NSTimer * updateTimer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.valueTF.delegate=self;
    self.valueTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
}

- (IBAction)startTimer:(id)sender {
    self.updateTimer = [NSTimer scheduledTimerWithTimeInterval: 0.5
                                                        target: self
                                                      selector: @selector(update)
                                                      userInfo: nil
                                                       repeats: YES];
}

- (IBAction)stopTimer:(id)sender {
    [self.updateTimer invalidate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) update {
    double left = [self.valueTF.text doubleValue];
    double right = 1.0;
    NSArray * parms = @[[NSNumber numberWithDouble:left], [NSNumber numberWithDouble:right]];
    AsyncRPCCalc * calc = [[AsyncRPCCalc alloc] initWithMethod:@"add" parms:parms resultTF:self.valueTF];
    [calc execute];
}

// UITextField delegate methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

// touch events on this view
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.valueTF resignFirstResponder];
}

@end
