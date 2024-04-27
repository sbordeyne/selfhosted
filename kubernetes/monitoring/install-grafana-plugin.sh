#!/usr/bin/bash

# Install Grafana plugins

filename=$(basename $1)
curl -L $1 --output "/tmp/$filename"
kubeNamespace=monitoring
pvcName=grafana-pvc
volumeName=$(kubectl --namespace $kubeNamespace get pvc $pvcName -o jsonpath='{.spec.volumeName}')
outDirName=$(echo $filename | sed -E 's/-\d+\d+\d+.zip//')
outputDirectory="/tank/persistentvolumes/$kubeNamespace-$pvcName-$volumeName/plugins/$outDirName"
sudo unzip "/tmp/$filename" -d $outputDirectory

sudo chown -R 472:472 $outputDirectory
