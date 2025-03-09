#!/usr/bin/env bash

FILE=$1

if [[ -z "$FILE" ]]; then
    echo -e "No file argument. Usage: \n$0 filename.kbdx"
    exit 0
fi

BASE_NAME="${FILE%.*}"
BASE_NAME=$(basename "$BASE_NAME")
DIR_NAME=$(dirname "$BASE_NAME")
EXT="${FILE##*.}"
FILE_PATTERN="${BASE_NAME}*.${EXT}"
FILE_PATTERN_RE="^${BASE_NAME}.*\.${EXT}$"

CONFLICTED=$(ls -1 "$DIR_NAME" | grep -i 'conflicted copy' | grep -E "$FILE_PATTERN_RE" | sort --reverse | head -n 1)

if [[ -z "$CONFLICTED" ]]; then
    echo -ne "No $CONFLICTED files among: $FILE_PATTERN\n  "
    ls -1 | grep -E "$FILE_PATTERN_RE"
    echo "other confilcts:"
    ls -1 | grep -i conflicted
    exit 0
fi

#SSH_PASS=$(secret-tool lookup ssh-key sec)
if [[ -z "$KEE_PASSWORD" ]]; then
    read -s -p "Enter KeePass password (to reuse it): " KEE_PASSWORD
    echo
fi
echo 'dry run. show changes:'
DRY_RUN_OUTPUT=$(echo "$KEE_PASSWORD" | keepassxc-cli merge --dry-run --same-credentials "$FILE" "$CONFLICTED" \
    | tee "$DIR_NAME/last_resolve.txt" | tee /dev/tty)

{ echo "keepassxc-cli merge --dry-run --same-credentials \"$FILE\" \"$CONFLICTED\"" && echo "$DRY_RUN_OUTPUT"; } > "$DIR_NAME/last_resolve.txt"

echo "$DRY_RUN_OUTPUT" | grep 'Database was not modified by merge operation' \
    && echo -e '        ^\033[1mwas not modified\033[0m^'
if [[ $? -eq 0 ]]; then
    echo -en "deleting file \033[1m"
    echo -n "$CONFLICTED"
    echo -e "\033[0m without \033[1;4mconfirmation\033[0m"
    YES='SKIP'
    sleep 2
    rm "$CONFLICTED"
    OK=$?
else
    echo -en "delete file \033[1m"
    echo -n "$CONFLICTED"
    echo -e "\033[0m? (y/\033[1;4mn\033[0m)"
    read -t 10 YES
fi
if [[ $? -eq 142 ]]; then
    echo "Timeout reached, defaulting to 'no'"
    YES='TMOUT'
fi
export KEE_PASSWORD
if [[ "${YES,,}" == "y" ]]; then
    echo "$KEE_PASSWORD" | keepassxc-cli merge --same-credentials "$FILE" "$CONFLICTED" && rm "$CONFLICTED"
    OK=$?
fi
if [[ $OK -eq 0 ]]; then
    echo "moving on"
    exec "$0" "$@"
else
    echo "exiting.."
fi
