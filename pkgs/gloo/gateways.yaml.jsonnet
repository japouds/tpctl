local lib = import '../../lib/lib.jsonnet';

local defaults = {
  pkgs+: {
    gloo+: {
      gateways+: {
        'gateway-proxy'+: {
          enabled: true,
          options+: {
            accessLogging: true,
            healthCheck: true,
            proxyProtocol: true,
            tracing: true,
          },
          proxies: [
            'gateway-proxy',
          ],
          selector: {
            protocol: 'http',
            type: 'external',
          },
        },
        'gateway-proxy-ssl'+: {
          enabled: true,
          options+: {
            accessLogging: true,
            healthCheck: true,
            proxyProtocol: true,
            ssl: true,
            tracing: true,
          },
          proxies: [
            'gateway-proxy',
          ],
          selector: {
            protocol: 'https',
            type: 'external',
          },
        },
        'internal-gateway-proxy'+: {
          enabled: true,
          options+: {
            accessLogging: true,
            tracing: true,
          },
          proxies: [
            'internal-gateway-proxy',
          ],
          selector: {
            protocol: 'http',
            type: 'internal',
          },
        },
      },
    },
  },
};


function(config) std.manifestYamlStream(lib.gateways(lib.merge(defaults, lib.expandConfig(config))))
