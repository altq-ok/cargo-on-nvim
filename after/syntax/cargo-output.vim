syntax match CargoError /^error:.*/
syntax match CargoWarning /^warning:.*/
syntax match CargoNote /^note:.*/

highlight link CargoError ErrorMsg
highlight link CargoWarning WarningMsg
highlight link CargoNote Comment
