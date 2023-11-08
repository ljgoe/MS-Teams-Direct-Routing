# Run Each set of commands don't run the whole script at once as it will not work. 
# Yes there are other scripts you can run or download to do this automatically but using this script is good to confirm each line is running and working
# Replace your phone numbers and extensions in this script in Normalisation rules and PSTN Routes
# replace your SBC hostname

# START #
# Connect to MS teams

$UserCredential = Get-Credential
connect-MicrosoftTeams -Credential $UserCredential -ShowProgress $true

# Office 365 Teams Calling Policy Configuration
Set-CsTeamsCallingPolicy -Identity Global -AllowCallGroups  $true
Set-CsTeamsCallingPolicy -Identity Global -AllowPrivateCalling $true 

# Set-CsOnlinePstnUsage
Set-CsOnlinePstnUsage -Identity Global -Usage @{Add = "All" }

#Add Online PSTN Gateway
# Create Teams Direct Routing PSTN Gateways - This is the SIP Gateway being added to MS Teams"
New-CsOnlinePSTNGateway -FQDN 'cube1.lab.testit.vc' `
    -SIPSignalingPort 5061 `
    -ForwardPAI $False `
    -ForwardCallHistory $true `
    -Enabled $True `
    -MediaRelayRoutingLocationOverride AU `
    -MaxConcurrentSessions 24

# Verify the SBC has been created
Get-CsOnlinePSTNGateway -Identity cube1.lab.testit.vc

# Dial Plans - Teams Direct Routing
# Queensland
# Normalization rules for Queensland, Australia, 07 area code
$DPParent = "AU-Queensland"
New-CsTenantDialPlan $DPParent -Description "Normalization rules for Queensland, Australia, 07 area code"
$NR = @()
$NR += New-CsVoiceNormalizationRule -Name ‘AU-Internal-Calls-1xxx’ -Parent $DPParent -Pattern ‘^(1\d{3})$’ -Translation ‘+61712345$1’ -IsInternalExtension $true -InMemory -Description "Translate 1xxx to 61712345xxx" 
$NR += New-CsVoiceNormalizationRule -Name ‘AU-Internal-Calls-44xx’ -Parent $DPParent -Pattern ‘^(44\d{2})$’ -Translation ‘+6121231$1’ -IsInternalExtension $true -InMemory -Description "Translate 44xx to 612123144xx"
$NR += New-CsVoiceNormalizationRule -Name "AU-Emergency" -Parent $DPParent -Pattern '^(000|911|999|112)$'  -Translation '+61000' -InMemory -Description "Translate 000|911|999|112 to 000 Emergency-Calls via SIP GW"

$NR += New-CsVoiceNormalizationRule -Name "AU-Queensland-Local" -Parent $DPParent -Pattern '^([2-9]\d{7})$' -Translation '+617$1' -InMemory -Description "Local number normalization for Queensland, Australia"
$NR += New-CsVoiceNormalizationRule -Name 'AU-TollFree' -Parent $DPParent -Pattern '^(180(0\d{6}|\d{4}))\d*$' -Translation '+61$1' -InMemory -Description "TollFree number normalization for Australia"
$NR += New-CsVoiceNormalizationRule -Name 'AU-Premium' -Parent $DPParent -Pattern '^(19\d{4,8}|13(\d{4}|00\d{6}))$' -Translation '+61$1' -InMemory -Description "Premium number normalization for Australia"
$NR += New-CsVoiceNormalizationRule -Name 'AU-Mobile' -Parent $DPParent -Pattern '^0(([45]\d{8}))$' -Translation '+61$1' -InMemory -Description "Mobile number normalization for Australia"
$NR += New-CsVoiceNormalizationRule -Name 'AU-National' -Parent $DPParent -Pattern '^0([23578]\d{8})\d*(\D+\d+)?$' -Translation '+61$1' -InMemory -Description "National number normalization for Australia"
$NR += New-CsVoiceNormalizationRule -Name 'AU-Service' -Parent $DPParent -Pattern '^(1[12389]\d*)' -Translation '+61$1' -InMemory -Description "Service number normalization for Australia"
$NR += New-CsVoiceNormalizationRule -Name 'AU-International-Ext' -Parent $DPParent -Pattern '^(?:\+|0011)(1|7|2[07]|3[0-46]|39\d|4[013-9]|5[1-8]|6[0-6]|8[1246]|9[0-58]|2[1235689]\d|24[013-9]|242\d|3[578]\d|42\d|5[09]\d|6[789]\d|8[035789]\d|9[679]\d)(?:0)?(\d{6,14})\D+(\d+)$' -Translation '+$1$2;ext=$3' -InMemory -Description "International extension number normalization for Australia"
$NR += New-CsVoiceNormalizationRule -Name 'AU-International' -Parent $DPParent -Pattern '^(?:\+|0011)(1|7|2[07]|3[0-46]|39\d|4[013-9]|5[1-8]|6[0-6]|8[1246]|9[0-58]|2[1235689]\d|24[013-9]|242\d|3[578]\d|42\d|5[09]\d|6[789]\d|8[035789]\d|9[679]\d)(?:0)?(\d{6,14})(\D+\d+)?$' -Translation '+$1$2' -InMemory -Description "International number normalization for Australia"

