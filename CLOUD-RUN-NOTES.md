cloud-run-notes
===============

This file contains notes about an effort to convert `mac-to-vendor` from a manually deployed
heroku app to an app that uses Google Cloud Build for CI/CD and runs on Google Cloud Run.

Related PR: https://github.com/joemiller/mac-to-vendor/pull/5

Notes
-----

1. create google cloud project
2. enable cloud run and container registry

Switching accounts with `gcloud`:
```
gcloud auth list
gcloud config set account joeym@joeym.net
```

```
gcloud services enable run.googleapis.com --project=joe-mac-to-vendor
gcloud services enable containerregistry.googleapis.com --project=joe-mac-to-vendor
```

building on cloud builder:
```
gcloud builds submit --tag gcr.io/joe-mac-to-vendor/mac-to-vendor --project=joe-mac-to-vendor
```

or - build/push locally
```
# Build the image
docker build -t gcr.io/[PROJECT-ID]/movies/sintel .

# Push the image to your Google Cloud Repository
docker push gcr.io/[PROJECT-ID]/movies/sintel
```

Deploy on Cloud Run
```
gcloud beta run deploy sintel-movie --allow-unauthenticated --image=gcr.io/[PROJECT-ID]/movies/sintel --region=us-central1 --project=[PROJECT-ID]
```

IAM, Deploying from Cloud Build -> Cloud run:

1. Grant the Cloud Run Admin role to the Cloud Build service account
2. Grant the IAM Service Account User role to the Cloud Build service account on the Cloud Run runtime service account

https://cloud.google.com/cloud-build/docs/configuring-builds/build-test-deploy-artifacts#deploying_artifacts


TODOs:

- [ ] update readme
  - [ ] new URL
- [ ] turn off heroku app

cloud builder notes
-------------------

https://cloud.google.com/cloud-build/docs/quickstart-docker

https://itnext.io/what-i-learned-switching-from-circleci-to-google-cloud-build-b4405de2be38

> A shared workspace (mounted at /workspace) is persisted between steps.

short example cloudbuild.yaml pushing to cloud run on gke - https://gist.github.com/ricardolsmendes/9567b295422669b02d9966f3e9ba3aa1

default env vars in GCB - https://cloud.google.com/cloud-build/docs/configuring-builds/substitute-variable-values#using_default_substitutions


Learnings
---------

### Different actions on branches, eg: deploy only from master

For the common case of "run tests on all branches, plus deploy on master", you can setup
multiple Build Triggers for the project. This is kind of awkward coming from circle or travis.

Each trigger could execute a different `cloudbuild.yaml` from the repo, however. Which makes
this a bit similar to Azure DevOps Pipelines.

### Parallel builds / ordering of steps

Ref: https://cloud.google.com/cloud-build/docs/configuring-builds/configure-build-step-order

TL;DR:

1. By default, all `steps` run sequentially
2. A step can be given only a single or multiple dependencies by using `waitFor` to determine
   which jobs must run first.
3. Use `waitfor: ['-']` to run a step immediately at build time, in parallel of other steps that
   may be running sequentially.

### Speeding up builds with docker layer caching

Ref: https://cloud.google.com/cloud-build/docs/kaniko-cache

Support for Kaniko to push intermediate layers to repo with a cache TTL:

Replace:

```yaml
steps:
- name: gcr.io/cloud-builders/docker
  args: ['build', '-t', 'gcr.io/$PROJECT_ID/image', '.']
images:
- 'gcr.io/$PROJECT_ID/image'
```

With:

```yaml
steps:
- name: 'gcr.io/kaniko-project/executor:latest'
  args:
  - --destination=gcr.io/$PROJECT_ID/image
  - --cache=true
  - --cache-ttl=XXh
```