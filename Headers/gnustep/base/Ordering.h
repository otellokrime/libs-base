/* Protocol for Objective-C objects that can be ordered.
   Copyright (C) 1993,1994 Free Software Foundation, Inc.

   Written by:  Andrew Kachites McCallum <mccallum@gnu.ai.mit.edu>
   Date: May 1993

   This file is part of the GNUstep Base Library.

   This library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Library General Public
   License as published by the Free Software Foundation; either
   version 2 of the License, or (at your option) any later version.
   
   This library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Library General Public License for more details.

   You should have received a copy of the GNU Library General Public
   License along with this library; if not, write to the Free
   Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
*/ 

#ifndef __Ordering_h_GNUSTEP_BASE_INCLUDE
#define __Ordering_h_GNUSTEP_BASE_INCLUDE

#include <base/preface.h>
#include <objc/objc.h>

@protocol Ordering

- (int) compare: anObject;

- (BOOL) greaterThan: anObject;
- (BOOL) greaterThanOrEqual: anObject;

- (BOOL) lessThan: anObject;
- (BOOL) lessThanOrEqual: anObject;

- (BOOL) between: firstObject and: secondObject;

- maximum: anObject;
- minimum: anObject;

@end

#endif /* __Ordering_h_GNUSTEP_BASE_INCLUDE */
