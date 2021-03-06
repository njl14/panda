
[Mesh]
  file = cylinder_extrude.msh
[]


[UserObjects]
  [./dictator]
    type = PorousFlowDictator
    porous_flow_vars = 'pp temperature'
    number_fluid_phases = 1
    number_fluid_components = 1
  [../]
  [./pc]
    type = PorousFlowCapillaryPressureVG
    alpha = 1E-6
    m = 0.6
  [../]
[]

[GlobalParams]
  PorousFlowDictator = dictator
[]


[AuxVariables]
  [./v_x]
    family = MONOMIAL
    order = CONSTANT
  [../]
  [./v_y]
    family = MONOMIAL
    order = CONSTANT
  [../]
  [./v_z]
    family = MONOMIAL
    order = CONSTANT
  [../]

[]

[AuxKernels]
  [./vel_x]
    type = PorousFlowDarcyVelocityComponent
    variable = v_x
    gravity = '0 0 0'
    component=x
    PorousFlowDictator=dictator
  [../]
  [./vel_y]
    type = PorousFlowDarcyVelocityComponent
    variable = v_y
    gravity = '0 0 0'
    component=y
    PorousFlowDictator=dictator
  [../]
  [./vel_z]
    type = PorousFlowDarcyVelocityComponent
    variable = v_z
    gravity = '0 0 0'
    component=z
    PorousFlowDictator=dictator
  [../]
[]


[Variables]
  [./pp]
    initial_condition = 7.0E6
  [../]
  [./temperature]
    initial_condition = 250.0
    scaling = 1E-10
  [../]

  [./ts]
    scaling = 1E-10
    [./InitialCondition]
      type = FunctionIC
      function = ic_func
    [../]
  [../]
[]

[Functions]

active = 'ic_func'
  [./ic_func]
    type = ParsedFunction
    value = 950.0-57.0*z
  [../]
[]



[Kernels]

  [./flux]
    type = PorousFlowAdvectiveFlux
    variable = pp
    gravity = '0 0 0'
  [../]



  [./flux_heat]
    type = PorousFlowHeatAdvection
    variable = temperature
    gravity = '0 0 0'
  [../]

  [./heat_source]
    type = FluidHeatSource
    variable = temperature
    v=ts
  [../]



  [./SolidTemperature_Diffusion]
    type = SolidTemperatureDiffusion
    variable = ts
  [../]

  [./SolidTemperature_CoupledForce]
    type = SolidTemperatureCoupledForce
    variable = ts
    v=temperature
  [../]

  [./SolidTemperature_Source]
    type = SolidTemperatureSource
    variable = ts
  [../]

[]

[AuxVariables]
  [./sat]
    family = MONOMIAL
    order = CONSTANT
  [../]
[]

[AuxKernels]
  [./saturation]
    type = PorousFlowPropertyAux
    variable = sat
    property = saturation
  [../]
[]


[BCs]
  [./pp_inlet]
    type = PorousFlowSink
    variable = pp
    fluid_phase = 0
    flux_function = -12.08
    use_relperm = true
    boundary = 'inlet'
  [../]

  [./pp_outlet]
    type = PresetBC
    variable = pp
    value=7.0E6
    boundary = 'outlet'
  [../]

  [./temperature_inlet]
    type = PresetBC
    variable = temperature
    value=250.0
    boundary = 'inlet'
  [../]

  [./temperature_outlet]
    type = PresetBC
    variable = temperature
    value=740.0
    boundary = 'outlet'
  [../]

#  [./ts_inlet]
#    type = PresetBC
#    variable = ts
#    value=320.0
#    boundary = 'inlet'
#  [../]

#  [./temperature_outlet]
#    type = PorousFlowHeatOutflowBC
#    variable = temperature
#    boundary = 'outlet'
#    gravity = '0 0 0'
#  [../]
[]

[Modules]
  [./FluidProperties]
    [./the_simple_fluid]
      type = SimpleFluidProperties
      viscosity = 3.834E-5
      density0 = 4.2
      cp = 5195.0
      cv = 5195.0
      porepressure_coefficient = 0

    [../]
  [../]
[]

