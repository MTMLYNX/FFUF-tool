#!/bin/bash

WORDLIST=$1
FUZZLIST=$2
OUTPUT_STATUS_CODES="output_status_codes.txt"
SUCCESSFUL_DOMAINS="successful_domains.txt"


check_domains() {
    while read -r domain; do
        if [ -z "$domain" ]; then
            continue
        fi
        response=$(curl -s -o /dev/null -w "%{http_code}" "http://$domain")
        if [ $? -ne 0 ]; then
            echo "$domain: Error" | tee -a $OUTPUT_STATUS_CODES
        else
            echo "$domain: $response" | tee -a $OUTPUT_STATUS_CODES
        fi
    done < "$WORDLIST"
}


extract_successful_domains() {
    grep -v 'Error' $OUTPUT_STATUS_CODES | awk -F': ' '$2 == 200 || $2 == 403 {print $1}' > $SUCCESSFUL_DOMAINS
}


run_ffuf() {
    while read -r domain; do
        domain_dir=$(echo "$domain" | tr '.' '_')
        mkdir -p "$domain_dir"
        ffuf -u "http://$domain/FUZZ" -w "$FUZZLIST" -mc 200,403 | tee "$domain_dir/${domain}_successful_subdomains.txt"
    done < "$SUCCESSFUL_DOMAINS"
}
