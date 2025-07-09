# Quantora Chain: Contributing Guide

## 1. Getting Started

- Fork the repo and clone your fork locally.
- Set up Rust, Node.js, or other required toolchains (see [README.md](README.md)).
- Run tests locally before submitting PRs.

---

## 2. Pull Request Process

- Open an issue for bugs or features before coding (unless trivial).
- Create a feature branch (`feature/your-feature`).
- Make small, focused commits with clear messages.
- Run `cargo test`, `cargo fmt`, and `cargo clippy` before pushing.
- Add tests for new features or bugfixes.
- Reference related issues in your PR.

---

## 3. Code Style

- Rust: `cargo fmt` (default style)
- JS/TS: Prettier (see `package.json`)
- Markdown: 100 columns max, use semantic line breaks

---

## 4. Commit Message Format

- Use [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/)
  - `fix: ...` for bug fixes
  - `feat: ...` for new features
  - `docs: ...` for documentation
  - `test: ...` for new/changed tests
  - `refactor: ...` for refactoring only
  - `chore: ...` for infra or non-product changes

---

## 5. Issue Tracking

- Use GitHub Issues for bugs, feature requests, proposals.
- Tag issues appropriately (e.g. `bug`, `enhancement`, `question`).

---

## 6. Security

- Do **not** post vulnerabilities in public issues.
- Use security@quantora.org for responsible disclosure.

---

## 7. Contributor License

- All contributions are dual-licensed (MIT/Apache 2.0).
- You agree to this by submitting code or docs.

---

## 8. Help

- Ask in Discord (#dev) or open a draft PR for feedback.

---

## 9. Recognition

- Top contributors are highlighted in [community_and_support.md](community_and_support.md) and can earn QTA rewards.

---