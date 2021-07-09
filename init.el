(package-initialize)
(when (>= emacs-major-version 24)
  (require 'package)
  (add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t))

(eval-when-compile
  (or (require 'use-package nil t)
      (progn
	(package-refresh-contents)
	(package-install 'use-package)
	(message "On a new system. Just installed use-package!"))))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(inhibit-startup-screen t)
 '(package-selected-packages
   (quote
    (ggtags lsp-ui flycheck-pos-tip flycheck-rust racer cargo flycheck-popup-tip company-c-headers darkokai-theme cyberpunk-theme irony-eldoc platformio-mode clang-format+ rust-mode elpy company-irony use-package company)))
 '(safe-local-variable-values
   (quote
    ((projectile-project-run-cmd . "./target/debug")
     (projectile-project-compilation-cmd . "bear make")))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
;;enable cyberpunk theme
(load-theme 'darkokai t)
;; Turn on global auto completion
(use-package company
  :ensure t
  :delight
  :hook (after-init . global-company-mode)
  :bind (("C-<tab>" . company-complete))
  :custom (company-backends '(company-capf company-gtags)))

;; To use clang format for all c c++ and glsl files
;; This is the standard for Blender
(add-hook 'c-mode-hook (lambda () (add-to-list 'before-save-hook 'clang-format-buffer)))
(add-hook 'c++-mode-hook (lambda () (add-to-list 'before-save-hook 'clang-format-buffer)))
(add-hook 'glsl-mode-hook (lambda () (add-to-list 'before-save-hook 'clang-format-buffer)))
;; comment hook for c++
(add-hook 'c++-mode-hook (lambda() (setq comment-start "/* " comment-end "*/")))

;; To use gtags, must have run `apt install global exuberant-ctags`
;; first
(use-package ggtags
  :ensure t
  :hook ((c-mode c++-mode glsl-mode) . ggtags-mode))

;; Turn on line numbers for all buffers
(global-linum-mode)

;; adjust line numbers when zoomed in

(eval-after-load "linum"
  '(set-face-attribute 'linum nil :height 200))

;; auto complete braces
(setq electric-pair-preserve-balance nil)

;; elpy python
(use-package elpy
  :ensure t
  :init
  (elpy-enable))
;; use python3 not python2.7
(setq elpy-rpc-python-command "python3")

;; overlapping strings sound fix
(setq elpy-eldoc-show-current-function nil)

;; setting default syntactic indentation

(setq-default c-basic-offset 2)
(setq-default c++-basic-offset 2)

;; To use clang format for all c and c++ files
;; This is the standard for Blender
(use-package clang-format+
  :ensure t
  :init
  (add-hook 'c-mode-hook #'clang-format+-mode)
  (add-hook 'c++-mode-hook #'clang-format+-mode)
  )

;; To use gtags, must have run `apt install global exuberant-ctags`
;; first
;; (use-package ggtags
;;   :ensure t
;;   :hook ((c-mode c++-mode glsl-mode) . ggtags-mode))

;; Use projectile for easily moving around in projects
(use-package projectile
  :ensure t
  :bind-keymap ("C-c p" . projectile-command-map))



;; Rust configuration
(use-package rust-mode
  :ensure t
  :config
  (setq rust-format-on-save t
        rust-format-show-buffer nil)
  (add-hook 'rust-mode-hook
            (lambda ()
              (setq indent-tabs-mode nil)
              ;; Prevent rust from hijacking the nice fold-this mode
              (define-key rust-mode-map (kbd "C-c C-f") nil))))
(use-package cargo
  :ensure t
  :after rust-mode
  :hook (rust-mode . cargo-minor-mode))


;; (use-package racer
;;   :ensure t
;;   :after rust-mode
;;   :hook (rust-mode . racer-mode)
;;   :config
;;   (add-hook 'racer-mode-hook #'eldoc-mode)
;;   (add-hook 'racer-mode-hook #'company-mode)
;;   ;; (define-key rust-mode-map (kbd "TAB") #'company-indent-or-complete-common)
;;   (setq company-tooltip-align-annotations t)
;;   (setq racer-rust-src-path
;;         ;; Workaround for changes to where std is stored until (see
;;         ;; https://github.com/racer-rust/emacs-racer/pull/143)
;;       (let* ((sysroot (string-trim
;;                        (shell-command-to-string "rustc --print sysroot")))
;;              (lib-path (concat sysroot "/lib/rustlib/src/rust/library"))
;;               (src-path (concat sysroot "/lib/rustlib/src/rust/src")))
;;         (or (when (file-exists-p lib-path) lib-path)
;;             (when (file-exists-p src-path) src-path))))
;;   :bind (:map racer-mode-map
;;          ("C-'" . racer-find-definition-other-window)))
;; (use-package flycheck-rust
;;   :ensure t
;;   :after rust-mode
;;   :hook (flycheck-mode . flycheck-rust-setup)
;;   :hook (rust-mode . flycheck-mode))
;; (use-package flycheck-pos-tip
;;   :ensure t
;;   ;; :hook (rust-mode . flycheck-pos-tip-mode)
;; )
;; (use-package flycheck-popup-tip
;;   :ensure t
;;   :hook (rust-mode . flycheck-popup-tip-mode)
;;   )


;; Language server using lsp-mode
(use-package lsp-mode
  :ensure t
  :commands (lsp lsp-deferred)
  :init (setq lsp-keymap-prefix "C-c l")
  :hook ((c++-mode . lsp-deferred)
	 (c-mode . lsp-deferred)
	 (rust-mode . lsp-deferred)
	 (lsp-mode . lsp-enable-which-key-integration))
  :config
  (setq lsp-enable-symbol-highlighting nil)
  (yas-global-mode t))

;; nice lsp ui features
(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode
  :after (lsp-mode)
  :hook (lsp-mode-hook . lsp-ui-mode)
  :bind (:map lsp-ui-mode-map
         ("C-?" . 'lsp-ui-doc-glance)
         ("C-]" . 'lsp-ui-peek-find-references))
  :init
  ;; Make sure lsp prefers flycheck over flymake
  (setq lsp-prefer-flymake nil)
  ;; Disable the semi-annoying hover-to-see-docs view
  (setq lsp-ui-doc-enable nil))

;; a fix to make lsp-mode work
;; might need to `list-packages` and install `dash` from `MELPA`
(use-package dash
    :ensure t)



