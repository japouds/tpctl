local configmap(config) = {
  apiVersion: 'v1',
  data: {
    'cluster.name': config.cluster.metadata.name,
    'logs.region': config.cluster.metadata.region,
  },
  kind: 'ConfigMap',
  metadata: {
    name: 'cluster-info',
    namespace: 'amazon-cloudwatch',
  },
};

function(config, prev) configmap(config)
