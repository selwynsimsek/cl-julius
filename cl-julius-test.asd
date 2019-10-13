#|
  This file is a part of cl-julius project.
  Copyright (c) 2019 Selwyn Simsek (sgs16@ic.ac.uk)
|#

(defsystem "cl-julius-test"
  :defsystem-depends-on ("prove-asdf")
  :author "Selwyn Simsek"
  :license ""
  :depends-on ("cl-julius"
               "prove")
  :components ((:module "tests"
                :components
                ((:test-file "cl-julius"))))
  :description "Test system for cl-julius"

  :perform (test-op (op c) (symbol-call :prove-asdf :run-test-system c)))
