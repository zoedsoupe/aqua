{ pkgs, ... }:

with pkgs;

let
  prolog-mode-over = epkgs: epkgs.prolog-mode.overrideAttrs (oldAttrs: rec {
    src = builtins.fetchurl {
      url = "http://bruda.ca/_media/emacs/prolog.el";
      sha256 = "ZzIDFQWPq1vI9z3btgsHgn0axN6uRQn9Tt8TnqGybOk=";
    };
  });
in
{
  xdg.configFile."emacs/init.el".source = ./init.el;
  xdg.configFile."emacs/elisp".source = ./elisp;
  xdg.configFile."emacs/libs".source = ./libs;

  services.emacs.enable = true;

  programs.emacs = {
    enable = true;
    extraPackages = epkgs: with epkgs; [
      dashboard
      posframe
      centaur-tabs
      agda2-mode
      hl-todo
      doom-modeline
      doom-themes
      racket-mode
      nix-mode
      neotree
      git-gutter-fringe
      vterm
      magit
      gist
      github-review
      rainbow-delimiters
      rainbow-mode
      projectile
      paredit
      flycheck
      elixir-mode
      alchemist
      (prolog-mode-over epkgs)
      flycheck-credo
      erlang
      haskell-mode
      js2-mode
      rjsx-mode
      typescript-mode
      js2-refactor
      attrap
      use-package
      org
      markdown-mode
      markdown-toc
      edit-indirect
      grip-mode
      fish-mode
      emmet-mode
      web-mode
      company-web
      toml-mode
      yaml-mode
      json-mode
      all-the-icons
      emojify
      page-break-lines
      yasnippet-snippets
      flycheck-popup-tip
      org-cliplink
      org-pdftools
      orgit
      org-brain
      org-download
      org-tree-slide
      which-key
      ob-elixir
      org-bullets
      org-roam
      company-box
      company-quickhelp
      selectrum
      orderless
      consult
      consult-flycheck
      evil-nerd-commenter
      bind-key
      gnu-elpa-keyring-update
      diminish
      paradox
      auto-package-update
      minions
    ];
  };
}
