# Only God knows what's going on here
# Based on https://github.com/BJDubb/codex-full-output/blob/main/src/Store.ps1

$now = [DateTime]::UtcNow
$created = $now.ToString('yyyy-MM-ddTHH:mm:ss.fffZ')
$cookieExpires = $now.AddDays(27).ToString('yyyy-MM-ddTHH:mm:ss.fffZ')
$syncExpires = $now.AddMinutes(5).ToString('yyyy-MM-ddTHH:mm:ss.fffZ')
$lastChange = $now.AddYears(-2).ToString('yyyy-MM-ddTHH:mm:ss.fffffffZ')
$currentTime = $now.AddMilliseconds(7).ToString('yyyy-MM-ddTHH:mm:ss.fffZ')

$cookieRequest = @"
<Envelope
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema"
    xmlns="http://www.w3.org/2003/05/soap-envelope">
    <Header>
        <Action d3p1:mustUnderstand="1"
            xmlns:d3p1="http://www.w3.org/2003/05/soap-envelope"
            xmlns="http://www.w3.org/2005/08/addressing">http://www.microsoft.com/SoftwareDistribution/Server/ClientWebService/GetCookie
        </Action>
        <MessageID
            xmlns="http://www.w3.org/2005/08/addressing">urn:uuid:$([guid]::NewGuid())
        </MessageID>
        <To d3p1:mustUnderstand="1"
            xmlns:d3p1="http://www.w3.org/2003/05/soap-envelope"
            xmlns="http://www.w3.org/2005/08/addressing">https://fe3.delivery.mp.microsoft.com/ClientWebService/client.asmx
        </To>
        <Security d3p1:mustUnderstand="1"
            xmlns:d3p1="http://www.w3.org/2003/05/soap-envelope"
            xmlns="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">
            <Timestamp
                xmlns="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd">
                <Created>$created</Created>
                <Expires>$cookieExpires</Expires>
            </Timestamp>
            <WindowsUpdateTicketsToken d4p1:id="ClientMSA"
                xmlns:d4p1="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"
                xmlns="http://schemas.microsoft.com/msus/2014/10/WindowsUpdateAuthorization">
                <TicketType Name="MSA" Version="1.0" Policy="MBI_SSL">
                    <User />
                </TicketType>
            </WindowsUpdateTicketsToken>
        </Security>
    </Header>
    <Body>
        <GetCookie
            xmlns="http://www.microsoft.com/SoftwareDistribution/Server/ClientWebService">
            <oldCookie />
            <lastChange>$lastChange</lastChange>
            <currentTime>$currentTime</currentTime>
            <protocolVersion>1.40</protocolVersion>
        </GetCookie>
    </Body>
</Envelope>
"@

$Headers = @{
	"Content-Type" = "application/soap+xml; charset=utf-8"
}
$Parameters = @{
	Uri             = "https://fe3.delivery.mp.microsoft.com/ClientWebService/client.asmx"
	Method          = "Post"
	Body            = $cookieRequest
	Headers         = $Headers
	UseBasicParsing = $true
	Verbose         = $true
}
$cookie = (Invoke-RestMethod @Parameters).GetElementsByTagName('EncryptedData')[0].FirstChild.Data

# https://apps.microsoft.com/detail/9N4WGH0Z6VHQ
$Parameters = @{
	Uri             = "https://storeedgefd.dsx.mp.microsoft.com/v9.0/products/9N4WGH0Z6VHQ?market=US&locale=en-us&deviceFamily=Windows.Desktop"
	Method          = "Get"
	UseBasicParsing = $true
	Verbose         = $true
}
$categoryId = (((Invoke-RestMethod @Parameters).Payload.Skus[0].FulfillmentData | ConvertFrom-Json).WuCategoryId).ToString()

