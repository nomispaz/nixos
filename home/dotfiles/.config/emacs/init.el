(require 'package)
(add-to-list 'package-archives '("gnu" . "https://elpa.gnu.org/packages/") t)
  (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

(add-to-list 'load-path "/usr/share/emacs/site-lisp")
(add-to-list 'load-path "~/.config/emacs/site-lisp")

(setq inhibit-startup-screen t)   ;; Disable the welcome screen
(tool-bar-mode -1)   	            ;; Disable the toolbar
(menu-bar-mode -1)                ;; Disable the menu bar
(scroll-bar-mode -1)              ;; Disable visible scrollbar

;; Remember recently edited files. Can then be shown with recentf-open-files
(recentf-mode 1)

;; Save what you enter into minibuffer prompts
(setq history-length 25)
(savehist-mode 1)

;; Remember and restore the last cursor location of opened files
(save-place-mode 1)

;; show relative line numbers
(menu-bar--display-line-numbers-mode-relative)

;; automatically close brackets
(electric-pair-mode 1)

;; disable sound
(setq ring-bell-function 'ignore)

;; (require 'nomispaz)

(global-set-key (kbd "C-+") 'text-scale-increase)                ;; zoom in
   (global-set-key (kbd "C--") 'text-scale-decrease)                ;; zoom out
   (global-set-key (kbd "<C-wheel-up>") 'text-scale-increase)       ;; zoom in with mouse wheel
   (global-set-key (kbd "<C-wheel-down>") 'text-scale-decrease)     ;; zoom out with mouse wheel
 ;;copy link anker to clipboard, insert with C-c C-l
 (global-set-key (kbd "C-c l") 'org-store-link)
 ;; duplicate current line
;; first unbind the C-, map in orgmode, then redefine the keymap
 (with-eval-after-load 'org
    (define-key org-mode-map (kbd "C-,") nil))

 (global-set-key (kbd "C-,") 'duplicate-line)

(require 'desktop)
  (desktop-save-mode 1)
   ;; don't save the following buffers
   (add-to-list 'desktop-modes-not-to-save 'dired-mode)
   (add-to-list 'desktop-modes-not-to-save 'Info-mode)
   (add-to-list 'desktop-modes-not-to-save 'info-lookup-mode)
   (add-to-list 'desktop-modes-not-to-save 'fundamental-mode)
   ;; specify dir to save session
   (setq desktop-dirname "~/.local/share/emacs/emacs_session_backup")
   (setq desktop-base-file-name "desktop")
   (setq desktop-base-lock-name "desktop.lock")

(set-face-attribute 'default nil :font "DejaVu Sans Mono" :height 180)
(set-face-attribute 'fixed-pitch nil :font "DejaVu Sans Mono" :height 180)
(set-face-attribute 'variable-pitch nil :font "DejaVu Sans" :height 180)

(set-face-attribute 'mouse nil :background "white")

(require 'catppuccin-theme)
(load-theme 'catppuccin :no-confirm)

;; Define a helper function to display a popup menu with all commands for a mode
(defun my/display-mode-menu (mode)
  "Display a popup menu with all commands available for MODE."
  (let ((mode-map (symbol-function mode)))
    (if (keymapp mode-map)
        (popup-menu
         (easy-menu-create-menu
          (symbol-name mode)
          (cl-loop for key in (cdr mode-map)
                   for binding = (cdr key)
                   when (commandp binding)
                   collect (vector (symbol-name binding) binding))))
      (message "No command menu available for %s" (symbol-name mode)))))

;; Helper function to make clickable modeline text with a popup menu
(defun my/modeline-menu-clickable (text mode)
  "Return TEXT with MODE set as a clickable action to show the mode's commands in the mode line."
  (propertize text 'mouse-face 'mode-line-highlight
              'help-echo (concat "Click to see commands for " (symbol-name mode))
              'local-map (let ((map (make-sparse-keymap)))
                           ;; Use a dynamically created function to avoid lexical binding
                           (define-key map [mode-line mouse-1]
                             `(lambda () (interactive) (my/display-mode-menu ',mode)))
                           map)))

;; Define a custom modeline
(defun my/custom-evil-mode-line-indicator ()
  "Return a string for the current Evil mode state."
  (cond
   ((evil-normal-state-p) "N")
   ((evil-visual-state-p) "V")
   ((evil-insert-state-p) "I")
   (t "-")))

(setq-default mode-line-format
              '((:eval (concat
                        " "
                        ;; Evil mode indicator
                        (my/custom-evil-mode-line-indicator)
                        " "

                        ;; Buffer name
                        "%b "
                        
                        ;; Line number
                        "L%l "
                        
                        ;; Yasnippet
                        (when (bound-and-true-p yas-minor-mode)
                          (my/modeline-menu-clickable " Yas " 'yas-minor-mode))
                        
                        ;; Flymake
                        (when (bound-and-true-p flymake-mode)
                          (my/modeline-menu-clickable " Flymake " 'flymake-mode))

                        ;; Go mode
                        (when (derived-mode-p 'go-mode)
                          (my/modeline-menu-clickable " Go " 'go-mode))

                        ;; Rust mode
                        (when (derived-mode-p 'rust-mode)
                          (my/modeline-menu-clickable " Rust " 'rust-mode))

                        ;; Python mode
                        (when (derived-mode-p 'python-mode)
                          (my/modeline-menu-clickable " Python " 'python-mode))))))

;; display completions in one column in minibuffer
(setq completions-format 'one-column)
;; disable header for completions (shown number of possible completions)
(setq completions-header-format nil)
;; disables case-sensitivity for minibuffer searches
(setq completion-ignore-case t)
(setq read-file-name-completion-ignore-case t)
(setq read-buffer-completion-ignore-case t)

(setq completion-auto-wrap t
    completion-auto-help nil
    completions-max-height 15
    completion-styles '(basic flex)
    icomplete-in-buffer t
    max-mini-window-height 10)

(fido-vertical-mode 1)

(require 'yasnippet)
(require 'yasnippet-snippets)
(yas-global-mode 1)

; Enable company-mode with language server support
    (require 'company)
      (setq company-minimum-prefix-length 2)
    (add-hook 'after-init-hook 'global-company-mode)
(setq company-backends '(company-capf company-yasnippet company-files))

(require 'consult)
(setq recentf-mode 1)

(require 'eglot)
  (require 'breadcrumb)
(defun add-yasnippet
    ()
    (setq company-backends '((company-capf :with company-yasnippet))))
(add-hook 'eglot--managed-mode-hook #'add-yasnippet)

; tree-sitter setup languages
    (setq treesit-language-source-alist
          '((go "https://github.com/tree-sitter/tree-sitter-go")
            (rust "https://github.com/tree-sitter/tree-sitter-rust"))
          )
(defun my/install-treesit_languages()
 (interactive)
 (mapc #'treesit-install-language-grammar (mapcar #'car treesit-language-source-alist))
 )

; Enable lsp-mode for Go and Rust modes
(require 'go-mode)
  (setq indent-tabs-mode nil)
  (setq go-announce-deprecations t)
  (setq go-mode-treesitter-derive t)

(add-hook 'go-mode-hook 'eglot-ensure)
(add-hook 'go-mode-hook 'yas-minor-mode)
(add-hook 'go-mode-hook 'breadcrumb-local-mode)

(require 'rust-mode)
(setq indent-tabs-mode nil)
 (setq rust-mode-treesitter-derive t)

(add-hook 'rust-mode-hook 'eglot-ensure)
(add-hook 'rust-mode-hook
  (lambda () (setq indent-tabs-mode nil)))  
(add-hook 'rust-mode-hook 'yas-minor-mode)
(add-hook 'rust-mode-hook 'breadcrumb-local-mode)
(setq rust-format-on-save t)

(require 'nix-mode)

(require 'org)
(require 'org-agenda)

;; replace "..." at the end of collapsed headlines
(setq org-ellipsis " ▾"
;; remove special characters used for bold, kursiv etc.
org-hide-emphasis-markers t)

(setq org-agenda-start-with-log-mode t)
(setq org-log-done 'time)
(setq org-log-into-drawer t)
;; RETURN will follow links in org-mode files
(setq org-return-follows-link  t)  

(add-hook 'org-mode-hook 'my/org-mode-setup())
(add-hook 'org-mode-hook 'my/org-font-setup())

;; folder for org-agenda
;,(setq org-agenda-files (directory-files-recursively "/mnt/nvme2/data/orgmode" "\\.org$"))

(defun my/org-mode-setup()
  ;; active automatic indentation
  (org-indent-mode 1)
  ;; proportially resize font
  (variable-pitch-mode 1)
  ;; automatically perform line wrap
  (visual-line-mode 1)
)
  (defun my/org-font-setup()
  ;; Replace list hyphen with dot
  (font-lock-add-keywords 'org-mode
                          '(("^ *\\([-]\\) "
                             (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

  ;;Set faces for heading levels.
  (dolist (face '((org-level-1 . 1.2)
                  (org-level-2 . 1.1)
                  (org-level-3 . 1.1)
                  (org-level-4 . 1.1)
                  (org-level-5 . 1.0)
                  (org-level-6 . 1.0)
                  (org-level-7 . 1.0)
                  (org-level-8 . 1.0)))
(set-face-attribute (car face) nil :font "DejaVu Sans" :weight 'regular :height (cdr face)))
;; Ensure that anything that should be fixed-pitch in Org files appears that way
(set-face-attribute 'org-block nil :foreground nil :inherit 'fixed-pitch)
(set-face-attribute 'org-code nil :inherit '(shadow fixed-pitch))
(set-face-attribute 'org-table nil :inherit '(shadow fixed-pitch))
(set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
(set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
(set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
(set-face-attribute 'org-checkbox nil :inherit 'fixed-pitch)
  )

(require 'evil)
   (setq evil-want-integration t)
    (setq evil-want-keybinding nil)
    (evil-mode 1)

(evil-set-undo-system 'undo-redo)

  ;;(use-package evil-collection
  ;;  :after evil
  ;;  :ensure t
  ;;  :config
  ;;  (evil-collection-init))

;; Using RETURN to follow links in Org/Evil 
;; Unmap keys in 'evil-maps if not done, (setq org-return-follows-link t) will not work
(with-eval-after-load 'evil-maps
  (define-key evil-motion-state-map (kbd "SPC") nil)
  (define-key evil-motion-state-map (kbd "RET") nil)
  (define-key evil-motion-state-map (kbd "TAB") nil))
;; Setting RETURN key in org-mode to follow links
  (setq org-return-follows-link  t)

;; set leader key in all states
   (evil-set-leader 'normal (kbd "SPC"))
   (evil-set-leader nil (kbd "SPC"))

   ;; set local leader
   (evil-set-leader 'normal "," t)

  ;; window navigation
    (define-key evil-normal-state-map (kbd "C-w <right>") '("Change to right window" . evil-window-right))
    (define-key evil-normal-state-map (kbd "C-w <left>") '("Change to left window" . evil-window-left))
   (define-key evil-normal-state-map (kbd "C-w <up>") '("Change to upper window" . evil-window-top))
   (define-key evil-normal-state-map (kbd "C-w <down>") '("Change to bottom window" . evil-window-down))
    (define-key evil-normal-state-map (kbd "C-w k") '("Close window" . evil-window-delete)) 
  ;; files
   (define-key evil-normal-state-map (kbd "<leader> f f") '("Search files" . consult-find))
   (define-key evil-normal-state-map (kbd "<leader> f r") '("Recent files" . recentf))
   (define-key evil-normal-state-map (kbd "<leader> f g") '("Search files (grep)" . consult-grep))
   (define-key evil-normal-state-map (kbd "<leader> f n") '("New file" . evil-buffer-new))

   ;; buffers
   (define-key evil-normal-state-map (kbd "<leader> b b") '("Switch to buffer" . switch-to-buffer))
   (define-key evil-normal-state-map (kbd "<leader> b k") '("Kill current buffer" . kill-current-buffer))
   (define-key evil-normal-state-map (kbd "<leader> b r") '("Rename buffer" . rename-buffer))
   (define-key evil-normal-state-map (kbd "<leader> b s") '("Save buffer" . basic-save-buffer))

   ;; tabs
   (define-key evil-normal-state-map (kbd "<leader> t t") '("Switch to tab" . tab-switch))

   ;; search
   (define-key evil-normal-state-map (kbd "<leader> s o") '("Search heading" - consult-outline))
   (define-key evil-normal-state-map (kbd "<leader> s l") '("Search line" . consult-line))

   ;; org-mode
   (define-key evil-normal-state-map (kbd "<leader> o e") '("Export org file" . org-export-dispatch))
    (define-key evil-normal-state-map (kbd "<leader> o a") '("Open org agenda" . org-agenda))
   (define-key evil-normal-state-map (kbd "<leader> o t") '("Export code blocks" . org-babel-tangle))
   (define-key evil-normal-state-map (kbd "<leader> o i s") '("Insert scheduled date" . org-schedule))

   ;; flycheck
   (define-key evil-normal-state-map (kbd "<leader> l l") '("Show list of flycheck errors" . flymake-show-buffer-diagnostics))
   (define-key evil-normal-state-map (kbd "<leader> l n") '("Next flycheck error" . flymake-goto-next-error))
   (define-key evil-normal-state-map (kbd "<leader> l p") '("Previous flycheck error" . flymake-goto-previous-error))

  ;; lsp
   (define-key evil-normal-state-map (kbd "<leader> g r n") '("Rename variable or function" . eglot-rename))
(define-key evil-normal-state-map (kbd "<leader> g d") '("LSP goto definition" . xref-find-definitions))
(define-key evil-normal-state-map (kbd "<leader> g D") '("LSP Find references" . xref-find-references))
(define-key evil-normal-state-map (kbd "K") '("LSP show doc in buffer" . eldoc))
(define-key evil-normal-state-map (kbd "C-.") '("LSP execute code action" . eglot-code-actions))
