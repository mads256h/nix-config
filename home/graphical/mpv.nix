{ config, pkgs, ... }:
{
  programs.mpv = {
    enable = true;
    config = {
      vo = "gpu-next";
      gpu-api = "opengl"; # Remove when VK_ERROR_OUT_OF_DEVICE_MEMORY is fixed
      ao = "pipewire";
      hwdec = "auto";
      alang = "eng,en,da";
    };
  };
}
