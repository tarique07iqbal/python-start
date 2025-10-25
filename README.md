# [![Python tests](https://github.com/tarique07iqbal/python-start/actions/workflows/python-tests.yml/badge.svg)](https://github.com/tarique07iqbal/python-start/actions/workflows/python-tests.yml)
# [![Codecov coverage](https://codecov.io/gh/tarique07iqbal/python-start/branch/main/graph/badge.svg?token=)](https://codecov.io/gh/tarique07iqbal/python-start)

# Sign-up process

# 1. First Name
   The first letter must be capital.
   It should contain only alphabets (no numbers, no symbols).
   It should not contain spaces.
   Example: Ali
   Wrong: ali, Ali123, Ali Khan
   
# 2. Second Name
   The first letter must be capital.
   It should only contain alphabets.
   It should not contain spaces.
   Example: Azhar
   Wrong: azhar, azhar123, Ali Khan
   
# 3. Age
   Must be entered as a number (no text).
   Age must be between 0 and 150.
   If below 18 → You are considered a Minor.
   If 18 or above but less than 150 → You are an Adult.
   If 150 or more → Registration not allowed. Example: 25 Wrong: twenty, 200

# 4. Address
   Any text is allowed (no strict rules).
   Example: Hyderabad, India

# 5. Mobile Number
   Must be exactly 10 digits.
   Only numbers allowed.
   No spaces allowed.
   Example: 9876543210
   Wrong: 98765 43210, 98765432AB

# 6. Username
   Must only contain alphabets.
   No numbers, no spaces, no special characters.
   Example: AliAzhar
   Wrong: Ali123, Ali_Azhar, Ali Azhar

# 7. Password
   Exactly 8 characters long.
   First letter must be capital.
   At least one special character must be included (!, @, #, $).
   At least one number must be included.
   No spaces allowed.
   Example: Abc@1234
   Wrong: abc@1234 (first letter not capital)
   Wrong: Abcdefgh (no number, no special character)
   Wrong: Abc 123@ (contains space)
   
# 8. Confirm Password
   You must re-enter the same password.
   If it matches →  Registration successful.
   If it doesn’t match →  Error: “Password mismatch.”


## Example Signup Flow
Enter First name: Ali
Enter Second name: Azhar
Enter your age: 22
You are adult
Enter Address: Hyderabad
Enter your contact number: 9876543210
Create username: AliAzhar
Enter your password: Abc@1234
Confirm Password: Abc@1234
Sign up done successfully...


## Error Examples
Enter First name: ali
Insert correct first name.
Enter your age: 200
You are not eligible.
Enter your password: Abc12345
password at least one special character
Confirm Password: Abc123@
Your password is mismatch

## Monitor CI workflow (optional)

If you want to monitor the GitHub Actions workflow from your machine, a helper script is available at `scripts/poll-workflow.ps1`.

Short example (PowerShell):

```powershell
# prompt for PAT in session and poll the 'python-tests' workflow
$env:GITHUB_PAT = Read-Host -AsSecureString "Enter GitHub PAT" | ConvertFrom-SecureString
powershell -ExecutionPolicy Bypass -File .\scripts\poll-workflow.ps1 -RepoOwner tarique07iqbal -RepoName python-start
```
