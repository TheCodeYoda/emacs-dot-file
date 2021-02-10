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
 '(custom-enabled-themes (quote (tango-dark)))
 '(inhibit-startup-screen t)
 '(package-selected-packages (quote (elpy company-irony use-package company))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; Turn on global auto completion
(use-package company
  :ensure t
  :delight
  :hook (after-init . global-company-mode)
  :bind (("C-<tab>" . company-complete))
  :config (add-to-list 'company-backends 'company-gtags))

;; To use clang format for all c c++ and glsl files
;; This is the standard for Blender
(add-hook 'c-mode-hook (lambda () (add-to-list 'before-save-hook 'clang-format-buffer)))
(add-hook 'c++-mode-hook (lambda () (add-to-list 'before-save-hook 'clang-format-buffer)))
(add-hook 'glsl-mode-hook (lambda () (add-to-list 'before-save-hook 'clang-format-buffer)))

;; Turn on line numbers for all buffers
(global-linum-mode)

;; auto complete braces
(setq electric-pair-preserve-balance nil)

;; elpy python
(use-package elpy
  :ensure t
  :init
  (elpy-enable))
;; use python3 not python2.7
(setq elpy-rpc-python-command "python3")

;; setting default syntactic indentation

(setq-default c-basic-offset 4)
(setq-default c++-basic-offset 4)
