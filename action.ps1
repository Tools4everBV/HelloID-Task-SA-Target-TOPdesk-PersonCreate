# TOPdesk-Task-SA-Target-TOPdesk-PersonCreate
###########################################################
# Form mapping
$formObject = @{
    surName          = $form.surname
    prefixes         = $form.prefixes
    firstName        = $form.firstName
    firstInitials    = $form.firstInitials
    gender           = $form.gender

    phoneNumber      = $form.phoneNumber
    mobileNumber     = $form.mobileNumber

    employeeNumber   = $form.employeeNumber
    email            = $form.email
    networkLoginName = $form.networkLoginName
    tasLoginName     = $form.tasLoginName

    jobTitle         = $form.jobTitle
    branch           = $form.branch
    department       = $form.department
}
$userDisplayName = $formObject.surName + ", " + $formObject.firstName + " " + $formObject.prefixes

try {
    Write-Information "Executing TOPdesk action: [CreatePersonAccount] for: [$($userDisplayName)]"
    Write-Verbose "Creating authorization headers"
    # Create authorization headers with TOPdesk API key
    $pair = "${topdeskApiUsername}:${topdeskApiSecret}"
    $bytes = [System.Text.Encoding]::ASCII.GetBytes($pair)
    $base64 = [System.Convert]::ToBase64String($bytes)
    $key = "Basic $base64"
    $headers = @{
        "authorization" = $Key
        "Accept"        = "application/json"
    }

    Write-Verbose "Creating TOPdesk Person for: [$($userDisplayName)]"
    $splatCreateUserParams = @{
        Uri         = "$($topdeskBaseUrl)/tas/api/persons"
        Method      = "POST"
        Body        = ([System.Text.Encoding]::UTF8.GetBytes(($formObject | ConvertTo-Json -Depth 10)))
        Verbose     = $false
        Headers     = $headers
        ContentType = "application/json; charset=utf-8"
    }
    $response = Invoke-RestMethod @splatCreateUserParams

    $auditLog = @{
        Action            = "CreateAccount"
        System            = "TOPdesk"
        TargetIdentifier  = [String]$response.id
        TargetDisplayName = [String]$response.dynamicName
        Message           = "TOPdesk action: [CreatePersonAccount] for: [$($userDisplayName)] executed successfully"
        IsError           = $false
    }
    Write-Information -Tags "Audit" -MessageData $auditLog

    Write-Information "TOPdesk action: [CreatePersonAccount] for: [$($userDisplayName)] executed successfully"
}
catch {
    $ex = $_
    $auditLog = @{
        Action            = "CreateAccount"
        System            = "TOPdesk"
        TargetIdentifier  = ""
        TargetDisplayName = [String]$userDisplayName
        Message           = "Could not execute TOPdesk action: [CreatePersonAccount] for: [$($userDisplayName)], error: $($ex.Exception.Message)"
        IsError           = $true
    }
    if ($($ex.Exception.GetType().FullName -eq "Microsoft.PowerShell.Commands.HttpResponseException")) {
        $auditLog.Message = "Could not execute TOPdesk action: [CreatePersonAccount] for: [$($userDisplayName)]"
        Write-Error "Could not execute TOPdesk action: [CreatePersonAccount] for: [$($userDisplayName)], error: $($ex.ErrorDetails)"
    }
    Write-Information -Tags "Audit" -MessageData $auditLog
    Write-Error "Could not execute TOPdesk action: [CreatePersonAccount] for: [$($userDisplayName)], error: $($ex.Exception.Message)"
}
###########################################################
