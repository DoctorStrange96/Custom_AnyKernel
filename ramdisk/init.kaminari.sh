#!/system/bin/sh

# Custom busybox path
bb=/system/xbin/busybox;

# Enable Fsync
$bb echo "Y" > /sys/module/sync/parameters/fsync_enabled;

# Disable gentle fair sleepers
$bb echo "NO_GENTLE_FAIR_SLEEPERS" > /sys/kernel/debug/sched_features;
$bb echo "0" > /sys/kernel/sched/gentle_fair_sleepers;

# Enable Headset High Performance Mode
$bb echo "1" > /sys/devices/virtual/misc/soundcontrol/highperf_enabled;

# Enable arch power
$bb echo "ARCH_POWER" > /sys/kernel/debug/sched_features;
$bb echo "1" > /sys/kernel/sched/arch_power;

# GPU Settings
$bb echo "msm-adreno-tz" > /sys/devices/fdb00000.qcom,kgsl-3d0/devfreq/fdb00000.qcom,kgsl-3d0/governor;

# Enable Adreno Idler
$bb echo "Y" > /sys/module/adreno_idler/parameters/adreno_idler_active;

# Set TCP congestion control algo to westwood
$bb echo "westwood" > /proc/sys/net/ipv4/tcp_congestion_control;

# Disable debugging on some modules
$bb echo "0" > /sys/module/kernel/parameters/initcall_debug;
$bb echo "0" > /sys/module/alarm/parameters/debug_mask;
$bb echo "0" > /sys/module/alarm_dev/parameters/debug_mask;
$bb echo "0" > /sys/module/binder/parameters/debug_mask;
$bb echo "0" > /sys/module/xt_qtaguid/parameters/debug_mask;

# Power Mode
$bb echo "1" > /sys/module/msm_pm/modes/cpu0/retention/idle_enabled;
$bb echo "1" > /sys/module/msm_pm/modes/cpu1/retention/idle_enabled;
$bb echo "1" > /sys/module/msm_pm/modes/cpu2/retention/idle_enabled;
$bb echo "1" > /sys/module/msm_pm/modes/cpu3/retention/idle_enabled;

# Entropy
$bb echo "256" > /proc/sys/kernel/random/read_wakeup_threshold;
$bb echo "512" > /proc/sys/kernel/random/write_wakeup_threshold;

# Set i/o scheduler & read-ahead memory size
$bb echo "deadline" > /sys/block/mmcblk0/queue/scheduler;
$bb echo "128" > /sys/block/mmcblk0/bdi/read_ahead_kb;