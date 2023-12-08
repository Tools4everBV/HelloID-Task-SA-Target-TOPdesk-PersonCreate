# HelloID-Task-SA-Target-TOPdesk-PersonCreate

## Prerequisites

- [ ] TOPdesk API Username and Key
- [ ] User-defined variables: `topdeskBaseUrl`, `topdeskApiUsername` and `topdeskApiSecret` created in your HelloID portal.

## Description

This code snippet will create a new person within TOPdesk and executes the following tasks:

1. Define a hash table `$formObject`. The keys of the hash table represent the properties necessary to create a new person within `TOPdesk`, while the values represent the values entered in the form.

> To view an example of the form output, please refer to the JSON code pasted below.

```json
$topdeskBaseUrl = "https://tools4ever.topdesk.net"
$topdeskApiUsername = "tempadmin"
$topdeskApiSecret = "3kd4d-6eeje-q2id5-u64qu-uggfq"

$form = '{
    "surName": "Doe",
    "prefixes": "van der",
    "firstName": "John",
    "firstInitials": "J.J.",
    "gender": "MALE",
    "phoneNumber": "0229123456",
    "mobileNumber": "0612345678",
    "employeeNumber": "12345678",
    "email": "j.doe@enyoi.org",
    "networkLoginName": "j.doe",
    "tasLoginName": "j.doe@enyoi.org",
    "jobTitle": "Tester",
    "branch": {
        "id": "1fe19024-d652-46ec-b080-eec3737a3d7a"
    },
    "department": {
        "id": "54a543bc-e8a3-425d-9c44-065b862b313e"
    }
}' | ConvertFrom-Json
```

> :exclamation: It is important to note that the names of your form fields might differ. Ensure that the `$formObject` hash table is appropriately adjusted to match your form fields.
> [See the TOPdesk API Docs page](https://developers.topdesk.com/explorer/?page=supporting-files#/Persons/createPerson)

2. Creates authorization headers using the provided API key and secret.

3. Create a new person using the: `Invoke-RestMethod` cmdlet. The hash table called: `$formObject` is passed to the body of the: `Invoke-RestMethod` cmdlet as a JSON object.
