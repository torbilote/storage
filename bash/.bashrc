# add at the end of your .bashrc file

# to add alias for windows home directory
export HOMEWIN=/mnt/c/Users/<user_folder>

# to add path line for VSCode
export PATH=$PATH:/mnt/c/Users/<user_folder>/<path_to_vsc_bin_folder>

# to copy ssh folder from Windows to WSL
if [ -d $HOMEWIN/.ssh ] ; then 
    if [ -d $HOME/.ssh ] ; then
        if [ -z "$(ls $HOME/.ssh)" ] ; then
            cp $HOMEWIN/.ssh/* $HOME/.ssh &&
            chmod 600 $HOME/.ssh/* &&
            echo "SSH keys copied successfully." ;
        else
            rm $HOME/.ssh/* &&
            cp $HOMEWIN/.ssh/* $HOME/.ssh &&
            chmod 600 $HOME/.ssh/* &&
            echo "SSH keys copied successfully." ;
        fi ;
    else
        mkdir $HOME/.ssh &&
        cp $HOMEWIN/.ssh/* $HOME/.ssh &&
        chmod 600 $HOME/.ssh/* &&
        echo "SSH keys copied successfully." ;
    fi ;
else
    echo "No .ssh folder found in $HOMEWIN directory." ;
fi ;

# to run ssh-agent and add ssh-keys to agent
eval "$(ssh-agent -s)"
ssh-add $HOME/.ssh/<key_name>


# add uv auto completion
uv generate-shell-completion bash

