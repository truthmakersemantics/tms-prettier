#!/bin/sh
# e is for exiting the script automatically if a command fails, u is for exiting if a variable is not set
# x would be for showing the commands before they are executed
set -eu

# PROGRAM
echo "Installing prettier..."
case $INPUT_PRETTIER_VERSION in
    false)
        npm install --silent --global prettier
        ;;
    *)
        npm install --silent --global prettier@$INPUT_PRETTIER_VERSION
        ;;
esac

# Install plugins
if [ -n "$INPUT_PRETTIER_PLUGINS" ]; then
    for plugin in $INPUT_PRETTIER_PLUGINS; do
        echo "Checking plugin: $plugin"
        # check regex against @prettier/xyz
        if ! echo "$plugin" | grep -Eq '(@prettier\/)+(plugin-[a-z\-]+)'; then
            echo "$plugin does not seem to be a valid @prettier/plugin-x plugin. Exiting."
            exit 1
        fi
    done
    npm install --silent --global $INPUT_PRETTIER_PLUGINS
fi

echo "Prettifing files..."
echo "Files:"
prettier $INPUT_PRETTIER_OPTIONS || echo "Problem running prettier with $INPUT_PRETTIER_OPTIONS"

echo "All done, enjoy your pretty code!"
