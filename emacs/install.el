;;
;; open this file in Emacs then M-x eval-buffer [RET]
;;
(require 'package)
(setq
   package-archives
   '(("marmalade" . "http://marmalade-repo.org/packages/"))
   )
(package-install 'elnode)
