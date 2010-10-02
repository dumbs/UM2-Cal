//
//  Cours.m
//  UM2 Cal
//
//  Created by Bertrand BRUN on 12/09/10.
//  Copyright (c) 2010 Universite Montpellier 2. All rights reserved.
//

#import "Cours.h"

@interface Cours ()

- (void)formatTitle;
- (void)formatStartDate:(NSString *)startDate;
- (void)formatEndDate:(NSString *)endDate;
- (NSInteger)weekDayFromString:(NSString *)string;
- (NSComparisonResult)compareWeekDay:(Cours *)cours;

@end

@implementation Cours

@synthesize id, allDay, editable, readOnly, model, description, location, title, type, end, start, group, stringStart, stringEnd;

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self != nil) {
        self.id = [[dictionary objectForKey:@"id"] intValue];
        self.allDay = [[dictionary objectForKey:@"allDay"] boolValue];
		self.editable = [[dictionary objectForKey:@"editable"] boolValue];
		self.readOnly = [[dictionary objectForKey:@"readOnly"] boolValue];
		self.model = [[dictionary objectForKey:@"model"] boolValue];
		self.description = [dictionary objectForKey:@"description"];
		self.location = [dictionary objectForKey:@"location"];
		self.title = [dictionary objectForKey:@"title"];
        self.stringStart = [dictionary objectForKey:@"start"];
        self.stringEnd = [dictionary objectForKey:@"end"];
		self.group = @"Tous";
		[self formatTitle];
		[self formatStartDate:[dictionary objectForKey:@"start"]];
		[self formatEndDate:[dictionary objectForKey:@"end"]];
    }
    
    return (self);
}

#pragma mark -
#pragma mark Private Method

- (void)formatTitle
{
    NSRange range;
    
    if ((range = [title rangeOfString:@" ["]).location != NSNotFound) {
        NSRange range2 = [title rangeOfString:@"]"];
		NSRange finalRange;
		finalRange.location = range.location + range.length;
		finalRange.length = (range2.location - range.location) - 2;
		self.location = [title substringWithRange:finalRange];
		self.title = [title substringToIndex:range.location];
    }
    if ((range = [title rangeOfString:@" dans "]).location != NSNotFound) {
		self.title = [title substringToIndex:range.location];
	}
	if ((range = [title rangeOfString:@" gr. "]).location != NSNotFound) {
		NSRange rangeForGroup = range;
		rangeForGroup.location += 1;
		self.group = [title substringWithRange:rangeForGroup];
		self.title = [title substringToIndex:range.location];
	}
	range.location = 0;
	range.length = 2;
	self.type = [title substringWithRange:range];
	self.title = [title substringFromIndex:3];
}

- (NSInteger)weekDayFromString:(NSString *)string
{
	NSRange range = [string rangeOfString:@"T"];
	NSString *dateS = [string substringToIndex:range.location];
	
	NSInteger year = [[dateS substringToIndex:4] intValue];
	range.location = 5;
	range.length = 2;
	NSInteger month = [[dateS substringWithRange:range] intValue];
	range.location = 8;
	NSInteger day = [[dateS substringWithRange:range] intValue];
	
	NSDateComponents *comps = [[NSDateComponents alloc] init];
	[comps setDay:day];
	[comps setMonth:month];
	[comps setYear:year];
	NSCalendar *gregorian = [[NSCalendar alloc]
							 initWithCalendarIdentifier:NSGregorianCalendar];
	NSDate *date = [gregorian dateFromComponents:comps];
	[comps release];
	NSDateComponents *weekdayComponents =
    [gregorian components:NSWeekdayCalendarUnit fromDate:date];
	int weekday = [weekdayComponents weekday];
	[gregorian release];
	return (weekday);
}

