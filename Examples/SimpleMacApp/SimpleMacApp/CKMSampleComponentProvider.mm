/*
 *  Copyright (c) 2014-present, Facebook, Inc.
 *  All rights reserved.
 *
 *  This source code is licensed under the BSD-style license found in the
 *  LICENSE file in the root directory of this source tree. An additional grant
 *  of patent rights can be found in the PATENTS file in the same directory.
 *
 */

#import "CKMSampleComponentProvider.h"

#import "CKMTableCellComponentProvider.h"

#import <ComponentKit/CKStackLayoutComponent.h>
#import <ComponentKit/CKMTableComponent.h>

NSString *const kCKMSamplePasteboardType = @"kCKMSamplePasteboardType";

@implementation CKMSampleComponentProvider

+ (CKComponent *)componentForModel:(id<NSObject>)model context:(id<NSObject>)context
{
  NSArray *objects = (NSArray *)model;

  return [CKStackLayoutComponent
          newWithView:{}
          size:{}
          style:{
            .direction = CKStackLayoutDirectionVertical,
            .alignItems = CKStackLayoutAlignItemsStretch,
          }
          children:{
            {[CKMTextLabelComponent
              newWithTextAttributes:{
                .text = @"This example shows how you can combine different Components together into a simple Mac app.",
                .backgroundColor = [NSColor whiteColor]}
              viewAttributes:{}
              size:{}],
              .flexGrow = YES, .flexBasis = 0.0},

            {[CKMTableComponent
              newWithScrollView:{{[NSScrollView class]},
                {
                  {@selector(setBackgroundColor:), [NSColor lightGrayColor]},
                  {@selector(setScrollerStyle:), @(NSScrollerStyleOverlay)},
                  {@selector(setHasVerticalScroller:), @YES},
                }
              }
              tableView:{{[NSTableView class]},
                {
                  {@selector(setAllowsMultipleSelection:), @YES},
                  {@selector(setBackgroundColor:), [NSColor lightGrayColor]},
                  {@selector(setColumnAutoresizingStyle:), @(NSTableViewUniformColumnAutoresizingStyle)},
                  {@selector(registerForDraggedTypes:), @[kCKMSamplePasteboardType]},
                  CKComponentDelegateAttribute(@selector(setDataSource:), {
                    /* We list this selector but do not implement it ourselves to silence a log from NSTableView
                     * because it's momentarily set to this dataSource without the overrides from CKMTableComponent */
                    @selector(numberOfRowsInTableView:),

                    @selector(tableView:writeRowsWithIndexes:toPasteboard:),
                    @selector(tableView:validateDrop:proposedRow:proposedDropOperation:),
                    @selector(tableView:acceptDrop:row:dropOperation:),
                  })
                }
              }
              models:objects
              selection:nil
              componentProvider:[CKMTableCellComponentProvider class]
              size:{}],
              .flexGrow = YES, },
            
            {[CKStackLayoutComponent
              newWithView:{}
              size:{}
              style:{
                .direction = CKStackLayoutDirectionHorizontal,
              }
              children:{
                {[CKMButtonComponent
                  newWithTitle:@"Flexible width"
                  type:NSMomentaryLightButton
                  viewAttributes:{}],
                  .flexGrow = YES},
                {[CKMButtonComponent
                  newWithTitle:@"Fixed width"
                  type:NSMomentaryLightButton
                  viewAttributes:{}]},
              }],
            .spacingBefore = 5},
          }];
}

@end
