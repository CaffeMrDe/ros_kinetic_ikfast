export MYROBOT_NAME="HsRobotArm"
export IKFAST_PRECISION="5"#保留精度小数点后5位
export PLANNING_GROUP="arm"
export BASE_LINK="0"#起始关节
export EEF_LINK="7"#末端关节
export FREE_INDEX="0"#若关节数大于6需设置一自由关节
export IKFAST_OUTPUT_PATH=/home/maizitian/ikfastWork/ikfast_"$PLANNING_GROUP".cpp
export MOVEIT_IK_PLUGIN_PKG="$MYROBOT_NAME"_ikfast_"$PLANNING_GROUP"_plugin
