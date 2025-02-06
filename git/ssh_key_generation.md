# ssh key generation

- You can access and write data in repositories in GitHub using SSH(Secure Shell Protocol).
- Authentication uses private key stored on your local machine and public key which is added to your GitHub account.

--- 

1. To generate new SSH key pairs run:
    ```bash
    ssh-keygen -t ed25519 -C "email or name"
    ```
2. Pass the name and path to your .ssh user folder.
3. Start your SSH agent:
    ```bash
    eval "$(ssh-agent -s)"
    ```
4. Add your new private key to agent. 
    ```bash
    ssh-add <path_to_private_key> # ie. ~/.ssh/id_ed25519
    ```
5. Copy the content of the public key and add it in GitHub settings.

---

1. To test your connection to GitHub run:
    ```bash
    ssh -vT git@github.com
    ```

---




