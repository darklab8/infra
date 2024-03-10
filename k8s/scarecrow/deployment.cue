package scarecrow

import (
    appsv1 "k8s.io/api/apps/v1"
    shared "github.com/darklab8/infra/k8s/shared"
)

#screcrow_name: "amd-scarecrow"
#screcrow_pod_name: "\(#screcrow_name)-pod"
#scarecrow_selector: {
    app: #screcrow_pod_name
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
    shared.#deployment_kind
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

#files: [
   {
        #scarecrow_deploy
   }
]

