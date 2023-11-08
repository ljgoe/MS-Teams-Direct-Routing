<a name="readme-top"></a>
<!--

<!-- PROJECT LOGO -->
<br />
<div align="center">
  <a href="https://testit.vc/">
    <img src="https://testit.vc/wp-content/uploads/2023/11/logo.png" alt="Logo" width="80" height="80">
  </a>
  <h3 align="center">Microsoft Teams Direct Routing using powershell</h3>
</div>

<br />
<div align="Left">
  <a href="https://testit.vc/">
    <img src="https://testit.vc/wp-content/uploads/2023/11/MS-Teams-Direct-Routing-1024x502.png" alt="diagram" width="650" height="300">
</div>

### MS-Teams-Direct-Routing

Read through the script to verify it isn’t going to do anything malicious (which you should always do before running someone else’s code)


The script will do the following:
```
 
1.	Connect to O365 tenant
2.	Set Office 365 Teams Calling Policy Configuration
3.	Set PSTN Usage
4.	Create Teams Direct Routing PSTN Gateways - This is the Cisco CUBE Gateway being added to MS Teams
5.	Set the Dial Plans  for each State in Australia
a.	Normalization rules for Queensland, Australia, 07 area code
b.	Normalization rules for NSW and ACT region, Australia, 02 area code
c.	Normalization rules for WA, SA & NT region, Australia, 08 area code
d.	Normalization rules for Victoria and Tasmania region, Australia, 03 area code
6.	Teams Direct Routing PSTN Voice Components
1.	Create PSTN Usages
2.	Create PSTN Routes
3.	Create PSTN Policies
7.	Normalise phone numbers dialled.
8.	Assign, configure, and list number manipulation rules on SBCs
9.	PSTN Policies
10.	Apply polices to a test user
 


```
