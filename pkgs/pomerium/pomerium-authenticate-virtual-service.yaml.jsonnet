local virtualService(config) = {
  apiVersion: 'gateway.solo.io/v1',
  kind: 'VirtualService',
  metadata: {
    labels: {
      protocol: 'https',
      type: 'external',
    },
    name: 'authenticate',
    namespace: 'pomerium',
  },
  spec: {
    displayName: 'authenicate',
    sslConfig: {
      secretRef: {
        name: 'pomerium-tls',
        namespace: 'pomerium',
      },
      sniDomains: [
        'authenticate.%s' % config.pkgs.pomerium.rootDomain,
      ],
    },
    virtualHost: {
      domains: [
        'authenticate.%s' % config.pkgs.pomerium.rootDomain,
      ],
      routes: [
        {
          matchers: [
            {
              prefix: '/',
            },
          ],
          routeAction: {
            single: {
              upstream: {
                name: 'pomerium-authenticate',
                namespace: 'pomerium',
              },
            },
          },
        },
      ],
    },
  },
};

function(config) virtualService(config)
