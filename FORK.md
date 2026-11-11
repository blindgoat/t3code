# This checkout is Colter's personal fork

`~/dev/t3code` is a fork of `pingdotgg/t3code`. Colter builds it and runs it as his everyday
T3 Code, in place of the official release. Keep the fork's changes small so upstream merges stay
easy.

## Remotes and identity

- `origin` is `git@github.com:blindgoat/t3code.git`, the fork. Changes go on `main`, no feature branches.
- `upstream` is `https://github.com/pingdotgg/t3code.git`, read only. Never push to it.
- Commits must be authored as `blindgoat@gmail.com`. `~/.gitconfig` picks that for any repo with a
  GitHub remote. Check with `git config user.email` before committing. Never use the MobilityWare identity here.
- Agents don't commit or push. Leave that to Colter and give him the commands.

## Making a change

1. Edit on `main` in `~/dev/t3code`.
2. Check: `vp run typecheck` in the app you changed (e.g. `apps/web`), plus `vp lint <file>` and `vp fmt --check <file>`.
3. Build the Mac app (about 2 minutes): `vp run dist:desktop:dmg:arm64`. It writes `release/T3-Code-<version>-arm64.zip`.
4. Colter commits and pushes: `git commit -am "..." && git push origin main`.
5. Install: Colter runs `~/dev/t3code/scripts/install-fork-build.sh` from **Terminal.app**. The script quits
   T3 Code, which ends any agent chat, so an agent can't run it. The script unpacks the newest build,
   moves the current app to the Trash, installs the new one, and reopens it.

## Pulling in upstream updates

```sh
git fetch upstream && git merge upstream/main
vp i   # when dependencies changed
```

Then build and install as above. Git only stops when upstream edited the same lines as a fork change.

## Things that keep this working

- The build must stay named `T3 Code (Beta)` with app ID `com.t3tools.t3code`. That makes it a drop-in
  replacement that uses the real data in `~/.t3/userdata`.
- Local builds have no update feed (`app-update.yml`), so the app never replaces itself with the official
  release. Don't set `T3CODE_DESKTOP_UPDATE_REPOSITORY` or `GITHUB_REPOSITORY` when building.
- Never run a dev server (`vp run dev`) against `~/.t3/userdata`. The main checkout's dev data is `~/.t3/dev`.
- Before a risky upgrade, back up the database while the app runs:
  `sqlite3 ~/.t3/userdata/statev2.sqlite ".backup '$HOME/t3-backup-$(date +%Y%m%d)/statev2.sqlite'"`
  (create the folder first). New code can migrate the database, and the older app may not read it afterwards.
- To roll back, quit T3 Code and drag a previous app from the Trash into `/Applications`.
