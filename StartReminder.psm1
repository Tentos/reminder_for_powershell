function New-Reminder {
  Param(
      [Parameter(Mandatory = $true, ParameterSetName = "ByMinutes")]
      [decimal]
      $Minutes,
      [Parameter(Mandatory = $true, ParameterSetName = "ByTime")]
      [string]
      $EndingTime,
      [Parameter(Mandatory = $false)]
      [string]
      $Message)
  [decimal] $SecondsToSleep = 0;
  if ($Minutes -ne 0) {
    $SecondsToSleep = $Minutes * 60;
  } else {
    $SecondsToSleep = (New-TimeSpan -End $EndingTime).TotalSeconds;
  }

  if(($Minutes -ne 0) -and (-not $Message)) {
    $Message = "$($Minutes.ToString()) Minutes have passed";
  } elseif ($EndingTime -and (-not $Message)) {
    $Message = "It is $EndingTime";
  }

  [scriptblock] $TimerWithPopup = {
      param($SecondsToSleep, $Message) 
      Start-Sleep -Seconds ($SecondsToSleep); 
      (New-Object -ComObject Wscript.Shell).Popup($Message, 0, "Reminder", 0x0)
  };

  return Start-Job -Name "Reminder" -ScriptBlock $TimerWithPopup -ArgumentList $SecondsToSleep, $Message;
}

Export-ModuleMember -Function New-Reminder;