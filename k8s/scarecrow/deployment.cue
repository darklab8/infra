package scarecrow

import (
    appsv1 "k8s.io/api/apps/v1"
    metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
)

#screcrow_name: "amd-scarecrow"
#screcrow_pod_name: "\(#screcrow_name)-pod"
#scarecrow_selector: {
    app: #screcrow_pod_name
}

#scarecrow_meta: metav1.#TypeMeta
#scarecrow_meta: {
    apiVersion: "apps/v1"
    kind: "Deployment"
}

#label_selector_node_arm: {
    matchExpressions: [
        {
            key: "node"
            operator: "In"
            values: ["amd"]  
        }
    ]
}

#scarecrow_deploy: appsv1.#Deployment
#scarecrow_deploy: {
    metadata: {
        name: "\(#screcrow_name)-deploy"
    }
    spec: {
        replicas: 1
        selector: {
            matchLabels: #scarecrow_selector
        }
        template: {
            metadata: {
                labels: #scarecrow_selector
            }
            spec: {
                affinity: {
                    nodeAffinity: {
                        requiredDuringSchedulingIgnoredDuringExecution: {nodeSelectorTerms: [#label_selector_node_arm]}
                    }
                    podAntiAffinity: {
                        requiredDuringSchedulingIgnoredDuringExecution: [
                            {   
                                labelSelector: #label_selector_node_arm
                                topologyKey: "kubernetes.io/hostname"
                            }
                        ]
                        
                    }
                }
                containers: [
                    {
                        image: "busybox"
                        name: "\(#screcrow_name)-ctr"
                        command: ["tail", "-f", "/dev/null"]
                    }
                ]
            }
        }
    }
}

#scarecrow_meta
#scarecrow_deploy
