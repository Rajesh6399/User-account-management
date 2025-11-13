#!/bin/bash
INPUT_FILE="${1:-users.txt}"  # Allow passing filename as argument
LOG_DIR="./logs"
LOG_FILE="$LOG_DIR/user_management.log"
PASSWORD_FILE="$LOG_DIR/user_passwords.txt"

# ====== SETUP ======
mkdir -p "$LOG_DIR"
touch "$LOG_FILE" "$PASSWORD_FILE"
chmod 600 "$LOG_FILE" "$PASSWORD_FILE"

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

# ====== PRIVILEGE CHECK ======
if [ "$(id -u)" -ne 0 ]; then
    echo " Run this script with sudo"
    exit 1
fi

# ====== FILE CHECK ======
if [ ! -f "$INPUT_FILE" ]; then
    echo " Input file '$INPUT_FILE' not found!"
    exit 1
fi

log "----- Starting User Creation Process -----"

# ====== MAIN LOOP ======
# The '|| [[ -n "$line" ]]' ensures the last line is processed even without a newline.
while IFS= read -r line || [[ -n "$line" ]]; do

    # Clean Windows CRLF and whitespace
    line=$(echo "$line" | tr -d '\r' | tr -d '\t')

    # Skip empty lines or comments
    [[ -z "$line" || "$line" =~ ^# ]] && continue

    # Remove all spaces
    clean=$(echo "$line" | sed 's/[[:space:]]//g')

    # Split username and groups
    username=$(echo "$clean" | cut -d ';' -f 1)
    groups=$(echo "$clean" | cut -d ';' -f 2)

    # Validate
    if [ -z "$username" ]; then
        log " Skipping malformed line: '$line'"
        continue
    fi

    log "Processing user: $username"

    # Split groups into array
    IFS=',' read -ra GROUP_LIST <<< "$groups"

    # Create groups if they don't exist
    for grp in "${GROUP_LIST[@]}"; do
        [[ -z "$grp" ]] && continue
        if ! getent group "$grp" >/dev/null 2>&1; then
            groupadd "$grp"
            log "Created group: $grp"
        else
            log "Group exists: $grp"
        fi
    done

    # Create user if missing
    if id "$username" >/dev/null 2>&1; then
        log "User $username already exists."
    else
        useradd -m -s /bin/bash -G "$groups" "$username"
        log "Created user: $username"
    fi

    # Ensure home ownership
    if [ -d "/home/$username" ]; then
        chown "$username:$username" "/home/$username" 2>/dev/null
    fi

    # Generate and set password
    password=$(openssl rand -base64 12)
    echo "$username:$password" | chpasswd 2>/dev/null

    # Save password securely
    echo "$username : $password" >> "$PASSWORD_FILE"
    log "Password set for $username"

done < "$INPUT_FILE"

log "----- User Creation Process Completed -----"
echo " Done! Check logs in: $LOG_FILE"