Set-CsTenantDialPlan -Identity $DPParent -NormalizationRules @{add = $NR }

# NSW-ACT
# Normalization rules for NSW and ACT region, Australia, 02 area code
$DPParent = "AU-NSW-ACT"
New-CsTenantDialPlan $DPParent -Description "Normalization rules for NSW and ACT region, Australia, 02 area code"
$NR = @()
$NR += New-CsVoiceNormalizationRule -Name ‘AU-Internal-Calls-1xxx’ -Parent $DPParent -Pattern ‘^(1\d{3})$’ -Translation ‘+61712345$1’ -IsInternalExtension $true -InMemory -Description "Translate 1xxx to 61712345xxx" 
$NR += New-CsVoiceNormalizationRule -Name ‘AU-Internal-Calls-44xx’ -Parent $DPParent -Pattern ‘^(44\d{2})$’ -Translation ‘+6121231$1’ -IsInternalExtension $true -InMemory -Description "Translate 44xx to 612123144xx"
$NR += New-CsVoiceNormalizationRule -Name "AU-Emergency" -Parent $DPParent -Pattern '^(000|911|999|112)$'  -Translation '+61000' -InMemory -Description "Translate 000|911|999|112 to 000 Emergency-Calls via SIP GW"

$NR += New-CsVoiceNormalizationRule -Name "AU-NSW-ACT-Local" -Parent $DPParent -Pattern '^([2-9]\d{7})$' -Translation '+612$1' -InMemory -Description "Local number normalization for NSW and ACT region, Australia"
$NR += New-CsVoiceNormalizationRule -Name 'AU-TollFree' -Parent $DPParent -Pattern '^(180(0\d{6}|\d{4}))\d*$' -Translation '+61$1' -InMemory -Description "TollFree number normalization for Australia"
$NR += New-CsVoiceNormalizationRule -Name 'AU-Premium' -Parent $DPParent -Pattern '^(19\d{4,8}|13(\d{4}|00\d{6}))$' -Translation '+61$1' -InMemory -Description "Premium number normalization for Australia"
$NR += New-CsVoiceNormalizationRule -Name 'AU-Mobile' -Parent $DPParent -Pattern '^0(([45]\d{8}))$' -Translation '+61$1' -InMemory -Description "Mobile number normalization for Australia"
$NR += New-CsVoiceNormalizationRule -Name 'AU-National' -Parent $DPParent -Pattern '^0([23578]\d{8})\d*(\D+\d+)?$' -Translation '+61$1' -InMemory -Description "National number normalization for Australia"
$NR += New-CsVoiceNormalizationRule -Name 'AU-Service' -Parent $DPParent -Pattern '^(000|1[0125]\d{1,8})$' -Translation '$1' -InMemory -Description "Service number normalization for Australia"
$NR += New-CsVoiceNormalizationRule -Name 'AU-International-Ext' -Parent $DPParent -Pattern '^(?:\+|0011)(1|7|2[07]|3[0-46]|39\d|4[013-9]|5[1-8]|6[0-6]|8[1246]|9[0-58]|2[1235689]\d|24[013-9]|242\d|3[578]\d|42\d|5[09]\d|6[789]\d|8[035789]\d|9[679]\d)(?:0)?(\d{6,14})\D+(\d+)$' -Translation '+$1$2;ext=$3' -InMemory -Description "International extension number normalization for Australia"
$NR += New-CsVoiceNormalizationRule -Name 'AU-International' -Parent $DPParent -Pattern '^(?:\+|0011)(1|7|2[07]|3[0-46]|39\d|4[013-9]|5[1-8]|6[0-6]|8[1246]|9[0-58]|2[1235689]\d|24[013-9]|242\d|3[578]\d|42\d|5[09]\d|6[789]\d|8[035789]\d|9[679]\d)(?:0)?(\d{6,14})(\D+\d+)?$' -Translation '+$1$2' -InMemory -Description "International number normalization for Australia"

