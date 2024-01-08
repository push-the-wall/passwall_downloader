#!/bin/bash

# Define an array of filenames
filenames=("x86_64" "aarch64_cortex-a53" "aarch64_generic" "aarch64_cortex-a72" "arm_cortex-a9" "mipsel_24kc") # Replace with your actual filenames

# Loop over each filename
for filename in "${filenames[@]}"; do
    # Create a directory for each filename
    mkdir -p "$filename"
    url_file="${filename}_url.txt"
    > "$url_file"

    # Fetch the RSS feed and parse the URLs for the current filename
    curl "https://sourceforge.net/projects/openwrt-passwall-build/rss?path=/releases/packages-23.05/$filename" | \
    grep "<link>.*</link>" | \
    sed 's|<link>||;s|</link>||' | \
    while read url; do
        # Remove the '/download' suffix from each URL
        url=$(echo $url | sed 's|/download$||')

        # Save the URL to the file
        echo "$url" >> "$url_file"

        # Download the file into the respective directory
        wget "$url" -P "${filename}/"

        sleep 2
    done
done
