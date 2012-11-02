; Skip the welcome screen.
(setq inhibit-splash-screen t)

; Confirm exiting because I have stubby fingers and hit C-x C-c easily.
(setq confirm-kill-emacs 'y-or-n-p)

; Disable scroll bars.
(scroll-bar-mode -1)

; Set column boundary.
(setq-default fill-column 79)

; View tabs as 4 spaces.
(setq-default tab-width 4)

; JetHead coding style.
(defun set-jh-style ()
    ; Use Stroustrup as a base.
    (setq c-default-style "stroustrup")

    ; Indent by four.
    (setq c-basic-offset 4)

    ; Indent with tab characters, not spaces.
    (setq indent-tabs-mode t))

; Use JetHead style automatically when opening a file in cc-mode.
(add-hook 'c-mode-common-hook 'set-jh-style)
