package apps

import (
    appsv1 "k8s.io/api/apps/v1"
    metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
    argoapp "github.com/argoproj/argo-cd/v2/pkg/apis/application/v1alpha1"
)

#kube_server: "https://kubernetes.default.svc"
#argo_namespace: "argocd"

#app_kind: metav1.#TypeMeta
#app_kind: {
    apiVersion: "argoproj.io/v1alpha1"
    kind: "Application"
    ...
}

application: argoapp.#Application
application: {
    #app_kind
    metadata: {
        name: "scarecrow"
        namespace: #argo_namespace
    }
    spec: {
        project: "default"
        source: {
            repoURL: "https://github.com/darklab8/infra.git"
            targetRevision: "HEAD"
            path: "k8s/scarecrow/build"
        }
        destination: {
            server: #kube_server
            namespace: "scarecrow"
        }
        syncPolicy: {
            automated: {}
        }
    }
}


#files: [
   {application},
   {namespace},
]


#namespace_kind: metav1.#TypeMeta
#namespace_kind: {
    apiVersion: "v1"
    kind: "Namespace"
    ...
}

#namespace: appsv1.#Namespace
namespace: {
    #namespace_kind
    metadata: {
        name: "scarecrow"
        labels: {
            name: "scarecrow"
        }
    }
}
