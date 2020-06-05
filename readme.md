# ROS KINETIC 更换IKfast的步骤
1. 安装依赖库  
    
        sudo apt-get install libassimp-dev libavcodec-dev libavformat-dev libavformat-dev libboost-all-dev libboost-date-time-dev libbullet-dev libfaac-dev libglew-dev libgsm1-dev liblapack-dev liblog4cxx-dev libmpfr-dev libode-dev libogg-dev libpcrecpp0v5 libpcre3-dev libqhull-dev libqt4-dev libsoqt-dev-common libsoqt4-dev libswscale-dev libswscale-dev libvorbis-dev libx264-dev libxml2-dev libxvidcore-dev

2. 安装OpenSceneGraph 3.4   

        git clone https://github.com/openscenegraph/OpenSceneGraph.git

3. 安装Flexible Collision Library (fcl)  0.5.0

        git clone https://github.com/flexible-collision-library/fcl

         ' git checkout -b 0.5.0 '

4. 安装sympy 0.7.1(注意版本，若版本不对会产生错误)  

        pip install --upgrade --user sympy==0.7.1
 
5. 删除mpmath

        sudo apt remove python-mpmath

5. 安装MoveIt! IKFast  
    
        sudo apt-get install ros-kinetic-moveit-kinematics

6. 安装OpenRAVE (0.9.0)

        git clone https://github.com/rdiankov/openrave.git

7. ikfast param  

        export MYROBOT_NAME="panda_arm"
        export IKFAST_PRECISION="5"//保留精度小数点后5位
        export PLANNING_GROUP="panda_arm"
        export BASE_LINK="0"//起始关节
        export EEF_LINK="8"//末端关节
        export FREE_INDEX="1"//若关节数大于6需设置一自由关节
        export IKFAST_OUTPUT_PATH=`pwd`/ikfast61_"$PLANNING_GROUP".cpp

--- IKFAST_OUTPUT_PATH* 

---

8  ikfast settings

8.1 设置机器人名字

     export MYROBOT_NAME="panda_arm"

8.2 若机器人模型为xacro格式需先转为urdf格式

    rosrun xacro xacro --inorder -o "$MYROBOT_NAME".urdf "$MYROBOT_NAME".urdf.xacro

8.3 机器人模型urdf格式转换为dae格式

    rosrun collada_urdf urdf_to_collada "$MYROBOT_NAME".urdf "$MYROBOT_NAME".dae

8.4 设置精度为小数点后5位，然后保留备份后重新设置dae格式机器人模型描述文件的精度

    export IKFAST_PRECISION="5"
    cp "$MYROBOT_NAME".dae "$MYROBOT_NAME".backup.dae  # create a backup of your full precision dae.
    rosrun moveit_kinematics round_collada_numbers.py "$MYROBOT_NAME".dae "$MYROBOT_NAME".dae "$IKFAST_PRECISIO

8.5 查看模型
模型关节数据（数据如下图）

	openrave-robot.py "$MYROBOT_NAME".dae --info links

  	openrave "$MYROBOT_NAME".dae



8.6 生成IKFAST文件

 6轴

    python `openrave-config --python-dir`/openravepy/_openravepy_/ikfast.py --robot="$MYROBOT_NAME".dae --iktype=transform6d --baselink="$BASE_LINK" --eelink="$EEF_LINK" --savefile="$IKFAST_OUTPUT_PATH"



8.7  生成插件

---

注意：create_ikfast_moveit_plugin.py默认该目录下存在名字为"$MYROBOT_NAME"_moveit_config的功能包如下，该功能包为机器人模型通过moveit_setup_assistant配置生成的功能包。



    export MOVEIT_IK_PLUGIN_PKG="$MYROBOT_NAME"_ikfast_"$PLANNING_GROUP"_plugin
    cd ~/catkin_ws/src
    catkin_create_pkg "$MOVEIT_IK_PLUGIN_PKG"
    
    catkin build
    
    rosrun moveit_kinematics create_ikfast_moveit_plugin.py "$MYROBOT_NAME" "$PLANNING_GROUP" "$MOVEIT_IK_PLUGIN_PKG" "$IKFAST_OUTPUT_PATH"



9. 使用IKFAST插件

        在生成的package.xml exec_depend instead of the run_depend ,and add the build_depend
