/* Implementation of login-related functions for GNUstep
   Copyright (C) 1996 Free Software Foundation, Inc.
   
   Written by:  Andrew Kachites McCallum <mccallum@gnu.ai.mit.edu>
   Created: May 1996
   
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

#include <config.h>
#include <objc/objc-api.h>
#include <base/preface.h>
#include <Foundation/NSString.h>
#include <Foundation/NSPathUtilities.h>
#include <Foundation/NSArray.h>
#include <Foundation/NSDictionary.h>
#include <Foundation/NSFileManager.h>
#include <Foundation/NSProcessInfo.h>
#include <Foundation/NSValue.h>

#include <stdlib.h>		// for getenv()
#if !defined(__WIN32__) && !defined(_WIN32)
#include <unistd.h>		// for getlogin()
#include <pwd.h>		// for getpwnam()
#endif
#include <sys/types.h>

/* Return the caller's login name as an NSString object. */
NSString *
NSUserName ()
{
#if defined(__WIN32__) || defined(_WIN32)
  /* The GetUserName function returns the current user name */
  char buf[1024];
  DWORD n = 1024;

  if (GetUserName(buf, &n))
    return [NSString stringWithCString: buf];
  else
    return [NSString stringWithCString: ""];
#elif __SOLARIS__ || defined(BSD)
  int uid = geteuid(); // get the effective user id
  struct passwd *pwent = getpwuid (uid);
  NSString* name = [NSString stringWithCString: pwent->pw_name];
  return name;
#else
  const char *login_name = getlogin ();
  
  if (!login_name)
        login_name = cuserid(NULL);

  if (!login_name)
        login_name= getenv ("LOGNAME");

  if (login_name)
    return [NSString stringWithCString: login_name];
  else
    return nil;
#endif
}

/* Return the caller's home directory as an NSString object. */
NSString *
NSHomeDirectory ()
{
  return NSHomeDirectoryForUser (NSUserName ());
  /* xxx Was using this.  Is there a reason to prefer it?
     return [NSString stringWithCString: getenv ("HOME")]; */
}

/* Return LOGIN_NAME's home directory as an NSString object. */
NSString *
NSHomeDirectoryForUser (NSString *login_name)
{
#if !defined(__WIN32__) && !defined(_WIN32)
  struct passwd *pw;
  pw = getpwnam ([login_name cString]);
  return [NSString stringWithCString: pw->pw_dir];
#else
  /* Then environment variable HOMEPATH holds the home directory
     for the user on Windows NT; Win95 has no concept of home. */
  char buf[1024], *nb;
  DWORD n;
  NSString *s;

  n = GetEnvironmentVariable("HOMEPATH", buf, 1024);
  if (n > 1024)
    {
      /* Buffer not big enough, so dynamically allocate it */
      nb = (char *)objc_malloc(sizeof(char)*(n+1));
      n = GetEnvironmentVariable("HOMEPATH", nb, n+1);
      nb[n] = '\0';
      s = [NSString stringWithCString: nb];
      free(nb);
      return s;
    }
  else
    {
      /* null terminate it and return the string */
      buf[n] = '\0';
      return [NSString stringWithCString: buf];
    }
#endif
}

NSString *NSFullUserName(void)
{
  NSLog(@"Warning: NSFullUserName not implemented\n");
  return NSUserName();
}

NSArray *NSStandardApplicationPaths(void)
{
  NSLog(@"Warning: NSStandardApplicationPaths not implemented\n");
  return [NSArray array];
}

NSArray *NSStandardLibraryPaths(void)
{
  NSLog(@"Warning: NSStandardLibraryPaths not implemented\n");
  return [NSArray array];
}

NSString *NSTemporaryDirectory(void)
{
  NSFileManager *manager;
  NSString *tempDirName, *baseTempDirName;
#ifdef WIN32
  char buffer[1024];
  if (GetTempPath(1024, buffer))
    baseTempDirName = [NSString stringWithCString: buffer];
  else 
    baseTempDirName = @"C:\\";
#else
  baseTempDirName = @"/tmp";
#endif

  tempDirName = [baseTempDirName stringByAppendingPathComponent: NSUserName()];
  manager = [NSFileManager defaultManager];
  if ([manager fileExistsAtPath: tempDirName] == NO)
    {
      NSDictionary *attr;
      attr = [NSDictionary dictionaryWithObject: [NSNumber numberWithInt: 0700]
			   forKey: NSFilePosixPermissions];
      if ([manager createDirectoryAtPath: tempDirName attributes: attr] == NO)
	tempDirName = baseTempDirName;
    }

  return tempDirName;
}

NSString *NSOpenStepRootDirectory(void)
{
  NSString* root = [[[NSProcessInfo processInfo] environment]
		     objectForKey:@"GNUSTEP_SYSTEM_ROOT"];

  if (!root)
#ifdef WIN32
    root = @"C:\\";
#else
    root = @"/";
#endif
  return root;
}


