#!/usr/bin/env bash

# Shows the results of a flux HelmRelease

# Usage: flux-template.sh <path>

HR="$1"
if [ -z "$HR" ]; then
  echo "Usage: $0 <path>"
  exit 1
fi

if [ ! -f "$HR" ]; then
  echo "File not found: $HR"
  exit 1
fi

# Get hte values from the HelmRelease
VALUES=$(yq -r '.spec.values' "$HR")
if [ -z "$VALUES" ]; then
  echo "No values found in HelmRelease: $HR"
  exit 1
fi

# Get the chart name from the HelmRelease
CHART=$(yq -r '.spec.chart.spec.chart' "$HR")
REPO=$(yq -r '.spec.chart.spec.sourceRef.name' "$HR")
VERSION=$(yq -r '.spec.chart.spec.version' "$HR")

if [ -z "$CHART" ] || [ -z "$REPO" ]; then
  echo "Chart or repository not found in HelmRelease: $HR"
  exit 1
fi

helm template "$REPO/$CHART" \
  --version "$VERSION" \
  --values <(echo "$VALUES") \
  --namespace "$(yq -r '.metadata.namespace' "$HR")" \
  --name-template "$(yq -r '.metadata.name' "$HR")" | bat -l yaml --paging always
