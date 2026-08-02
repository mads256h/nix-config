{ sysconfig, ... }:
{
  security.apparmor.enable = sysconfig.baremetal;
  security.apparmor.killUnconfinedConfinables = true;

  nix.settings.allowed-users = [ "@wheel" ];

  boot.kernelParams = [ "debugfs=off" ];

  # Keep up to date with 
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

    ## Thunderbolt:
    ## Disable Thunderbolt modules to prevent certain DMA attacks.
    ##
    ## https://en.wikipedia.org/wiki/Thunderbolt_(interface)#Security_vulnerabilities
    ##
    "intel-wmi-thunderbolt"
    "thunderbolt"
    "thunderbolt_net"

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
    "econet"
    "eepro100"
    "eth1394"
    "ipx"
    "n-hdlc"
    "netrom"
    "p8022"
    "p8023"
    "psnap"
    "rose"
    "x25"

    ## Network Protocol - Asynchronous Transfer Mode (ATM):
    ##
    "atm"
    "ueagle-atm"
    "usbatm"
    "xusbatm"

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


    ## Amateur Radios:
    ##
    "hamradio"

    ## Floppy Disks:
    ##
    "floppy"

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
  ];
}
