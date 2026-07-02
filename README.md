As of 07/02/2026, includes all files from the PX06's code directory sparing directories with a .git file (tracked third-party repositories). The tracked third-party repositories can be built using vcstool and the workspace.repos file; instructions are below.

### Cloning

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

