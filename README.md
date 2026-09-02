# dotfiles

Personal configuration, linked into place by [`./install`](install) (macOS, Arch, Debian, WSL).

## Writing (prose)

[harper-ls](https://writewithharper.com) checks spelling and English grammar everywhere in nvim: markdown
(Obsidian vault), commit messages, and comments/doc-blocks in code (JSDoc, swagger, etc.). Native vim `spell`
is off — Harper replaces it because it understands code identifiers, and running both doubled every mark.
Style rules (sentence capitalization, long sentences, Oxford comma, title case, …) are deliberately disabled
in [`nvim/init.lua`](nvim/init.lua); only spelling and grammar remain. If Harper's grammar ever feels too
shallow, the agreed step-up is `ltex-ls-plus` (LanguageTool; also covers Spanish).

### Keymaps

| Keymap       | Action                                                                                |
| ------------ | ------------------------------------------------------------------------------------- |
| `<leader>ca` | Code action on a flagged word: add to dictionary, fix, or ignore this instance        |
| `<leader>uH` | Toggle Harper in the current buffer (kill switch while drafting)                      |
| `<leader>uS` | Spanish mode: native spell with `spelllang=es`, Harper muted; toggle again to go back |

First use of Spanish mode prompts to download the `es` spell file — accept once.

### Everyday operations

- **Teach Harper a word**: code action → "Add to user dictionary". Words land in
  [`harper/dictionary.txt`](harper/dictionary.txt) (tracked — commit it so machines stay in sync).
- **Silence a rule permanently**: the diagnostic shows the rule code (e.g. `SentenceCapitalization`);
  add `RuleName = false` to the `linters` table in `nvim/init.lua`. Full rule list:
  <https://writewithharper.com/docs/rules>.
- **Dismiss one occurrence**: code action → "Ignore this". Stored machine-locally in
  `~/Library/Application Support/harper-ls/ignored_lints/`, not synced.

### Known behavior

- `isolateEnglish` skips text Harper doesn't classify as English (so Spanish paragraphs stay quiet);
  it can rarely skip a strangely-worded English chunk too.
- Commit messages are checked, but the verbose diff below the scissors line is not — `commit.verbose`
  is safe to keep.
- Dialect is American English (Harper's default).
