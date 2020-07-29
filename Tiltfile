local('kubectl apply -f tilt/namespace.yaml')

docker_build('prometheus-klot-io', '.')

k8s_yaml(kustomize('.'))

k8s_resource('db', port_forwards=['9090:80'])