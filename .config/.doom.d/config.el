;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-
(setq user-full-name "Fanny Pungkas Prayoga"
      user-mail-address "fannypungkas99@gmail.com"
      doom-scratch-initial-major-mode 'text-mode
      doom-font (font-spec :family "PragmataPro" :size 12)
      doom-variable-pitch-font (font-spec :family "PragmataPro" :size 12)
      doom-serif-font (font-spec :family "PragmataPro")
      doom-theme 'doom-homage-white
      display-line-numbers-type 'nil
      load-prefer-newer t
      +zen-text-scale 1
      writeroom-extra-line-spacing 0.3

      lsp-ui-sideline-enable nil
      lsp-enable-symbol-highlighting nil
      search-highlight t
      search-whitespace-regexp ".*?"
      org-directory "~/org/"
      org-ellipsis " ▼ "
      org-adapt-indentation nil
      org-habit-show-habits-only-for-today t)

(autoload 'ffap-guesser "ffap")
(setq minibuffer-default-add-function
      (defun minibuffer-default-add-function+ ()
        (with-selected-window (minibuffer-selected-window)
          (delete-dups
           (delq nil
                 (list (thing-at-point 'symbol)
                       (thing-at-point 'list)
                       (ffap-guesser)
                       (thing-at-point-url-at-point)))))))

 ;; (set-frame-parameter (selected-frame) 'alpha '(85 . 50))
 (add-to-list 'default-frame-alist '(alpha . (100 . 100)))

(setq fanny/default-bibliography `(,(expand-file-name "~/org/zettels/org/biblio.bib" org-directory)))

(use-package! ctrlf
  :hook
  (after-init . ctrlf-mode))

(use-package! dired-narrow
  :commands (dired-narrow-fuzzy)
  :init
  (map! :map dired-mode-map
        :desc "narrow" "/" #'dired-narrow-fuzzy))

(map! "C-c h s" #'+vc/smerge-hydra/body)

(use-package! easy-kill
  :bind*
  (([remap kill-ring-save] . easy-kill)))

(use-package! smartparens
  :init
  (map! :map smartparens-mode-map
        "C-M-f" #'sp-forward-sexp
        "C-M-b" #'sp-backward-sexp
        "C-M-u" #'sp-backward-up-sexp
        "C-M-d" #'sp-down-sexp
        "C-M-p" #'sp-backward-down-sexp
        "C-M-n" #'sp-up-sexp
        "C-M-s" #'sp-splice-sexp
        "C-)" #'sp-forward-slurp-sexp
        "C-}" #'sp-forward-barf-sexp
        "C-(" #'sp-backward-slurp-sexp
        "C-M-)" #'sp-backward-slurp-sexp
        "C-M-)" #'sp-backward-barf-sexp))

(require 'org)
(require 'org-habit)

(after! org
  (setq org-attach-dir-relative t))

(with-eval-after-load 'flycheck
  (flycheck-add-mode 'proselint 'org-mode))

(map! :map org-mode-map
      "M-n" #'outline-next-visible-heading
      "M-p" #'outline-previous-visible-heading)

(setq org-src-window-setup 'current-window
      org-return-follows-link t
      org-babel-load-languages '((emacs-lisp . t)
                                 (python . t)
                                 (dot . t)
                                 (R . t))
      org-confirm-babel-evaluate nil
      org-use-speed-commands t
      org-catch-invisible-edits 'show
      org-preview-latex-image-directory "/tmp/ltximg/"
      org-structure-template-alist '(("a" . "export ascii")
                                     ("c" . "center")
                                     ("C" . "comment")
                                     ("e" . "example")
                                     ("E" . "export")
                                     ("h" . "export html")
                                     ("l" . "export latex")
                                     ("q" . "quote")
                                     ("s" . "src")
                                     ("v" . "verse")
                                     ("el" . "src emacs-lisp")
                                     ("d" . "definition")
                                     ("t" . "theorem")))

(defun fanny/org-archive-done-tasks ()
  "Archive all done tasks."
  (interactive)
  (org-map-entries 'org-archive-subtree "/DONE" 'file))

(require 'find-lisp)
(setq fanny/org-agenda-directory
      (expand-file-name "gtd/" org-directory))
(setq org-agenda-files
      (find-lisp-find-files fanny/org-agenda-directory "\.org$"))

(setq org-capture-templates
      `(("i" "Inbox" entry  (file "gtd/inbox.org")
         ,(concat "* TODO %?\n"
                  "/Entered on/ %U"))
        ("s" "Slipbox" entry  (file "zettels/org/inbox.org")
         "* %?\n")))

(defun fanny/org-capture-inbox ()
  (interactive)
  (org-capture nil "i"))

(defun fanny/org-capture-slipbox ()
  (interactive)
  (org-capture nil "s"))

(defun fanny/org-agenda ()
  (interactive)
  (org-agenda nil " "))

(bind-key "C-c <tab>" #'fanny/org-capture-inbox)
(bind-key "C-c SPC" #'fanny/org-agenda)

(setq org-todo-keywords
      '((sequence "TODO(t)" "NEXT(n)" "HOLD(h)" "|" "DONE(d)" "|" "Cancelled(c)")))

(defun log-todo-next-creation-date (&rest ignore)
  "Log NEXT creation time in the property drawer under the key 'ACTIVATED'"
  (when (and (string= (org-get-todo-state) "NEXT")
             (not (org-entry-get nil "ACTIVATED")))
    (org-entry-put nil "ACTIVATED" (format-time-string "[%Y-%m-%d]"))))
(add-hook 'org-after-todo-state-change-hook #'log-todo-next-creation-date)

(setq org-log-done 'time
      org-log-into-drawer t
      org-log-state-notes-insert-after-drawers nil)

(setq org-tag-alist '(("@errand" . ?e)
                      ("@office" . ?o)
                      ("@home" . ?h)))

(setq org-fast-tag-selection-single-key nil)
(setq org-refile-use-outline-path 'file
      org-outline-path-complete-in-steps nil)
(setq org-refile-allow-creating-parent-nodes 'confirm
      org-refile-targets '(("projects.org" . (:level . 1))))

(defun fanny/org-process-inbox ()
  "Called in org-agenda-mode, processes all inbox items."
  (interactive)
  (org-agenda-bulk-mark-regexp "inbox:")
  (fanny/bulk-process-entries))

(defvar fanny/org-current-effort "1:00"
  "Current effort for agenda items.")

(defun fanny/my-org-agenda-set-effort (effort)
  "Set the effort property for the current headline."
  (interactive
   (list (read-string (format "Effort [%s]: " fanny/org-current-effort) nil nil fanny/org-current-effort)))
  (setq fanny/org-current-effort effort)
  (org-agenda-check-no-diary)
  (let* ((hdmarker (or (org-get-at-bol 'org-hd-marker)
                       (org-agenda-error)))
         (buffer (marker-buffer hdmarker))
         (pos (marker-position hdmarker))
         (inhibit-read-only t)
         newhead)
    (org-with-remote-undo buffer
      (with-current-buffer buffer
        (widen)
        (goto-char pos)
        (org-show-context 'agenda)
        (funcall-interactively 'org-set-effort nil fanny/org-current-effort)
        (end-of-line 1)
        (setq newhead (org-get-heading)))
      (org-agenda-change-all-lines newhead hdmarker))))

(defun fanny/org-agenda-process-inbox-item ()
  "Process a single item in the org-agenda."
  (org-with-wide-buffer
   (org-agenda-set-tags)
   (org-agenda-priority)
   (call-interactively 'fanny/my-org-agenda-set-effort)
   (org-agenda-refile nil nil t)))

(defun fanny/bulk-process-entries ()
  (let ())
  (if (not (null org-agenda-bulk-marked-entries))
      (let ((entries (reverse org-agenda-bulk-marked-entries))
            (processed 0)
            (skipped 0))
        (dolist (e entries)
          (let ((pos (text-property-any (point-min) (point-max) 'org-hd-marker e)))
            (if (not pos)
                (progn (message "Skipping removed entry at %s" e)
                       (cl-incf skipped))
              (goto-char pos)
              (let (org-loop-over-headlines-in-active-region) (funcall 'fanny/org-agenda-process-inbox-item))
              ;; `post-command-hook' is not run yet.  We make sure any
              ;; pending log note is processed.
              (when (or (memq 'org-add-log-note (default-value 'post-command-hook))
                        (memq 'org-add-log-note post-command-hook))
                (org-add-log-note))
              (cl-incf processed))))
        (org-agenda-redo)
        (unless org-agenda-persistent-marks (org-agenda-bulk-unmark-all))
        (message "Acted on %d entries%s%s"
                 processed
                 (if (= skipped 0)
                     ""
                   (format ", skipped %d (disappeared before their turn)"
                           skipped))
                 (if (not org-agenda-persistent-marks) "" " (kept marked)")))))

(defun fanny/org-inbox-capture ()
  (interactive)
  "Capture a task in agenda mode."
  (org-capture nil "i"))

(map! :map org-agenda-mode-map
      "i" #'org-agenda-clock-in
      "I" #'fanny/clock-in-and-advance
      "r" #'fanny/org-process-inbox
      "R" #'org-agenda-refile
      "c" #'fanny/org-inbox-capture)

(defun fanny/advance-todo ()
  (org-todo 'right)
  (remove-hook 'org-clock-in-hook #'fanny/advance-todo))

(defun fanny/clock-in-and-advance ()
  (interactive)
  (add-hook 'org-clock-in-hook 'fanny/advance-todo)
  (org-agenda-clock-in))

(use-package! org-clock-convenience
  :bind (:map org-agenda-mode-map
         ("<S-up>" . org-clock-convenience-timestamp-up)
         ("<S-down>" . org-clock-convenience-timestamp-down)
         ("o" . org-clock-convenience-fill-gap)
         ("e" . org-clock-convenience-fill-gap-both)))

(use-package! org-agenda
  :init
  (map! "<f1>" #'fanny/switch-to-agenda)
  (setq org-agenda-block-separator nil
        org-agenda-start-with-log-mode t)
  (defun fanny/switch-to-agenda ()
    (interactive)
    (org-agenda nil " "))
  :config
  (defun fanny/is-project-p ()
    "Any task with a todo keyword subtask"
    (save-restriction
      (widen)
      (let ((has-subtask)
            (subtree-end (save-excursion (org-end-of-subtree t)))
            (is-a-task (member (nth 2 (org-heading-components)) org-todo-keywords-1)))
        (save-excursion
          (forward-line 1)
          (while (and (not has-subtask)
                      (< (point) subtree-end)
                      (re-search-forward "^\*+ " subtree-end t))
            (when (member (org-get-todo-state) org-todo-keywords-1)
              (setq has-subtask t))))
        (and is-a-task has-subtask))))

  (defun fanny/skip-projects ()
    "Skip trees that are projects."
    (save-restriction
      (widen)
      (let ((next-headline (save-excursion (or (outline-next-heading) (point-max)))))
        (cond
         ((org-is-habit-p)
          next-headline)
         (t
          nil)))))

  (setq org-columns-default-format "%40ITEM(Task) %Effort(EE){:} %CLOCKSUM(Time Spent) %SCHEDULED(Scheduled) %DEADLINE(Deadline)")
  (setq org-agenda-custom-commands `((" " "Agenda"
                                      ((alltodo ""
                                                ((org-agenda-overriding-header "Inbox")
                                                 (org-agenda-files `(,(expand-file-name "gtd/inbox.org" org-directory)))))
                                       (agenda ""
                                               ((org-agenda-span 'week)
                                                (org-deadline-warning-days 365)))
                                       (todo "NEXT"
                                             ((org-agenda-overriding-header "In Progress")
                                              (org-agenda-files `(,(expand-file-name "gtd/projects.org" org-directory)))))
                                       (todo "TODO"
                                             ((org-agenda-overriding-header "Active Projects")
                                              (org-agenda-files `(,(expand-file-name "gtd/projects.org" org-directory)))
                                              (org-agenda-skip-function #'fanny/skip-projects))))))))

(use-package! org-roam
  :init
  (map! :leader
        :prefix "n"
        :desc "org-roam" "l" #'org-roam-buffer-toggle
        :desc "org-roam-node-insert" "i" #'org-roam-node-insert
        :desc "org-roam-node-find" "f" #'org-roam-node-find
        :desc "org-roam-ref-find" "r" #'org-roam-ref-find
        :desc "org-roam-show-graph" "g" #'org-roam-show-graph
        :desc "fanny/org-capture-slipbox" "<tab>" #'fanny/org-capture-slipbox
        :desc "org-roam-capture" "c" #'org-roam-capture)
  (setq org-roam-directory (file-truename "~/org/zettels/org/")
        org-roam-db-gc-threshold most-positive-fixnum
        org-id-link-to-org-use-id t)
  :config
  (org-roam-db-autosync-mode +1)
  (set-popup-rules!
    `((,(regexp-quote org-roam-buffer) ; persistent org-roam buffer
       :side right :width .33 :height .5 :ttl nil :modeline nil :quit nil :slot 1)
      ("^\\*org-roam: " ; node dedicated org-roam buffer
       :side right :width .33 :height .5 :ttl nil :modeline nil :quit nil :slot 2)))
  (add-hook 'org-roam-mode-hook #'turn-on-visual-line-mode)
  (setq org-roam-capture-templates
        '(("m" "main" plain
           "%?"
           :if-new (file+head "main/${slug}.org"
                              "#+title: ${title}\n")
           :immediate-finish t
           :unnarrowed t)
          ("r" "reference" plain "%?"
           :if-new
           (file+head "reference/${slug}.org" "#+title: ${title}\n")
           :immediate-finish t
           :unnarrowed t)
          ("a" "article" plain "%?"
           :if-new
           (file+head "articles/${slug}.org" "#+title: ${title}\n#+filetags: :article:\n")
           :immediate-finish t
           :unnarrowed t)))
  (defun fanny/tag-new-node-as-draft ()
    (org-roam-tag-add '("draft")))
  (add-hook 'org-roam-capture-new-node-hook #'fanny/tag-new-node-as-draft)
  (cl-defmethod org-roam-node-type ((node org-roam-node))
    "Return the TYPE of NODE."
    (condition-case nil
        (file-name-nondirectory
         (directory-file-name
          (file-name-directory
           (file-relative-name (org-roam-node-file node) org-roam-directory))))
      (error "")))
  (setq org-roam-node-display-template
        (concat "${type:15} ${title:*} " (propertize "${tags:10}" 'face 'org-tag)))
  (require 'citar)
  (defun fanny/org-roam-node-from-cite (keys-entries)
    (interactive (list (citar-select-ref :multiple nil :rebuild-cache t)))
    (let ((title (citar--format-entry-no-widths (cdr keys-entries)
                                                "${author editor} :: ${title}")))
      (org-roam-capture- :templates
                         '(("r" "reference" plain "%?" :if-new
                            (file+head "reference/${citekey}.org"
                                       ":PROPERTIES:
:ROAM_REFS: [cite:@${citekey}]
:END:
#+title: ${title}\n")
                            :immediate-finish t
                            :unnarrowed t))
                         :info (list :citekey (car keys-entries))
                         :node (org-roam-node-create :title title)
                         :props '(:finalize find-file)))))

(use-package! ox-hugo
  :after org)

(defun insert-date ()
  "Insert a timestamp according to locale's date and time format."
  (interactive)
  (insert (format-time-string "%c" (current-time))))

(after! bibtex-completion
  (setq! bibtex-completion-notes-path org-roam-directory
         bibtex-completion-bibliography fanny/default-bibliography
         org-cite-global-bibliography fanny/default-bibliography
         bibtex-completion-pdf-field "file"))

(after! bibtex-completion
  (after! org-roam
    (setq! bibtex-completion-notes-path org-roam-directory)))

(after! citar
  (map! :map org-mode-map
        :desc "Insert citation" "C-c b" #'citar-insert-citation)
  (setq citar-bibliography fanny/default-bibliography
        citar-at-point-function 'embark-act
        citar-symbol-separator "  "
        citar-format-reference-function 'citar-citeproc-format-reference
        org-cite-csl-styles-dir "~/Zotero/styles"
        citar-citeproc-csl-styles-dir org-cite-csl-styles-dir
        citar-citeproc-csl-locales-dir "~/Zotero/locales"
        citar-citeproc-csl-style (file-name-concat org-cite-csl-styles-dir "apa.csl")))

(after! org-noter
  org-noter-doc-split-fraction '(0.57 0.43))


(defun fanny/open-with (arg)
  "Open visited file in default external program.
When in dired mode, open file under the cursor.
With a prefix ARG always prompt for command to use."
  (interactive "P")
  (let* ((current-file-name
          (if (eq major-mode 'dired-mode)
              (dired-get-file-for-visit)
            buffer-file-name))
         (open (pcase system-type
                 (`darwin "open")
                 ((or `gnu `gnu/linux `gnu/kfreebsd) "xdg-open")))
         (program (if (or arg (not open))
                      (read-shell-command "Open current file with: ")
                    open)))
    (call-process program nil 0 nil current-file-name)))

(map! "C-c o o" 'fanny/open-with)

(after! org-latex
  (setq org-latex-pdf-process (list "latexmk -f -xelatex %f")))

(map!
 [backtab] #'+fold/toggle
 [C-tab] #'+fold/open-all
 [C-iso-lefttab] #'+fold/close-all)

(use-package! tree-sitter
  :hook
  (prog-mode . global-tree-sitter-mode))


