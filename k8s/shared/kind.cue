package shared

import (
    metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
)

#kube_server: "https://kubernetes.default.svc"
#argo_namespace: "argocd"

#app_kind: metav1.#TypeMeta
#app_kind: {
    apiVersion: "argoproj.io/v1alpha1"
    kind: "Application"
    ...
}


#namespace_kind: metav1.#TypeMeta
#namespace_kind: {
    apiVersion: "v1"
    kind: "Namespace"
    ...
}


#deployment_kind: metav1.#TypeMeta
#deployment_kind: {
    apiVersion: "apps/v1"
    kind: "Deployment"
}
