{
  description = "Unicode characters in pdfLaTeX documents";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" ];
      forAll = f: nixpkgs.lib.genAttrs systems (system: f nixpkgs.legacyPackages.${system});

      unicode-latex = pkgs: pkgs.stdenvNoCC.mkDerivation {
        pname = "unicode-latex";
        version = builtins.substring 0 8 self.lastModifiedDate;
        src = self;
        outputs = [ "tex" ];
        passthru.tlDeps = ps: with ps; [ esint esint-type1 dsserif cm-super graphics pgf ];
        preHook = ''
          out="''${tex-}"
        '';
        dontConfigure = true;
        dontBuild = true;
        installPhase = ''
          install -Dm644 -t "$tex/tex/latex/unicode-latex" utf8.sty interrobang.sty
        '';
      };
    in {
      packages = forAll (pkgs: {
        default = unicode-latex pkgs;
      });

      checks = forAll (pkgs: {
        characters = pkgs.runCommand "unicode-latex-characters" {
          nativeBuildInputs = [
            (pkgs.texlive.withPackages (ps: with ps; [
              scheme-basic amsfonts amsmath amscls stmaryrd was
            ] ++ [ (unicode-latex pkgs) ]))
          ];
        } ''
          export HOME="$TMPDIR" LC_ALL=C.UTF-8
          sed -nE 's/^\\DeclareUnicodeCharacter\{([0-9A-F]+)\}.*% "(.*)"$/\1 \2/p' \
            ${./utf8.sty} > declared
          if cut -d' ' -f1 declared | sort | uniq -d | grep .; then
            echo "declared more than once" >&2
            exit 1
          fi
          while read -r hex char; do
            expected=$(printf "\\U$(printf %08X "0x$hex")")
            if [ "$char" != "$expected" ]; then
              echo "U+$hex is commented as $char" >&2
              exit 1
            fi
            case $hex in
              221A) printf 'U+%s $%sx$ \\texttt{$%sx$}\\par\n' "$hex" "$char" "$char" ;;
              *) printf 'U+%s %s \\texttt{%s}\\par\n' "$hex" "$char" "$char" ;;
            esac
          done < declared > declared-characters.tex
          cp ${./test/characters.tex} characters.tex
          pdflatex -halt-on-error -interaction=nonstopmode characters.tex
          touch "$out"
        '';
      });
    };
}
