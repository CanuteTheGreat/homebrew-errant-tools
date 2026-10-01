# homebrew-errant-tools

Homebrew tap for free, zero-dependency security/ops CLI tools from
[Errant Solutions](https://errant.solutions).

## Install

```sh
brew tap canutethegreat/errant-tools https://git.canutethegreat.com/CanuteTheGreat/homebrew-errant-tools
brew install sshd-hardening-auditor
brew install tls-cert-watchdog
```

## Tools

- **sshd-hardening-auditor** — audits an `sshd_config` (or a live server via
  `sshd -T`) against CIS Benchmark / NIST-aligned SSH hardening
  recommendations. Stdlib-only Python, no dependencies.
- **tls-cert-watchdog** — checks TLS certificate expiry/chain health for one
  or more hosts, exits non-zero on problems so it's CI/cron-friendly.
  Stdlib-only Python, no dependencies.

Both tools are also available standalone at
https://git.canutethegreat.com/CanuteTheGreat/sshd-hardening-auditor and
https://git.canutethegreat.com/CanuteTheGreat/tls-cert-watchdog, and are
free to use (pay-what-you-want Stripe links in each README if you'd like to
support development).
