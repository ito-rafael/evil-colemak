;;; evil-colemak.el --- Basic Colemak key bindings for evil-mode

;; Author: Wouter Bolsterlee <wouter@bolsterl.ee>
;; Version: 2.2.1
;; Package-Requires: ((emacs "24.3") (evil "1.2.12") (evil-snipe "2.0.3"))
;; Keywords: convenience emulations colemak evil
;; URL: https://github.com/wbolster/evil-colemak-basics
;;
;; This file is not part of GNU Emacs.

;;; License:

;; Licensed under the same terms as Emacs.

;;; Commentary:

;; This package provides basic key rebindings for evil-mode with the
;; Colemak keyboard layout.  See the README for more information.
;;
;; To enable globally, use:
;;
;;   (global-evil-colemak-mode)
;;
;; To enable for just a single buffer, use:
;;
;;   (evil-colemak-mode)

;;; Code:

(require 'evil)
(require 'evil-snipe)

(defgroup evil-colemak nil
  "Basic key rebindings for evil-mode with the Colemak keyboard layout."
  :prefix "evil-colemak-"
  :group 'evil)

(defcustom evil-colemak-layout-mod nil
  "Which Colemak layout mod to use.

Colemak Mod-DH, also known as Colemak Mod-DHm, has m where the h
key is on qwerty. This means we need to swap the h and m
bindings. No other changes are necessary."
  :group 'evil-colemak
  :type '(choice (const :tag "default" nil)
                 (const :tag "mod-dh" mod-dh)))

(defcustom evil-colemak-rotate-t-f-j t
  "Whether to keep find-char and end of word jumps at their qwerty position.

When non-nil, this will rotate the t, f, and j keys, so that f
jumps to the end of the word (qwerty e, same position), t jumps to a
char (qwerty f, same position), and j jumps until a char (qwerty t,
different position)."
  :group 'evil-colemak
  :type 'boolean)

(defcustom evil-colemak-char-jump-commands nil
  "The set of commands to use for jumping to characters.

By default, the built-in evil commands evil-find-char (and
variations) are used; when set to the symbol \\='evil-snipe, this
behaves like evil-snipe-override-mode, but adapted to the right
keys.

This setting is only used when the character jump commands are
rotated; see evil-colemak-rotate-t-f-j."
  :group 'evil-colemak
  :type '(choice (const :tag "default" nil)
                 (const :tag "evil-snipe" evil-snipe)))

(defun evil-colemak--make-keymap ()
  "Initialise the keymap based on the current configuration."
  (let ((keymap (make-sparse-keymap)))
    (evil-define-key '(motion normal visual) keymap

      ;; navigation
      "n"  'evil-backward-char
      "e"  'evil-next-line
      "i"  'evil-previous-line
      "o"  'evil-forward-char

      ;; new line
      "h"  'evil-open-below
      "H"  'evil-open-above

      ;; next/previous matches
      "k" (if (eq evil-search-module 'evil-search) 'evil-ex-search-next 'evil-search-next)
      "K" (if (eq evil-search-module 'evil-search) 'evil-ex-search-previous 'evil-search-previous)
      "gk" 'evil-next-match
      "gK" 'evil-previous-match)

      ;; end of word
      "l"  'evil-forward-word-end
      "L"  'evil-forward-WORD-end
      "gl" 'evil-backward-word-end
      "gL" 'evil-backward-WORD-end

      ;; not used
      ;"ge" 'evil-next-visual-line
      ;"E"  'evil-lookup
      ;"gi" 'evil-previous-visual-line
      ;"I"  'evil-window-bottom
      ;"zi" 'evil-scroll-column-right
      ;"zI" 'evil-scroll-right

    ;; join lines
    (evil-define-key '(normal visual) keymap
      "J"  'evil-join
      "gJ" 'evil-join-whitespace)

    ;; insert state
    (evil-define-key 'normal keymap
      "s"  'evil-insert
      "S"  'evil-insert-line
      "gs" 'evil-insert-resume
      "gS" 'evil-insert-0-line)
    (evil-define-key 'visual keymap
      "S"  'evil-insert)

    ;; operator
    (evil-define-key '(visual operator) keymap
      "s"  evil-inner-text-objects-map)
    (evil-define-key 'operator keymap
      "i"  'evil-forward-char)

    ;; t-f-j rotation
    ;(when evil-colemak-rotate-t-f-j
    ;  (evil-define-key '(motion normal visual) keymap
    ;    "l"  'evil-forward-word-end
    ;    "L"  'evil-forward-WORD-end
    ;    "gl" 'evil-backward-word-end
    ;    "gL" 'evil-backward-WORD-end)
    ;  (evil-define-key 'normal keymap
    ;    "gt" 'find-file-at-point
    ;    "gT" 'evil-find-file-at-point-with-line)
    ;  (evil-define-key 'visual keymap
    ;    "gt" 'evil-find-file-at-point-visual)
    ;  (when (featurep 'tab-bar)  ; Evil also checks this; see evil-maps.el
    ;    (evil-define-key 'normal keymap
    ;      "ge" 'tab-bar-switch-to-next-tab
    ;      "gE" 'tab-bar-switch-to-prev-tab))
    ;  (cond
    ;   ((eq evil-colemak-char-jump-commands nil)
    ;   ((eq evil-colemak-char-jump-commands 'evil-snipe)
    ;    ;; XXX https://github.com/hlissner/evil-snipe/issues/46
    ;   (t (user-error "Invalid evil-colemak-char-jump-commands configuration"))))

    ;; Colemak-DH mod
    ;(when (eq evil-colemak-layout-mod 'mod-dh)
    ;  (evil-define-key '(motion normal visual) keymap
    ;    "m" 'evil-backward-char)
    ;  (evil-define-key '(normal visual) keymap
    ;    "h" 'evil-set-marker))
    ;(when evil-respect-visual-line-mode
    ;  (evil-define-key '(motion normal visual) keymap
    ;    "e"  'evil-next-visual-line
    ;    "ge" 'evil-next-line
    ;    "i"  'evil-previous-visual-line
    ;    "gi" 'evil-previous-line
    ;    "0"  'evil-beginning-of-visual-line
    ;    "g0" 'evil-beginning-of-line
    ;    "$"  'evil-end-of-visual-line
    ;    "g$" 'evil-end-of-line
    ;    "V"  'evil-visual-screen-line))

    keymap))

(defvar evil-colemak-keymap
  (evil-colemak--make-keymap)
  "Keymap for evil-colemak-mode.")

(defun evil-colemak--refresh-keymap ()
  "Refresh the keymap using the current configuration."
  (setq evil-colemak-keymap (evil-colemak--make-keymap)))

;;;###autoload
(define-minor-mode evil-colemak-mode
  "Minor mode with evil-mode enhancements for the Colemak keyboard layout."
  :keymap evil-colemak-keymap
  :lighter " hnei")

;;;###autoload
(define-globalized-minor-mode global-evil-colemak-mode
  evil-colemak-mode
  (lambda () (evil-colemak-mode t))
  "Global minor mode with evil-mode enhancements for the Colemak keyboard layout.")

(provide 'evil-colemak)

;;; evil-colemak.el ends here
