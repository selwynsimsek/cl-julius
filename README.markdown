# cl-julius

Common Lisp interface to the open-source [Julius speech recognition engine](https://github.com/julius-speech/julius).

## Usage

```lisp
(ql:quickload :cl-julius)
(loop with stream = (cl-julius:input) do (princ (read-char stream)))
```
and speak into your microphone.

At the moment only voice recognition of microphone input is exposed via `(cl-julius:input)`.

## Installation

Build and install Julius according to the [Quick Run instructions](https://github.com/julius-speech/julius#quick-run) (as of October 2019), and clone this repository to `~/quicklisp/local-projects`. You will need to ensure that the `cl-julius:*directory*` and `cl-julius:*model-directory*` special variables point to the right paths on your system.

## Author

* Selwyn Simsek (sgs16@ic.ac.uk)

## Copyright

Copyright (c) 2019 Selwyn Simsek (sgs16@ic.ac.uk)
