(defun nomispaz-seconds-to-hhmmss (seconds)
  "Convert seconds since midnight to 'hh:mm:ss' format."
  (interactive "nEnter seconds after midnight: ")

  (setq total-seconds seconds
	hours (floor total-seconds 3600)
	seconds-left (mod total-seconds 3600))
    
    (setq minutes (floor (mod total-seconds 3600) 60)
	  seconds-left (mod seconds-left 60)) 

    ;; Pad with leading zeros if necessary
    (print (format "%02d:%02d:%02d"
            hours minutes seconds-left)))
