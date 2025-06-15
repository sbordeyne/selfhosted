echo "Checking file names in apps directory..."
folders=$(find apps -type d | grep -vE '(^apps/|/)$' | tr '\n' ',')
IFS=',' read -r -a folder_array <<< "$folders"
for folder in "${folder_array[@]}"; do
  echo "Checking folder: $folder"
  echo "---"
  if [[ ! -d "$folder" ]]; then
    continue
  fi
  for file in "$folder"/*.yaml; do
    if [[ -f "$file" ]]; then
      filename=$(basename "$file")
      # Skip kustomization.yaml files
      if [[ "$filename" == "kustomization.yaml" ]]; then
        continue
      fi
      # Check that the filename is in the format <kind>-<metadata.name>.yaml
      kind=$(yq eval '.kind' "$file")
      metadata_name=$(yq eval '.metadata.name' "$file")
      # Construct the expected filename
      expected_filename="${kind}-${metadata_name}.yaml"
      if [[ "$filename" != "$expected_filename" ]]; then
        echo "File $file is named '$filename', expected '$expected_filename'."
      fi
    fi
  done
done
