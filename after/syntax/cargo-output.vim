syntax match CargoError /^error:.*/
syntax match CargoWarning /^warning:.*/
syntax match CargoNote /^note:.*/
syntax match CargoError /^Compiling.*/

highlight link CargoError ErrorMsg
highlight link CargoWarning WarningMsg
highlight link CargoNote Comment
