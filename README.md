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
  unassociated EIPs, old snapshots, NAT gateways, idle load balancers,
  oversized RDS). Requires `boto3` (`pip3 install boto3`) — not vendored by
  the formula.

All tools are stdlib-only Python unless noted above, zero dependencies
beyond `python@3.12` (and `boto3` for aws-waste-finder). Each is also
available standalone at
`https://git.canutethegreat.com/CanuteTheGreat/<tool-name>` and is free to
use — pay-what-you-want Stripe links are in each tool's own README if you'd
like to support development.
