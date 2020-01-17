# Remove Shadow copies (restoration points)
# Удалить теневые копии (точки восстановения)
Get-CimInstance -ClassName Win32_ShadowCopy | Remove-CimInstance