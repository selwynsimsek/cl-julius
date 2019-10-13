#|
  This file is a part of cl-julius project.
  Copyright (c) 2019 Selwyn Simsek (sgs16@ic.ac.uk)
|#

#|
  Author: Selwyn Simsek (sgs16@ic.ac.uk)
|#

(defsystem "cl-julius"
  :version "0.1.0"
  :author "Selwyn Simsek"
  :license ""
  :depends-on ("external-program"
               "trivial-gray-streams"
               "str")
  :components ((:module "src"
                :components
                ((:file "cl-julius"))))
  :description ""
  :long-description
  #.(read-file-string
     (subpathname *load-pathname* "README.markdown"))
  :in-order-to ((test-op (test-op "cl-julius-test"))))
