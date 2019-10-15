local helmrelease(config) = {
  "apiVersion": "helm.fluxcd.io/v1",
  "kind": "HelmRelease",
  "metadata": {
    "annotations": {
      "fluxcd.io/automated": "true"
    },
    "name": "cluster-autoscaler",
    "namespace": "kube-system"
  },
  "spec": {
    "chart": {
      "name": "cluster-autoscaler",
      "repository": "https://kubernetes-charts.storage.googleapis.com/",
      "version": "6.0.0"
    },
    "releaseName": "cluster-autoscaler",
    "values": {
      "autoDiscovery": {
        "clusterName": config.cluster.metadata.name,
      },
      "awsRegion": config.cluster.metadata.region,
      "image": {
        "tag": "v1.16.1"
      }
    }
  }
};

function(config) helmrelease(config)