#ifndef INCLUDE_libbranches_branches_cil_h
#define INCLUDE_libbranches_branches_cil_h

#include "branches.h"


/* the instrumentor will create initializers for these */
static struct BranchProfile branchProfile;
#pragma cilnoremove("siteInfo")
static const char siteInfo[] __attribute__((section(".debug_site_info")));


#pragma cilnoremove("branchProfileConstructor")
static void branchProfileConstructor() __attribute__((constructor));
static void branchProfileConstructor()
{
  registerBranchProfile(&branchProfile);
}


#pragma cilnoremove("branchProfileDestructor")
static void branchProfileDestructor() __attribute__((destructor));
static void branchProfileDestructor()
{
  unregisterBranchProfile(&branchProfile);
}


#endif /* !INCLUDE_libbranches_branches_cil_h */
