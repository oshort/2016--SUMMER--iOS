//
//  ViewController.m
//  AgeCalculator
//
//  Created by Ben Gohlke on 6/28/16.
//  Copyright © 2016 The Iron Yard. All rights reserved.
//

#import "AgeViewController.h"

@interface AgeViewController ()

@property (nonatomic, weak) IBOutlet UIDatePicker *birthdatePicker;
@property (nonatomic, weak) IBOutlet UILabel *currentDateLabel;
@property (nonatomic, weak) IBOutlet UILabel *ageLabel;
@property (nonatomic, weak) IBOutlet UILabel *nextBirthdayLabel;

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

- (IBAction)birthdateSelected:(UIDatePicker *)sender;

@end

@implementation AgeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 1. Setting the labels to "empty" so that they don't display the placeholder data from the storyboard.
    self.currentDateLabel.text = @"";
    self.ageLabel.text = @"";
    self.nextBirthdayLabel.text = <#based on the pattern with the first two, what goes here?#>;
    
    // We'll need to format several dates, so let's set up a formatter object that we can reuse
    self.dateFormatter = [[NSDateFormatter alloc] init];
    
    // 2. What does "medium style" mean? (hint: copy the value used below on the right of the equal sign and open the "Documentation and API Reference" window from the Window menu at the top of the screen. Paste the value to search the Appledoc for it.)
    self.dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    
    // 3. How does "no style" differ from the medium style used above? You can look in the same place in the docs to find the answer.
    self.dateFormatter.timeStyle = NSDateFormatterNoStyle;
    
    // Once you get it working, this will call the method below and ensure the current date label shows today's date
    [self configureCurrentDateLabel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action handlers

- (IBAction)birthdateSelected:(UIDatePicker *)sender
{
    // As soon as the user chooses a date, we can have the app spring into action and calculate both their age and their next birthday. This will get the selected date from the picker and store it in a local variable called "birthdate".
    NSDate *birthdate = sender.date;
    
    // 7. We need to use the user's birthdate and today's date to calculate their age. Fortunately, we have a method already defined called "findAgeFromBirthdate" that does just that. How do we call it?
    int age = [self <#how do we call the above method here?#>];
    
    // 9. Once we calculate the user's age, we need to display it to them in the age label
    self.ageLabel.text = [NSString stringWithFormat:@"%d", <#what goes here?#>];
    
    // 10. Now, let's figure out their next birthday. Wouldn't you know there is a pre-existing method for that too. You just need to call it.
    NSDate *nextBirthday = [self <#what's the name of the method that determines their next birthday?#>];
    
    // 14. Once you get the date, you need to display it in the appropriate label. Don't forget to format it into a pretty string first.
    self.nextBirthdayLabel.text = [self.dateFormatter stringFromDate:<#which date?#>];
}

#pragma mark - private methods

- (void)configureCurrentDateLabel
{
    // 4. We need to get the current date. I bet the system already knows what it is. How do we ask it? The variable today below will store our date object, but what belongs on the right side of the equals sign? Search the documentation window you opened earlier for "NSDate" to find how to create a new date object initialized to today (look in the tasks list on the left of the doc window. It has many common tasks you might want to perform with the class you've looked up).
    
    NSDate *today = <#What goes here?#>;
    
    // 5. Once you have a date object in the today variable, you need to show that date in the "currentDateLabel" on screen for your user. Up in viewDidLoad, we set the value of several labels to "empty" string. What property of the label did we access?
    // 6. For the right side of the above instruction, can we just put "today" after the equals sign? What is that dateFormatter object we created earlier used for? Is it involved in the above instruction (look up the documentation for the NSDateFormatter class; I think we might want a "string" from a "date")?
    
    self.currentDateLabel.<#which property of the UILabel should we be setting here?#> = <#Can we just put the today variable here?#>;
}

- (int)findAgeFromBirthdate:(NSDate *)birthdate
{
    // This will determine how many seconds are between the birthdate and today's date
    NSTimeInterval difference = [[NSDate date] timeIntervalSinceDate:birthdate];
    
    // These should be useful numbers to calculate the age
    double secondsInDay = 86400.0f;
    double secondsInYear = secondsInDay * 365.0f;
    
    // 8. Using "secondsInYear", how do we determine their age? Remember, the difference variable is also measured in seconds.
    int age = difference / secondsInYear;
    
    // This will send the age value back to where this method was called (#7)
    return age;
}

- (NSDate *)findNextBirthdayUsingBirthdate:(NSDate *)birthdate
{l
    // This determines which calendar we're using. Could be Gregorian (the one we use), or another one, e.g. the Buddhist or Jewish calendars.
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // This will pull the birthdate object apart into year, month, and day components. This lets us use/manipulate those pieces individually.
    NSDateComponents *birthdateComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitCalendar fromDate:birthdate];
    
    // This uses today's date and simply pulls the year out as a number.
    NSInteger currentYear = [calendar component:NSCalendarUnitYear fromDate:[NSDate date]];
    
    // 11. This should change the year of the birthdate components object to this year. We're trying to determine what the user's birthday is for the current year.
    [birthdateComponents setYear:<#what goes here?#>];
    
    // 12. This should convert the birthdateComponents object back into a regular NSDate object (search for NSDateComponents docs and look in the sidebar under tasks. There should be a mention of accessing the date).
    NSDate *currentYearBirthday = [birthdateComponents <#which property do we want?#>];
    
    // The above NSDate object represents the user's birthday for this year. We now need to add 1 year to it to determine the user's next birthday. The following object is a dateComponents object that only has its month property set. It represents 12 months of time.
    NSDateComponents *oneYear = [[NSDateComponents alloc] init];
    [oneYear setMonth:12];
    
    // 13. We can use the above "oneYear" object and add it to "currentYearBirthday" to determine the user's next birthday.
    NSDate *nextBirthday = [calendar dateByAddingComponents:<#we need to reference the year component object here#> toDate:<#which date object should we use?#> options:0];
    
    
    // We send the nextBirthday object back to where this method was called (#10)
    return nextBirthday;
}

@end