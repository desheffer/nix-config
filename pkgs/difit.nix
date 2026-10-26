{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchPnpmDeps,
  makeWrapper,
  nodejs_24,
  pnpm_10_latest,
  pnpmConfigHook,
  git,
  gh,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "difit";
  version = "5.0.12";

  src = fetchFromGitHub {
    owner = "yoshiko-pg";
    repo = "difit";
    rev = "v${finalAttrs.version}";
    hash = "sha256-1EoC5t+8KjNmwKg5lFLig26tzCnp2byhkeGjctVdRls=";
  };

  pnpmWorkspaces = [ "difit" ];
  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      pnpmWorkspaces
      ;
    pnpm = pnpm_10_latest;
    fetcherVersion = 4;
    hash = "sha256-hX7JSbA/ZgY8B8Wwvkcq3/TpSy/nZAs7x65vDUQO5yM=";
  };

  nativeBuildInputs = [
    makeWrapper
    nodejs_24
    pnpm_10_latest
    pnpmConfigHook
  ];

  buildPhase = ''
    runHook preBuild

    pnpm run build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/node_modules/difit $out/bin
    cp -R dist package.json pnpm-lock.yaml pnpm-workspace.yaml $out/lib/node_modules/difit/

    pushd $out/lib/node_modules/difit
    pnpm install --prod --offline --frozen-lockfile --ignore-scripts
    popd

    makeWrapper ${lib.getExe nodejs_24} $out/bin/difit \
      --add-flags "$out/lib/node_modules/difit/dist/cli/index.js" \
      --prefix PATH : ${
        lib.makeBinPath [
          gh
          git
        ]
      }

    runHook postInstall
  '';

  meta = {
    description = "GitHub-style diff viewer for local Git changes";
    homepage = "https://github.com/yoshiko-pg/difit";
    license = lib.licenses.mit;
    mainProgram = "difit";
  };
})
