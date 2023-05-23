{
  lib,
  ...
}: {
  boot.kernelPatches = [
    {
      name = "disable-network";
      patch = null;
      extraStructuredConfig = with lib.kernel; {
        ETHERNET = no;
        SCSI_CXGB3_ISCSI = no;
        SCSI_BNX2_ISCSI = no;
        SCSI_BNX2X_FCOE = no;
        USB_NET_DRIVERS = no;
      };
    }
  ];
}
