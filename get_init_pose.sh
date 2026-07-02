#!/bin/bash

source ~/code/mavros_ws/install/setup.bash

# Initialize pose to zero 
#export INIT_X="0.0"
#export INIT_Y="0.0"
#export INIT_Z="0.0"
#export INIT_ROLL="0.0"
#export INIT_PITCH="0.0"
#export INIT_YAW="0.0"

if [ -z "${INIT_X}" ]; then 

# If mocap is running get initial pose 
mocap_running=$(ros2 topic list | grep ${VEH_NAME}/world)

if [ ${#mocap_running} -gt 0 ]; then
        eval $(ros2 run ros2_px4_stack get_init_pose)
fi

else

export INIT_X=${INIT_X}
export INIT_Y=${INIT_Y}
export INIT_Z=${INIT_Z}
export INIT_ROLL=${INIT_ROLL}
export INIT_PITCH=${INIT_PITCH}
export INIT_YAW=${INIT_YAW} 

fi	
