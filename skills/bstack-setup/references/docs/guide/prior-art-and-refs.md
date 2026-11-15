# Prior art and local references

Reference repositories live in the parent workspace under `../ref/`, sibling to
`<project-name>/`.

| Relative path | Contents and role |
| --- | --- |
| `../ref/<repo>/` | <Role, upstream/historical context, and pinned commit SHA when inspected> |

Additional upstream or prior-art repositories can be checked out into `../ref/` on demand
as milestone investigations require them; update the table above when adding new checkouts.

## Usage rules

1. Keep all directories under `../ref/` read-only. If a checkout is missing on a new
   machine, ask the owner where to clone it before proceeding.
2. Cite exact file paths and commit SHAs in `research/` or `design/` notes when referencing
   upstream or historical implementations.
3. Preserve upstream license and attribution notices when reusing third-party code or test
   cases, and re-verify observations from earlier prototypes on the project's target
   toolchain and runtime environment.
