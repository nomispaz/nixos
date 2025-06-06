(setq-default mode-line-format
              '("%b"
		" "
		mode-line-position
                " "
		mode-line-modes
                ))

(kill-local-variable 'mode-line-format)

(force-mode-line-update)
