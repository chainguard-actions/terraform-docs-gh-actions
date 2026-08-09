<!-- markdownlint-disable -->

# Hardening Report: terraform-docs--gh-actions/v1.4.1

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **terraform-docs--gh-actions/v1.4.1** was hardened automatically. 1 finding(s) were identified and resolved across 3 iteration(s).

## Findings Fixed

### unpinned-uses (severity: high)

The action.yml runs.image field references a Docker image using a mutable tag (`docker://quay.io/terraform-docs/gh-actions:1.4.1`) instead of an immutable SHA digest. A tag can be silently overwritten to point to a different (potentially malicious) image without any change to this file, creating a supply-chain risk. It should be pinned to a full SHA256 digest, e.g. `image: quay.io/terraform-docs/gh-actions@sha256:<64-hex-char-digest> # 1.4.1`.

Locations:

- `action.yml:88`

## Iteration Notes

### Iteration 1

**Fixes applied:** unpinned-uses

**Notes:**

Pinned the Docker image reference in action.yml from the mutable tag `docker://quay.io/terraform-docs/gh-actions:1.4.1` to the immutable digest `docker://quay.io/terraform-docs/gh-actions:1.4.1@sha256:b3af46b47a0758f81c989706210ce632a64f00d0a150dca8270465f7f62b8031`. The docker:// scheme and the :1.4.1 tag are preserved inline alongside the digest.

### Iteration 2

**Fixes applied:** unpinned-uses, missing-permissions, script-injection, github-env-injection

**Notes:**

Fixed all five workflow files:

**ci.yml**: Pinned all 6 action references to full SHAs (actions/checkout@v4→11d5960a, docker/setup-qemu-action@v3→c7c53464, docker/setup-buildx-action@v3→8d2750c6, docker/build-push-action@v6→10e90e36, hashicorp/setup-terraform@v3→b9cd54a3). Added top-level `permissions: {}` and job-level `permissions: contents: read` on both jobs.

**publish.yml**: Pinned all 5 action references (actions/checkout@v4, docker/setup-qemu-action@v3, docker/setup-buildx-action@v3, docker/login-action@v3→c94ce9fb, docker/build-push-action@v6, release-drafter/release-drafter@v6→6a93d829). Added top-level `permissions: {}`, job-level `contents: read` on docker job, and `contents: write` + `pull-requests: write` on release-draft job.

**test.yml**: Pinned actions/checkout@v4 (×2) and ludeeus/action-shellcheck@master→00b27aa7. Added top-level `permissions: {}` and job-level `permissions: contents: read` on both jobs.

**release.yml**: Pinned all action references (actions/checkout@v4 ×3, stefanzweifel/git-auto-commit-action@v5→b863ae19, docker/setup-qemu-action@v3, docker/setup-buildx-action@v3, docker/login-action@v3, docker/build-push-action@v6). Fixed script injection by moving `${{ env.GOMPLATE_VERSION }}` and `${{ inputs.version }}` into `env:` blocks. Fixed github-env-injection by sanitizing with `printf '%s' | tr -d '\n\r'` before writing to $GITHUB_ENV. Added `permissions: contents: write` to update-tag job.

**update-tfdocs.yml**: Pinned actions/checkout@v4 and stefanzweifel/git-auto-commit-action@v5. Fixed script injection by moving `${{ env.GOMPLATE_VERSION }}`, `${{ github.event.client_payload.release-version }}`, and `${{ inputs.release-version }}` into `env:` blocks. Fixed github-env-injection by sanitizing with `printf '%s' | tr -d '\n\r'` before writing to $GITHUB_ENV.

### Iteration 3

**Fixes applied:** missing-permissions

**Notes:**

Added `permissions: contents: read` to the `docker` job in `.github/workflows/release.yml`. The docker job only needs read access to the repository contents for the checkout step; all other operations (Docker registry login and push) interact with an external registry and require no GitHub token permissions. This prevents the job from inheriting the default broad GitHub Actions permissions.

