//
//  Cours.h
//  UM2 Cal
//
//  Created by Bertrand BRUN on 12/09/10.
//  Copyright (c) 2010 Universite Montpellier 2. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Cours : NSObject 
{
    NSInteger   id;
    BOOL        allDay;
    BOOL        editable;
    BOOL        readOnly;
    BOOL        model;
    NSString    *description;
    NSString    *location;
    NSString    *title;
    NSString    *type;
    NSString    *group;
    NSDate      *end;
    NSDate      *start;
}

@property (nonatomic, retain)               NSString    *description;
@property (nonatomic, retain)               NSString    *location;
@property (nonatomic, retain)               NSString    *title;
@property (nonatomic, retain)               NSString    *type;
@property (nonatomic, retain)               NSString    *group;
@property (nonatomic, getter = isAllDay)    BOOL        allDay;
@property (nonatomic, getter = isEditable)  BOOL        editable;
@property (nonatomic, getter = isReadOnly)  BOOL        readOnly;
@property (nonatomic, getter = isModel)     BOOL        model;
@property (nonatomic, retain)               NSDate      *end;
@property (nonatomic, retain)               NSDate      *start;
@property (nonatomic, assign)               NSInteger   id;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (NSInteger)weekDay;

@end
