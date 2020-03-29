{
  _config+:: {
    nodelocaldnsSelector: error 'must provide selector for coredns',
  },
  prometheusAlerts+:: {
    groups+: [
      {
        name: 'nodelocaldns',
        rules: [
          {
            alert: 'NodeLocalDNSDown',
            'for': '2m',
            expr: |||
              absent(up{%(nodelocaldnsSelector)s} == 1)
            ||| % $._config,
            labels: {
              severity: 'critical',
            },
            annotations: {
              message: 'Node Local DNS has disappeared from Prometheus target discovery.',
            },
          },
          {
            alert: 'NodeLocalDNSSetupErrorsHigh',
            expr: |||
              rate(coredns_nodecache_setup_errors{%(nodelocaldnsSelector)s}[5m]) > 0
            ||| % $._config,
            'for': '2m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              message: 'There are {{$labels.errortype}} errors setting up Node Local DNS.',
            },
          },
        ],
      },
    ],
  },
}
