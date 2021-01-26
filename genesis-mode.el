;;; genesis-mode.el --- Genesis major mode

;; Copyright (C) 2019 Cheng Tan

;; Author: Cheng Tan
;; Keywords: Genesis

;; This file is derived from *Emacs DerivedMode*
;; http://www.emacswiki.org/emacs/DerivedMode
;; For Syntax highlighting, the codes are modified from Xah Lee's ergoemacs
;; http://ergoemacs.org/emacs/elisp_syntax_coloring.html

;;; Commentary:

;;; Code:

(defvar genesis-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map "\C-j" 'newline-and-indent)
    map)
  "Keymap for `genesis-mode'.")

(defvar genesis-mode-syntax-table
  (let ((st (make-syntax-table)))
    (modify-syntax-entry ?# "<" st)
    (modify-syntax-entry ?\n ">" st)
    (modify-syntax-entry ?\[ "w" st)
    (modify-syntax-entry ?\] "w" st)
    st)
  "Syntax table for `genesis-mode'.")

;;; ------------------------------
;;  _     _       _     _ _       _     _   _
;; | |__ (_) __ _| |__ | (_) __ _| |__ | |_(_)_ __   __ _
;; | '_ \| |/ _` | '_ \| | |/ _` | '_ \| __| | '_ \ / _` |
;; | | | | | (_| | | | | | | (_| | | | | |_| | | | | (_| |
;; |_| |_|_|\__, |_| |_|_|_|\__, |_| |_|\__|_|_| |_|\__, |
;;          |___/           |___/                   |___/
;; define keywords, types, consts, events, functions
(setq genesis-keywords
      '("topfile" "parfile" "strfile" "psffile" "pdbfile" "crdfile" "modefile" "gprfile" "reffile" "logfile"
        "prmtopfile" "ambcrdfile" "ambreffile" "grotopfile" "grocrdfile" "groreffile" "dcdfile" "dcdvelfile" 
        "rstfile" "forcefield" "electrostatic" "switchdist" "cutoffdist" "pairlistdist" "dielec_const" 
	"cg_cutoffdist_ele" "cg_cutoffdist_126" "cg_cutoffdist_DNAbp"
	"cg_pairlistdist_ele" "cg_pairlistdist_126" "cg_pairlistdist_DNAbp"
	"cg_pairlistdist_exv" "cg_pairlistdist_PWMcos"
	"cg_sol_temperature" "cg_sol_ionic_strength" "cg_pro_DNA_ele_scale_Q" "cg_IDR_HPS_epsilon"
        "vdw_force_switch" "vdw_shift" "cmap_pspline" "pme_alpha" "pme_alpha_tol" "pme_nspline" "pme_multiple" "pme_mul_ratio" 
        "table_density" "water_model" "output_style" "dispersion_corr" "integrator" "nsteps" 
        "timestep" "eneout_period" "qmsave_period" "crdout_period" "velout_period" "rstout_period" "method"
        "stoptr_period" "nbupdate_period" "iseed" "initial_time" "annealing" "anneal_period"
        "dtemperature" "verbose" "target_md" "steered_md" "initial_value" "final_value"
        "rigid_bond" "fast_water" "shake_iteration" "shake_tolerance" "water_model" "hydrogen_mass_upper_bound"
        "ensemble" "tpcontrol" "temperature" "pressure" "gamma" "tau_t"
        "tau_p" "compressibility" "gamma_t" "gamma_p" "isotropy" "type"
        "box_size_x" "box_size_y" "box_size_z" "nfunctions"
        "dimension" "exchange_period"
        "group1" "group2" "group3" "group4" "group5" "group6" "group7" "group8" "group9"
        "function1" "function2" "function3"
        "direction1" "direction2" "direction3"
        "constant1" "constant2" "constant3"
        "type1" "type2" "type3"
        "nreplica1" "nreplica2" "nreplica3"
        "parameters1" "parameters2" "parameters3"
        "cyclic_params1" "cyclic_params2" "cyclic_params3"
        "select_intex1" "select_intex2" "select_intex3" ))
(setq genesis-types
      '("[INPUT]" "[OUTPUT]" "[ENERGY]" "[DYNAMICS]" "[CONSTRQAINTS]" "[ENSEMBLE]" "[BOUNDARY]" "[SELECTION]"
        "[REMD]" "[CONSTRAINTS]" "[RESTRAINTS]"))
(setq genesis-constants
      '("ALL" "X" "Y" "Z"
        "auto" "NO" "YES" "NONE" ))
(setq genesis-events
      '("pdb" "top" "psf" "par" "str" "crd" "gpr" "gro" "dcd" "rst" "mode" "log"))
(setq genesis-functions
      '("CHARMM" "AAGO" "CAGO" "KBGO" "AMBER" "GROAMBER" "GROMARTINI" "PME"
        "TIP3" "AICG2P" "CUTOFF"
        "LEAP" "VVER"
        "NOBC" "PBC"
        "SD"
        "TEMPERATURE" "PRESSURE" "GAMMA" "REST"
        "NVE" "NVT" "NPT" "NPAT" "NPgT"
        "ISO" "SEMI-ISO" "ANISO" "XY-FIXED"
        "POSI" "DIST"))

;; create the regex string for each class of keywords
(setq genesis-keywords-regexp (regexp-opt genesis-keywords 'words))
(setq genesis-type-regexp (regexp-opt genesis-types 'words))
(setq genesis-constant-regexp (regexp-opt genesis-constants 'words))
(setq genesis-event-regexp (regexp-opt genesis-events 'words))
(setq genesis-functions-regexp (regexp-opt genesis-functions 'words))
;; clear defined lists
(setq genesis-keywords nil)
(setq genesis-types nil)
(setq genesis-constants nil)
(setq genesis-events nil)
(setq genesis-functions nil)
;; font-lock lists
(setq genesis-font-lock-keywords
      `(
        (,genesis-keywords-regexp . font-lock-keyword-face)
        (,genesis-type-regexp . font-lock-type-face)
        (,genesis-constant-regexp . font-lock-constant-face)
        (,genesis-event-regexp . font-lock-builtin-face)
        (,genesis-functions-regexp . font-lock-function-name-face)
        ))

(defun genesis-indent-line ()
  "Indent current line of Sample code."
  (interactive)
  (let ((savep (> (current-column) (current-indentation)))
        (indent (condition-case nil (max (sample-calculate-indentation) 0)
                  (error 0))))
    (if savep
        (save-excursion (indent-line-to indent))
      (indent-line-to indent))))

(defun sample-calculate-indentation ()
  "Return the column to which the current line should be indented."
  )

;;; ------------------------------
;;  ____        __ _       _ _   _
;; |  _ \  ___ / _(_)_ __ (_) |_(_) ___  _ __
;; | | | |/ _ \ |_| | '_ \| | __| |/ _ \| '_ \
;; | |_| |  __/  _| | | | | | |_| | (_) | | | |
;; |____/ \___|_| |_|_| |_|_|\__|_|\___/|_| |_|
;;
(define-derived-mode genesis-mode fundamental-mode "Genesis"
  "A major mode for editing Genesis input files."
  :syntax-table genesis-mode-syntax-table
  (setq-local comment-start "# ")
  ;; (setq-local comment-start-skip "#+\\s-*")
  (setq font-lock-defaults '((genesis-font-lock-keywords)))
  (setq-local indent-line-function 'genesis-indent-line)
  ;; trash cleaning
  (setq genesis-keywords-regexp nil)
  (setq genesis-types-regexp nil)
  (setq genesis-constants-regexp nil)
  (setq genesis-events-regexp nil)
  (setq genesis-functions-regexp nil)
  )

(provide 'genesis-mode)
;;; genesis-mode.el ends here
