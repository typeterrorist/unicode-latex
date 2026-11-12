# unicode-latex

LaTeX packages for typing Unicode characters directly into pdfLaTeX
documents, in text and in maths: `$∀ x ∈ ℕ. x ≥ 0$` comes out as
`$\forall x \in \mathbb{N}. x \ge 0$` would.

## Packages

- `utf8.sty` declares a few hundred characters: Greek letters, arrows,
  logical and set-theoretic symbols, blackboard and calligraphic capitals,
  sub- and superscripts. It loads `esint` and `graphicx`. Characters set as
  AMS symbols need `amssymb`, or a font package that provides them such as
  `newtxmath`; `⟦` and `⟧` need `stmaryrd`, and `∎` needs `amsthm`.
  It also defines `\scaledbin{factor}{symbol}`, a binary operator made from a
  scaled glyph, and `\widerel{factor}{symbol}`, a horizontally stretched
  relation.
- `interrobang.sty` sets `‽` (or `\interrobang`) from the current font's `?`
  and `!`, leaning apart by `\interrobangangle` degrees. It needs TikZ.

## With Nix

The flake's default package is a TeX Live package, so the packages are found
like any other once it is part of the TeX environment:

```nix
inputs.unicode-latex = {
  url = "github:typeterrorist/unicode-latex";
  inputs.nixpkgs.follows = "nixpkgs";
};

tex = pkgs.texlive.withPackages (ps: [
  ps.scheme-small
  unicode-latex.packages.${system}.default
]);
```

`nix flake check` typesets every character `utf8.sty` declares.

## Without Nix

Copy `utf8.sty` and `interrobang.sty` next to the document, or into a
directory on `TEXINPUTS`.
