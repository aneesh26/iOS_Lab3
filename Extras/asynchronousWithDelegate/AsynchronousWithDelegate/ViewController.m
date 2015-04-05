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

#import "ViewController.h"
#import "CalcProxy.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *leftTF;
@property (weak, nonatomic) IBOutlet UITextField *rightTF;
@property (weak, nonatomic) IBOutlet UITextField *methodTF;
@property (weak, nonatomic) IBOutlet UITextField *resultTF;

@property (strong, nonatomic) NSArray * pickerData;
@property (strong, nonatomic) UIPickerView * methodPicker;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.leftTF.delegate=self;
    self.leftTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    self.rightTF.delegate=self;
    self.rightTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    self.resultTF.delegate=self;
    
    self.pickerData = @[@"add", @"subtract", @"multiply", @"divide"];
    self.methodTF.text = self.pickerData[0];
    self.methodPicker = [[UIPickerView alloc] init];
    self.methodPicker.delegate=self;
    self.methodPicker.dataSource=self;
    self.methodTF.inputView=self.methodPicker;
    self.methodTF.delegate=self;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)callClicked:(id)sender {
    CalcProxy * calc = [[CalcProxy alloc] initWithTarget:self action: @selector(callResult:)];
    double left = [self.leftTF.text doubleValue];
    double right = [self.rightTF.text doubleValue];
    NSString*oper = self.methodTF.text;
    if([@"add" isEqualToString:oper]){
        [calc add: left to: right];
    }else if([@"subtract" isEqualToString:oper]){
        [calc subtract: left by: right];
    }else if([@"multiply" isEqualToString:oper]){
        [calc multiply: left times: right];
    }else if([@"divide" isEqualToString:oper]){
        [calc divide: left by: right];
    }
}

- (void) callResult:(NSNumber*) result {
    double res = [result doubleValue];
    self.resultTF.text=[NSString stringWithFormat:@"%6.2f", res];
    //NSLog(@"call returned: %@",result);
}

// Picker data source methods
- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
    [self.methodTF resignFirstResponder];
    self.methodTF.text = self.pickerData[row];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.pickerData.count;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.pickerData[row];
}

// UITextField delegate methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

// touch events on this view
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.leftTF resignFirstResponder];
    [self.rightTF resignFirstResponder];
    [self.resultTF resignFirstResponder];
}

@end
