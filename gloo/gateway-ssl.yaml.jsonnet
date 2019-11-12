local lib = import '../lib/lib.jsonnet';

local sslGateway(config) = {
  apiVersion: 'gateway.solo.io.v2/v2',
  kind: 'Gateway',
  metadata: {
    annotations: {
      origin: 'default',
    },
    name: 'gateway-proxy-v2-ssl',
    namespace: lib.getElse(config, 'pkgs.gloo.namespace', 'gloo-system'),
  },
  spec: {
    bindAddress: '::',
    bindPort: 8443,
    httpGateway: {
      virtualServiceSelector: {
        source: "external",
      },
      plugins: {
        httpConnectionManagerSettings: {
          tracing: {
            verbose: true,
            requestHeadersForTags: [ "path", "origin" ]
          }
        },
        healthCheck: {
          path: '/status',
        },
      },
    },
    plugins: {
      accessLoggingService: {
        accessLog: [
          {
            fileSink: {
              jsonFormat: {
                authority: '%REQ(:authority)%',
                authorization: '%REQ(authorization)%',
                content: '%REQ(content-type)%',
                duration: '%DURATION%',
                forwardedFor: "%REQ(X-FORWARDED-FOR)%",
                method: '%REQ(:method)%',
                path: '%REQ(:path)%',
                remoteAddress: "%DOWNSTREAM_REMOTE_ADDRESS_WITHOUT_PORT%",
                request: '%REQ(x-tidepool-trace-request)%',
                response: '%RESPONSE_CODE%',
                scheme: '%REQ(:scheme)%',
                session: '%REQ(x-tidepool-trace-session)%',
                startTime: '%START_TIME%',
                token: '%REQ(x-tidepool-session-token)%',
                upstream: '%UPSTREAM_CLUSTER%',
              },
              path: '/dev/stdout',
            },
          },
        ],
      },
    },
    proxyNames: [
      'gateway-proxy-v2',
    ],
    ssl: true,
    useProxyProto: true,
  },
};

function(config) sslGateway(config)
