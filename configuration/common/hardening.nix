{
  sysconfig,
  lib,
  config,
  ...
}:
{
  security.apparmor = {
    enable = sysconfig.baremetal;
    killUnconfinedConfinables = true;
  };

  # Disable hibernation on servers
  security.protectKernelImage = sysconfig.server;

  nix.settings.allowed-users = [ "@wheel" ];

  # Disable debugfs
  # Disable vsyscall
  boot.kernelParams = [
    "debugfs=off"
    "vsyscall=none"
  ]
  # Disable 32-bit binaries on servers
  ++ lib.optionals sysconfig.server [
    "ia32_emulation=0"
  ];

  # Keep up to date with https://github.com/Kicksecure/security-misc
  boot.blacklistedKernelModules = [
    ## FireWire (IEEE 1394):
    ## Disable IEEE 1394 (FireWire/i.LINK/Lynx) modules to prevent certain DMA attacks.
    ##
    ## https://en.wikipedia.org/wiki/IEEE_1394#Security_issues
    ##
    "dv1394"
    "firewire-core"
    "firewire-ohci"
    "firewire-net"
    "firewire-sbp2"
    "ohci1394"
    "raw1394"
    "sbp2"
    "video1394"
    "nosy"
    "firedtv"

    ## Global Positioning Systems (GPS):
    ## Disable GPS-related modules like GNSS (Global Navigation Satellite System).
    ##
    "garmin_gps"
    "gnss"
    "gnss-mtk"
    "gnss-serial"
    "gnss-sirf"
    "gnss-ubx"
    "gnss-usb"

    ## Thunderbolt:
    ## Disable Thunderbolt modules to prevent certain DMA attacks.
    ##
    ## https://en.wikipedia.org/wiki/Thunderbolt_(interface)#Security_vulnerabilities
    ##
    "intel-wmi-thunderbolt"
    "thunderbolt"
    "thunderbolt_net"
    "thunderbolt_stream"

    ## File Systems:
    ## Disable uncommon file systems to reduce attack surface.
    ## HFS/HFS+ are legacy Apple file systems that may be required depending on the EFI partition format.
    ##
    ## https://docs.kernel.org/filesystems/index.html
    ## https://github.com/secureblue/secureblue/tree/live/files/system/usr/lib/modprobe.d
    ##
    "adfs"
    "affs"
    "afs"
    "befs"
    "ceph"
    "coda"
    "cramfs"
    "ecryptfs"
    "freevxfs"
    "hfs"
    "hfsplus"
    "jffs2"
    "jfs"
    "kafs"
    "minix"
    "nilfs2"
    "ocfs2"
    "orangefs"
    "reiserfs"
    "romfs"
    "sysv"
    "ubifs"
    "udf"
    "ufs"
    "zonefs"

    "cifs"
    "cifs_md4"
    "ksmbd"

    # https://documentation.suse.com/sle-ha/12-SP5/html/SLE-HA-all/cha-ha-storage-dlm.html
    "dlm"
    # https://en.wikipedia.org/wiki/OCFS2
    "ocfs2_dlm"
    "ocfs2_dlmfs"
    "ocfs2_nodemanager"
    "ocfs2_stackglue"
    "ocfs2_stack_o2cb"
    "ocfs2_stack_user"

    ## Network Protocols:
    ## Disable rare and unneeded network protocols that are a common source of unknown vulnerabilities.
    ## Previously had blacklisted eepro100 and eth1394.
    ##
    ## https://tails.boum.org/blueprint/blacklist_modules/
    ## https://fedoraproject.org/wiki/Security_Features_Matrix#Blacklist_Rare_Protocols
    ## https://git.launchpad.net/ubuntu/+source/kmod/tree/debian/modprobe.d/blacklist-rare-network.conf?h=ubuntu/disco
    ## https://github.com/Kicksecure/security-misc/pull/234#issuecomment-2230732015
    ##
    "af_802154"
    "appletalk"
    "ax25"
    "decnet"
    "dccp"
    "xt_dccp"
    "econet"
    "eepro100"
    "eth1394"
    "ipx"
    "n-hdlc"
    "hdlcdrv"
    "netrom"
    "p8022"
    "p8023"
    "psnap"
    "rose"
    "x25"
    "mctp-serial"
    "mctp-usb"
    "mctp-i3c"
    "batman-adv"
    "rxrpc"

    ## Network Protocol - Asynchronous Transfer Mode (ATM):
    ##
    "atm"
    "ueagle-atm"
    "usbatm"
    "xusbatm"
    "pppoeatm"
    "atmtcp"

    ## Network Protocol - Controller Area Network (CAN):
    ##
    "c_can"
    "c_can_pci"
    "c_can_platform"
    "can"
    "can-bcm"
    "can-dev"
    "can-gw"
    "can-isotp"
    "can-raw"
    "can-j1939"
    "can327"
    "ifi_canfd"
    "janz-ican3"
    "m_can"
    "m_can_pci"
    "m_can_platform"
    "phy-can-transceiver"
    "slcan"
    "ucan"
    "vxcan"
    "vcan"

    ## Network Protocol - Transparent Inter Process Communication (TIPC):
    ##
    "tipc"
    "tipc_diag"

    ## Network Protocol - Reliable Datagram Sockets (RDS):
    ##
    "rds"
    "rds_rdma"
    "rds_tcp"

    ## Network Protocol - Stream Control Transmission Protocol (SCTP):
    ##
    "sctp"
    "sctp_diag"
    "xt_sctp"

    # esp4 and esp6 provide support for Encapsulating Security Payload, part of IPSec.
    "esp4"
    "esp4_offload"
    "esp6"
    "esp6_offload"

    # More IPSec functionality
    # https://cateee.net/lkddb/web-lkddb/NET_IPVTI.html
    # https://cateee.net/lkddb/web-lkddb/IPV6_VTI.html
    "ip_vti"
    "ip6_vti"

    # xfrm, another part of IPSec involved in related exploits
    "nft_xfrm"
    "xfrm4_tunnel"
    "xfrm6_tunnel"
    "xfrm_algo"
    "xfrm_interface"
    "xfrm_ipcomp"
    "xfrm_iptfs"
    "xfrm_user"

    # disable remaining ipsec modules
    "ah4"
    "ah6"
    "ipcomp"
    "ipcomp6"
    #"af_key"

    # disable l2tp (depends on ipsec)
    "l2tp_core"
    "l2tp_debugfs"
    "l2tp_eth"
    "l2tp_ip"
    "l2tp_ip6"
    "l2tp_netlink"
    "l2tp_ppp"
    "xt_l2tp"

    # legacy interfaces
    # https://en.wikipedia.org/wiki/Parallel_port
    "parport"
    "parport_cs"
    "parport_pc"
    "parport_serial"
    "pps_parport"
    "i2c-parport"
    # https://github.com/torvalds/linux/blob/master/drivers/char/ppdev.c
    "ppdev"
    # https://github.com/torvalds/linux/blob/master/drivers/char/lp.c
    "lp"

    ## Amateur Radios:
    ##
    "hamradio"

    ## Floppy Disks:
    ##
    "floppy"

    # android tablet support
    "x86-android-tablets"

    # block loading cdrom
    "cdrom"
    "sr_mod"

    # https://en.wikipedia.org/wiki/Game_port
    "gameport"

    ## Framebuffer (fbdev):
    ## Video drivers are known to be buggy, cause kernel panics, and are generally only used by legacy devices.
    ## These were all previously blacklisted.
    ##
    ## https://docs.kernel.org/fb/index.html
    ## https://en.wikipedia.org/wiki/Linux_framebuffer
    ## https://git.launchpad.net/ubuntu/+source/kmod/tree/debian/modprobe.d/blacklist-framebuffer.conf?h=ubuntu/disco
    ##
    "aty128fb"
    "atyfb"
    "cirrusfb"
    "cyber2000fb"
    "cyblafb"
    "gx1fb"
    "hgafb"
    "i810fb"
    "intelfb"
    "kyrofb"
    "lxfb"
    "matroxfb_base"
    "neofb"
    "nvidiafb"
    "pm2fb"
    "radeonfb"
    "rivafb"
    "s1d13xxxfb"
    "savagefb"
    "sisfb"
    "sstfb"
    "tdfxfb"
    "tridentfb"
    "vesafb"
    "vfb"
    "viafb"
    "vt8623fb"
    "udlfb"

    ## Replaced Modules:
    ## These legacy drivers have all been entirely replaced and superseded by newer drivers.
    ## Many of these were previously blacklisted.
    ##
    ## https://git.launchpad.net/ubuntu/+source/kmod/tree/debian/modprobe.d/blacklist.conf?h=ubuntu/disco
    ##
    "asus_acpi"
    "bcm43xx"
    "brcm80211"
    "de4x5"
    "prism54"

    ## RNDIS:
    ## Disable as believed to have unfixable buffer overflow issues impossible to make secure.
    ## Used by some network devices common with Android USB tethering.
    ##
    ## https://en.wikipedia.org/wiki/RNDIS
    ## https://lkml.org/lkml/2022/11/23/728
    ## https://lore.kernel.org/lkml/2023071333-wildly-playroom-878b@gregkh/
    ##
    "rndis_host"
    "usb_f_rndis"

    # GPIB
    # https://en.wikipedia.org/wiki/GPIB
    # https://github.com/torvalds/linux/blob/master/drivers/gpib/common/gpib_os.c
    "gpib_common"
    # https://github.com/torvalds/linux/blob/master/drivers/gpib/agilent_82350b/agilent_82350b.c
    "agilent_82350b"
    # https://github.com/torvalds/linux/blob/master/drivers/gpib/agilent_82357a/agilent_82357a.c
    "agilent_82357a"
    # https://github.com/torvalds/linux/blob/master/drivers/gpib/cb7210/cb7210.c
    "cb7210"
    # https://github.com/torvalds/linux/blob/master/drivers/gpib/cec/cec_gpib.c
    "cec_gpib"
    # https://github.com/torvalds/linux/blob/master/drivers/gpib/ines/ines_gpib.c
    "ines_gpib"
    # https://github.com/torvalds/linux/blob/master/drivers/gpib/lpvo_usb_gpib/lpvo_usb_gpib.c
    "lpvo_usb_gpib"
    # https://github.com/torvalds/linux/blob/master/drivers/gpib/nec7210/nec7210.c
    "nec7210"
    # https://github.com/torvalds/linux/blob/master/drivers/gpib/ni_usb/ni_usb_gpib.c
    "ni_usb_gpib"
    # https://github.com/torvalds/linux/blob/master/drivers/gpib/tms9914/tms9914.c
    "tms9914"
    # https://github.com/torvalds/linux/tree/master/drivers/gpib/tnt4882
    "tnt4882"

    # NFC
    "nfc"

    # kernel debugging / development modules
    # https://linux.die.net/man/8/mce-inject
    "mce-inject"
    # https://github.com/torvalds/linux/blob/master/mm/hwpoison-inject.c
    "hwpoison-inject"
    # https://github.com/torvalds/linux/blob/master/drivers/pci/pcie/aer_inject.c
    "aer_inject"
    # https://github.com/torvalds/linux/blob/master/drivers/scsi/scsi_debug.c
    "scsi_debug"
    # https://github.com/torvalds/linux/blob/master/drivers/usb/serial/usb_debug.c
    "usb_debug"
    # https://github.com/torvalds/linux/blob/master/kernel/trace/ring_buffer_benchmark.c
    "ring_buffer_benchmark"
    # https://github.com/torvalds/linux/blob/master/drivers/gpu/drm/vkms/vkms_drv.c
    "vkms"
    # diagnostic module for vsock: https://man7.org/linux/man-pages/man7/vsock.7.html
    "vsock_diag"
    # diagnostic module for xdp: https://github.com/torvalds/linux/blob/master/net/xdp/xsk_diag.c
    "xsk_diag"
    # https://docs.kernel.org/admin-guide/media/visl.html
    # https://github.com/torvalds/linux/tree/master/drivers/media/test-drivers/visl
    "visl"
    # https://github.com/torvalds/linux/blob/master/drivers/media/test-drivers/vim2m.c
    "vim2m"
    # https://docs.kernel.org/admin-guide/media/vimc.html
    # https://github.com/torvalds/linux/tree/master/drivers/media/test-drivers/vimc
    "vimc"
    # disable vivid
    "vivid"
    # https://github.com/torvalds/linux/blob/master/drivers/usb/gadget/udc/dummy_hcd.c
    "dummy_hcd"
    # https://manpages.ubuntu.com/manpages/bionic/man4/nandsim.4freebsd.html
    # https://github.com/torvalds/linux/blob/master/drivers/mtd/nand/raw/nandsim.c
    "nandsim"
    # https://github.com/torvalds/linux/blob/master/drivers/mtd/devices/mtdram.c
    "mtdram"

    # kernel debugging modules for blind users
    "speakup"
    "speakup_acntsa"
    "speakup_apollo"
    "speakup_audptr"
    "speakup_bns"
    "speakup_dectlk"
    "speakup_ltlk"
    "speakup_soft"
    "speakup_spkout"
    "speakup_txprt"

    # kernel message logging over UDP
    # https://www.kernel.org/doc/Documentation/networking/netconsole.txt
    "netconsole"

    # NFS
    # Core NFS client functionality
    "nfs"
    # NFS version 3 support
    "nfsv3"
    # NFS version 4 support
    "nfsv4"
    # NFSv4.1 file-layout support
    "nfs_layout_nfsv41_files"
    # NFSv4 flexible file-layout support
    "nfs_layout_flexfiles"
    # NFS server functionality
    "nfsd"
    # NFSv3 file locking (NLM)
    "lockd"
    # Grace-period handling for NFS locks
    "grace"
    # NFSv3 ACL support
    "nfs_acl"

    # Sunrpc
    # Sun RPC framework
    "sunrpc"
    # RPCSEC_GSS authentication framework
    "auth_rpcgss"
    # Kerberos authentication for RPC
    "rpcsec_gss_krb5"

  ]
  ++ lib.optionals (!sysconfig.graphical) [
    ## Joysticks:
    ##
    ## https://docs.kernel.org/input/joydev/joystick.html
    ##
    "joydev"

    ## USB Video Device Class:
    ## Disable the USB-based video streaming driver for devices like some webcams and digital camcorders.
    ##
    "uvcvideo"
  ]
  ++ lib.optionals sysconfig.server [
    ## Bluetooth:
    ## Disable Bluetooth to reduce the attack surface due to its long history of security vulnerabilities.
    ## Replaced with a privacy and security preserving default Bluetooth configuration for better usability.
    ##
    ## https://en.wikipedia.org/wiki/Bluetooth#History_of_security_concerns
    ## https://github.com/Kicksecure/security-misc/pull/145
    ##
    "bluetooth"
    "bluetooth_6lowpan"
    "bt3c_cs"
    "btbcm"
    "btintel"
    "btmrvl"
    "btmrvl_sdio"
    "btmtk"
    "btmtksdio"
    "btmtkuart"
    "btnxpuart"
    "btqca"
    "btrsi"
    "btrtl"
    "btsdio"
    "btusb"
    "virtio_bt"
  ];

  boot.kernel.sysctl = {
    # Disable kexec
    "kernel.kexec_load_disabled" = 1;

    # Only allow CAP_SYS_ADMIN or CAP_BPF to call bpf(), and don't allow changing the value
    "kernel.unprivileged_bpf_disabled" = 1;

    # Only allow admins CAP_SYS_ADMIN or CAP_SYS_PTRACE to ptrace
    "kernel.yama.ptrace_scope" = if sysconfig.server then 2 else 1;

    # Harden jit for all users
    "net.core.bpf_jit_harden" = 2;

    # Protect against time-wait assassination
    # Drop RST packets for sockets in the time-wait state
    "net.ipv4.tcp_rfc1337" = 1;
  };

  # Only allow wheel users to issue su
  security.pam.services = {
    su.requireWheel = true;
    su-l.requireWheel = true;
  };

  # Hardened memory allocator
  environment.memoryAllocator = lib.attrsets.optionalAttrs sysconfig.server {
    provider = "graphene-hardened";
  };
}
