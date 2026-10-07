{ ... }:
{
  security.pam.loginLimits = [
    # Fixes for rpcs3
    {
      domain = "*";
      type = "hard";
      item = "memlock";
      value = "unlimited";
    }
    {
      domain = "*";
      type = "soft";
      item = "memlock";
      value = "unlimited";
    }
  ];
}
