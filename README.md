# Chain of Trust for SSL Certificates

Purpose:

 The script is for verifying proper Chain of Trust on Cert, Intermediate Cert, Root Cert 
 
[cot.sh](cot.sh) ChainOfTrust(COT) for Cert/Bundle/Root 

Output:
<d1>
<dd>Total of Certs in Bundle is  3</dd>
<dd>c_akid == 40:C2:BD:27:8E:CC:34:83:30:A2:33:D7:FB:6C:B3:F0:B4:2C:80:CE</dd>
<dd>b_akid1 == 3A:9A:85:07:10:67:28:B6:EF:F6:BD:05:41:6E:20:C1:94:DA:0F:DE</dd>
<dd>b_skid1 == 40:C2:BD:27:8E:CC:34:83:30:A2:33:D7:FB:6C:B3:F0:B4:2C:80:CE</dd>
<dd>b_akid2 == D2:C4:B0:D2:91:D4:4C:11:71:B3:61:CB:3D:A1:FE:DD:A8:6A:D4:E3</dd>
<dd>b_skid2 == 3A:9A:85:07:10:67:28:B6:EF:F6:BD:05:41:6E:20:C1:94:DA:0F:DE</dd>
<dd>b_akid3 == D2:C4:B0:D2:91:D4:4C:11:71:B3:61:CB:3D:A1:FE:DD:A8:6A:D4:E3</dd>
<dd>b_skid3 == D2:C4:B0:D2:91:D4:4C:11:71:B3:61:CB:3D:A1:FE:DD:A8:6A:D4:E3</dd>
<dd>Cert is matching Bundle1</dd>
<dd>Root Cert found in Bundle3</dd>
<dd>Bundle1 is matching bundle2</dd>
<dd>Bundle2 is matching bundle3</dd>
</d1>