$syncRequest = @"
<s:Envelope
    xmlns:a="http://www.w3.org/2005/08/addressing"
    xmlns:s="http://www.w3.org/2003/05/soap-envelope">
    <s:Header>
        <a:Action s:mustUnderstand="1">http://www.microsoft.com/SoftwareDistribution/Server/ClientWebService/SyncUpdates</a:Action>
        <a:MessageID>urn:uuid:$([guid]::NewGuid())</a:MessageID>
        <a:To s:mustUnderstand="1">https://fe3.delivery.mp.microsoft.com/ClientWebService/client.asmx</a:To>
        <o:Security s:mustUnderstand="1"
            xmlns:o="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">
            <Timestamp
                xmlns="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd">
                <Created>$created</Created>
                <Expires>$syncExpires</Expires>
            </Timestamp>
            <wuws:WindowsUpdateTicketsToken wsu:id="ClientMSA"
                xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"
                xmlns:wuws="http://schemas.microsoft.com/msus/2014/10/WindowsUpdateAuthorization">
                <TicketType Name="MSA" Version="1.0" Policy="MBI_SSL">Retail</TicketType>
            </wuws:WindowsUpdateTicketsToken>
        </o:Security>
    </s:Header>
    <s:Body>
        <SyncUpdates
            xmlns="http://www.microsoft.com/SoftwareDistribution/Server/ClientWebService">
            <cookie>
                <Expiration>2045-03-11T02:02:48Z</Expiration>
                <EncryptedData>$cookie</EncryptedData>
            </cookie>
            <parameters>
                <ExpressQuery>false</ExpressQuery>
                <InstalledNonLeafUpdateIDs>
                    <int>1</int>
                    <int>2</int>
                    <int>11</int>
                    <int>23110993</int>
                </InstalledNonLeafUpdateIDs>
                <OtherCachedUpdateIDs />
                <SkipSoftwareSync>false</SkipSoftwareSync>
                <NeedTwoGroupOutOfScopeUpdates>true</NeedTwoGroupOutOfScopeUpdates>
                <FilterAppCategoryIds>
                    <CategoryIdentifier>
                        <Id>$categoryId</Id>
                    </CategoryIdentifier>
                </FilterAppCategoryIds>
                <TreatAppCategoryIdsAsInstalled>true</TreatAppCategoryIdsAsInstalled>
                <AlsoPerformRegularSync>false</AlsoPerformRegularSync>
                <ComputerSpec />
                <ExtendedUpdateInfoParameters>
                    <XmlUpdateFragmentTypes>
                        <XmlUpdateFragmentType>Extended</XmlUpdateFragmentType>
                    </XmlUpdateFragmentTypes>
                    <Locales>
                        <string>en-US</string>
                        <string>en</string>
                    </Locales>
                </ExtendedUpdateInfoParameters>
                <ClientPreferredLanguages>
                    <string>en-US</string>
                </ClientPreferredLanguages>
                <ProductsParameters>
                    <SyncCurrentVersionOnly>false</SyncCurrentVersionOnly>
                    <DeviceAttributes>BranchReadinessLevel=CB;CurrentBranch=rs_prerelease;InstallLanguage=en-US;OSUILocale=en-US;InstallationType=Client;FlightingBranchName=external;OSSkuId=48;FlightContent=Branch;App=WU;AppVer=$([Environment]::OSVersion.Version.ToString());OSArchitecture=AMD64;UpdateManagementGroup=2;IsFlightingEnabled=1;TelemetryLevel=3;OSVersion=$([Environment]::OSVersion.Version.ToString());DeviceFamily=Windows.Desktop;</DeviceAttributes>
                    <CallerAttributes>Interactive=1;IsSeeker=0;</CallerAttributes>
                    <Products />
                </ProductsParameters>
            </parameters>
        </SyncUpdates>
    </s:Body>
</s:Envelope>
"@

$Parameters = @{
	Uri             = "https://fe3.delivery.mp.microsoft.com/ClientWebService/client.asmx"
	Method          = "Post"
	Body            = $syncRequest
	Headers         = $Headers
	UseBasicParsing = $true
	Verbose         = $true
}
[xml]$syncXml = (Invoke-RestMethod @Parameters).InnerXml.ToString().Replace('&lt;', '<').Replace('&gt;', '>')

