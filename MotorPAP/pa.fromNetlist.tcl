
# PlanAhead Launch Script for Post-Synthesis floorplanning, created by Project Navigator

create_project -name MotorPAP -dir "C:/Users/Albert/Documents/CircuitosLogicos/Practica_5/MotorPAP/planAhead_run_5" -part xc6slx9ftg256-3
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "C:/Users/Albert/Documents/CircuitosLogicos/Practica_5/MotorPAP/MotorPAP.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {C:/Users/Albert/Documents/CircuitosLogicos/Practica_5/MotorPAP} }
set_property target_constrs_file "restricciones.ucf" [current_fileset -constrset]
add_files [list {restricciones.ucf}] -fileset [get_property constrset [current_run]]
link_design
