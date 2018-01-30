;; General Setup --------------------------------------------------------------

;; Added by Package.el.  This must come before configurations of
;; installed packages.
(package-initialize)

;; custom set variables, can only be one instance
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (tango-dark)))
 '(elpy-modules
   (quote
    (elpy-module-company elpy-module-eldoc elpy-module-flymake elpy-module-pyvenv elpy-module-yasnippet elpy-module-sane-defaults)))
 '(package-selected-packages (quote (auctex ggtags elpy jedi marmalade-demo))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


(setq default-directory "~/Dropbox/VM_VirtualBox" )

;; additional elisp paths
(add-to-list 'load-path "~/Dropbox/VM_VirtualBox/emacs.d/lisp/ESS/lisp")
(add-to-list 'load-path "~/Dropbox/VM_VirtualBox/emacs.d/lisp/predictive")
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
(add-to-list 'package-archives
'("marmalade" . "http://marmalade-repo.org/packages/"))


;; make emacs open full screen 
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; set the opening screen to blank scratch page
(setq inhibit-splash-screen t)
(setq initial-scratch-message nil)

;;load packages
(require 'ssh)
(require 'tramp)
(require 'package)
(require 'ido)
(require 'predictive)
(require 'ess-site)
(require 'textmate)
(require 'magit)
(require 'auto-complete)

;; package specs
(ido-mode t)
(autopair-global-mode 1)
(elpy-enable)
(setenv "PYTHONPATH" "/usr/bin/python")

;;R auto-complete
(setq ess-use-auto-complete t)
(ess-toggle-underscore nil)
(global-auto-complete-mode t)

;; C++ mode
(add-hook 'c-mode-common-hook
          (lambda ()
            (when (derived-mode-p 'c-mode 'c++-mode 'java-mode 'asm-mode)
              (ggtags-mode 1))))

;; TEX mode
(setq TeX-auto-save t)
(setq TeX-parse-self t)
(setq TeX-save-query nil)
(setq TeX-PDF-mode t)
(setq-default TeX-master nil)
(add-hook 'LaTeX-mode-hook 'visual-line-mode)
(add-hook 'LaTeX-mode-hook 'flyspell-mode)
(add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)
(add-hook 'LaTeX-mode-hook 'turn-on-reftex)
(setq reftex-plug-into-AUCTeX t)
;;(load "auctex.el" nil t t)

;; to load TeX packages, put .sty file at:
;; /usr/share/texlive/texmf-dist/text
;; use root (sudo -s)



;; Custom Functions -------------------------------------------------------------------

;; function to open a new blank buffer
(defun j-new-buffer ()
  "Open a new empty buffer."
  (interactive)
  (let ((-buf (generate-new-buffer "untitled")))
    (switch-to-buffer -buf)
    (funcall (and initial-major-mode))
    (setq buffer-offer-save t)))

;; functions for python mode
(defun forward-block (&optional Ï†n)
  (interactive "p")
  (let ((Ï†n (if (null Ï†n) 1 Ï†n)))
    (search-forward-regexp "\n[\t\n ]*\n+" nil "NOERROR" Ï†n)))

(defun elpy-shell-send-current-block ()
  "Send current block to Python shell."
  (interactive)
  (beginning-of-line)
  (push-mark)
  (forward-block)
  (elpy-shell-send-region-or-buffer)
  (display-buffer (process-buffer (elpy-shell-get-or-create-process))
                  nil
                  'visible))


;; Custom Macros --------------------------------------------------------

;; open new empty buffer
(global-set-key (kbd "C-x C-k n") 'j-new-buffer) 

;; macro to login to app15
(fset 'login-15
   [?\M-x ?e ?s ?h ?e ?l ?l return ?c ?d ?  ?/ ?j ?m ?c ?m ?i ?l ?l ?a ?n ?@ ?1 ?0 ?. ?9 ?6 ?. ?2 ?6 ?. ?6 ?3 ?:])
(global-set-key (kbd "C-x C-k 1") 'login-15)

;; IP for app01 is 10.96.26.57
;; IP for app02 is 10.96.26.47

;; macro to login to app16
(fset 'login-16
   [?\M-x ?e ?s ?h ?e ?l ?l return ?c ?d ?  ?/ ?j ?m ?c ?m ?i ?l ?l ?a ?n ?@ ?1 ?0 ?. ?9 ?6 ?. ?2 ?6 ?. ?6 ?4 ?:])
(global-set-key (kbd "C-x C-k 2") 'login-16)

;; login to devapp01

(fset 'login-devapp1
   [?\M-x ?e ?s ?h ?e ?l ?l return ?c ?d ?  ?/ ?j ?m ?c ?m ?i ?l ?l ?a ?n ?@ ?1 ?0 ?. ?9 ?6 ?. ?2 ?6 ?. ?5 ?7 ?:])
(global-set-key (kbd "C-x C-k d") 'login-devapp1)

(setq last-kbd-macro
   nil)


;; type IP to app15 server
(global-set-key (kbd "C-x C-j 1") "/jmcmillan@10.96.26.63:/")

;; macro to open the configuration file
(fset 'open-config
   [?\C-x ?\C-f ?/ ?~ ?/ ?D ?r ?o ?p ?b ?o ?x ?/ ?V ?M ?_ ?V ?i ?r ?t ?u ?a ?l ?B ?o ?x ?/ ?e ?m ?a ?c ?d backspace ?s ?. ?d ?/ ?i ?n ?i ?t ?. ?e ?l return up up S-down S-down ?\M-x ?i ?n tab ?s ?e ?t ?- ?n backspace backspace backspace ?r ?t ?- ?k tab])

;; macros to navigate windows
(global-set-key (kbd "C-x <up>") 'windmove-up)
(global-set-key (kbd "C-x <down>") 'windmove-down)
(global-set-key (kbd "C-x <right>") 'windmove-right)
(global-set-key (kbd "C-x <left>") 'windmove-left) 
(global-set-key (kbd "C-S-x <left>") 'previous-buffer)
(global-set-key (kbd "C-S-x <right>") 'next-buffer)

;; set alt [ and ] be arrow keys
(global-set-key (kbd "M-[") [left])
(global-set-key (kbd "M-]") [right])
(global-set-key (kbd "M-p") [up])
(global-set-key (kbd "M-;") [down])



;;macros to edit pane size
(global-set-key (kbd "M-<left>") 'shrink-window-horizontally)
(global-set-key (kbd "M-<right>") 'enlarge-window-horizontally)
(global-set-key (kbd "M-<down>") 'shrink-window)
(global-set-key (kbd "M-<up>") 'enlarge-window)



;; make C-return send line to python shell
(eval-after-load "elpy"
  '(define-key elpy-mode-map (kbd " <C-return>") 'elpy-shell-send-current-statement))

;; shift C-return sends block to python shell
(eval-after-load "elpy"
  '(define-key elpy-mode-map (kbd " <C-S-return>") 'elpy-shell-send-region-or-buffer))

;; macro for git-status
(global-set-key (kbd "C-x g") 'magit-status)