$IDs = $syncXml.Envelope.Body.SyncUpdatesResponse.SyncUpdatesResult.ExtendedUpdateInfo.Updates.Update.ID
$package = ($syncXml.Envelope.Body.SyncUpdatesResponse.SyncUpdatesResult.NewUpdates.UpdateInfo | Where-Object -FilterScript {($_.ID -in $IDs) -and $_.Xml.Properties.SecuredFragment}).Xml.UpdateIdentity | Select-Object -First 1

$fileRequest = @"
<s:Envelope
    xmlns:a="http://www.w3.org/2005/08/addressing"
    xmlns:s="http://www.w3.org/2003/05/soap-envelope">
    <s:Header>
        <a:Action s:mustUnderstand="1">http://www.microsoft.com/SoftwareDistribution/Server/ClientWebService/GetExtendedUpdateInfo2</a:Action>
        <a:MessageID>urn:uuid:$([guid]::NewGuid())</a:MessageID>
        <a:To s:mustUnderstand="1">https://fe3.delivery.mp.microsoft.com/ClientWebService/client.asmx/secured</a:To>
        <o:Security s:mustUnderstand="1"
            xmlns:o="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">
            <Timestamp
                xmlns="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd">
                <Created>$created</Created>
                <Expires>$syncExpires</Expires>
            </Timestamp>
            <wuws:WindowsUpdateTicketsToken wsu:id="ClientMSA"
                xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"
                xmlns:wuws="http://schemas.microsoft.com/msus/2014/10/WindowsUpdateAuthorization">
                <TicketType Name="MSA" Version="1.0" Policy="MBI_SSL">Retail</TicketType>
            </wuws:WindowsUpdateTicketsToken>
        </o:Security>
    </s:Header>
    <s:Body>
        <GetExtendedUpdateInfo2
            xmlns="http://www.microsoft.com/SoftwareDistribution/Server/ClientWebService">
            <updateIDs>
                <UpdateIdentity>
                    <UpdateID>$($package.UpdateID)</UpdateID>
                    <RevisionNumber>$($package.RevisionNumber)</RevisionNumber>
                </UpdateIdentity>
            </updateIDs>
            <infoTypes>
                <XmlUpdateFragmentType>FileUrl</XmlUpdateFragmentType>
                <XmlUpdateFragmentType>FileDecryption</XmlUpdateFragmentType>
            </infoTypes>
            <deviceAttributes>BranchReadinessLevel=CB;CurrentBranch=rs_prerelease;InstallLanguage=en-US;OSUILocale=en-US;InstallationType=Client;FlightingBranchName=external;OSSkuId=48;FlightContent=Branch;App=WU;AppVer=$([Environment]::OSVersion.Version.ToString());OSArchitecture=AMD64;UpdateManagementGroup=2;IsFlightingEnabled=1;TelemetryLevel=3;OSVersion=$([Environment]::OSVersion.Version.ToString());DeviceFamily=Windows.Desktop;</deviceAttributes>
        </GetExtendedUpdateInfo2>
    </s:Body>
</s:Envelope>
"@

$Parameters = @{
	Uri             = "https://fe3.delivery.mp.microsoft.com/ClientWebService/client.asmx/secured"
	Method          = "Post"
	Body            = $fileRequest
	Headers         = $Headers
	UseBasicParsing = $true
	Verbose         = $true
}
$TempURL = ((Invoke-RestMethod @Parameters).Envelope.Body.GetExtendedUpdateInfo2Response.GetExtendedUpdateInfo2Result.FileLocations.FileLocation | Where-Object -FilterScript {$_.Url -match "tlu"}).Url

# Download archive
$Parameters = @{
	Uri             = $TempURL
	OutFile         = "HEVC\Microsoft.HEVCVideoExtension_8wekyb3d8bbwe.appxbundle"
	Verbose         = $true
	UseBasicParsing = $true
}
Invoke-WebRequest @Parameters
