---
layout: default
title: Running Tests
---

# Running Tests

## Enabling Tests in the Pipeline

Tests are enabled by setting `runzTests=true` in [`CBSA/application-conf/application.properties`](../../../CBSA/application-conf/application.properties):

```properties
runzTests=true
```

When enabled, the DBB pipeline runs `ZunitConfig.groovy` after the main build completes.

## Running All Tests (Full Pipeline)

Tests run automatically as part of the zAppBuild pipeline on z/OS:

```bash
$DBB_HOME/bin/groovyz dbb-zappbuild/build.groovy \
  --workspace /u/gitlab/CBSA \
  --application CBSA \
  --hlq GITLAB.CBSA \
  --fullBuild
```

## Running a Single Test (User Build)

To run only the test for `BNKMENU`:

```bash
$DBB_HOME/bin/groovyz dbb-zappbuild/build.groovy \
  --workspace /u/gitlab/CBSA \
  --application CBSA \
  --hlq GITLAB.CBSA \
  --userBuild CBSA/testcfg/BNKMENU.bzucfg
```

The `--userBuild` flag targets the `.bzucfg` file (not the `.cbl` test case directly).

## Test Results

With `zunit_bzuplayParms=STOP=E,REPORT=XML`, results are written as XML to the build output directory. DBB processes these XML files to determine pass/fail status and publish results to the pipeline.

Return code thresholds (from `ZunitConfig.properties`):

| RC Range | Status |
|---|---|
| 0 – 4 | Pass |
| 5 – 8 | Warning |
| > 8 | Fail |

## Viewing Results in GitLab CI

The `Build and Test` stage uploads test XML results as artifacts. View them in GitLab under **CI/CD → Pipelines → [build] → Tests**.