Set-CsTenantDialPlan -Identity $DPParent -NormalizationRules @{add = $NR }

# SA-NT-WA
# Normalization rules for WA, SA & NT region, Australia, 08 area code
$DPParent = "AU-SA-NT-WA"
New-CsTenantDialPlan $DPParent -Description "Normalization rules for WA, SA & NT region, Australia, 08 area code"
$NR = @()
$NR += New-CsVoiceNormalizationRule -Name ‘AU-Internal-Calls-1xxx’ -Parent $DPParent -Pattern ‘^(1\d{3})$’ -Translation ‘+61712345$1’ -IsInternalExtension $true -InMemory -Description "Translate 1xxx to 61712345xxx" 
$NR += New-CsVoiceNormalizationRule -Name ‘AU-Internal-Calls-44xx’ -Parent $DPParent -Pattern ‘^(44\d{2})$’ -Translation ‘+6121231$1’ -IsInternalExtension $true -InMemory -Description "Translate 44xx to 612123144xx"
$NR += New-CsVoiceNormalizationRule -Name "AU-Emergency" -Parent $DPParent -Pattern '^(000|911|999|112)$'  -Translation '+61000' -InMemory -Description "Translate 000|911|999|112 to 000 Emergency-Calls via SIP GW"

$NR += New-CsVoiceNormalizationRule -Name "AU-SA-NT-WA-Local" -Parent $DPParent -Pattern '^([2-9]\d{7})$' -Translation '+618$1' -InMemory -Description "Local number normalization for WA, SA & NT region, Australia"
$NR += New-CsVoiceNormalizationRule -Name 'AU-TollFree' -Parent $DPParent -Pattern '^(180(0\d{6}|\d{4}))\d*$' -Translation '+61$1' -InMemory -Description "TollFree number normalization for Australia"
$NR += New-CsVoiceNormalizationRule -Name 'AU-Premium' -Parent $DPParent -Pattern '^(19\d{4,8}|13(\d{4}|00\d{6}))$' -Translation '+61$1' -InMemory -Description "Premium number normalization for Australia"
$NR += New-CsVoiceNormalizationRule -Name 'AU-Mobile' -Parent $DPParent -Pattern '^0(([45]\d{8}))$' -Translation '+61$1' -InMemory -Description "Mobile number normalization for Australia"
$NR += New-CsVoiceNormalizationRule -Name 'AU-National' -Parent $DPParent -Pattern '^0([23578]\d{8})\d*(\D+\d+)?$' -Translation '+61$1' -InMemory -Description "National number normalization for Australia"
$NR += New-CsVoiceNormalizationRule -Name 'AU-Service' -Parent $DPParent -Pattern '^(000|1[0125]\d{1,8})$' -Translation '$1' -InMemory -Description "Service number normalization for Australia"
$NR += New-CsVoiceNormalizationRule -Name 'AU-International-Ext' -Parent $DPParent -Pattern '^(?:\+|0011)(1|7|2[07]|3[0-46]|39\d|4[013-9]|5[1-8]|6[0-6]|8[1246]|9[0-58]|2[1235689]\d|24[013-9]|242\d|3[578]\d|42\d|5[09]\d|6[789]\d|8[035789]\d|9[679]\d)(?:0)?(\d{6,14})\D+(\d+)$' -Translation '+$1$2;ext=$3' -InMemory -Description "International extension number normalization for Australia"
$NR += New-CsVoiceNormalizationRule -Name 'AU-International' -Parent $DPParent -Pattern '^(?:\+|0011)(1|7|2[07]|3[0-46]|39\d|4[013-9]|5[1-8]|6[0-6]|8[1246]|9[0-58]|2[1235689]\d|24[013-9]|242\d|3[578]\d|42\d|5[09]\d|6[789]\d|8[035789]\d|9[679]\d)(?:0)?(\d{6,14})(\D+\d+)?$' -Translation '+$1$2' -InMemory -Description "International number normalization for Australia"

Set-CsTenantDialPlan -Identity $DPParent -NormalizationRules @{add = $NR }

