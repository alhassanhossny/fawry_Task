#!/bin/bash

show_help() {
  echo "Usage: $0 [OPTIONS] search_string filename"
  echo ""
  echo "Options:"
  echo "  -n        Show line numbers for matches"
  echo "  -v        Invert match (show non-matching lines)"
  echo "  --help    Show this help message"
  exit 0
}

# Check for --help Option
if [[ "$1" == "--help" ]]; then
  show_help
fi

# Check if there are at least 2 arguments
if [ $# -lt 2 ]; then
  echo "Error: Not enough arguments."
  show_help
fi

# Initialize options
show_line_numbers=false
invert_match=false

# Parse options
while [[ "$1" == -* ]]; do
  case "$1" in
    *n*) show_line_numbers=true ;;
    *v*) invert_match=true ;;
    *) echo "Invalid option: $1" ; show_help ;;
  esac
  shift
done

# Now $1 should be search string, $2 should be file
search_string="$1"
file="$2"

# Check if file exists
if [ ! -f "$file" ]; then
  echo "Error: File '$file' does not exist."
  exit 1
fi

# Read and process file
line_number=0
while IFS= read -r line
do
  ((line_number++))
  match=$(echo "$line" | grep -i "$search_string")

  if [ "$invert_match" = false ] && [ -n "$match" ]; then
    if [ "$show_line_numbers" = true ]; then
      echo "${line_number}:$line"
    else
      echo "$line"
    fi
  elif [ "$invert_match" = true ] && [ -z "$match" ]; then
    if [ "$show_line_numbers" = true ]; then
      echo "${line_number}:$line"
    else
      echo "$line"
    fi
  fi
done < "$file"