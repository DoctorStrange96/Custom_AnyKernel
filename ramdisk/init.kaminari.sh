#!/system/bin/sh

# Function to output stuff to dmesg
function kmesg() {
	$bb echo $1 | $bb tee /dev/kmsg;
}

# Custom busybox path
bb=/sbin/bb/busybox;

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

# Set i/o scheduler & read-ahead memory size
$bb echo "zen" > /sys/block/mmcblk0/queue/scheduler;
$bb echo "128" > /sys/block/mmcblk0/bdi/read_ahead_kb;

# Enable Multicore Power Saving
$bb echo "1" > /sys/devices/system/cpu/sched_mc_power_savings;

# Enable Fast Charge
$bb echo "1" > /sys/kernel/fast_charge/force_fast_charge;

# Wait for systemui and increase its priority
while sleep 1; do
  if [ `$bb pidof com.android.systemui` ]; then
    systemui=`$bb pidof com.android.systemui`;
    $bb renice -18 $systemui;
    $bb echo "-17" > /proc/$systemui/oom_adj;
    $bb chmod 100 /proc/$systemui/oom_adj;
    exit;
  fi;
done &

# LMK whitelist for common launchers and increase launcher priority
list="com.android.launcher com.google.android.googlequicksearchbox org.adw.launcher org.adwfreak.launcher net.alamoapps.launcher com.anddoes.launcher com.android.lmt com.chrislacy.actionlauncher.pro com.cyanogenmod.trebuchet com.gau.go.launcherex com.gtp.nextlauncher com.miui.mihome2 com.mobint.hololauncher com.mobint.hololauncher.hd com.qihoo360.launcher com.teslacoilsw.launcher com.tsf.shell org.zeam";
while sleep 60; do
  for class in $list; do
    if [ `$bb pgrep $class | $bb head -n 1` ]; then
      launcher=`$bb pgrep $class`;
      $bb echo "-17" > /proc/$launcher/oom_adj;
      $bb chmod 100 /proc/$launcher/oom_adj;
      $bb renice -18 $launcher;
    fi;
  done;
  exit;
done &