# SAU-VIC-TAS
# Normalization rules for Victoria and Tasmania region, Australia, 03 area code
$DPParent = "AU-VIC-TAS"
New-CsTenantDialPlan $DPParent -Description "Normalization rules for Victoria and Tasmania region, Australia, 03 area code"
$NR = @()
$NR += New-CsVoiceNormalizationRule -Name ‘AU-Internal-Calls-1xxx’ -Parent $DPParent -Pattern ‘^(1\d{3})$’ -Translation ‘+61712345$1’ -IsInternalExtension $true -InMemory -Description "Translate 1xxx to 61712345xxx" 
$NR += New-CsVoiceNormalizationRule -Name ‘AU-Internal-Calls-44xx’ -Parent $DPParent -Pattern ‘^(44\d{2})$’ -Translation ‘+6121231$1’ -IsInternalExtension $true -InMemory -Description "Translate 44xx to 612123144xx"
$NR += New-CsVoiceNormalizationRule -Name "AU-Emergency" -Parent $DPParent -Pattern '^(000|911|999|112)$'  -Translation '+61000' -InMemory -Description "Translate 000|911|999|112 to 000 Emergency-Calls via SIP GW"

$NR += New-CsVoiceNormalizationRule -Name "AU-VIC-TAS-Local" -Parent $DPParent -Pattern '^([2-9]\d{7})$' -Translation '+613$1' -InMemory -Description "Local number normalization for Victoria and Tasmania, Australia"
$NR += New-CsVoiceNormalizationRule -Name 'AU-TollFree' -Parent $DPParent -Pattern '^(180(0\d{6}|\d{4}))\d*$' -Translation '+61$1' -InMemory -Description "TollFree number normalization for Australia"
$NR += New-CsVoiceNormalizationRule -Name 'AU-Premium' -Parent $DPParent -Pattern '^(19\d{4,8}|13(\d{4}|00\d{6}))$' -Translation '+61$1' -InMemory -Description "Premium number normalization for Australia"
$NR += New-CsVoiceNormalizationRule -Name 'AU-Mobile' -Parent $DPParent -Pattern '^0(([45]\d{8}))$' -Translation '+61$1' -InMemory -Description "Mobile number normalization for Australia"
$NR += New-CsVoiceNormalizationRule -Name 'AU-National' -Parent $DPParent -Pattern '^0([23578]\d{8})\d*(\D+\d+)?$' -Translation '+61$1' -InMemory -Description "National number normalization for Australia"
$NR += New-CsVoiceNormalizationRule -Name 'AU-Service' -Parent $DPParent -Pattern '^(000|1[0125]\d{1,8})$' -Translation '$1' -InMemory -Description "Service number normalization for Australia"
$NR += New-CsVoiceNormalizationRule -Name 'AU-International-Ext' -Parent $DPParent -Pattern '^(?:\+|0011)(1|7|2[07]|3[0-46]|39\d|4[013-9]|5[1-8]|6[0-6]|8[1246]|9[0-58]|2[1235689]\d|24[013-9]|242\d|3[578]\d|42\d|5[09]\d|6[789]\d|8[035789]\d|9[679]\d)(?:0)?(\d{6,14})\D+(\d+)$' -Translation '+$1$2;ext=$3' -InMemory -Description "International extension number normalization for Australia"
$NR += New-CsVoiceNormalizationRule -Name 'AU-International' -Parent $DPParent -Pattern '^(?:\+|0011)(1|7|2[07]|3[0-46]|39\d|4[013-9]|5[1-8]|6[0-6]|8[1246]|9[0-58]|2[1235689]\d|24[013-9]|242\d|3[578]\d|42\d|5[09]\d|6[789]\d|8[035789]\d|9[679]\d)(?:0)?(\d{6,14})(\D+\d+)?$' -Translation '+$1$2' -InMemory -Description "International number normalization for Australia"

Set-CsTenantDialPlan -Identity $DPParent -NormalizationRules @{add = $NR }


#Check Rules have been added
(Get-CsTenantDialPlan “Global”).NormalizationRules | FT Name, Description, Pattern, Translation, IsInternalExtension


# Teams Direct Routing PSTN Voice Components
# 1. Create PSTN Usages
# 2. Create PSTN Routes
# 3. Create PSTN Policies

