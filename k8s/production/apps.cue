package apps

import (
    // appsv1 "k8s.io/api/apps/v1"
    argoapp "github.com/argoproj/argo-cd/v2/pkg/apis/application/v1alpha1"
    shared "github.com/darklab8/infra/k8s/shared"
)

#scarecrow_name: "production-scarecrow"
#monitoring_name: "production-monitoring"

#application: [string]: argoapp.#Application
#application: [Namespace=_]: {
    shared.#app_kind
    metadata: {
        name: Namespace
        namespace: shared.#argo_namespace
    }
    spec: {
        project: "default"
        source: {
            repoURL: string
            targetRevision: "HEAD"
            path: string
        }
        destination: {
            server: shared.#kube_server
            namespace: Namespace
        }
        syncPolicy: {
            automated: {}
        }
    }
}

#application: "production-screwgrow": {
    spec: {
        source: {
            repoURL: "https://github.com/darklab8/infra.git"
            path: "k8s/modules/scarecrow"
        }
    }
}

#application: "production-monitoring": {
    spec: {
        source: {
            repoURL: "https://github.com/darklab8/infra.git"
            path: "k8s/modules/monitoring"
        }
    }
}

build_file: [
   {#application."production-screwgrow"},
   {#application."production-monitoring"},
   {#namespace."production-screwgrow"},
   {#namespace."production-monitoring"},
]

#namespace: [Name=_]: {
    shared.#namespace_kind
    metadata: {
        name: Name
    }
}

#namespace: "production-screwgrow": {}
#namespace: "production-monitoring": {}
