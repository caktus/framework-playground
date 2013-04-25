
(defun dep-spellcheck-word (word)
  "Returns t if the word is correctly spelled"
  ;; Emacs doesn't have a simple 'spellcheck this word non-interactively'
  ;; function (believe it or not).  Just call hunspell ourselves.
  (with-temp-buffer
    (insert word)
    ;; give hunspell the buffer as stdin, then replace the
    ;; buffer contents with hunspell's output
    (call-process-region (point-min) (point-max) "hunspell" t t nil "-a")
    ;; look at the output to see if our word was valid
    ;; First line of output is hunspell version string (stupid!) which
    ;; we need to skip over
    (goto-char (point-min))
    (forward-line)
    ;; Possible hunspell output first chars:
    ;;   *  word is valid
    ;;   +  word was valid by affix removal
    ;;   -  word was valid by compound formation
    ;;   &  there are near misses
    ;;   #  just not valid
    ;; so it's valid for *, +, or -
    (looking-at-p "[*+-]")))

(defun spellcheck-handler (httpcon)
  ;; Should be a single parm `q` that is the word to check: /check?q=word
  (let
      ((word (elnode-http-param httpcon "q" nil)))
    (if word
        (elnode-send-json httpcon `(:valid ,(dep-spellcheck-word word)))
      (elnode-send-400 httpcon)
    ))
)

(defvar spellcheck-routes
  '(("^.*//check$" . spellcheck-handler)))

(defun spellcheck-root-handler (httpcon)
  (elnode-hostpath-dispatcher httpcon spellcheck-routes))

(elnode-start 'spellcheck-root-handler :port 8000)
