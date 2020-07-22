#ask for username
$username = Read-Host 'username please'
#connect to rubrik
Connect-Rubrik -server nj-rubrik -Username $username
#create a list of names and add it to a text file.
$names = (gc C:\scripts\files\SLAS.txt)
#not sure why a counter is needed
$counter = 0
#create an arrary
$list=@()
#foreach loop through the names to get each item in the $sla varible
foreach ($n in $names) {
#again not sure why the counter is needed but it works
$counter++
#create a new system object ($slaobject = New-Object System.Object) so we can add each extended property ie.."$sla.allowedBackupWindows.startTimeAttributes.hour"
$slaobject = New-Object System.Object
$sla= Get-RubrikSLA -name $n|select name, allowedBackupWindows, frequencies -ErrorAction SilentlyContinue
$slaobject |Add-Member -MemberType NoteProperty -Name "Name" -Value $sla.name
$slaobject |Add-Member -MemberType NoteProperty -Name "Start Hour" -Value $sla.allowedBackupWindows.startTimeAttributes.hour
$slaobject |Add-Member -MemberType NoteProperty -Name "Start Minute" -Value $sla.allowedBackupWindows.startTimeAttributes.minutes
$slaobject |Add-Member -MemberType NoteProperty -Name "Duration" -Value $sla.allowedBackupWindows.durationInHours
$slaobject |Add-Member -MemberType NoteProperty -Name "Every Hour" -Value $sla.frequencies.hourly.frequency
$slaobject |Add-Member -MemberType NoteProperty -Name "Hourly Retention" -Value $sla.frequencies.hourly.retention
$slaobject |Add-Member -MemberType NoteProperty -Name "Monthly" -Value $sla.frequencies.monthly.frequency
$slaobject |Add-Member -MemberType NoteProperty -Name "Monthly Rentention" -Value $sla.frequencies.monthly.retention
Write-Host $sla.name
#add the system property to the array list
$list+=$slaobject
}
$list |Export-Csv C:\scripts\out\test1.csv -NoTypeInformation -append
