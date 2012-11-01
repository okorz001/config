; Skip the welcome screen.
(setq inhibit-splash-screen t)

; Confirm exiting because I have stubby fingers and hit C-x C-c easily.
(setq confirm-kill-emacs 'y-or-n-p)

; Disable scroll bars.
(scroll-bar-mode -1)

; Set column boundary.
(setq fill-column 79)

; JetHead coding style -- BSD indentation with 4 width tabs.
(setq c-default-style "bsd")
(setq-default tab-width 4)
