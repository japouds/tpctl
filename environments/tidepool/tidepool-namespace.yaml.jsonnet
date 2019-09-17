local gen_namespace(config, namespace) = {
  apiVersion: "v1",
  kind: "Namespace",
  metadata: {
    name: namespace,
    annotations: {
      "istio-injection": "disabled",
      "linkerd.io/inject": "enabled",
      "discovery.solo.io/function_discovery": "enabled"
    }
  }
};

function(config, namespace) gen_namespace(config, namespace)