- (NSInteger)weekDay
{
    NSCalendar *gregorian = [[NSCalendar alloc]
							 initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *weekdayComponents =
    [gregorian components:NSWeekdayCalendarUnit fromDate:start];
    int weekday = [weekdayComponents weekday];
    [gregorian release];
    return (weekday);
}

- (void)formatStartDate:(NSString *)startDate
{
	NSRange range = [startDate rangeOfString:@"T"];
	NSString *dateS = [startDate substringToIndex:range.location];
	
	NSInteger year = [[dateS substringToIndex:4] intValue];
	range.location = 5;
	range.length = 2;
	NSInteger month = [[dateS substringWithRange:range] intValue];
	range.location = 8;
	NSInteger day = [[dateS substringWithRange:range] intValue];
	
	NSRange rangeOfT = [startDate rangeOfString:@"T"];
	range = rangeOfT;
	range.location += 1;
	range.length = 5;
	dateS = [startDate substringWithRange:range];
	
	NSInteger hour = [[dateS substringToIndex:2] intValue];
	range.location = 3;
	range.length = 2;
	NSInteger minute = [[dateS substringWithRange:range] intValue];
	
	NSDateComponents *comps = [[NSDateComponents alloc] init];
	[comps setDay:day];
	[comps setMonth:month];
	[comps setYear:year];
	[comps setHour:hour];
	[comps setMinute:minute];
	NSCalendar *gregorian = [[NSCalendar alloc]
							 initWithCalendarIdentifier:NSGregorianCalendar];
	self.start = [gregorian dateFromComponents:comps];
	[comps release];
	[gregorian release];
	
	NSLog(@"%@", start);
	
}

- (void)formatEndDate:(NSString *)endDate
{
	NSRange range = [endDate rangeOfString:@"T"];
	NSString *dateS = [endDate substringToIndex:range.location];
	
	NSInteger year = [[dateS substringToIndex:4] intValue];
	range.location = 5;
	range.length = 2;
	NSInteger month = [[dateS substringWithRange:range] intValue];
	range.location = 8;
	NSInteger day = [[dateS substringWithRange:range] intValue];
	
	NSRange rangeOfT = [endDate rangeOfString:@"T"];
	range = rangeOfT;
	range.location += 1;
	range.length = 5;
	dateS = [endDate substringWithRange:range];
	
	NSInteger hour = [[dateS substringToIndex:2] intValue];
	range.location = 3;
	range.length = 2;
	NSInteger minute = [[dateS substringWithRange:range] intValue];
	
	NSDateComponents *comps = [[NSDateComponents alloc] init];
	[comps setDay:day];
	[comps setMonth:month];
	[comps setYear:year];
	[comps setHour:hour];
	[comps setMinute:minute];
	NSCalendar *gregorian = [[NSCalendar alloc]
							 initWithCalendarIdentifier:NSGregorianCalendar];
	self.end = [gregorian dateFromComponents:comps];
	[comps release];
	[gregorian release];
	
	NSLog(@"%@", end);
}

- (NSString *)formatDayToString:(NSInteger)day
{
	switch (day) {
		case 0:
			return @"samedi";
			break;
		case 1:
			return @"dimanche";	
			break;
		case 2:
			return @"lundi";
			break;
		case 3:
			return @"mardi";
			break;
		case 4:	
			return @"mercredi";
			break;
		case 5:
			return @"jeudi";
			break;
		default:	
			return @"vendredi";
			break;
	}
}

- (NSString *)formatMonthToString:(NSInteger)month
{
	switch (month) {
		case 1:
			return (@"janvier");
			break;
		case 2:
			return (@"fevrier");
			break;
		case 3:
			return (@"mars");
			break;
		case 4:
			return (@"avril");
			break;
		case 5:
			return (@"mai");
			break;
		case 6:
			return (@"juin");
			break;
		case 7:
			return (@"juillet");
			break;
		case 8:
			return (@"aout");
			break;
		case 9:
			return (@"septembre");
			break;
		case 10:
			return (@"octobre");
			break;
		case 11:
			return (@"novembre");
			break;
		default:
			return (@"decembre");
			break;
	}
}

- (NSComparisonResult)compareWeekDay:(Cours *)cours
{
    NSInteger day1 = [self weekDay];
    NSInteger day2 = [cours weekDay];
    
    if (day1 < day2) {
        return (NSOrderedAscending);
    } else if (day1 > day2) {
        return (NSOrderedDescending);
    } else {
        return (NSOrderedSame);
    }
}

- (void) dealloc
{
	self.description = nil;
	self.location = nil;
	self.title = nil;
	self.type = nil;
	self.end = nil;
	self.start = nil;
	[super dealloc];
}

@end
