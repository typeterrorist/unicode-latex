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

  In typewriter text, such as code, Greek and double-struck letters and `×`
  are each one column wide: Greek letters stand upright (`\upalpha` and so
  on, from `newtxmath` or `upgreek`), double-struck letters are DSSerif's,
  and `×` is the typewriter face's own. A letter wider than its column is
  centred on it; `\usepackage[condensed]{utf8}` squeezes it to the column
  instead. Italic double-struck letters (ⅅ ⅆ ⅇ ⅈ ⅉ) are the upright ones
  slanted. Lowercase double-struck letters in maths need a `\mathbb` that
  has them; `amssymb`'s does not.
- `interrobang.sty` sets `‽` (or `\interrobang`) from the current font's `?`
  and `!` around a single dot, leaning apart by `\interrobangangle` degrees.
  The dots of Kepler (kpfonts) are known; `\interrobangdots` gives them for
  another font. It needs TikZ.

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

`nix flake check` typesets every character `utf8.sty` declares, in roman and
in typewriter text.

## Without Nix

Copy `utf8.sty` and `interrobang.sty` next to the document, or into a
directory on `TEXINPUTS`.
