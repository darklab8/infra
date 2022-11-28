#!/usr/bin/env python3
import argparse
import subprocess

parser = argparse.ArgumentParser()

parser.add_argument("--key", help="Registry key for gitlab runner")
parser.add_argument("--ns", help="Kubernetes namespaces for deployment")
parser.add_argument("--url", default="https://gitlab.com")

args = parser.parse_args()

subprocess.run((
    f'helm upgrade --install --create-namespace --namespace {args.ns} gitlab-runner .'
    f' --set gitlab-runner.runnerRegistrationToken={args.key}'
    f' --set gitlab-runner.gitlabUrl={args.url}'
), shell=True, check=True)
