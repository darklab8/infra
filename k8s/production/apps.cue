package apps

import (
    appsv1 "k8s.io/api/apps/v1"
    argoapp "github.com/argoproj/argo-cd/v2/pkg/apis/application/v1alpha1"
    shared "github.com/darklab8/infra/k8s/shared"
)

#scarecrow_name: "production-scarecrow"

application: argoapp.#Application
application: {
    shared.#app_kind
    metadata: {
        name: #scarecrow_name
        namespace: shared.#argo_namespace
    }
    spec: {
        project: "default"
        source: {
            repoURL: "https://github.com/darklab8/infra.git"
            targetRevision: "HEAD"
            path: "k8s/modules/scarecrow/build"
        }
        destination: {
            server: shared.#kube_server
            namespace: #scarecrow_name
        }
        syncPolicy: {
            automated: {}
        }
    }
}

#build_file: [
   {application},
   {namespace},
]

#namespace: appsv1.#Namespace
namespace: {
    shared.#namespace_kind
    metadata: {
        name: #scarecrow_name
        labels: {
            name: #scarecrow_name
        }
    }
}
