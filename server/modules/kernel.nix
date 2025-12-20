{ pkgs, ... }:
{
  boot = {

    kernelPackages = pkgs.linuxPackages;

    # ==========================================================================================
    # Modules
    # ==========================================================================================

    kernelModules = [ "kvm-intel" ];

    blacklistedKernelModules = [

      # Obscure networking protocols
      "dccp"
      "sctp"
      "rds"
      "tipc"
      "n-hdlc"
      "ax25"
      "netrom"
      "x25"
      "rose"
      "decnet"
      "econet"
      "af_802154"
      "ipx"
      "appletalk"
      "psnap"
      "p8023"
      "p8022"
      "can"
      "atm"

      # Various rare filesystems
      "cramfs"
      "freevxfs"
      "jffs2"
      "hfs"
      "hfsplus"
      "udf"

      # Not so rare filesystems
      "squashfs"
      "cifs"
      "nfs"
      "nfsv3"
      "nfsv4"
      "ksmbd"
      "gfs2"
      "vivid" # vivid driver is only useful for testing purposes and has been the cause of privilege escalation vulnerabilities

      # Others modules
      "bluetooth"
      "btusb"
    ];

    # ==========================================================================================
    # Boot Parameters: https://www.kernel.org/doc/html/latest/admin-guide/kernel-parameters.html
    # ==========================================================================================

    kernelParams = [

      # Hardening
      "debugfs=off"
      "disable_ipv6=1"
      "hibernate=no"
      "init_on_alloc=1"
      "init_on_free=1"
      "lockdown=confidentiality"
      "module.sig_enforce=1"
      "oops=panic"
      "page_alloc.shuffle=1"
      "pti=on"
      "randomize_kstack_offset=on"
      "slab_nomerge"
      "vsyscall=none"

      # Since we can't manually respond to a panic, just reboot.
      "panic=1"
      "boot.panic_on_fail"
      "vga=0x317"
      "nomodeset"

      # Power saving
      "intel_pstate=active"
      "rcutree.enable_rcu_lazy=1"

    ];

    # ==========================================================================================
    # sysctl
    # ==========================================================================================

    kernel.sysctl = {

      # ------------------------------------------
      # Legacy Interface Hardening
      # ------------------------------------------

      "abi.vsyscall32" = 1; # Disable legacy syscall interface to reduce attack surface

      # ------------------------------------------
      # Terminal Device Security
      # ------------------------------------------

      "dev.tty.ldisc_autoload" = 0;
      "dev.tty.legacy_tiocsti" = 1; # disable TIOCSTI injection for better container/sandbox security

      # ------------------------------------------
      # Filesystem
      # ------------------------------------------

      "fs.suid_dumpable" = 0;
      "fs.protected_fifos" = 2;
      "fs.protected_regular" = 2;
      "fs.protected_symlinks" = 1;
      "fs.protected_hardlinks" = 1;

      # ------------------------------------------
      # Kernel protections
      # ------------------------------------------

      "kernel.dmesg_restrict" = 1;
      "kernel.kexec_load_disabled" = 1;
      "kernel.kptr_restrict" = 2;
      # "kernel.modules_disabled" = 1;  # Disables loadable kernel modules. 0 means they are enabled
      "kernel.printk" = "3 3 3 3";
      "kernel.sysrq" = 0; # Disable Low level access to Kernel
      "kernel.unprivileged_bpf_disabled" = 1; # restrict eBPF to the CAP_BPF capability (certain container runtimes or browser sandboxes might rely on the following)
      # "kernel.unprivileged_userns_clone" = 0; # Disable unprivileged user namespaces (Breaks a lot of programs)
      "kernel.perf_event_paranoid" = 3; # restrict all usage of performance events to the CAP_PERFMON capability
      "kernel.yama.ptrace_scope" = 2; # restrict usage of ptrace

      # ------------------------------------------
      # Network
      # ------------------------------------------

      # Security
      "net.core.bpf_jit_harden" = 2;
      "net.core.bpf_jit_kallsyms" = 0; # Reduces attack surface by hiding JIT-compiled symbols from kallsyms.
      "net.core.fb_tunnels_only_for_init_net" = 1;
      "net.core.xfrm_larval_drop" = 1;

      # Buffers
      "net.core.rmem_default" = 524288;
      "net.core.wmem_default" = 524288;
      "net.core.rmem_max" = 8388608;
      "net.core.wmem_max" = 8388608;
      "net.core.optmem_max" = 262144;
      "net.core.netdev_max_backlog" = 4096; # Increase netdev receive queue May help prevent losing packets

      # IPV4 Hardening
      "net.ipv4.conf.all.accept_redirects" = 0;
      "net.ipv4.conf.all.accept_source_route" = 0;
      "net.ipv4.conf.all.bootp_relay" = 0;
      "net.ipv4.conf.all.forwarding" = 0;
      "net.ipv4.conf.all.log_martians" = 1;
      "net.ipv4.conf.all.mc_forwarding" = 0;
      "net.ipv4.conf.all.proxy_arp" = 0;
      "net.ipv4.conf.all.rp_filter" = 1;
      "net.ipv4.conf.all.send_redirects" = 0;

      "net.ipv4.conf.default.accept_redirects" = 0;
      "net.ipv4.conf.default.accept_source_route" = 0;
      "net.ipv4.conf.default.bootp_relay" = 0;
      "net.ipv4.conf.default.forwarding" = 0;
      "net.ipv4.conf.default.log_martians" = 1;
      "net.ipv4.conf.default.mc_forwarding" = 0;
      "net.ipv4.conf.default.proxy_arp" = 0;
      "net.ipv4.conf.default.rp_filter" = 1;
      "net.ipv4.conf.default.send_redirects" = 0;

      # ICMP Hardening
      "net.ipv4.icmp_echo_ignore_all" = 1;
      "net.ipv4.icmp_echo_ignore_broadcasts" = 1;
      "net.ipv4.icmp_errors_use_inbound_ifaddr" = 0;
      "net.ipv4.icmp_ignore_bogus_error_responses" = 1;
      "net.ipv4.icmp_msgs_burst" = 10;
      "net.ipv4.icmp_msgs_per_sec" = 10;
      "net.ipv4.icmp_ratelimit" = 100;
      "net.ipv4.icmp_ratemask" = 6168;

      # TCP Hardening
      "net.ipv4.tcp_sack" = 0;
      "net.ipv4.tcp_dsack" = 0;
      "net.ipv4.tcp_fack" = 0;
      "net.ipv4.tcp_syncookies" = 1; # protect against SYN flood attacks (denial of service attack)
      "net.ipv4.tcp_rfc1337" = 1; # protection against TIME-WAIT assassination
      "net.ipv4.tcp_timestamps" = 0;

      # TCP optimization
      # TCP Fast Open is a TCP extension that reduces network latency by packing data in the sender’s initial TCP SYN. 
      "net.ipv4.tcp_fastopen" = 3; #  Setting 3 = enable TCP Fast Open for both incoming and outgoing connections:
      "net.ipv4.tcp_congestion_control" = "bbr"; # Bufferbloat mitigations + slight improvement in throughput & latency
      "net.core.default_qdisc" = "cake";

      # ------------------------------------------
      # Virtual Memory
      # ------------------------------------------

      # ASLR memory protection (64-bit systems)
      "vm.mmap_rnd_bits" = 32;
      "vm.mmap_rnd_compat_bits" = 16;

      # CachyOS Optimization : https://github.com/CachyOS/CachyOS-Settings/blob/master/usr/lib/sysctl.d/99-cachyos-settings.conf
      "vm.swappiness" = 0; # I don't use Swap
      "vm.vfs_cache_pressure" = 50;
      "vm.dirty_bytes" = 268435456;
      "vm.dirty_background_bytes" = 67108864;
      "vm.dirty_writeback_centisecs" = 1500;
    };
  };
}