$Prefix = 'AU-'
#Create PSTN Usages
Set-CsOnlinePstnUsage -Identity global -Usage @{add = "AU-Internal-Calls-1xxx" }
Set-CsOnlinePstnUsage -Identity global -Usage @{add = "AU-Internal-Calls-44xx" }
Set-CsOnlinePstnUsage -Identity global -Usage @{add = "AU-Emergency" }

Set-CsOnlinePSTNUsage -Identity global -Usage @{Add = "AU-Queensland-Local" }
Set-CsOnlinePSTNUsage -Identity global -Usage @{Add = "AU-NSW-ACT-Local" }
Set-CsOnlinePSTNUsage -Identity global -Usage @{Add = "AU-SA-NT-WA-Local"}
Set-CsOnlinePSTNUsage -Identity global -Usage @{Add = "AU-VIC-TAS-Local"}

Set-CsOnlinePSTNUsage -Identity global -Usage @{Add = "AU-National" } 
Set-CsOnlinePSTNUsage -Identity global -Usage @{Add = "AU-Mobile" } 
Set-CsOnlinePSTNUsage -Identity global -Usage @{Add = "AU-Premium" } 
Set-CsOnlinePSTNUsage -Identity global -Usage @{Add = "AU-International" } 

#Check 
Get-CSOnlinePSTNUsage

$PSTNGW01 = Get-CSOnlinePSTNGateway -identity 'cube1.lab.testit.vc'
# $PSTNGW02 = Get-CSOnlinePSTNGateway -identity 'SBC.com'
# $PSTNGW03 = Get-CSOnlinePSTNGateway -identity 'sbc.com'
# add additional gatewas to the commands below e.g @{add = $PSTNGW01.identity, $PSTNGW02.identity, $PSTNGW03.identity } 
# New-CsOnlineVoiceRoute -Name "AU-Internal-Calls-1xxx" -Priority 8 -OnlinePstnUsages "AU-Internal-Calls-1xxx" -OnlinePstnGatewayList @{add = $PSTNGW01.identity, $PSTNGW02.identity, $PSTNGW03.identity } -NumberPattern '^(1\d{3})$' -Description "Route 1xxx via via SIP GW"

#PSTN Routes
New-CsOnlineVoiceRoute -Name "AU-Internal-Calls-1xxx" -Priority 8 -OnlinePstnUsages "AU-Internal-Calls-1xxx" -OnlinePstnGatewayList @{add = $PSTNGW01.identity} -NumberPattern '^(1\d{3})$' -Description "Route 1xxx via SIP GW" 
New-CsOnlineVoiceRoute -Name "AU-Internal-Calls-44xx" -Priority 9 -OnlinePstnUsages "AU-Internal-Calls-44xx" -OnlinePstnGatewayList @{add = $PSTNGW01.identity} -NumberPattern '^(44\d{2})$' -Description "Route 44xx via SIP GW" 

New-CsOnlineVoiceRoute -Name "AU-Emergency" -Priority 0 -OnlinePstnUsages "AU-Emergency" -OnlinePstnGatewayList @{add = $PSTNGW01.identity} -NumberPattern '^\+61000$' -Description "Emergency-Calls via SIP GW" 
New-CsOnlineVoiceRoute -Name "AU-Service" -Priority 6 -OnlinePstnUsages "AU-Service" -OnlinePstnGatewayList @{add = $PSTNGW01.identity} -NumberPattern '^\+61(1[12389]\d*)$' -Description "Service-Calls via SIP GW" 
New-CsOnlineVoiceRoute -Name "AU-Mobile" -Priority 2 -OnlinePstnUsages "AU-Mobile" -OnlinePstnGatewayList @{add = $PSTNGW01.identity} -NumberPattern '^\+61([45]\d{8})$' -Description "Mobile routing for Australia" | Out-Null
New-CsOnlineVoiceRoute -Name "AU-TollFree" -Priority 3 -OnlinePstnUsages "AU-Local" -OnlinePstnGatewayList @{add = $PSTNGW01.identity} -NumberPattern '^\+61180(0\d{6}|\d{4})$' -Description "TollFree routing for Australia" | Out-Null
New-CsOnlineVoiceRoute -Name "AU-Premium" -Priority 4 -OnlinePstnUsages "AU-Premium" -OnlinePstnGatewayList @{add = $PSTNGW01.identity} -NumberPattern '^\+6119\d{4,8}|13(\d{4}|00\d{6})$' -Description "Premium routing for Australia" | Out-Null
New-CsOnlineVoiceRoute -Name "AU-National" -Priority 5 -OnlinePstnUsages "AU-National" -OnlinePstnGatewayList @{add = $PSTNGW01.identity} -NumberPattern '^\+610?[23578]\d{8}' -Description "National routing for  Australia" | Out-Null
New-CsOnlineVoiceRoute -Name "AU-International" -Priority 7 -OnlinePstnUsages "AU-International" -OnlinePstnGatewayList @{add = $PSTNGW01.identity} -NumberPattern '^\+((1[2-9]\d\d[2-9]\d{6})|((?!(61))([2-9]\d{6,14})))' -Description "International routing for Australia" | Out-Null


