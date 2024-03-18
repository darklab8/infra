package apps

import (
    argoapp "github.com/argoproj/argo-cd/v2/pkg/apis/application/v1alpha1"
    shared "github.com/darklab8/infra/k8s/shared"
    argocue "github.com/darklab8/argocd-cue/argocue/settings"
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
    }
}

#application: "production-scarecrow": {
    spec: {
        source: {
            repoURL: "https://github.com/darklab8/infra.git"
            path: "k8s/modules/scarecrow"
        }
    }
}

#helm_parameters: argocue.#AppParameterGroup & {
    map: argocue.#AppParameters.HelmParameters,
}

#application: "production-monitoring": {
    spec: {
        source: {
            repoURL: "https://github.com/darklab8/infra.git"
            path: "k8s/modules/monitoring"
            plugin: {
                parameters: [
                    #helm_parameters & {
                        name: argocue.#APP_PARAMETER_HELM_PARAMETERS_KEY,
                        map: {
                            name_template: "monitoring"
                            namespace: "production-monitoring"
                        }
                    },
                ]
            }
        }
    }
}

build_file: [
   {#application."production-scarecrow"},
   {#application."production-monitoring"},
   {#namespace."production-scarecrow"},
   {#namespace."production-monitoring"},
]

#namespace: [Name=_]: {
    shared.#namespace_kind
    metadata: {
        name: Name
    }
}

#namespace: "production-scarecrow": {}
#namespace: "production-monitoring": {}
