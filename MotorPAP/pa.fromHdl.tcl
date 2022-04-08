
# PlanAhead Launch Script for Pre-Synthesis Floorplanning, created by Project Navigator

create_project -name MotorPAP -dir "C:/Users/Albert/Documents/CircuitosLogicos/Practica_5/MotorPAP/planAhead_run_1" -part xc6slx9ftg256-3
set_param project.pinAheadLayout yes
set srcset [get_property srcset [current_run -impl]]
set_property target_constrs_file "restricciones.ucf" [current_fileset -constrset]
set hdlfile [add_files [list {Motor_PAP.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set_property top MotorPAP $srcset
add_files [list {restricciones.ucf}] -fileset [get_property constrset [current_run]]
open_rtl_design -part xc6slx9ftg256-3