#check
Get-CsOnlineVoiceRoute

# Translate phone numbers to an alternate format
New-CsTeamsTranslationRule -identity 'AddPlus61' -Pattern '^(\d{9})$' -Translation '+61$1'
New-CsTeamsTranslationRule -identity 'StripPlus61' -Pattern '^\+61(\d*)$' -Translation '$1'


# Check Rules
Get-CsTeamsTranslationRule

# Assign, configure, and list number manipulation rules on SBCs, use below if you have multiple gateways
# Set-CSOnlinePSTNGateway @{add = $PSTNGW01.identity, $PSTNGW02.identity, $PSTNGW03.identity } -InboundTeamsNumberTranslationRules 'AddPlus61' -InboundPstnNumberTranslationRules 'AddPlus61'
# Set-CSOnlinePSTNGateway @{add = $PSTNGW01.identity, $PSTNGW02.identity, $PSTNGW03.identity } -OutboundPSTNNumberTranslationRules 'StripPlus61' -OutboundTeamsNumberTranslationRules 'StripPlus61'

Set-CSOnlinePSTNGateway $PSTNGW01.identity -InboundTeamsNumberTranslationRules 'AddPlus61' -InboundPstnNumberTranslationRules 'AddPlus61'
Set-CSOnlinePSTNGateway $PSTNGW01.identity -OutboundPSTNNumberTranslationRules 'StripPlus61' -OutboundTeamsNumberTranslationRules 'StripPlus61'


# Check Rules
Get-CSOnlinePSTNGateway 

#PSTN Policies
$Prefix = 'AU-'
# New-CsOnlineVoiceRoutingPolicy  -Identity ($Prefix + 'Queensland-Local') -OnlinePstnUsages  @{add = ($Prefix + 'Emergency'), ($Prefix + 'Queensland-Local'), ($Prefix + 'Service') }

New-CsOnlineVoiceRoutingPolicy  -Identity ($Prefix + 'National-Calling')  -OnlinePstnUsages  @{add = ($Prefix + 'Emergency'), ($Prefix + 'National'), ($Prefix + 'Internal-Calls-1xxx'), ($Prefix + 'Internal-Calls-44xx'), ($Prefix + 'Internal-Calls-xxxx'), ($Prefix + 'Mobile') }
New-CsOnlineVoiceRoutingPolicy  -Identity ($Prefix + 'International-Calling') -OnlinePstnUsages  @{add = ($Prefix + 'Emergency'), ($Prefix + 'National'), ($Prefix + 'Internal-Calls-1xxx'), ($Prefix + 'Internal-Calls-44xx'), ($Prefix + 'Internal-Calls-xxxx'), ($Prefix + 'Mobile'), ($Prefix + 'International') }

## Enable your test user

# Ensure that the user(s) is/are homed online
Get-CsOnlineUser -Identity user1@lab.testit.vc | fl RegistrarPool,OnPremLineUri,LineUri
Get-CsOnlineUser -Identity user1@lab.testit.vc

# Configure the users phone number and enable enterprise voice (licence required). Note: Change the number below to suit
Set-CsPhoneNumberAssignment -Identity "user1@lab.testit.vc" -EnterpriseVoiceEnabled $true 
Set-CsPhoneNumberAssignment -Identity "user1@lab.testit.vc" -PhoneNumber "+61712345001" -PhoneNumberType DirectRouting

# Assign the voice routing policy (which determines where they are allowed to call) and the dialplan (Which determines which location they are in e.g Queensland) to a user
Grant-CsOnlineVoiceRoutingPolicy -Identity "user1@lab.testit.vc" -PolicyName "AU-International-Calling"
Grant-CsTenantDialPlan -Identity "user1@lab.testit.vc" -PolicyName "AU-Queensland"

Get-CsOnlineUser -Identity user1@lab.testit.vc
