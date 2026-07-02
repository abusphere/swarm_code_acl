As of 07/02/2026, includes all files from the PX06's code directory sparing directories with a .git file (tracked third-party repositories). The tracked third-party repositories can be built using vcstool and the workspace.repos file; instructions are below.

## Cloning

Clone:
```
git clone https://github.com/abusphere/swarm_code_acl.git ~/code
cd ~/code
```
Import remaining third-party dependencies:
```
vcs import . < workspace.repos
```
Build the remaining workspaces:
```
colcon build --symlink-install
```
Source install:
```
source install/setup.bash
```

----

## Helpful files in root directory:

### .tmux.conf

```
# Enable mouse support (click panes, resize, scroll)
set -g mouse on

# Start window and pane numbering at 1 (easier to reach on keyboard)
set -g base-index 1
setw -g pane-base-index 1

# Renumber windows when one is closed
set -g renumber-windows on

# Increase scrollback buffer
set -g history-limit 10000

# Reduce escape key delay (useful for vim/neovim users)
set -sg escape-time 10

# Enable 256 color support
set -g default-terminal "tmux-256color"

# Easier pane splitting with | and -
bind | split-window -h -c "#{pane_current_path}"
bind - split-window -v -c "#{pane_current_path}"

# New windows open in the current directory
bind c new-window -c "#{pane_current_path}"

# Use vi keys in copy mode
setw -g mode-keys vi

# Copy to system clipboard on mouse drag select
bind -T copy-mode MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel "xclip -selection clipboard"
bind -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel "xclip -selection clipboard"

# Middle-click to paste from system clipboard
bind -n MouseDown2Pane run "xclip -selection clipboard -o | tmux load-buffer - && tmux paste-buffer"

# Show pane titles in border
set -g pane-border-status top
set -g pane-border-format " #{pane_title} "
set -g pane-border-lines heavy
set -g pane-border-style fg=colour240
set -g pane-active-border-style fg=green,bold


# Reload config with prefix + r
bind r source-file ~/.tmux.conf \; display "Config reloaded"

```

### .bashrc

