{ pkgs, ... }:
{
  # Automatically download new youtube videos daily
  # TODO: This stops downloading if any errors occur in the for loop, we should keep going.
  systemd.services."update-yt" = {
    serviceConfig = {
      Type = "oneshot";
      User = "mads";
    };
    path = with pkgs; [ yt-dlp ];
    script = ''
      cd "/mnt/share/Mads/Videoklip/yt/"
      for D in */; do
        pushd "''${D}"
        echo "Updating ''${D%/}..."

        if [ -f "download.txt" ]; then
          cat "download.txt" | xargs yt-dlp -f bestvideo+bestaudio --add-metadata --embed-subs --all-subs --download-archive .archive -i
        else
          echo "No download.txt found in ''${D} skipping..."
        fi
        popd
      done
      exit 0
    '';
  };

  systemd.timers."update-yt" = {
    wantedBy = [ "timers.target" ];
    partOf = [ "update-yt.service" ];
    timerConfig = {
      OnCalendar = "daily";
      Unit = "update-yt.service";
    };
  };
}
