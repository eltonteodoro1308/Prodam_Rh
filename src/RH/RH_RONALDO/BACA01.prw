#include "protheus.ch"

User function BACA01()
	Local cEntry
	Local cFile

//	SRA->(dbSetOrder(1))

//	Do While !(SRA->(Eof()))

//		cEntry := SRA->RA_FILIAL+SRA->RA_MAT
//		cFile := SRA->RA_FILIAL+SRA->RA_MAT+".jpg"

		cEntry := "01000046"
		cFile := "01000046.jpg"

//		RepExtract(cEntry,cFile)

If RepExtract(cEntry,cFile)
     conout('Extra��o realizada 1')
Else
     conout('Extra��o nao realizada 1')
EndIf

		cEntry := "01000046"
		cFile := "01000046.bmp"

If RepExtract(cEntry,cFile)
     conout('Extra��o realizada 2')
Else
     conout('Extra��o nao realizada 2')
EndIf

		cEntry := "01000046"
		cFile := "01000046"

If RepExtract(cEntry,cFile)
     conout('Extra��o realizada 3')
Else
     conout('Extra��o nao realizada 3')
EndIf

		cEntry := "01000046"

If RepExtract(cEntry)
     conout('Extra��o realizada 4')
Else
     conout('Extra��o nao realizada 4')
EndIf


//		SRA->(dbSkip())

//	EndDo
Return