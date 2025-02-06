
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

## Testing Your Connection to GitHub
1. Run the following command to test your connection to GitHub:
    ```bash
    ssh -vT git@github.com
    ```

---
