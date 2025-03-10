
# SSH Key Generation

## Introduction
- You can access and write data in repositories on GitHub using SSH (Secure Shell Protocol).
- Authentication uses a private key stored on your local machine and a public key added to your GitHub account.

---

## Generating a New SSH Key Pair
1. Run the following command to generate a new SSH key pair:
    ```bash
    ssh-keygen -t ed25519 -C "email or name"
    ```
2. Specify the name and path to your `.ssh` user folder when prompted.

## Starting the SSH Agent
1. Start your SSH agent by running:
    ```bash
    eval "$(ssh-agent -s)"
    ```

## Adding Your Private Key to the SSH Agent
1. Add your new private key to the agent:
    ```bash
    ssh-add <path_to_private_key> # e.g., ~/.ssh/id_ed25519
    ```

## Adding the Public Key to GitHub
1. Copy the content of the public key file:
    ```bash
    cat <path_to_public_key> # e.g., ~/.ssh/id_ed25519.pub
    ```
2. Add the copied public key to your GitHub account in the **Settings** > **SSH and GPG keys** section.

---

## Defining your SSH config file for multiple GitHub accounts
1. create config file
   ```bash
   touch $HOME/.ssh/config
   ```
2. paste the following
    ```bash
        Host github-valtech
        HostName github.com
        User norbert-lipinski_valtech
        IdentityFile ~/.ssh/valtech-worklaptop
        IdentitiesOnly yes
        AddKeysToAgent yes

    Host github-torbilote
        HostName github.com
        User torbilote
        IdentityFile ~/.ssh/torbilote-worklaptop
        IdentitiesOnly yes
        AddKeysToAgent yes
    ```

## Testing Your Connection to GitHub
1. run to add your defined hosts to known_hosts file
   ```bash
   ssh-keyscan github.com >> $HOME/.ssh/known_hosts 
   ```
2. Run the following command to test your connection to GitHub:
    ```bash
    ssh -vT git@github-torbilote.com
    ```

## Modyfing your remote origin url in your exisitng repository
1. run
   ```bash
   git remote set-url origin git@github-torbilote:<gh_account>/<gh_repo>.git
    ```
    
---
