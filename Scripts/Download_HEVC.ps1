# Only God knows what's going on here

$Uri       = "https://fe3.delivery.mp.microsoft.com/ClientWebService/client.asmx"
$Namespace = "http://www.microsoft.com/SoftwareDistribution/Server/ClientWebService"
$WSSE      = "http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity"
$Format    = "yyyy-MM-ddTHH:mm:ss.fffZ"
$Now       = [DateTime]::UtcNow
$Created   = $Now.ToString($Format)
$Expires   = $Now.AddMinutes(5).ToString($Format)
$OSVersion = [Environment]::OSVersion.Version.ToString()

$DeviceAttributes = "BranchReadinessLevel=CB;CurrentBranch=rs_prerelease;InstallLanguage=en-US;OSUILocale=en-US;InstallationType=Client;FlightingBranchName=external;OSSkuId=48;FlightContent=Branch;App=WU;AppVer=$OSVersion;OSArchitecture=AMD64;UpdateManagementGroup=2;IsFlightingEnabled=1;TelemetryLevel=3;OSVersion=$OSVersion;DeviceFamily=Windows.Desktop;"

# Get cookie
$CookieRequest = @"
<Envelope xmlns="http://www.w3.org/2003/05/soap-envelope">
	<Header>
		<Action d3p1:mustUnderstand="1" xmlns:d3p1="http://www.w3.org/2003/05/soap-envelope" xmlns="http://www.w3.org/2005/08/addressing">$Namespace/GetCookie</Action>
		<MessageID xmlns="http://www.w3.org/2005/08/addressing">urn:uuid:$([guid]::NewGuid())</MessageID>
		<To d3p1:mustUnderstand="1" xmlns:d3p1="http://www.w3.org/2003/05/soap-envelope" xmlns="http://www.w3.org/2005/08/addressing">$Uri</To>
		<Security d3p1:mustUnderstand="1" xmlns:d3p1="http://www.w3.org/2003/05/soap-envelope" xmlns="$WSSE-secext-1.0.xsd">
			<Timestamp xmlns="$WSSE-utility-1.0.xsd">
				<Created>$Created</Created>
				<Expires>$Expires</Expires>
			</Timestamp>
			<WindowsUpdateTicketsToken d4p1:id="ClientMSA" xmlns:d4p1="$WSSE-utility-1.0.xsd" xmlns="http://schemas.microsoft.com/msus/2014/10/WindowsUpdateAuthorization">
				<TicketType Name="MSA" Version="1.0" Policy="MBI_SSL">
					<User />
				</TicketType>
			</WindowsUpdateTicketsToken>
		</Security>
	</Header>
	<Body>
		<GetCookie xmlns="$Namespace">
			<oldCookie />
			<lastChange>$($Now.AddYears(-2).ToString($Format))</lastChange>
			<currentTime>$Created</currentTime>
			<protocolVersion>1.40</protocolVersion>
		</GetCookie>
	</Body>
</Envelope>
"@

# The same splat is reused for all SOAP requests: only Uri and Body are changed
$Parameters = @{
	Uri             = $Uri
	Method          = "Post"
	Body            = $CookieRequest
	ContentType     = "application/soap+xml; charset=utf-8"
	UseBasicParsing = $true
	Verbose         = $true
}
$Cookie = (Invoke-RestMethod @Parameters).GetElementsByTagName("EncryptedData")[0].FirstChild.Data

# Get category ID
# https://apps.microsoft.com/detail/9N4WGH0Z6VHQ
$StoreParameters = @{
	Uri             = "https://storeedgefd.dsx.mp.microsoft.com/v9.0/products/9N4WGH0Z6VHQ?market=US&locale=en-us&deviceFamily=Windows.Desktop"
	UseBasicParsing = $true
	Verbose         = $true
}
$CategoryId = ((Invoke-RestMethod @StoreParameters).Payload.Skus[0].FulfillmentData | ConvertFrom-Json).WuCategoryId