```
# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*/>

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
# Make prompt a different color for each drone
PCOLOR='01;34m'
export GIT_PS1_SHOWDIRTYSTATE=1
export PS1='\[\033['$PCOLOR'\]\h\[\033[01;34m\] \w\[\033[00;33m\]$(__git_ps1)\[\033[01;32m\] \$\[\033[00m\] '

source /opt/ros/humble/setup.bash

# Gurobi
export GUROBI_HOME="/opt/gurobi1103/linux64" 
export PATH="${PATH}:${GUROBI_HOME}/bin" 
export LD_LIBRARY_PATH="${GUROBI_HOME}/lib" 

export LD_LIBRARY_PATH="/home/swarm/code/livox_ws/install/livox_ros_driver2/lib:${LD_LIBRARY_PATH}" 
export LD_LIBRARY_PATH="/opt/ros/humble/lib:${LD_LIBRARY_PATH}"
export LD_LIBRARY_PATH="/home/swarm/code/decomp_ws/install/decomp_ros_msgs/lib:${LD_LIBRARY_PATH}"

alias sb="source ~/.bashrc"
alias eb="code ~/.bashrc"
alias gs="git status"
alias gp="git push"
alias roscd="cd ~/code/dynus_ws"
alias cb="roscd && colcon build && sb"
alias ss="roscd && source install/setup.bash"
alias cbd="clear && roscd && colcon build && ss"
alias cbm="clear && roscd && colcon build --packages-select ros2_mapper && ss"
alias cbrpx="colcon build --packages-select ros2_px4_stack && source /home/swarm/code/mavros_ws/install/setup.bash"
alias cbsl="roscd && colcon build --symlink-install && sb"
alias cbps="roscd && colcon build --packages-select"
alias tf_visualize="ros2 run rqt_tf_tree rqt_tf_tree"
alias tks="tmux kill-server"
#alias dynus="tmuxp load ~/code/dynus_ws/src/dynus/launch/hardware_blue_drone.yaml"
alias dynus="python3 ~/code/mavros_ws/src/ros2_px4_stack/scripts/tmux/dynus_tmux.py"
alias sando_flight="cd ~/code/sando_ws && colcon build --cmake-args -DCMAKE_BUILD_TYPE=Release && python3 ~/code/mavros_ws/src/ros2_px4_s>
alias sando_flight_mocap="cd ~/code/sando_ws && colcon build --cmake-args -DCMAKE_BUILD_TYPE=Release && python3 ~/code/mavros_ws/src/ros2>

alias sando_debug="cd ~/code/sando_ws && colcon build --cmake-args -DCMAKE_BUILD_TYPE=Release && python3 ~/code/mavros_ws/src/ros2_px4_st>
alias mighty="python3 ~/code/mavros_ws/src/ros2_px4_stack/scripts/tmux/dynus_tmux.py --planner mighty"
alias send_goal_dynus='ros2 topic pub /mission_start std_msgs/Bool "{data: true}" --once'
alias zenoh_router="source ~/code/zenoh_ws/install/setup.bash && ros2 run zenoh_vendor zenoh-bridge-ros2dds -c ~/code/zenoh_ws/src/zenoh_>
alias give_goal="/home/swarm/code/mavros_ws/src/ros2_px4_stack/scripts/trajectories/give_goal.sh" 

alias trajgen_go="source ~/code/trajgen_ws/install/setup.bash && ros2 service call /change_mode mission_mode/srv/MissionModeChange '{mode>
alias trajgen_mocap="python3 ~/code/mavros_ws/src/ros2_px4_stack/scripts/tmux/trajgen_tmux.py --odom_type mocap"
alias trajgen_livox="python3 ~/code/mavros_ws/src/ros2_px4_stack/scripts/tmux/trajgen_tmux.py --odom_type livox"
alias fly="source ~/code/mavros_ws/install/setup.bash && ros2 run ros2_px4_stack there_and_back"
alias fly_back_left="source ~/code/mavros_ws/install/setup.bash && ros2 run ros2_px4_stack there_and_back -2.5 2.0 2.0"
alias fly_back_right="source ~/code/mavros_ws/install/setup.bash && ros2 run ros2_px4_stack there_and_back 2.5 2.0 2.0"
alias zenoh_router="source ~/code/zenoh_ws/install/setup.bash && ros2 run zenoh_vendor zenoh-bridge-ros2dds -c ~/code/zenoh_ws/src/zenoh_>
alias give_goal="/home/swarm/code/mavros_ws/src/ros2_px4_stack/scripts/trajectories/give_goal.sh"
alias trajgen_go="source ~/code/trajgen_ws/install/setup.bash && ros2 service call /change_mode mission_mode/srv/MissionModeChange '{mode>
alias trajgen_stop="ros2 service call /change_mode mission_mode/srv/MissionModeChange '{mode: 2}'"
alias trajgen_kill="ros2 service call /change_mode mission_mode/srv/MissionModeChange '{mode: 3}'"

export VEH_NAME="PX06"
export VEH_NUM=6
export MAV_SYS_ID="6"

# ROS2 RTPS network
export ROS_AUTOMATIC_DISCOVERY_RANGE=LOCALHOST
#export ROS_AUTOMATIC_DISCOVERY_RANGE=SUBNET

# Use either zenoh or cyclone 
export RMW_IMPLEMENTATION=rmw_cyclonedds_cpp
#source cyclone_config.sh
#source zenoh_config.sh 

# Path to library for cyclonedds 
export LD_LIBRARY_PATH=/opt/ros/humble/lib/x86_64-linux-gnu:$LD_LIBRARY_PATH
#export CYCLONEDDS_URI="/home/swarm/code/cyclonedds.xml"
#export CYCLONEDDS_URI="<CycloneDDS><Domain><General><NetworkInterfaceAddress>wlo1</NetworkInterfaceAddress></General></Domain></CycloneD>



# Alias for dynus docker
alias dynus_docker="cd ~/docker/dynus_setup/docker && make run-hw"

# Source ros
source /opt/ros/humble/setup.bash

# ROMAN
source ~/.romanrc

# ============================================
# MIGHTY Setup
# ============================================

# Source ROS 2 Humble
source /opt/ros/humble/setup.bash

# ROS 2 RTPS network
export ROS_DOMAIN_ID=0
export ROS_LOCALHOST__ONLY=1

# Livox library path
export LD_LIBRARY_PATH=/home/swarm/code/livox_ws/install/livox_ros_driver2/lib:$LD_LIBRARY_PATH:/usr/local/lib:/usr/local/include
export LD_LIBRARY_PATH=/opt/ros/humble/lib:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/home/swarm/code/decomp_ws/install/decomp_ros_msgs/lib:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/opt/ros/humble/lib/x86_64-linux-gnu:$LD_LIBRARY_PATH

# Source MIGHTY workspaces
source /home/swarm/code/decomp_ws/install/setup.bash
```

