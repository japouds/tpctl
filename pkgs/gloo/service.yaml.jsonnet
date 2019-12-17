local lib = import '../../lib/lib.jsonnet';

local expand = import '../../lib/expand.jsonnet';

local service(config) = {
  apiVersion: 'v1',
  kind: 'Service',
  spec: {
    externalTrafficPolicy: 'Cluster',
    ports: [
      {
        name: 'http',
        port: 80,
        protocol: 'TCP',
        targetPort: 8080,
      },
      {
        name: 'https',
        port: 443,
        protocol: 'TCP',
        targetPort: 8443,
      },
    ],
    selector: {
      'gateway-proxy': 'live',
      'gateway-proxy-id': 'gateway-proxy',
    },
    type: 'LoadBalancer',
  },
  metadata+: {
    labels: {
      app: 'gloo',
      'gateway-proxy-id': 'gateway-proxy',
      gloo: 'gateway-proxy',
    },
    name: 'gateway-proxy',
    namespace: 'gloo-system',
    annotations+: {
      'external-dns.alpha.kubernetes.io/alias': 'true',
      'prometheus.io/path': '/metrics',
      'prometheus.io/port': '8081',
      'prometheus.io/scrape': 'true',
      'service.beta.kubernetes.io/aws-load-balancer-proxy-protocol': '*',
      'external-dns.alpha.kubernetes.io/hostname': 
	std.join(
          ',',
          [ '*.%s' % config.cluster.metadata.domain ]
          + lib.dnsNames(config)
        ),
      'service.beta.kubernetes.io/aws-load-balancer-additional-resource-tags': 'cluster:%s' % config.cluster.metadata.name,
    },
  },
};

function(config, prev) service(expand.expandConfig(config), prev)
