# homebrew-errant-tools

Homebrew tap for free, zero-dependency security/ops CLI tools from
[Errant Solutions](https://errant.solutions).

## Install

```sh
brew tap canutethegreat/errant-tools https://git.canutethegreat.com/CanuteTheGreat/homebrew-errant-tools
brew install sshd-hardening-auditor
```

## Tools

- **sshd-hardening-auditor** — audits an `sshd_config` (or a live server via
  `sshd -T`) against CIS Benchmark / NIST-aligned SSH hardening
  recommendations.
- **tls-cert-watchdog** — checks TLS certificate expiry/chain health for one
  or more hosts, exits non-zero on problems so it's CI/cron-friendly.
- **security-txt-auditor** — audits `robots.txt` + `security.txt` (RFC 9116)
  misconfigurations for a domain.
- **cert-transparency-watcher** — monitors Certificate Transparency logs for
  unexpected issuers/subdomains via crt.sh, no API key needed.
- **dns-hygiene-checker** — finds dangling CNAMEs / subdomain-takeover setups
  before an attacker does.
- **cron-sanity-checker** — catches impossible dates, step-of-zero typos,
  backwards ranges, and the day-of-month/day-of-week OR gotcha in cron
  expressions.
- **json-schema-diff** — diffs two JSON Schema files and classifies every
  difference as breaking/compatible/informational, for API-versioning CI
  gates.
- **http-header-auditor** — live HTTP security header scanner (HSTS, CSP,
  cookie flags, HTTP→HTTPS redirect, etc.).
- **mail-security-auditor** — audits a domain's SPF/DKIM/DMARC/MX email
  authentication hygiene.
- **nginx-config-auditor** — static analyzer for nginx config files flagging
  common misconfigurations.
- **docker-baseline-auditor** — read-only Docker security baseline checker
  (CIS-adjacent).
- **webhook-sig-verifier** — verifies/debugs webhook HMAC signatures
  (GitHub, Stripe, Slack, generic HMAC schemes).
- **aws-waste-finder** — read-only AWS cost-drain scanner (unattached EBS,
  unassociated EIPs, old snapshots, NAT gateways, idle load balancers; RDS
  instances listed for manual review). boto3 and its dependencies are pinned in the formula and
  installed into the formula's own virtualenv — no `pip install` needed.

All tools are stdlib-only Python unless noted above, zero dependencies
beyond `python@3.13` (aws-waste-finder brings its own boto3). Every command
runs with Homebrew's Python (not whatever `python3` is first on PATH) and
supports `--version`. Each is also
available standalone at
`https://git.canutethegreat.com/CanuteTheGreat/<tool-name>` and is free to
use — pay-what-you-want Stripe links are in each tool's own README if you'd
like to support development.

## Tests

`ci/test_formulae.py` (run by CI on every push and daily) downloads every formula's
real archive and resources, checks their sha256, performs the formula's install steps
(libexec + wrapper, and the pinned boto3 virtualenv for aws-waste-finder) and runs its
`test do` block, which checks `--version` and one real offline behaviour per tool.
Changelogs and checksums for each version: the tool repo's Releases page.
