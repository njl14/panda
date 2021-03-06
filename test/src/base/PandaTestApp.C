//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html
#include "PandaTestApp.h"
#include "PandaApp.h"
#include "Moose.h"
#include "AppFactory.h"
#include "MooseSyntax.h"
#include "ModulesApp.h"

template <>
InputParameters
validParams<PandaTestApp>()
{
  InputParameters params = validParams<PandaApp>();
  return params;
}

PandaTestApp::PandaTestApp(InputParameters parameters) : MooseApp(parameters)
{
  Moose::registerObjects(_factory);
  ModulesApp::registerObjects(_factory);
  PandaApp::registerObjectDepends(_factory);
  PandaApp::registerObjects(_factory);

  Moose::associateSyntax(_syntax, _action_factory);
  ModulesApp::associateSyntax(_syntax, _action_factory);
  PandaApp::associateSyntaxDepends(_syntax, _action_factory);
  PandaApp::associateSyntax(_syntax, _action_factory);

  Moose::registerExecFlags(_factory);
  ModulesApp::registerExecFlags(_factory);
  PandaApp::registerExecFlags(_factory);

  bool use_test_objs = getParam<bool>("allow_test_objects");
  if (use_test_objs)
  {
    PandaTestApp::registerObjects(_factory);
    PandaTestApp::associateSyntax(_syntax, _action_factory);
    PandaTestApp::registerExecFlags(_factory);
  }
}

PandaTestApp::~PandaTestApp() {}

void
PandaTestApp::registerApps()
{
  registerApp(PandaApp);
  registerApp(PandaTestApp);
}

void
PandaTestApp::registerObjects(Factory & /*factory*/)
{
  /* Uncomment Factory parameter and register your new test objects here! */
}

void
PandaTestApp::associateSyntax(Syntax & /*syntax*/, ActionFactory & /*action_factory*/)
{
  /* Uncomment Syntax and ActionFactory parameters and register your new test objects here! */
}

void
PandaTestApp::registerExecFlags(Factory & /*factory*/)
{
  /* Uncomment Factory parameter and register your new execute flags here! */
}

/***************************************************************************************************
 *********************** Dynamic Library Entry Points - DO NOT MODIFY ******************************
 **************************************************************************************************/
// External entry point for dynamic application loading
extern "C" void
PandaTestApp__registerApps()
{
  PandaTestApp::registerApps();
}

// External entry point for dynamic object registration
extern "C" void
PandaTestApp__registerObjects(Factory & factory)
{
  PandaTestApp::registerObjects(factory);
}

// External entry point for dynamic syntax association
extern "C" void
PandaTestApp__associateSyntax(Syntax & syntax, ActionFactory & action_factory)
{
  PandaTestApp::associateSyntax(syntax, action_factory);
}

// External entry point for dynamic execute flag loading
extern "C" void
PandaTestApp__registerExecFlags(Factory & factory)
{
  PandaTestApp::registerExecFlags(factory);
}
