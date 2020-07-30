docker_build('prometheus-klot-io', '.')

k8s_yaml(kustomize('.'))

k8s_resource('gui', port_forwards=['9090:9090'])