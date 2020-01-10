Class {
	#name : #NGDatasetFilterer,
	#superclass : #Object,
	#category : #SuggestingNamesExperiment
}

{ #category : #'private - filtering data' }
NGDatasetFilterer >> filterColumns: methodsTable [
	^ methodsTable columns: #(id project class selector words).
	
]

{ #category : #public }
NGDatasetFilterer >> filterDataset: methodsTable [
	| table |
	table := self filterRows: methodsTable.
	table := self filterColumns: table.
	^ table
]

{ #category : #'private - filtering data' }
NGDatasetFilterer >> filterRows: methodsTable [
	^ methodsTable select: [ :row |
		(self isNotEmpty: row) and: [ (self isNotAccessor: row) and: [ (self isNotAbstract: row) and: (self isNotShouldNotImplement: row) ] ] ].
]

{ #category : #'private - filtering data' }
NGDatasetFilterer >> isNotAbstract: rowOfMethodsTable [
	^ (rowOfMethodsTable at: 'words') asArray ~= #(self subclass responsibility).
]

{ #category : #'private - filtering data' }
NGDatasetFilterer >> isNotAccessor: rowOfMethodsTable [
	| tokenTypesWithoutComments exceptions |
	
	"((rowOfMethodsTable at: 'protocol') = 'accessing')
		ifFalse: [ ^ true ]."
	
	tokenTypesWithoutComments := (rowOfMethodsTable at: 'tokenTypes')
		reject: [ :tokenType | tokenType = 'COM' ].
				
	exceptions := #(
		(RET VAR DOT)
		(VAR ASS ARG DOT)
		(RET STR DOT)
		(RET NUM DOT)
		(RET SYM DOT)
		(RET CHR DOT)
		(RET ARR DOT)
		(RET TRU DOT)
		(RET FLS DOT)
		(RET NIL DOT)
		(RET CLS DOT)
		(RET SLF DOT)
		(RET CVR DOT)).
				
	^ (exceptions includes: tokenTypesWithoutComments asArray) not.
]

{ #category : #'private - filtering data' }
NGDatasetFilterer >> isNotEmpty: rowOfMethodsTable [
	^ (rowOfMethodsTable at: 'words') isNotEmpty
		and: (rowOfMethodsTable at: 'tokenTypes') isNotEmpty.
]

{ #category : #'private - filtering data' }
NGDatasetFilterer >> isNotShouldNotImplement: rowOfMethodsTable [
	^ (rowOfMethodsTable at: 'words') asArray ~= #(self should not implement).
]
