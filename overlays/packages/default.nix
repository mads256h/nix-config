final: prev: rec { 
  vifmimg = prev.callPackage ../../packages/vifmimg { };
  ps3netsrv-go = prev.callPackage ../../packages/ps3netsrv-go { };
}