[Materials]
  [./temperature]
    type = PorousFlowTemperature
    at_nodes = true
    temperature = temperature
  [../]
  [./temperature_nodal]
    type = PorousFlowTemperature
    temperature = temperature
  [../]
  [./porosity]
    type = PorousFlowPorosityConst
    at_nodes = true
    porosity = 0.39
  [../]
  [./porosity_qp]
    type = PorousFlowPorosityConst
    porosity = 0.39
  [../]



  [./rock_heat]
    type = PorousFlowMatrixInternalEnergy
    specific_heat_capacity = 0
    density = 0
  [../]
  [./thermal_conductivity]
    type = PorousFlowThermalConductivityIdeal
    dry_thermal_conductivity = '0 0 0  0 0 0  0 0 0'
  [../]

  [./simple_fluid]
    type = PorousFlowSingleComponentFluid
    fp = the_simple_fluid
    phase = 0
    at_nodes = true
  [../]
  [./simple_fluid_qp]
    type = PorousFlowSingleComponentFluid
    fp = the_simple_fluid
    phase = 0
  [../]
  [./dens_all]
    type = PorousFlowJoiner
    at_nodes = true
    material_property = PorousFlow_fluid_phase_density_nodal
  [../]
  [./dens_qp_all]
    type = PorousFlowJoiner
    material_property = PorousFlow_fluid_phase_density_qp
    at_nodes = false
  [../]
  [./visc_all]
    type = PorousFlowJoiner
    at_nodes = true
    material_property = PorousFlow_viscosity_nodal
  [../]
  [./visc_qp]
    type = PorousFlowJoiner
    at_nodes = false
    material_property = PorousFlow_viscosity_qp
  [../]
  [./energy_all]
    type = PorousFlowJoiner
    at_nodes = true
    material_property = PorousFlow_fluid_phase_internal_energy_nodal
  [../]
  [./enthalpy_all]
    type = PorousFlowJoiner
    at_nodes = true
    material_property = PorousFlow_fluid_phase_enthalpy_nodal
  [../]
  [./permeability]
    type = PorousFlowPermeabilityConst
    permeability = '1.74E-8 0 0   0 1.74E-8 0   0 0 1.74E-8'
  [../]

  [./relperm]
    type = PorousFlowRelativePermeabilityCorey
    at_nodes = true
    n = 3
    s_res = 0.1
    sum_s_res = 0.1
    phase = 0
  [../]
  [./relperm_all]
    type = PorousFlowJoiner
    at_nodes = true
    material_property = PorousFlow_relative_permeability_nodal
  [../]
  [./relperm_qp]
    type = PorousFlowRelativePermeabilityCorey
    at_nodes = false
    n = 3
    s_res = 0.1
    sum_s_res = 0.1
    phase = 0
  [../]
  [./relperm_qp_all]
    type = PorousFlowJoiner
    at_nodes = false
    material_property = PorousFlow_relative_permeability_qp
  [../]


  [./massfrac]
    type = PorousFlowMassFraction
    at_nodes = true
  [../]



  [./PS]
    type = PorousFlow1PhaseP
    at_nodes = true
    porepressure = pp
    capillary_pressure = pc
  [../]
  [./PS_qp]
    type = PorousFlow1PhaseP
    porepressure = pp
    capillary_pressure = pc
  [../]

  [./solid_material]
    type = CoupledMaterial
    v_ts=ts
  [../]
[]

[Postprocessors]
  [./sub_average_flux_outlet]
    type = SideFluxIntegral
    variable = pp
    boundary = 'outlet'
    diffusivity= 1
    execute_on = timestep_end
  [../]

  [./sub_average_flux_inlet]
    type = SideFluxIntegral
    variable = pp
    boundary = 'inlet'
    diffusivity= 1
    execute_on = timestep_end
  [../]

  [./sub_average_flux_wall]
    type = SideFluxIntegral
    variable = pp
    boundary = 'wall'
    diffusivity= 1
    execute_on = timestep_end
  [../]
[]

[Preconditioning]
  active = basic
  [./basic]
    type = SMP
    full = true
    petsc_options = '-ksp_diagonal_scale -ksp_diagonal_scale_fix'
    petsc_options_iname = '-pc_type -sub_pc_type -sub_pc_factor_shift_type -pc_asm_overlap'
    petsc_options_value = ' asm      lu           NONZERO                   2'
  [../]
  [./preferred_but_might_not_be_installed]
    type = SMP
    full = true
    petsc_options_iname = '-pc_type -pc_factor_mat_solver_package'
    petsc_options_value = ' lu       mumps'
  [../]

  [./PBP]
    type = PBP
    solve_order = 'ts pp temperature'
    preconditioner  = 'LU LU LU'
    off_diag_row    = 'pp temperature'
    off_diag_column = 'ts pp'
  [../]
[]

[Executioner]
  type = Steady
  solve_type = Newton
#  solve_type = JFNK
  l_max_its = 35
  nl_abs_tol = 1E-7
[]

[Outputs]
  exodus = true
[]
