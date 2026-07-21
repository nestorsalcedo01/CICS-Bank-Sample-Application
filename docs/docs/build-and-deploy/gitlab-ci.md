---
layout: default
title: GitLab CI Pipeline
---

# GitLab CI Pipeline

CBSA uses a GitLab CI pipeline defined in [`.gitlab-ci.yml`](../../../.gitlab-ci.yml). The pipeline runs on a DAT Linux machine (`10.3.20.96`) that has connectivity to z/OS.

## Pipeline Variables

| Variable | Value | Description |
|---|---|---|
| `HLQ` | `GITLAB.CBSA` | High-level qualifier for z/OS datasets |
| `APPLICATION_NAME` | `CBSA` | Application name passed to zAppBuild |
| `UCD_APPLICATION` | `retirementCalculator-GitLab` | UCD application name |
| `UCD_COMPONENT` | `retirementCalculator-GitLab` | UCD component name |

## Stages

```
Preparation → Import → Build and Test → Environment Creation → Environment Cleanup
```

| Stage | Job | Description |
|---|---|---|
| Preparation | Preparation | Clones repo, sets up workspace on z/OS |
| Import | Import zAppBuild | Clones zAppBuild framework (`main` branch) |
| Build and Test | Build and Test | Runs zAppBuild `--fullBuild` on z/OS |
| Environment Creation | (optional) | Creates test environment |
| Environment Cleanup | (optional) | Tears down test environment |

## Build and Test Job

```yaml
Build and Test:
  needs: ["Import zAppBuild"]
  variables:
    ZAPPBUILD: "$CI_PROJECT_DIR/dbb-zappbuild"
    BUILD_TYPE: "--fullBuild"
```

The build runs zAppBuild with `--fullBuild` by default. Change `BUILD_TYPE` to `--impactBuild` for faster incremental builds on topic branches.

## Templates Used

The pipeline includes three shared templates from the GitLab server:

- `Preparation.gitlab-ci.yml`
- `Import_zAppBuild.gitlab-ci.yml`
- `BuildAndTest.gitlab-ci.yml`

These templates are maintained centrally at `/opt/gitlab/embedded/service/gitlab-rails/lib/gitlab/ci/templates/` on the DAT Linux machine.

## Code Review (Optional)

The `.Code Review` job is commented out by default. It uses:

```yaml
CODE_REVIEW_OPTIONS: "--propertyGroupFile ${PROPERTY_GROUP_FILE} --codepage IBM-1047"
```

Where `PROPERTY_GROUP_FILE` points to [`CBSA/application-conf/property-group.xml`](../../../CBSA/application-conf/property-group.xml).
