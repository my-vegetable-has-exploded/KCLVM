:: Copyright 2021 The KCL Authors. All rights reserved.

setlocal

cd %~dp0

go run download-file.go
go run unzip.go

go run gen_pth.go

:: renname
go run rename.go -old="_output\kclvm-windows\python.exe" -new="_output\kclvm-windows\kclvm.exe"

:: install pip
_output\kclvm-windows\kclvm.exe get-pip.py

:: install kclvm
_output\kclvm-windows\kclvm.exe -m pip install kclvm

:: install kclvm-cli
call .\\build_kclvm_cli.bat

:: install hello.k
go run .\copy-file.go --src=..\..\samples\hello.k --dst=.\_output\kclvm-windows\hello.k

:: install tools
go build -o .\_output\kclvm-windows\bin\kcl.exe        kcl.go
go build -o .\_output\kclvm-windows\bin\kcl-doc.exe    kcl-doc.go
go build -o .\_output\kclvm-windows\bin\kcl-lint.exe   kcl-lint.go
go build -o .\_output\kclvm-windows\bin\kcl-fmt.exe    kcl-fmt.go
go build -o .\_output\kclvm-windows\bin\kcl-plugin.exe kcl-plugin.go
go build -o .\_output\kclvm-windows\bin\kcl-vet.exe    kcl-vet.go

:: run hello.k
_output\kclvm-windows\bin\kcl.exe           ..\..\samples\fib.k
_output\kclvm-windows\bin\kcl.exe           ..\..\samples\hello.k
_output\kclvm-windows\bin\kcl.exe           ..\..\samples\kubernetes.k

_output\kclvm-windows\bin\kclvm-cli.exe run ..\..\samples\fib.k
_output\kclvm-windows\bin\kclvm-cli.exe run ..\..\samples\hello.k
_output\kclvm-windows\bin\kclvm-cli.exe run ..\..\samples\kubernetes.k

_output\kclvm-windows\bin\kcl.exe           ..\..\samples\fib.k         --target native 
_output\kclvm-windows\bin\kcl.exe           ..\..\samples\hello.k       --target native 
_output\kclvm-windows\bin\kcl.exe           ..\..\samples\kubernetes.k  --target native 