# Security header is identical for SyncUpdates and GetExtendedUpdateInfo2
$Security = @"
<o:Security s:mustUnderstand="1" xmlns:o="$WSSE-secext-1.0.xsd">
			<Timestamp xmlns="$WSSE-utility-1.0.xsd">
				<Created>$Created</Created>
				<Expires>$Expires</Expires>
			</Timestamp>
			<wuws:WindowsUpdateTicketsToken wsu:id="ClientMSA" xmlns:wsu="$WSSE-utility-1.0.xsd" xmlns:wuws="http://schemas.microsoft.com/msus/2014/10/WindowsUpdateAuthorization">
				<TicketType Name="MSA" Version="1.0" Policy="MBI_SSL">Retail</TicketType>
			</wuws:WindowsUpdateTicketsToken>
		</o:Security>
"@

# Get update ID and revision number
$SyncRequest = @"
<s:Envelope xmlns:a="http://www.w3.org/2005/08/addressing" xmlns:s="http://www.w3.org/2003/05/soap-envelope">
	<s:Header>
		<a:Action s:mustUnderstand="1">$Namespace/SyncUpdates</a:Action>
		<a:MessageID>urn:uuid:$([guid]::NewGuid())</a:MessageID>
		<a:To s:mustUnderstand="1">$Uri</a:To>
		$Security
	</s:Header>
	<s:Body>
		<SyncUpdates xmlns="$Namespace">
			<cookie>
				<Expiration>2045-03-11T02:02:48Z</Expiration>
				<EncryptedData>$Cookie</EncryptedData>
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
						<Id>$CategoryId</Id>
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
					<DeviceAttributes>$DeviceAttributes</DeviceAttributes>
					<CallerAttributes>Interactive=1;IsSeeker=0;</CallerAttributes>
					<Products />
				</ProductsParameters>
			</parameters>
		</SyncUpdates>
	</s:Body>
</s:Envelope>
"@

$Parameters.Body = $SyncRequest
# Update fragments are returned as escaped XML, so unescape them to get a single XML document
[xml]$SyncXml = (Invoke-RestMethod @Parameters).InnerXml.Replace("&lt;", "<").Replace("&gt;", ">")

$SyncResult = $SyncXml.Envelope.Body.SyncUpdatesResponse.SyncUpdatesResult
$IDs        = $SyncResult.ExtendedUpdateInfo.Updates.Update.ID
$Package    = ($SyncResult.NewUpdates.UpdateInfo | Where-Object -FilterScript {($_.ID -in $IDs) -and $_.Xml.Properties.SecuredFragment} | Select-Object -First 1).Xml.UpdateIdentity

# Get direct URL
$FileRequest = @"
<s:Envelope xmlns:a="http://www.w3.org/2005/08/addressing" xmlns:s="http://www.w3.org/2003/05/soap-envelope">
	<s:Header>
		<a:Action s:mustUnderstand="1">$Namespace/GetExtendedUpdateInfo2</a:Action>
		<a:MessageID>urn:uuid:$([guid]::NewGuid())</a:MessageID>
		<a:To s:mustUnderstand="1">$Uri/secured</a:To>
		$Security
	</s:Header>
	<s:Body>
		<GetExtendedUpdateInfo2 xmlns="$Namespace">
			<updateIDs>
				<UpdateIdentity>
					<UpdateID>$($Package.UpdateID)</UpdateID>
					<RevisionNumber>$($Package.RevisionNumber)</RevisionNumber>
				</UpdateIdentity>
			</updateIDs>
			<infoTypes>
				<XmlUpdateFragmentType>FileUrl</XmlUpdateFragmentType>
				<XmlUpdateFragmentType>FileDecryption</XmlUpdateFragmentType>
			</infoTypes>
			<deviceAttributes>$DeviceAttributes</deviceAttributes>
		</GetExtendedUpdateInfo2>
	</s:Body>
</s:Envelope>
"@

$Parameters.Uri  = "$Uri/secured"
$Parameters.Body = $FileRequest
$TempURL = ((Invoke-RestMethod @Parameters).Envelope.Body.GetExtendedUpdateInfo2Response.GetExtendedUpdateInfo2Result.FileLocations.FileLocation | Where-Object -FilterScript {$_.Url.Contains("tlu")}).Url

if (-not (Test-Path -Path HEVC))
{
	New-Item -Path HEVC -ItemType Directory -Force
}

# Download archive
$Parameters = @{
	Uri             = $TempURL
	OutFile         = "HEVC\Microsoft.HEVCVideoExtension_8wekyb3d8bbwe.appxbundle"
	UseBasicParsing = $true
	Verbose         = $true
}
Invoke-WebRequest @Parameters
