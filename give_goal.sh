#!/bin/bash 


ros2 topic pub /PX02/term_goal_gf geometry_msgs/msg/PoseStamped "{header: {stamp: {sec: 0.0, nanosec: 0.0}, frame_id: map}, pose: {position: {x: 2.0, y: 1.0, z: 2.0}, orientation: {x: 0.0, y: 0.0, z: 0.0, w: 1.0}}}" -1 & 

ros2 topic pub /PX03/term_goal_gf geometry_msgs/msg/PoseStamped "{header: {stamp: {sec: 0.0, nanosec: 0.0}, frame_id: map}, pose: {position: {x: -2.0, y: 1.0, z: 2.0}, orientation: {x: 0.0, y: 0.0, z: 0.0, w: 1.0}}}" -1  &

