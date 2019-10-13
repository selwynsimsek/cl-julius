;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Common Lisp interface to the open-source Julius speech recognition engine.

(defpackage cl-julius
  (:use :cl))
(in-package :cl-julius)

(defparameter *directory*
  (uiop:merge-pathnames* #p"julius/" (user-homedir-pathname))
  "Change this to point to your Julius repo directory:
  <https://github.com/julius-speech/julius>")

(defparameter *model-directory*
  (uiop:merge-pathnames* #p"ENVR-v5.4.Dnn.Bin/" (user-homedir-pathname))
  "Change this to point to your Julius model directory:
  <https://sourceforge.net/projects/juliusmodels/files/>")

(defparameter *microphone-config*
  (uiop:merge-pathnames* #p"mic.jconf" *model-directory*))

(defparameter *dnn-config*
  (uiop:merge-pathnames* #p"dnn.jconf" *model-directory*))

(defparameter *binary*
  (uiop:merge-pathnames* #p"julius/julius" *directory*))

(defparameter *buffer-size* 20)

(defun microphone-command ()
  `("-C" ,(princ-to-string *microphone-config*) "-dnnconf" ,(princ-to-string *dnn-config*)))

(let ((process nil))
  (defun launch-process ()
    (when process (kill-julius))
    (setf process (external-program:start
                     (princ-to-string *binary*)
                     (microphone-command)
                     :output :stream
                     :error :stream
                     :input :stream)))

  (defun kill-process ()
    (when process
      (external-program:signal-process process 3)
      (setf process nil)))

  (defun ensure-process ()
    (unless (and process (eq (external-program:process-status process) :running))
      (launch-process)))

  (defun raw-input ()
    (ensure-process)
    (external-program:process-output-stream process)))

(defclass transformation-stream (trivial-gray-streams:fundamental-character-input-stream)
  ((input :initarg :input :initform (error "Need input stream"))
   (buffer :initarg :buffer :initform (make-list *buffer-size* :initial-element #\Nul))
   (in-word-p :initarg :in-word-p :initform nil)))

(defmethod trivial-gray-streams:stream-read-char ((stream transformation-stream))
  (with-slots (input buffer in-word-p) stream
    (loop with current-char do
          (progn
            ;; Read a character
            (setf current-char (read-char input))
            ;; Add it to the buffer
            (push current-char buffer)
            (setf buffer (subseq buffer 0 *buffer-size*)) 
            ;; See if we are in a word or not
            (let ((buffer-string (reverse (coerce buffer 'string))))
              (when (str:ends-with-p "sentence1: <s> "
                                     (subseq buffer-string 0 (1- (length buffer-string))))
                (setf in-word-p t))
              (when (str:ends-with-p "<" buffer-string)
                (setf in-word-p nil)))
            ;; If we are in a word, return the character, otherwise continue looping.
            (when in-word-p (return current-char))))))

(defun input ()
  (make-instance 'transformation-stream :input (raw-input)))

(export '(*directory* *model-directory* input))
